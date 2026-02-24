############################
## Microsoft Defender for Cloud
############################

resource "azurerm_security_center_subscription_pricing" "vms" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "sql" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "aks" {
  tier          = "Standard"
  resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "acr" {
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}

resource "azurerm_security_center_subscription_pricing" "storage" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "arm" {
  tier          = "Standard"
  resource_type = "Arm"
}

resource "azurerm_security_center_subscription_pricing" "dns" {
  tier          = "Standard"
  resource_type = "Dns"
}

resource "azurerm_security_center_contact" "this" {
  email               = var.security_contact_email
  alert_notifications = true
  alerts_to_admins    = true
}

############################
## Azure Policy Assignments
############################

resource "azurerm_subscription_policy_assignment" "require_tag_environment" {
  name                 = "require-tag-environment"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Require environment tag on all resources"
  parameters           = jsonencode({ tagName = { value = "environment" } })
}

resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-azure-locations"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Allowed Azure locations"
  parameters           = jsonencode({ listOfAllowedLocations = { value = var.allowed_locations } })
}

resource "azurerm_subscription_policy_assignment" "deny_public_storage" {
  name                 = "deny-public-storage-access"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Storage accounts should restrict network access"
}

resource "azurerm_subscription_policy_assignment" "require_https_storage" {
  name                 = "require-https-storage"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Secure transfer to storage accounts should be enabled"
}

resource "azurerm_subscription_policy_assignment" "aks_no_privileged_containers" {
  name                 = "aks-no-privileged-containers"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Kubernetes cluster should not allow privileged containers"
}

############################
## RBAC — Ops Team Access
############################

resource "azurerm_role_assignment" "ops_contributor" {
  for_each             = var.ops_principal_id != null ? toset(var.resource_group_ids) : toset([])
  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = var.ops_principal_id
}
