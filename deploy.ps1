param (
    [string]$ResourceGroupName = "Sandbox-Playground",
    [string]$Location = "Southeast Asia",
    [string]$TemplateFile = "./main.bicep"
)

# Load credentials from .env file
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
            [System.Environment]::SetEnvironmentVariable($Matches[1].Trim(), $Matches[2].Trim())
        }
    }
} else {
    Write-Error ".env file not found. Please create it with VM_ADMIN_USERNAME and VM_ADMIN_PASSWORD."
    exit 1
}

# Login
Connect-AzAccount

# Create resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

# Deploy
New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -TemplateParameterObject @{
        adminUsername = $env:VM_ADMIN_USERNAME
        adminPassword = $env:VM_ADMIN_PASSWORD
    } `
    -Verbose
