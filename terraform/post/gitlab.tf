variable "gitlab_projects" {
  type = map(object({
    name = string
  }))
  default = {}
}

data "gitlab_project" "this" {
  for_each            = var.gitlab_projects
  path_with_namespace = each.value.name
}

variable "gitlab_project_access_tokens" {
  type = map(object({
    name    = string
    project = string
    rotation = optional(
      object({
        expiration_days    = optional(number, 30)
        rotate_before_days = optional(number, 7)
      }),
      {
        expiration_days    = 30
        rotate_before_days = 7
      }
    )
    access_level = string
    scopes       = optional(list(string), [])
  }))
  default = {}
}

resource "gitlab_project_access_token" "this" {
  for_each = var.gitlab_project_access_tokens

  project      = data.gitlab_project.this[each.value.project].id
  name         = each.value.name
  access_level = each.value.access_level
  scopes       = each.value.scopes
  rotation_configuration = {
    expiration_days    = each.value.rotation.expiration_days
    rotate_before_days = each.value.rotation.rotate_before_days
  }
}

variable "gitlab_project_variables" {
  type = map(object({
    name      = string
    project   = string
    value     = string
    protected = optional(bool, true)
    masked    = optional(bool, true)
  }))
  default = {}
}

resource "gitlab_project_variable" "this" {
  for_each = var.gitlab_project_variables

  key       = each.value.name
  project   = data.gitlab_project.this[each.value.project].id
  protected = each.value.protected
  masked    = each.value.masked
  value = try(
    gitlab_project_access_token.this[trimprefix(each.value.value, "gitlab.pat.")].token,
    gitlab_personal_access_token.this[trimprefix(each.value.value, "gitlab.pat.")].token,
    each.value.value
  )
}

variable "gitlab_users" {
  type = map(object({
    name = string
  }))
  default = {}
}

data "gitlab_user" "this" {
  for_each = var.gitlab_users
  username = each.value.name
}

variable "gitlab_personal_access_tokens" {
  type = map(object({
    name = string
    user = string
    rotation = optional(
      object({
        expiration_days    = optional(number, 30)
        rotate_before_days = optional(number, 7)
      }),
      {
        expiration_days    = 30
        rotate_before_days = 7
      }
    )
    scopes = optional(list(string), [])
  }))
  default = {}
}

resource "gitlab_personal_access_token" "this" {
  for_each = var.gitlab_personal_access_tokens

  user_id = data.gitlab_user.this[each.value.user].id

  name   = each.value.name
  scopes = each.value.scopes
  rotation_configuration = {
    expiration_days    = each.value.rotation.expiration_days
    rotate_before_days = each.value.rotation.rotate_before_days
  }
}
