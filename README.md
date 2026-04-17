# Bicep VNet and Storage Account

Deploy an Azure Virtual Network and Storage Account using Bicep and PowerShell.

## Prerequisites

- [Azure PowerShell](https://learn.microsoft.com/powershell/azure/install-az-ps)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- An active Azure subscription

## Project Structure

| File | Description |
|---|---|
| `main.bicep` | Entry point — references VNet and Storage modules |
| `modules/vnet.bicep` | Virtual Network with subnets |
| `modules/storage.bicep` | Storage Account |
| `deploy.ps1` | Creates resource group and deploys `main.bicep` |
| `cleanup.ps1` | Removes the resource group and all resources |

## Steps

1. **Create modules** — define `modules/vnet.bicep` and `modules/storage.bicep`
2. **Create `main.bicep`** — reference both modules
3. **Deploy** — run `./deploy.ps1` (optionally pass `-ResourceGroupName` and `-Location`)
4. **Cleanup** — run `./cleanup.ps1` (optionally pass `-ResourceGroupName`)
