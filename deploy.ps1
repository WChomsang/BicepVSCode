param (
    [string]$ResourceGroupName = "Sandbox-Playground",
    [string]$Location = "Southeast Asia",
    [string]$TemplateFile = "./main.bicep",
    [switch]$skipLogin
)

# Load credentials from .env file
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
            [System.Environment]::SetEnvironmentVariable($Matches[1].Trim(), $Matches[2].Trim())
        }
    }
}
else {
    Write-Error ".env file not found. Please create it with VM_ADMIN_USERNAME and VM_ADMIN_PASSWORD."
    exit 1
}

# Login
if (-not $skipLogin) {
    Connect-AzAccount
}

# get public IP address of the machine running the script
try {
    $publicIp = (Invoke-WebRequest -Uri "https://api.ipify.org").Content
    Write-Host "Public IP address detected: $publicIp"
}
catch {
    Write-Error "Failed to retrieve public IP address. Please ensure you have an active internet connection."
    exit 1
}

# Create resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

# Deploy
New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -TemplateParameterObject @{
    adminUsername = $env:VM_ADMIN_USERNAME
    adminPassword = $env:VM_ADMIN_PASSWORD
    corporateIp = "$publicIp/32"
    } `
    -Verbose
