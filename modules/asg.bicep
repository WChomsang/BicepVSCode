param scopeName string
param rgLocation string = resourceGroup().location

resource asg 'Microsoft.Network/applicationSecurityGroups@2025-05-01' = {
  name: scopeName
  location: rgLocation
}

output asgId string = asg.id
