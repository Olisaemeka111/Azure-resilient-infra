############################
## Log Analytics Workspace
############################

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name_prefix}-law"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}

############################
## Action Group (alert routing)
############################

resource "azurerm_monitor_action_group" "critical" {
  name                = "${var.name_prefix}-ag-critical"
  resource_group_name = var.resource_group_name
  short_name          = "critical"

  email_receiver {
    name                    = "ops-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = var.tags
}

############################
## Metric Alerts
############################

resource "azurerm_monitor_metric_alert" "high_cpu" {
  name                = "${var.name_prefix}-alert-high-cpu"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.this.id]
  description         = "Alert when CPU usage exceeds 80% for 5 minutes."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Processor Time"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
  }

  tags = var.tags
}
