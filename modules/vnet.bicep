//Create some parameters
param location string = resourceGroup().location
param virtualNetworkName string = 'vnet-${uniqueString(resourceGroup().id)}'

targetScope = 'resourceGroup'

//First create a vNET with two Subnets
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  tags: {}
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'functions'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
  dependsOn: []
}

output virtualNetworkId string = virtualNetwork.id
output peSubnetId string = virtualNetwork.properties.subnets[0].id
