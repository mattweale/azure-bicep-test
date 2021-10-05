param location string = resourceGroup().location
param storageAccountName string = 'sa${uniqueString(resourceGroup().id)}'
param storageAccountSkuName string = 'Standard_LRS'
param tags object = {
  'environment' : 'dev-test'
  'purpose'     : 'secure-functions-test'
  'createdby'   : 'bicep'
}

//Create a Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  tags: tags
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
 }

 resource storageAccount_Blob 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  parent: storageAccount
  name: 'default'
  dependsOn: [
    storageAccount
  ]
}

resource storageAccount_File 'Microsoft.Storage/storageAccounts/fileservices@2021-04-01' = {
  parent: storageAccount
  name: 'default'
  dependsOn: [
    storageAccount
  ]
}

output outStorAcc string = storageAccount.name
output blobName string = storageAccount_Blob.name
output fileName string = storageAccount_File.name
