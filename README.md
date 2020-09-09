# terraform-tfc-workspace
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
This Terraform module provisions a Terraform Cloud workspace

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| tfe | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_apply | Whether to automatically apply changes when a Terraform plan is successful. | `bool` | `false` | no |
| file\_triggers\_enabled | Whether to filter runs based on the changed files in a VCS push. If enabled, the working directory and trigger prefixes describe a set of paths which must contain changes for a VCS push to trigger a run. If disabled, any push will trigger a run. | `bool` | `true` | no |
| name | Name of the workspace. | `any` | n/a | yes |
| organization | Name of the organization. | `any` | n/a | yes |
| queue\_all\_runs | Whether all runs should be queued. When set to false, runs triggered by a VCS change will not be queued until at least one run is manually queued. | `bool` | `true` | no |
| slack\_notifications | Map of `tfe_notification_configurations` to define in the workspace. Leave blank for none. | `map(object({ configuration = map(string), triggers = list(string) }))` | `{}` | no |
| ssh\_key\_id | The ID of an SSH key to assign to the workspace. | `any` | `null` | no |
| team\_access | Associate teams to permissions on the workspace. | `map(string)` | `{}` | no |
| terraform\_version | The version of Terraform to use for this workspace. Default is latest. | `any` | `null` | no |
| trigger\_prefixes | List of repository-root-relative paths which describe all locations to be tracked for changes. workspace. Defaults to the latest available version. | `list` | `null` | no |
| variables | Map of environment or Terraform variables to define in the workspace. | `map(map(string))` | `{}` | no |
| vcs\_repo | The VCS repository to configure. | `map(string)` | `{}` | no |
| working\_directory | A relative path that Terraform will execute within. Defaults to the root of your repository. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| tfc\_id | The Terraform Cloud workspace ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

### Terraform Cloud Authentication

A Terraform Cloud token must be specified in the `.terraformrc` configuration file found in your home directory (see below)

```hcl
credentials "app.terraform.io" {
  token = "<tfc-token>"
}
```

The token can be obtained within your Terraform Cloud account (User Settings > Tokens section))


### The `slack_notifications` object format

```hcl
slack_notifications = {
  "slack-notify-config" = {
    configuration = {
      enabled          = true  # (Optional) Whether config should be enabled. Default is true.
      url              = "<https://slack.webhook.url>"
    }
    triggers = [
      "run:created",
      "run:planning",
      "run:errored"
    ]
  }
}
```

### The `team_access` map format

```hcl
team_access = {
  "tfc-team" = "<permission>"
}
```

Valid values for the _permissions_ are `admin`, `read`, `plan`, or `write`.

### The `variables` map format

```hcl
variables = {
  env_vars = {
    key1 = var.value
    key2 = "<value>"
  }
  env_vars_sensitive = {
    ...
  }
  tfvars = {
    ...
  }
  tfvars_sensitive = {
    ...
  }
}
```

### The `vcs_repo` format

* `identifier` - (Required) A reference to your VCS repository in the format `:org/:repo` where `:org` and `:repo` refer to the organization and repository in your VCS provider.
* `branch` - (Optional) The repository branch that Terraform will execute from. Default is `master`.
* `ingress_submodules` - (Optional) Whether submodules should be fetched when cloning the VCS repository. Default is `false`.
* `oauth_token_id` - (Required) Token ID of the VCS Connection (OAuth Conection Token) to use.

```hcl
vcs_repo = {
  identifier         = "<:org/:repo>"
  branch             = "master"
  ingress_submodules = false
  oauth_token_id     = "<oauth-token>"
}
```
