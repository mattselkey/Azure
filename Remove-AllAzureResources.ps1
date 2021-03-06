<#
.SYNOPSIS
    Connect to Azure and remove ALL reosurce groups
.DESCRIPTION
    !!!USE WITH CARE!!!
    This script can be used to clear an Azure subscription of ALL reource groups.
.EXAMPLE
    PS >./Remove-AllAzureResources.ps1 -Account matthewselkirk@live.com -Silent $false
    The above will remove all resources in the account with the associated email address, setting silent to $false
    will provide additional information at the commandline for each step and failure.
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
    $Account,
    [Parameter(Mandatory=$false)]
    [String]
    $TenantID,
    [Parameter(Mandatory=$false)]
    [String]
    $AZContextPath="$env:USERPROFILE\azureprofile.json",
    [Parameter(Mandatory=$false)]
    [Bool]
    $Silent=$true
)

BEGIN{

 if($Silent){
     $InformationPreference="SilentlyContinue"
 }else{
     $InformationPreference="Continue"
 }

Import-Module -Name ./Modules/* -Verbose
Write-Information -MessageData "Importing Az Modules"
Import-AllAzureModules -Silent $false
Write-Information -MessageData "Importing Profile"
Import-localAZprofile -ProfilePath $AZContextPath -Silent $false

}

PROCESS{

try{
    Write-Information -Message "Getting loaded AZcontext for account $($Account)"
    $Azcontext = Get-AzContext | Where-Object {$_.Account.Id -eq $Account}

    if($Azcontext){
        Write-Information -Message "AZcontext successfully found for  $($Azcontext.Account.Id)"
    }
}
catch{
    Write-Information -Message "Error is: $($_)"
    Write-Information -Message "Cannot get current AzureContext. Will try to reconnect."
} 

    try{
        
            if($null -eq $Azcontext){
                Write-Information -MessageData "Context not found from save Profile. Connecting to Azure"  

                Connect-AzAccount
                
                #Linux path
                if(-Not (Test-Path $AZContextPath) ){
                Write-Information -MessageData "Saving Azure Account Context." 
                    #Save-AzContext -Path $AZContextPath -Force
                Get-AzDefault
             
            }
            else{
                Write-Information -MessageData "Context found from saved Profile." 
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
                Write-Information -MessageData "Removing resource group $($AZResouceGroup.ResourceGroupName)"  
                Remove-AzResourceGroup -Name $AZResouceGroup.ResourceGroupName -Force
        }
    }
    else{
        Write-Information -MessageData "No resource groups found. Nothing to do."

    }
}

END{

    $null = Disconnect-AzAccount

}