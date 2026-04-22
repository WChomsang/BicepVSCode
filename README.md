# 🚀 Deploy a Windows VM on Azure with Bicep

Spin up a fully secured Windows Server 2022 VM on Azure in minutes — networking, firewall rules, and antivirus enforcement all included. No manual portal clicks required.

---

## 🗺️ What Gets Deployed

```
┌─────────────────────────────────────────────────┐
│  Resource Group: Sandbox-Playground              │
│                                                  │
│  Storage Account  ←  VM boot diagnostics         │
│                                                  │
│  VNet (10.0.0.0/16)                              │
│  ├── Subnet-1  10.0.1.0/24                       │
│  └── Subnet-2  10.0.2.0/24  ← VM lives here     │
│                    │                             │
│                   NSG  ← RDP only from your IP   │
│                    │                             │
│                   NIC  ← Static Public IP        │
│                    │                             │
│                   VM  (Windows Server 2022)      │
│                    └── Defender always ON (GP)   │
│                                                  │
│  ASG  ← scopes the NSG rule to this VM only      │
└─────────────────────────────────────────────────┘
```

---

## ✅ Prerequisites

### 1. PowerShell 7+

Check if you already have it:

```powershell
$PSVersionTable.PSVersion
```

If the major version is below 7, [download PowerShell 7](https://github.com/PowerShell/PowerShell/releases/latest) and install it. Then always use **pwsh** (not Windows PowerShell) for this project.

---

### 2. Azure PowerShell module

Install the Az module from pwsh:

```powershell
Install-Module -Name Az -Repository PSGallery -Force
```

Verify it's installed:

```powershell
Get-Module -Name Az -ListAvailable | Select-Object Name, Version -First 1
```

---

### 3. Bicep (via Azure PowerShell — no CLI needed)

The `Az` module includes built-in Bicep support. Confirm it works:

```powershell
Get-Command New-AzResourceGroupDeployment
```

That's the only command needed — it accepts `.bicep` files directly without installing the Bicep CLI separately.

> 💡 If you ever see a `bicep build` error, follow the [official Bicep installation guide](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install).

---

### 4. Active Azure subscription

Verify you can connect:

```powershell
Connect-AzAccount
Get-AzSubscription
```

You should see your subscription listed.

---

## ⚙️ Setup (one-time)

Create a `.env` file in the project root with your VM credentials:

```env
VM_ADMIN_USERNAME=azureuser
VM_ADMIN_PASSWORD=YourStr0ngPassword!
```

> This file is already in `.gitignore` — it will never be committed.

**Password rules:** minimum 12 characters, must include uppercase, lowercase, number, and symbol.

---

## 🚢 Deploy

```powershell
# 1. First time — will prompt you to log in to Azure
.\deploy.ps1

# 2. Already logged in? Skip the login prompt
.\deploy.ps1 -skipLogin

# 3. Use a different resource group or region
.\deploy.ps1 -ResourceGroupName "MyRG" -Location "East US" -skipLogin
```

| Parameter | Default | Description |
|---|---|---|
| `-ResourceGroupName` | `Sandbox-Playground` | Resource group to deploy into (created if missing) |
| `-Location` | `Southeast Asia` | Azure region |
| `-TemplateFile` | `./main.bicep` | Bicep entry point |
| `-skipLogin` | *(off)* | Skip `Connect-AzAccount` if already authenticated |

> 💡 The script auto-detects your current public IP and restricts RDP access to that IP only.

---

## 🧹 Cleanup

When you're done, delete everything with one command:

```powershell
.\cleanup.ps1

# Different resource group?
.\cleanup.ps1 -ResourceGroupName "MyRG"
```

The cleanup script will:
1. Verify you're connected to the **correct tenant and subscription**
2. **List all resources** in the group so you know exactly what will be deleted
3. Ask for a **`yes` confirmation** before doing anything

---

## 📁 Project Structure

```
BicepVSCode/
├── main.bicep              # Entry point — wires all modules together
├── deploy.ps1              # Deploy script
├── cleanup.ps1             # Cleanup script
├── .env                    # Your credentials (gitignored)
└── modules/
    ├── storage.bicep       # Storage Account for boot diagnostics
    ├── asg.bicep           # Application Security Group
    ├── nsg.bicep           # NSG — RDP locked to your IP + ASG
    ├── vnet.bicep          # VNet + 2 subnets
    ├── nic.bicep           # NIC + static Public IP + ASG membership
    └── vm.bicep            # Windows Server 2022 VM
```

---

## 🔐 Security Highlights

| Feature | How it's implemented |
|---|---|
| RDP locked to your IP | NSG rule uses `corporateIp` (auto-detected) |
| RDP scoped to this VM only | NSG rule targets the ASG, not a broad address prefix |
| Real-time antivirus enforced | Windows Defender locked on via Group Policy registry key |
| Credentials never in code | Loaded from `.env` at deploy time |

