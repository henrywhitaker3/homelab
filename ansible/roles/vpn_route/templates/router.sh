#!/bin/bash

routes=(
{% for route in vpn_route_routes %}
    "{{ route.to }} via {{ route.via }}"
{% endfor %}
)

route_exists() {
    exists=$(ip route list | grep "$1")
    if [[ -n $exists ]]; then
        echo 1
    else
        echo 0
    fi
}

add_route() {
    ip route add $1
}

for route in "${routes[@]}"; do
    exists=$(route_exists "$route")
    if [[ $exists -eq 0 ]]; then
        echo "$(date +"%Y-%m-%dT%H:%M:%S%z") - Route $route does not exist, adding now"
        add_route "$route"
    fi
done
