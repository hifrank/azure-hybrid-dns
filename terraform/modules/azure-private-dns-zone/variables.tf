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
