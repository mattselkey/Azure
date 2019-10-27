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
    $Location,
    [String]
    $AZContextPath="/home/mskey/Documents/AZURE/azureprofile.json"
)

BEGIN{
    Import-module -Name ./Modules/* -Verbose
    Import-AllAzureModules
    Import-AZprofile -ProfilePath $AZContextPath
}


PROCESS{

Connect-AzAccount
$templateUri = "./ARM_Templates/"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -Location $location

}

END{



}
