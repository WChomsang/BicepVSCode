module vnetModule './modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'myVNet'
  }
}

module storageModule './modules/storage.bicep' = {
  name: 'storageDeployment'
}

@description('Logs the VNet Resource ID')
output logVnetId string = 'The VNet ID is: ${vnetModule.outputs.vnetId}'

@description('Logs the Storage Account Resource ID')
output logStorageId string = 'The Storage Account ID is: ${storageModule.outputs.storageAccountId}'
