<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $Resourcegroup,
    [String]
    $Location
)

Connect-AzAccount
$templateUri = "./ARM_Templates/"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -Location $location