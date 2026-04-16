# Bicep VNet and Storage Account

Deploy an Azure Virtual Network and Storage Account using Bicep and PowerShell.

## Prerequisites

- [Azure PowerShell](https://learn.microsoft.com/powershell/azure/install-az-ps)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- An active Azure subscription

## Project Structure

| File | Description |
|---|---|
| `main.bicep` | Bicep template — VNet and Storage Account |
| `deploy.ps1` | Creates resource group and deploys `main.bicep` |
| `cleanup.ps1` | Removes the resource group and all resources |

## Steps

1. **Create `main.bicep`** — define a VNet with subnets and a Storage Account resource
2. **Deploy** — run `./deploy.ps1` (optionally pass `-ResourceGroupName` and `-Location`)
3. **Cleanup** — run `./cleanup.ps1` (optionally pass `-ResourceGroupName`)
