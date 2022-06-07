module "service-principal" {
  #source                         = "app.terraform.io/b24x7/service-principal/azuread"
  #version                        = "4.0.0"
  source                         = "../terraform-azuread-service-principal/"
  for_each                       = toset(var.environments)
  app_display_name               = format("%s%s%s", "sp-tf-", "${var.project_name}-", each.key)
  identifier_uri_verified_domain = var.identifier_uri_verified_domain
  app_name                       = format("%s-%s", var.project_name, each.key)
  end_date_relative_hours        = var.service_principal_password_end_date_relative_hours
  password_rotating_days         = var.service_principal_password_rotating_days
}

