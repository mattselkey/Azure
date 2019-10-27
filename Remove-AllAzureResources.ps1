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
    $TenantID,
    [String]
    $AZContextPath="../../AZURE/azureprofile.json"
)
#https://blogs.technet.microsoft.com/dataplatform/2016/11/16/set-your-powershell-session-to-automatically-log-into-azure/
function Import-AZprofile{
    Write-Information -MessageData "Logging into Azure using saved profile" -InformationAction Continue 
    Import-AzureRmContext -Path $AZContextPath | Out-Null
    Get-AzureRmSubscription  | Select-AzureRmSubscription  | Out-Null

}

Write-Information -MessageData "Checking if Azure Modules are loaded. Loading if needed" -InformationAction Continue
$AZModules = Get-Module | Where-Object {$_.Name -like "*Az*"} 

if($null -eq $AZModules){
    Write-Information -MessageData "Azure Modules are not loaded, loading all Modules" -InformationAction Continue 
    Install-Module -Name Az -AllowClobber -Force}
    else{
    Write-Information -MessageData "Azure Modules are loaded." -InformationAction Continue 
    }
    
Import-AZprofile


try{
    $Azcontext = Get-AzContext -ErrorAction SilentlyContinue | Where-Object {$_.Account -eq $Account}
}
catch{
    Write-Error -Message "Cannot get current AzureConext"

}    
    try{
            if($null -eq $Azcontext){
                Connect-AzAccount -Tenant  $TenantID 
                #Linux path
                if(-Not (Test-Path $AZContextPath) ){
                Write-Information -MessageData "Saving Azure Account Context." -InformationAction Continue
                Save-AzContext -Path $AZContextPath -Force
                }
            }
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