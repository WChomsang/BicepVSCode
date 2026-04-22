@minLength(3)
@maxLength(24)
@description('Provide a name for the storage account. Use only lowercase letters and numbers. The name must be unique across Azure.')
param storageAccountName string = 'store${uniqueString(resourceGroup().id)}'

param rgLocation string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: storageAccountName
  location: rgLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output storageAccountId string = stg.id
output storageUri string = stg.properties.primaryEndpoints.blob
