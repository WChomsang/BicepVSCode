param rgLocation string = resourceGroup().location
param corporateIp string
param destinationApplicationSecurityGroups array = []

@description('Name of the Network Security Group.')
param nsgName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: nsgName
  location: rgLocation
  properties: {
    securityRules: [
      {
        name: 'AllowCorpRDP'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: corporateIp
          // only destinationApplicationSecurityGroups or destinationAddressPrefix can be set, not both. In this example, we are using destinationApplicationSecurityGroups, so destinationAddressPrefix is set to '*' to allow traffic to any destination within the ASG.
          // destinationAddressPrefix: '*'
          destinationApplicationSecurityGroups: [
            for asgId in destinationApplicationSecurityGroups: {
              id: asgId
            }
          ]
        }
      }
    ]
  }
}

output nsgId string = nsg.id
