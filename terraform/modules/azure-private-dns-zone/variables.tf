variable "rg_name" {
  type        = string
  description = "Resource group for DNS resources"
}

variable "dns_name" {
  type        = string
  description = "DNS name for private zone"
}

variable "dns_hub_vnet_id" {
  type        = string
  description = "VNet for private DNS zone to link to"
}

variable "enable_policy" {
  type        = bool
  description = "Whether to enable policy"
  default     = true
}

variable "policy_mi_id" {
  type        = string
  description = "Managed Identity for executing action"
}

variable "location" {
  type        = string
  description = "location to create DNS zones."
  default     = "East Asia"
}

variable "management_group_id" {
  type        = string
  description = "Management group id for private DNS Policy."
}