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
    $resourceGroupName,
    [String]
    $Location,
    [String]
    $AZContextPath="/home/mskey/Documents/AZURE/azureprofile.json",
    [Parameter(Mandatory=$false)]
    [Bool]
    $Silent=$true
)

BEGIN{

    if($Silent){
        $Global:info="SilentlyContinue"
    }
    else{
        $Global:info="Continue"
    }
    


    Import-module -Name ./Modules/* -Verbose
    Import-AllAzureModules
    Import-LocalAZprofile -ProfilePath $AZContextPath
    Find-module -Name Az.Resources | Where-Object {$_.Version -eq "1.7.1" } | Install-Module -AllowClobber -Force
    Import-Module -Name Az.Resources
    #Get-InstalledModule -Name Az.* | Uninstall-Module -Force
    #Get-InstalledModule -Name Az | Uninstall-Module -Force
    #New-AzResourceGroupDeployment  -resource 
}


PROCESS{

$templateFolder = "./ARM_Templates/ResourceGroups/"

New-AzResourceGroup -Name $resourceGroupName -Location "West Europe"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$($templateFolder)template.json" -TemplateParameterFile "$($templateFolder)parameters.json" 

}

END{
    $null = Disconnect-AzAccount


}
