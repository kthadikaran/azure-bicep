/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Container Registry
**************************************************************************************************************************************
*/
/*Parameters for Azure Container Regiistry*/
param containerRegistryName string
param Location string
param containerRegistrySKU string
param acradminUserStatus bool
param tags object

resource azurecontainerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: containerRegistryName
  location: Location
  sku:{
    name: containerRegistrySKU
  }
  properties:{
    adminUserEnabled: acradminUserStatus
  }
  tags: tags
}

/****************Azure Bicep Template for Assign AcrPull role to Azure Kubernetes Service***********************************************/
param  aksclusterName string
resource existingAKS 'Microsoft.ContainerService/managedClusters@2022-03-02-preview' existing = {
  name: aksclusterName
}

param roleAcrPull string
resource assignAcrPullRoleToAks 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, containerRegistryName, 'AssignAcrPullToAks')
  scope: azurecontainerRegistry
  properties: {
    description: 'Assign AcrPull role to AKS'
    principalId: existingAKS.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleAcrPull}'
  }
  dependsOn:[
    existingAKS
  ]
}
