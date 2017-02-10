# terraform

## Clone the Repo
`git clone https://github.com/mgis-architects/terraform`

## Install Terraform

Select the latest version...

`wget -O terraform_0.8.4_linux_amd64.zip https://releases.hashicorp.com/terraform/0.8.4/terraform_0.8.4_linux_amd64.zip

unzip -q -d /usr/local/bin terraform_0.8.4_linux_amd64.zip`

## Read about the Azure provider
Read https://www.terraform.io/docs/providers/azurerm/

## Set environment variables
`export TF_VAR_tenantid=YourAzureTenantId
export TF_VAR_appid=YourAzureADApplicationId
export TF_VAR_apppassword=YourAzureADApplicationKey
export TF_VAR_subscriptionid=YourAzureSubscriptionId`

## Create the infrastructure

cd &lt;cloudDirectory&gt;

Edit tfvars appropriately

Validate the action

`terraform plan -var-file=<component>-azure.tfvars`

Build the resource group

`terraform apply -var-file=<component>-azure.tfvars`


