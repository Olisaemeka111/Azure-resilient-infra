# Resources for this module are split across dedicated files:
#   networking.tf   — VNets, subnets, hub-spoke peering
#   security.tf     — Azure Firewall + rules
#   bastion.tf      — Azure Bastion + optional VPN Gateway
#   compute.tf      — AKS cluster (with Entra ID RBAC) + AcrPull role
#   storage.tf      — Storage Account + network rules
#   app_service.tf  — Optional App Service + VNet integration
#   key_vault.tf    — Optional Key Vault + AKS access policy
#   diagnostics.tf  — Diagnostic settings for all resources
