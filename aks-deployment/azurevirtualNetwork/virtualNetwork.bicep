/*
**************************************************************************************************************************************
Azure Bicep Template for Azure Virtual Networks
**************************************************************************************************************************************
*/
/*Parameters for Azure Virtual networks service*/

param tags object 
param virtualNetworkName string
param Location string
param akssubnetName string
param vnetAddressPrefixes array
param akssubnetIPAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
        name: akssubnetName
        properties: {
          addressPrefix:akssubnetIPAddressPrefix
        }
      }
    ]
  }
  tags: tags
}
