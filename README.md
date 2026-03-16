This is my azure static website deployment project.
Its objective is to deploy a static websit to azure using CLI.


Requirement:
Create an azure account.
Create a resource group.


step 1

On your terminal, Run: 
az storage account create --name obistaticweb --resource-group cloudproject1 --location uksouth --sku Standard_LRS

To create an azure storage account.

step 2
On your terminal, Run:
az storage blob service-properties update --account-name obistaticweb --static-website --index-document index.html --404 document  404.html

This creates the special container: $web which will host your code files.


Step 3
On your terminal, RUN:
az storage blob upload-batch --account-name obistaticweb --destination ‘$web’  --account-key “” --source .

This upload your code files to the container $web


Step 4
On your terminal, RUN:
az storage account show --name obistaticweb --resource-group cloudproject1 --query “primaryEndponts .web”

This displays the static website URL through which you can access the live site.

