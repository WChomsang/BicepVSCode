param (
    [string]$ResourceGroupName = "Sandbox-Playground"
)

# Verify active Azure context
$context = Get-AzContext -ErrorAction SilentlyContinue
if ($null -eq $context) {
    Write-Error "No active Azure session. Please run connect.ps1 first."
    exit 1
}

Write-Host "---------------------------------------------------" -ForegroundColor Cyan
Write-Host "Tenant       : $($context.Tenant.Id)"                -ForegroundColor Yellow
Write-Host "Subscription : $($context.Subscription.Name)"        -ForegroundColor Yellow
Write-Host "Account      : $($context.Account.Id)"               -ForegroundColor Yellow
Write-Host "---------------------------------------------------" -ForegroundColor Cyan

# Confirm RG exists in this tenant/subscription
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if ($null -eq $rg) {
    Write-Error "Resource group '$ResourceGroupName' not found in tenant '$($context.Tenant.Id)' / subscription '$($context.Subscription.Name)'."
    exit 1
}

Write-Host "Resource group '$ResourceGroupName' found in the above tenant/subscription." -ForegroundColor Green

# List resources inside the RG
$resources = Get-AzResource -ResourceGroupName $ResourceGroupName
if ($resources.Count -eq 0) {
    Write-Host "No resources found in '$ResourceGroupName'." -ForegroundColor Gray
} else {
    Write-Host "`nResources in '$ResourceGroupName':" -ForegroundColor Cyan
    $resources | Select-Object Name, ResourceType, Location | Format-Table -AutoSize
}

$confirm = Read-Host "Are you sure you want to delete '$ResourceGroupName'? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit 0
}

Remove-AzResourceGroup -Name $ResourceGroupName -Verbose
