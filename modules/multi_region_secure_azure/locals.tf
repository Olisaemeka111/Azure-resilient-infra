locals {
  # AKS service CIDRs — must not overlap with any VNet address spaces.
  # Using 10.240.x and 10.241.x which are outside all environment CIDR ranges.
  primary_aks_service_cidr   = "10.240.0.0/24"
  primary_aks_dns_service_ip = "10.240.0.10"

  secondary_aks_service_cidr   = "10.241.0.0/24"
  secondary_aks_dns_service_ip = "10.241.0.10"
}
