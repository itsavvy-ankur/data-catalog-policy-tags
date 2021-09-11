variable "project_id" {
  type        = string
  description = "Project ID"
  sensitive = true
}

variable "policy_members" {
  type        = list(any)
  description = "List of IAM policy members"
  sensitive = true
}
