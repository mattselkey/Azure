<#
.SYNOPSIS
    Deploy reources from a ARM template file.
.DESCRIPTION
    
.EXAMPLE
    PS C:\>.\Invoke-AzureTemplateDeploy.ps1 -ResourceGroupName resourceGroup -Location location -AZContextPath PathToProfileJSON
    
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $ResourceGroupName,
    [Parameter(Mandatory=$false)]
    [String]
    $Location,
    [Parameter(Mandatory=$false)]
    [String]
    $AZContextPath,
    [Parameter(Mandatory=$false)]
    [Bool]
    $Silent=$true
)

BEGIN{

    if($Silent){
        $InformationPreference="SilentlyContinue"
    }
    else{
        $InformationPreference="Continue"
    }
    
    if(!$AZContextPath){
        switch([System.Environment]::OSVersion.Platform){
            "Unix"{
                Write-Information -MessageData "Checking installed modules"
                $AZContextPath =  "$($env:HOME)\azureprofile.json"

            }
            "Win32NT"{
                $AZContextPath = "$($env:USERPROFILE)\azureprofile.json"

            }
        
        }
    }


    Write-Information -MessageData "Checking installed modules"
    Import-module -Name ./Modules/* -Verbose
    Import-AllAzureModules -Silent $Silent
    Import-LocalAZprofile -ProfilePath $AZContextPath -Silent $Silent
    #Find-module -Name Az.Resources | Where-Object {$_.Version -eq "1.8.0" } | Install-Module -AllowClobber -Force
    $azModule = Get-Module -Name Az.Resources
    if($azModule){
        Write-Information -MessageData "Az.resources is already loaded"
    }else{
        Write-Information -MessageData "Modules are: $azModule"
        Write-Information -MessageData "Importing Az.Reosurces module"
        Import-Module -Name Az.Resources
    }
    #remove
    
    

    #Get-InstalledModule -Name Az.* | Uninstall-Module -Force
    #Get-InstalledModule -Name AzureRM | Uninstall-Module -Force
    #New-AzResourceGroupDeployment  -resource 

    #$scriptBlock = {Get-AzureRmLocation | select-object -ExpandProperty Location}

    #Register-ArgumentCompleter -CommandName Invoke-AzureTemplateDeploy -ParameterName Location -ScriptBlock $scriptBlock 

}


PROCESS{

$templateFolder = "./ARM_Templates/ResourceGroups/"

New-AzResourceGroup -Name $resourceGroupName -Location "West Europe"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$($templateFolder)template.json" -TemplateParameterFile "$($templateFolder)parameters.json" 

#https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/new-azurermkeyvault?view=azurermps-6.13.0

New-AzureRmKeyVault  -VaultName "$($resourceGroupName)KeyVault" -ResourceGroupName $resourceGroupName -Location "West Europe"

}

END{
    $null = Disconnect-AzAccount


}
