param location string = 'uksouth'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  //name: '${sqlServer.name}-plink'
  location: location
  properties: {
    subnet: {
      id: vNetModule.
    }
    privateLinkServiceConnections: [
      {
        name: '${.name}-plink'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}
