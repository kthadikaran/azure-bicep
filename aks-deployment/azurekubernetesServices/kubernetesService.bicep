/*
**************************************************************************************************************************************
Azure Bicep Template for Azure Kubernetes Services
**************************************************************************************************************************************
*/
/*****Parameters for Azure Kubernetes*****/
param aksclusterName string
param Location string

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
param aksminnodeCount int
param aksmaxNodeCount int
param aksloadBalancerSku string
param aksnetworkPlugin string
param aksserviceCidr string
param aksdnsServiceIP string
param aksdockerBridgeCidr string

param aksazurepolicyStatus bool
param aksomsagentsStatus bool

param aksnodeAdminUsername string /*Linux profile parameters declaration is starting...*/
param aksnodesshpublicKey string


/*Importing the log analytics workspace after its creation*/
param virtualNetworkName string
param loganalyticsworkspace string
resource existingvnet 'Microsoft.Network/virtualnetworks@2015-05-01-preview' existing = {
  name: virtualNetworkName
}

resource existingloganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing ={
  name: loganalyticsworkspace
}

resource aksService 'Microsoft.ContainerService/managedClusters@2022-02-01' = {
  name: aksclusterName
  location: Location
  identity: {
    type: aksIdentitytype
  }
  properties: {
    nodeResourceGroup: aksnodeResourceGroup
    dnsPrefix: aksdnsPrefix
    agentPoolProfiles: [
      {        
        name: aksnodepoolName
        osDiskSizeGB: aksosDiskSizeGB
        count: aksnodeCount
        vmSize: aksnodeVmSize        
        osType: aksclusternodeOSType
        type: aksVirtualMachineScaleSets
        mode: aksagentPoolProfilesMode
        enableEncryptionAtHost: aksenableEncryptionAtHost
        enableAutoScaling: aksenableAutoScaling
        availabilityZones: aksavailabilityZones
        minCount: aksminnodeCount
        maxCount: aksmaxNodeCount
        vnetSubnetID: existingvnet.properties.subnets[0].id
      }
    ]
    networkProfile: {      
      loadBalancerSku: aksloadBalancerSku
      networkPlugin: aksnetworkPlugin
      serviceCidr: aksserviceCidr
      dnsServiceIP: aksdnsServiceIP
      dockerBridgeCidr: aksdockerBridgeCidr
    }
    addonProfiles: {
      azurepolicy: {
        enabled: aksazurepolicyStatus
      }
      omsAgent: {
        enabled: aksomsagentsStatus
        config: {
          logAnalyticsWorkspaceResourceID: existingloganalyticsworkspace.id
        }
      }   
    }
    linuxProfile: {      
      adminUsername: aksnodeAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: aksnodesshpublicKey
          }
        ]
      }      
    }
  }
}
