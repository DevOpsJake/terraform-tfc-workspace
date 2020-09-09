output "tfc_id" {
  description = "The Terraform Cloud workspace ID."
  value       = tfe_workspace.workspace.id
}
