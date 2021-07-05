Terraform Backend module for Azure by blinQ
===========

A Terraform module to provision common backend infrastructure in Azure. This module is meant to be run manually in Terraform CLI with an account that has Owner or roles that has permissions to IAM.


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
2. A Storage Account - Required for the Storage Container in Requirement #3
3. A Storage Container - This module will store its remote state in this location. (Make sure it is secured!)

Module Input Variables
----------------------

- `project_name` - name of the project. Some resources will use this in their name. Make sure it is no longer than 5 characters.
- `environments` - a list of the environments you want. Some resources are suffixed with its respective environment name.
- `backend_resource_group_name` - the name of the resource group you need to have pre-provisioned.
- `location` - location to provision resources to. Defaults to norwayeast.

Usage
-----

1. Save the Team API token for the b24x7 Terraform organization using `terraform login` - resides in 1Password (@Kim Iversen)
2. Copy the usage example below to `project/terraform/backend/main.tf` and modify to your needs
3. Authenticate to az `az login`
4. Copy `project/terraform/backend/backend.conf.example` to `project/terraform/backend/backend.conf` and edit the values to match your environment
5. Run `terraform init -backend-config="backend.conf"`
6. Run `terraform plan -out backend.tfplan`
7. Verify the plan
8. Run `terraform apply "backend.tfplan"`

```hcl
module "terraform-backend" {
  source                      = "app.terraform.io/b24x7/terraform-backend/azurerm"
  version                     = "2.0.0"
  project_name                = "kportal"
  environments                = ["dev", "test", "prod"]
  backend_resource_group_name = "rg-terraform"
  location                    = "norwayeast"
}
```


Outputs
=======

- none


Authors
=======

kim.iversen@blinq.no
