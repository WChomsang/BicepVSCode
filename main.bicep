targetScope = 'resourceGroup'

param corporateIp string
param adminUsername string
@secure()
param adminPassword string

var scopeName = 'simpleVM'
var vnetName = 'myVNet'
var addressPrefix = [
  '10.0.0.0/16'
]
var subnetSettings = [
  {
    name: 'Subnet-1'
    prefix: '10.0.1.0/24'
    nsg: false
  }
  {
    name: 'Subnet-2'
    prefix: '10.0.2.0/24'
    nsg: true
  }
]
var vmSize = 'Standard_B2as_v2'
var vmName = 'myVM'
var nicSubnetId = 'Subnet-2'

module storageModule './modules/storage.bicep' = {}

module asgModule './modules/asg.bicep' = {
  params: {
    scopeName: '${scopeName}-asg'
  }
}

module nsgModule './modules/nsg.bicep' = {
  params: {
    nsgName: '${vnetName}-nsg'
    corporateIp: corporateIp
    destinationApplicationSecurityGroups: [
      asgModule.outputs.asgId
    ]
  }
}

module vnetModule './modules/vnet.bicep' = {
  params: {
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnetSettings: subnetSettings
    nsgId: nsgModule.outputs.nsgId
  }
}

module nicModule './modules/nic.bicep' = {
  params: {
    nicName: '${vmName}-nic'
    subnetId: vnetModule.outputs.subnetIds[nicSubnetId]
    asgId: asgModule.outputs.asgId
  }
}

module vmModule './modules/vm.bicep' = {
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    vmName: vmName
    nicId: nicModule.outputs.nicId
    storageUri: storageModule.outputs.storageUri
  }
}

@description('Public IP address of the VM.')
output publicIpAddress string = nicModule.outputs.publicIpAddress

@description('Resource ID of the Network Security Group.')
output nsgId string = nsgModule.outputs.nsgId

@description('Resource ID of the Application Security Group.')
output asgId string = asgModule.outputs.asgId

@description('Resource ID of the Virtual Network.')
output vnetId string = vnetModule.outputs.vnetId

@description('Resource ID of the Subnets.')
output subnetIds object = vnetModule.outputs.subnetIds

@description('Resource ID of the Network Interface.')
output nicId string = nicModule.outputs.nicId

@description('Resource ID of the Virtual Machine.')
output vmId string = vmModule.outputs.vmId
