param location string = 'uksouth'
param globalResourceLocation string = 'global'
param virtualNetworkId string
param privateEndPointSubnetId string
param storageAccountId string
param storageAccountName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: '${storageAccountName}-pe'
  location: location
  properties: {
    subnet: {
      id: privateEndPointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${storageAccountName}-plsc'
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: globalResourceLocation
}

resource privateDNSZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = {
  name: '${privateEndpoint.name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'storage-private-link'
        properties: {
          privateDnsZoneId: privateDNSZone.id
        }
      }
    ]
  }
}

resource storageAccountPrivateLinkDnsZone 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDNSZone.name}/vnet-link'
  location: globalResourceLocation
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}
