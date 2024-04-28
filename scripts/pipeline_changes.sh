#!/bin/bash
set -x

source_branch=$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
target_branch=$CI_MERGE_REQUEST_TARGET_BRANCH_NAME
git_url=$CI_PROJECT_URL

echo Collecting changes compared to $source_branch

randstr() {
    output=$(cat /dev/random | head -n 15 | base64 -w 0 | cut -c1-8 | tr "/" "-")
    echo $output
}

clone() {
    dir="/tmp/$(randstr)"
    git clone -b $1 $git_url $dir 2> /dev/null
    echo $dir
}

clenaup() {
    rm -rf $1 $2
}

# Determines if the change is to a kubernetes manifest
is_k8s_change() {
    if [[ ! $1 =~ kubernetes/.* ]]; then
        echo false
        return
    fi

    if [[ ! $1 =~ ^.*chart/.*\.yaml ]]; then
        echo false
        return
    fi

    echo true
}

# Get the root app dir e.g. kubernetes/k3s/apps/monitoring/loki
get_root_dir() {
    dir=$(dirname "$1")
    while [[ ! $(echo $dir | grep -E ^.*/chart$) ]]; do
        dir=$(realpath -s "$dir/..")
    done
    full=$(realpath -s "$dir/..")
    echo ${full/"$source/"}
}

guess_format() {
    if [[ -f "$1/chart/kustomization.yaml" ]]; then
        echo kustomize
    elif [[ -f "$1/chart/Chart.yaml" ]]; then
        echo helm
    else
        echo raw
    fi
}

# Get the name of the argo app
# Usage: [app dir]
get_app_name() {
    app_file=$(ls $1/*.app.yaml)
    echo $(cat $app_file | grep -Eo "name: .*" | cut -d' ' -f 2)
}

# Format an app diff into markdown
# Usage: [app name] [diff]
diff_to_md() {
    echo "# $1"
    echo "\`\`\`diff"
    echo "$2"
    echo "\`\`\`"
}

# Format the json for a comment post request
# Useage: [comment body]
comment_json() {
    formatted=$(echo "$1" | sed -z 's/\n/\\n/g')
    body=$(cat <<EOF
{
    "body": "$formatted"
}
EOF
)
    echo $body
}

# Output the diffs of 2 helm charts
# Usage: [app dir] [app name]
helm_diffs() {
    helm dependency update "$target/$1/chart" > /dev/null
    helm dependency update "$source/$1/chart" > /dev/null

    target_file="/tmp/$(randstr).yaml"
    source_file="/tmp/$(randstr).yaml"

    helm template $2 "$target/$1/chart" > $target_file
    helm template $2 "$source/$1/chart" > $source_file

    echo "$(diff --color -t -C 5 $target_file $source_file)"
}

# Output the diffs of 2 kustomize charts
# Usage: [app dir]
kustomize_diffs() {
    target_file="/tmp/$(randstr).yaml"
    source_file="/tmp/$(randstr).yaml"

    kustomize build --enable-helm "$target/$1/chart" > $target_file
    kustomize build --enable-helm "$source/$1/chart" > $source_file

    echo "$(diff --color -t -C 5 $target_file $source_file)"
}

comment_on_mr() {
    body=$(comment_json "$1")
    curl --location --request POST "https://gitlab.com/api/v4/projects/$CI_MERGE_REQUEST_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/notes" \
        --header "PRIVATE-TOKEN: $GITLAB_COMMENT_TOKEN" --header "Content-Type: application/json" \
        --data-raw "$body"
}

echo Cloning target branch
target=$(clone $target_branch)

echo Cloning source branch
source=$(clone $source_branch)

cd $source

changed=$(git diff --name-only "origin/$target_branch")

for file in $changed; do
    is_k8s=$(is_k8s_change $file)

    if [[ true == $is_k8s ]]; then
        root=$(get_root_dir $file)
        app_name=$(get_app_name "$root")
        format=$(guess_format "$root")
        echo "Detected change to $app_name using format $format"

        if [[ $format == "helm" ]]; then
            diffs=$(helm_diffs $root $app_name)
            echo "$diffs"
            diff_md="$(diff_to_md $app_name "$diffs")"
            comment_on_mr "$diff_md"
        elif [[ $format == "kustomize" ]]; then
            diffs=$(kustomize_diffs $root $app_name)
            echo "$diffs"
            diff_md="$(diff_to_md $app_name "$diffs")"
            comment_on_mr "$diff_md"
        fi
    fi
done

echo Cleaning up
clenaup $source $target
