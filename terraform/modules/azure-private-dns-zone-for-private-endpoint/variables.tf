variable "location" {
  type        = string
  description = "location to create DNS zones."
  default     = "East Asia"
}

variable "private_dns_zone_rg" {
  type        = string
  description = "Resource group for private DNS zone."
  default     = "rg-prd-private-endpoint-dns"
}

variable "dns_hub_vnet_id" {
  type        = string
  description = "VNet for private DNS zone to link to"
}

variable "management_group_id" {
  type        = string
  description = "Management group id for private DNS Policy."
}

variable "dns_policy_mi_name" {
  type        = string
  description = "managed identity for private DNS"
  default     = "priv-dns-policy-mi"
}
