output "dns_zone_id" {
  description = "ID of DNS private zone "
  value       = azurerm_private_dns_zone.this.id
}