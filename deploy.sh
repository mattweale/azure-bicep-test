#! /bin/bash

## Set the default Subscription
#SUBSCRIPTION_ID="5545c350-5947-4001-8f12-d2e422addb7d"
#SUBSCRIPTION_NAME=""

#az account set --subscription $SUBSCRIPTION_ID

#az group create --name rg-secure-function-app --location "uksouth"

RESOURCE_GROUP_NAME="rg-secure-function-app"
SUBSCRIPTION_ID="5545c350-5947-4001-8f12-d2e422addb7d"
TEMPLATE_FILE="main.bicep"
PARAMETERS_FILE="@params.json"

#Deploy to Resource Group
az deployment group create \
--name bicep-deployment \
--resource-group $RESOURCE_GROUP_NAME \
--template-file $TEMPLATE_FILE 
#--parameters $PARAMETERS_FILE

#Deploy to Subscriptioon
az deployment sub create \
--location uksouth \
--name bicep-deployment \
--template-file $TEMPLATE_FILE 
#--parameters $PARAMETERS_FILE