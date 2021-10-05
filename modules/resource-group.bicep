//Specify Target Scope
targetScope = 'subscription'

param rgName string = 'rg-secure-function'
param location string = 'uksouth'
param tags object = {
  'environment' : 'dev-test'
  'purpose'     : 'secure-functions-test'
  'createdby'   : 'bicep'
}

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
}
