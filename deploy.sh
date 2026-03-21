#!/bin/bash

# Exit immediately if a command fails
set -e

# ==============================
# CONFIGURATION VARIABLES
# ==============================
RESOURCE_GROUP="cloudproject2"
LOCATION="uksouth"
STORAGE_ACCOUNT="obinnastorageacct"
SOURCE_DIR="/c/Users/OBINNA/Documents/MY_CAPSTONE_PROJECT/PROJECT1/Project-static"
SUBSCRIPTION="timothy1"
DESTINATION='$web'

# ==============================
# LOGGING FUNCTIONS
# ==============================
log() {
  echo -e "\n[INFO] $1"
}

error() {
  echo -e "\n[ERROR] $1"
  exit 1
}



# ==============================
# LOGIN TO AZURE
# ==============================
log "Logging into Azure..."
az account show >/dev/null 2>&1 || az login

# ==============================
# CREATE RESOURCE GROUP
# ==============================
log "Creating resource group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --output none

# ==============================
# CREATE STORAGE ACCOUNT
# ==============================
log "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --output none

# ==============================
# ENABLE STATIC WEBSITE
# ==============================
log "Enabling static website hosting..."
az storage blob service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --static-website \
  --index-document index.html \
  --404-document 404.html \
  --output none


# ==============================
# UPLOAD FILES
# ==============================
log "Uploading website files..."
az storage blob upload-batch \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login \
  --destination '$web' \
  --source $SOURCE_DIR \
  --output none \
  --overwrite

#   az ad signed-in-user show --query id -o tsv
# --auth-mode login \

# ==============================
# FETCH WEBSITE URL
# ==============================
log "Fetching website URL..."
WEB_URL=$(az storage account show \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "primaryEndpoints.web" \
  --output tsv)

# ==============================
# OUTPUT RESULT
# ==============================
echo -e "\n====================================="
echo "🎉 Deployment Successful!"
echo "🌐 Website URL: $WEB_URL"
echo "📦 Storage Account: $STORAGE_ACCOUNT"
echo "=====================================\n"


