# Bicep VNet and Storage Account

Deploy an Azure Virtual Network and Storage Account using Bicep and PowerShell.

## Prerequisites

- [Azure PowerShell](https://learn.microsoft.com/powershell/azure/install-az-ps)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- An active Azure subscription

## Steps

1. **Create `main.bicep`** — define a VNet with subnets and a Storage Account resource
2. **Deploy** — create a resource group and run `New-AzResourceGroupDeployment`
3. **Cleanup** — delete the resource group with `Remove-AzResourceGroup`
