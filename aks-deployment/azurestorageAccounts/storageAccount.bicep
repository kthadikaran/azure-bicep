/*
**************************************************************************************************************************************
Azure Bicep Template for Azure Storage Accounts
**************************************************************************************************************************************
*/
/*Parameters for Azure Storage Accounts*/
param tags object   
param storageAccountName string           //param-tells Bicep that you're defining a parameter. storageAccountName- is the name of the parameter.string is the type of the parameter.
param Location string
param storageAccountKind string
param storageAccountSKU string
param storageAccountAccessTier string 
param allowBlobPublicAccess bool
param minimumTlsVersion string 
  
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: Location
  tags: tags
  sku:{
    name: storageAccountSKU
  }
  kind: storageAccountKind 
  properties: {
    accessTier: storageAccountAccessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: minimumTlsVersion
  }
}


/*param storageAccountContainerName string 
resource storageContainer01 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: storageAccountContainerName
  dependsOn: [
    storageAccount  
  ]  
}*/
