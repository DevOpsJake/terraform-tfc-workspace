/**
 * This Terraform module provisions a Terraform Cloud workspace
 */

resource "tfe_workspace" "workspace" {
  name         = var.name
  organization = var.organization

  auto_apply            = var.auto_apply
  file_triggers_enabled = var.file_triggers_enabled
  queue_all_runs        = var.queue_all_runs
  ssh_key_id            = var.ssh_key_id
  terraform_version     = var.terraform_version
  trigger_prefixes      = var.trigger_prefixes

  dynamic "vcs_repo" {
    for_each = lookup(var.vcs_repo, "identifier", "void") == "void" ? [] : [var.vcs_repo]
    content {
      branch             = lookup(var.vcs_repo, "branch", null)
      identifier         = lookup(var.vcs_repo, "identifier", null)
      ingress_submodules = lookup(var.vcs_repo, "ingress_submodules", null)
      oauth_token_id     = lookup(var.vcs_repo, "oauth_token_id", null)
    }
  }

  working_directory = var.working_directory
}

resource "tfe_team_access" "workspace" {
  for_each     = var.team_access
  access       = each.value
  team_id      = each.key
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_notification_configuration" "slack" {
  for_each = var.slack_notifications

  name             = each.key
  destination_type = lookup(each.value.configuration["destination_type"], "slack")
  enabled          = lookup(each.value.configuration, "enabled", true)
  triggers         = each.value.triggers
  url              = each.value.configuration["url"]
  workspace_id     = tfe_workspace.workspace.id
}

resource "tfe_variable" "env_vars" {
  for_each = lookup(var.variables, "env_vars", {})

  category     = "env"
  key          = each.key
  value        = each.value
  sensitive    = false
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "env_vars_sensitive" {
  for_each = lookup(var.variables, "env_vars_sensitive", {})

  category     = "env"
  key          = each.key
  value        = each.value
  sensitive    = true
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "tfvars" {
  for_each = lookup(var.variables, "tfvars", {})

  category     = "terraform"
  key          = each.key
  value        = each.value
  sensitive    = false
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "tfvars_sensitive" {
  for_each = lookup(var.variables, "tfvars_sensitive", {})

  category     = "terraform"
  key          = each.key
  value        = each.value
  sensitive    = true
  workspace_id = tfe_workspace.workspace.id
}
