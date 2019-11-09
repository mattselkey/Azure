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
    Import-LocalAZprofile -ProfilePath $AZContextPath
    Get-InstalledModule -Name Az.Resources | Install-Module -AllowClobber -Force
    #Get-InstalledModule -Name Az.* | Uninstall-Module -Force
    #Get-InstalledModule -Name Az | Uninstall-Module -Force
    #New-AzResourceGroupDeployment  -resource 
}


PROCESS{


$templateFolder = "./ARM_Templates/"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$($templateFolder)template.json" -TemplateParameterFile "$($templateFolder)parameters.json" 

}

END{



}
