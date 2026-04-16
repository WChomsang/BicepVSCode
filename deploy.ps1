param (
    [string]$ResourceGroupName = "exampleRG",
    [string]$Location = "eastus",
    [string]$TemplateFile = "./main.bicep"
)

# Login
Connect-AzAccount

# Create resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

# Deploy
New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -Verbose
