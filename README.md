Terraform Backend module for Azure by blinQ
===========

A Terraform module to provision common backend infrastructure in Azure. This module is meant to be run manually in Terraform CLI with an account that has Owner or roles that has permissions to IAM.

You can optionally have this module create an Azure DevOps project and automatically provision service principals for you. See Usage for how-to.

Diagram
-------
![Diagram of topology](./documentation/diagram.png "Diagram of topology")


Deep dive
---------
This module will create the following resources per environment you provide.
* A resource group named `rg-project_name-${env}`
* A service principal named `sp-tf-project_name-${env}`
  * This service principal will be assigned the Contributor role to its respective resource group
* A key vault named `kvtf${project_name}pipeline-${env}`
  * This Key Vault will be deployed to the backend resource group. The purpose of this Key Vault is to store the service principal's credentials.
* The authenticated user who runs this module will be given ["Set", "Get", "List", "Delete", "Purge", "Recover"] on `Secrets` in this key vault.
  *  Each service principal will be given ["Get", "List"] on `Secrets` in its respective key vault.
* A Storage Account named `sa${project_name}${random_integer}` that will hold each environments Storage Container (to store remote state)
* A Storage Container named `${env}` that will hold the state for each environment
* A Blob Container SAS (Shared Access Signature) per environments respective Storage Container

Per environment, the following secrets are stored in its respective Key Vault
* SAS to its respective Storage Container
* Authentication details to each service principal
  * client_id
  * client_secret
  * tenant_id
  * subscription_id
* Backend configuration needed for Terraform to use Remote State (per environment)
  * backend_resource_group_name
  * Storage Account name
  * Storage Container name
  * Key name


Requirements
------------

The module expects you to have pre-provisioned the following

1. A Resource Group - This module deploys a single Storage Account and one Storage Container(pr. environment) where remote state for the project infrastructure will reside.
2. A Storage Account - Required for the Storage Container in the next requirement
3. A Storage Container - This module will store its remote state in this location. (Make sure it is secured!)

If you want this module to create an Azure DevOps project you will need the following

1. An existing Azure DevOps Organization
2. A PAT with the Scopes: `Project and Team: Read, write & manage`, `Service Connections: Read, query & manage`

Module Input Variables
----------------------

- `project_name` - name of the project. Some resources will use this in their name. Make sure it is no longer than 5 characters.
- `environments` - a list of the environments you want. Some resources are suffixed with its respective environment name.
- `backend_resource_group_name` - the name of the resource group you need to have pre-provisioned.
- `location` - location to provision resources to. Defaults to norwayeast.
- `enable_azuredevops` - set to true if you want this module to create a Azure DevOps Project in an existing organization
- `azuredevops` - block supports the following
  - `project_name` - the name of the Azure DevOps project to create
  - `project_description` - a description of the project
  - `visibility` - if the project should be `private` or `public`

Usage
-----

1. Save the Team API token for the b24x7 Terraform organization using `terraform login` - resides in 1Password (@Kim Iversen)
2. Copy the usage example below to `project/terraform/backend/main.tf` and modify to your needs
3. Authenticate to az `az login`
4. Copy `project/terraform/backend/backend.conf.example` to `project/terraform/backend/backend.conf` and edit the values to match your environment
5. Copy `project/terraform/backend/azuredevops.conf.example` to `project/terraform/backend/azuredevops.conf` and edit the values to match your Azure DevOps organization. Copy and paste the contents of the file into your PowerShell terminal where you run Terraform.
6. Run `terraform init -backend-config="backend.conf"`
7. Run `terraform plan -out backend.tfplan`
8. Verify the plan
9. Run `terraform apply "backend.tfplan"`

```hcl
module "terraform-backend" {
  source                      = "app.terraform.io/b24x7/terraform-backend/azurerm"
  version                     = "2.0.0"
  project_name                = "kportal"
  environments                = ["dev", "test", "prod"]
  backend_resource_group_name = "rg-terraform"
  location                    = "norwayeast"
  enable_azuredevops          = "true"
  azuredevops = {
    project_name = "My Azure DevOps Project"
    project_description = "Managed by Terraform"
    visibility = "private"
  }
}
```


Outputs
=======

- none


Authors
=======

kim.iversen@blinq.no
