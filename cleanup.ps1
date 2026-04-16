param (
    [string]$ResourceGroupName = "exampleRG"
)

Remove-AzResourceGroup -Name $ResourceGroupName -Verbose
