param nicName string
param rgLocation string = resourceGroup().location
param subnetId string
param asgId string

@description('Name for the Public IP.')
param publicIpName string = '${nicName}-pip'

resource pip 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIpName
  location: rgLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: nicName
  location: rgLocation
  properties: {
    ipConfigurations: [
      {
        name: '${nicName}-ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: subnetId
          }
          applicationSecurityGroups: [
            { id: asgId }
          ]
        }
      }
    ]
  }
}

output pipId string = pip.id
output publicIpAddress string = pip.properties.ipAddress
output nicId string = nic.id
