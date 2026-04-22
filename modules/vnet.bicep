param vnetName string
param rgLocation string = resourceGroup().location
param addressPrefix array = []
param subnetSettings array = []
param nsgId string

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vnetName
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        for prefix in addressPrefix: prefix
      ]
    }
    subnets: [
      for subnet in subnetSettings: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.prefix
          networkSecurityGroup: subnet.nsg ? {
            id: nsgId
          } : null
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnetIds object = toObject(vnet.properties.subnets, s => s.name, s => s.id)
