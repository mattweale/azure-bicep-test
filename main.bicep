//Decompile ARM Template to Bicep
//az bicep decompile --file vnet.json
targetScope = 'subscription'

//Create some parameters
param location string = 'uksouth'
param rgName string = 'rg-secure-function'
param storageAccountName string = 'sa${uniqueString(subscription().id)}'
param storageAccountSkuName string = 'Standard_LRS'
param virtualNetworkName string = 'vnet-${uniqueString(subscription().id)}'
param tags object = {
  'environment': 'dev-test'
  'purpose': 'secure-functions-test'
  'createdby': 'bicep'
}

//First create Resource Group
module newRG './modules/resource-group.bicep' = {
  name: rgName
  params: {
    location: location
    tags: tags
  }
}

//Call vNET Module
module vNetModule './modules/vnet.bicep' = {
  scope: resourceGroup(rgName)
  name: 'vNetDeploy'
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
  }
  dependsOn: [
    newRG
  ]
}

//Call the Storage Module
module storageModule './modules/storage-account.bicep' = {
  name: 'storageAccountDeploy'
  scope: resourceGroup(rgName)
  params: {
    location: location
    storageAccountName: storageAccountName
    storageAccountSkuName: storageAccountSkuName
    tags: tags
  }
  dependsOn: [
    newRG
  ]
}

//Call the Private Endpoint Module
module privateEndpoint 'modules/storage-account-private-endpoint.bicep' = {
  scope: resourceGroup(rgName)
  name: 'storageAccountDeploy-pe'
  params: {
    location: location
    storageAccountName: storageModule.outputs.outStorAcc
    storageAccountId: storageModule.outputs.storageAccountId
    virtualNetworkId: vNetModule.outputs.virtualNetworkId
    privateEndPointSubnetId: vNetModule.outputs.peSubnetId
  }
  dependsOn: [
    storageModule
  ]
}
