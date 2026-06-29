resource "azurerm_application_insights" "main" {
  name                = "${var.resource_prefix}-appins-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = 30
  daily_data_cap_in_gb = 1

  tags = var.common_tags
}

resource "azurerm_monitor_action_group" "main" {
  name                = "${var.resource_prefix}-ag-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "DocSumm"

  tags = var.common_tags
}

# Alert for high error rate
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "${var.resource_prefix}-alert-error-rate-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when error rate is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "failedRequests"
    metric_namespace = "Microsoft.Insights/components"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Alert for response time
resource "azurerm_monitor_metric_alert" "high_response_time" {
  name                = "${var.resource_prefix}-alert-response-time-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when response time is high"
  severity            = 3
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "serverResponseTime"
    metric_namespace = "Microsoft.Insights/components"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 2000 # 2 seconds in milliseconds
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
