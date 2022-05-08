/*
*************************************************************************************************************************************
Azure Bicep Code for Azure Resource Group 
**************************************************************************************************************************************
targetScope = 'subscription'
param resourceGroupName string
param resourceGroupLocation string
resource azureResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}*/

/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Storage Accounts
**************************************************************************************************************************************
*/
param storageAccountName string
param Location string = resourceGroup().location
param storageAccountKind string
param storageAccountSKU string
param storageAccountAccessTier string 
param allowBlobPublicAccess bool
param minimumTlsVersion string
param tags object

module storageAccountModule './azurestorageAccounts/storageAccount.bicep' = {
  name: 'storageAccountDeploy'
  params: {
    storageAccountName  : storageAccountName
    Location            : Location
    storageAccountKind  : storageAccountKind
    storageAccountSKU   : storageAccountSKU
    storageAccountAccessTier: storageAccountAccessTier
    allowBlobPublicAccess : allowBlobPublicAccess
    minimumTlsVersion     : minimumTlsVersion
    tags: tags
  }
}

/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Virtual Network
**************************************************************************************************************************************
*/
param virtualNetworkName string
param akssubnetName string
param vnetAddressPrefixes array
param akssubnetIPAddressPrefix string

module virtualNetworkModule './azurevirtualNetwork/virtualNetwork.bicep' = {
  name: 'virtualNetworkDeploy'
  params: {
    virtualNetworkName: virtualNetworkName 
    Location          : Location
    akssubnetName     : akssubnetName
    vnetAddressPrefixes : vnetAddressPrefixes 
    akssubnetIPAddressPrefix: akssubnetIPAddressPrefix
    tags: tags
  }
}

/**************************************************************************************************************************************
Referring the existing SSH Public Key
**************************************************************************************************************************************
*/
param aksnodesshkeyname string
resource existingSSHKey 'Microsoft.Compute/sshPublicKeys@2021-11-01' existing = {
  name: aksnodesshkeyname
  scope:resourceGroup('azurebicepdemo-rg')
}

/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Log Analytics Workspace
**************************************************************************************************************************************
*/
param loganalyticsworkspace string

module loganalyticsWorkspacekModule './azureloganalyticsWorkspace/loganalyticsWorkspace.bicep' = {
  name: 'loganalyticsworkspaceDeploy'
  params: {
    loganalyticsworkspace: loganalyticsworkspace
    Location: Location
  }
}


/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Kubernetes Service
**************************************************************************************************************************************
*/
/*****Azure Kubernetes Parameters*****/

param aksclusterName string
param aksIdentitytype string
param aksdnsPrefix string
param aksnodeResourceGroup string
param aksnodepoolName string  /*Agent profile parameters declaration is starting...*/
param aksosDiskSizeGB int
param aksnodeCount int
param aksnodeVmSize  string      
param aksclusternodeOSType string
param aksVirtualMachineScaleSets string
param aksagentPoolProfilesMode string
param aksenableEncryptionAtHost bool
param aksenableAutoScaling bool
param aksavailabilityZones array
param aksminNodeCount int
param aksmaxNodeCount int
param aksloadBalancerSku string
param aksnetworkPlugin string
param aksserviceCidr string
param aksdnsServiceIP string
param aksdockerBridgeCidr string
param aksazurepolicyStatus bool
param aksomsagentsStatus bool
param aksnodeAdminUsername string /*Linux profile parameters declaration is starting...*/

module kubernetesServiceModule './azurekubernetesServices/kubernetesService.bicep' = {
  name: 'kuberneteServiceDeploy'
  params: {
    virtualNetworkName: virtualNetworkName 
    loganalyticsworkspace: loganalyticsworkspace
    aksclusterName :aksclusterName
    Location    : Location 
    aksIdentitytype: aksIdentitytype
    aksdnsPrefix   : aksdnsPrefix
    aksnodeResourceGroup: aksnodeResourceGroup
    aksnodepoolName : aksnodepoolName 
    aksosDiskSizeGB : aksosDiskSizeGB 
    aksnodeCount    : aksnodeCount
    aksnodeVmSize   : aksnodeVmSize 
    aksclusternodeOSType      : aksclusternodeOSType
    aksVirtualMachineScaleSets: aksVirtualMachineScaleSets
    aksagentPoolProfilesMode  : aksagentPoolProfilesMode
    aksenableEncryptionAtHost : aksenableEncryptionAtHost
    aksenableAutoScaling: aksenableAutoScaling
    aksavailabilityZones: aksavailabilityZones
    aksminnodeCount: aksminNodeCount
    aksmaxNodeCount: aksmaxNodeCount
    aksloadBalancerSku:aksloadBalancerSku
    aksnetworkPlugin  : aksnetworkPlugin
    aksserviceCidr    : aksserviceCidr
    aksdnsServiceIP   : aksdnsServiceIP
    aksdockerBridgeCidr : aksdockerBridgeCidr   
    aksazurepolicyStatus: aksazurepolicyStatus
    aksomsagentsStatus  : aksomsagentsStatus
    aksnodeAdminUsername  : aksnodeAdminUsername
    aksnodesshpublicKey   : existingSSHKey.properties.publicKey
  }
  dependsOn:[ 
    existingSSHKey
    virtualNetworkModule
    loganalyticsWorkspacekModule
  ]
}

/*
**************************************************************************************************************************************
Azure Bicep Module for Azure Container Registry
**************************************************************************************************************************************
/*****Azure Container Registry Parameters*****/
param containerRegistryName string
param containerRegistrySKU string
param acradminUserStatus bool 
param roleAcrPull string


module containerRegistryModule './azurecontainerRegistry/containerRegistry.bicep' = {
  name: 'containerRegistryDeploy'
  params:{
    containerRegistryName: containerRegistryName
    aksclusterName: aksclusterName
    Location: Location
    containerRegistrySKU: containerRegistrySKU
    acradminUserStatus: acradminUserStatus
    roleAcrPull: roleAcrPull
    tags: tags
  }
  dependsOn: [
    kubernetesServiceModule
  ]
}
