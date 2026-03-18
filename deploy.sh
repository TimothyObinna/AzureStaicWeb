#!/bin/bash

RESOURCE_GROUP=cloudproject1
STORAGE_ACCOUNT=obistaticweb
LOCATION=uksouth

# This part of the script create the resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# This part of the script creat azure storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS


# This part of the script update the storage account and indicate the index page and the error page
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html \
  --404-document 404.html

# This part of the sript upload the files to the storage account
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --source . \
  --destination '$web'