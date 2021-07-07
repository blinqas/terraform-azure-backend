# # Create the Azure DevOps Project
# resource "azuredevops_project" "project" {
#     count = var.enable_azuredevops == true ? 1 : 0
#     name = var.azuredevops.project_name
#     description = var.azuredevops.project_description
#     visibility = "private"
#     work_item_template = "Basic"
# }
# 
# # Create a Service Connection for each service principal
# resource "azuredevops_serviceendpoint_azurerm" "service_connection" {
#     #for_each                  = toset(var.environments)
#     for_each                  = { for env in var.environments : env => env if var.enable_azuredevops }
#     project_id                = azuredevops_project.project.0.id
#     service_endpoint_name     = module.service-principal[each.key].name
#     description               = "Managed by Terraform"
#     azurerm_spn_tenantid      = module.service-principal[each.key].tenant_id
#     azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
#     azurerm_subscription_name = data.azurerm_subscription.current.display_name # TODO: Maybe implement this in the Service Principal module so we know for sure this is correct each time
# 
#     credentials {
#         serviceprincipalid    = module.service-principal[each.key].client_id
#         serviceprincipalkey   = module.service-principal[each.key].client_secret
#     }
# }