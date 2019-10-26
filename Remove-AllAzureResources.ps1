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
    $Account,
    [String]
    $TenantID 
)
Write-Information -MessageData "Checking if Azure Modules are loaded. Loading if needed" -InformationAction Continue
$AZModules = Get-Module | Where-Object {$_.Name -like "*Az*"} 

if($null -eq $AZModules){
    Write-Information -MessageData "Azure Modules are not loaded, loading all Modules" -InformationAction Continue 
    Install-Module -Name Az -AllowClobber -Force}
    else{
    Write-Information -MessageData "Azure Modules are loaded." -InformationAction Continue 
    }

try{
    $Azcontext = Get-AzContext -ErrorAction SilentlyContinue | Where-Object {$_.Account -eq $Account}
}
catch{
    Write-Error -Message "Cannot get current AzureConext"

}    
    try{
            if($null -eq $Azcontext){Connect-AzAccount -Tenant  $TenantID }
        }
        catch{
            Write-Error -Message "Error connecting to Azure $($_)"
            Pause
            exit
    }

    $AZResouceGroups = Get-AzResourceGroup
   
    if($AZResouceGroups){
    foreach($AZResouceGroup in $AZResouceGroups){
    #Remove-AzResourceGroup -Name $AZResouceGroup.ResourceGroupName -Force
    }
    else{
        Write-Information -MessageData "Azure Modules are loaded." -InformationAction Continue 

    }
    }
    Disconnect-AzAccount