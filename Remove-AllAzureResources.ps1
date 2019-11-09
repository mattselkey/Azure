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
    $AZContextPath="/home/mskey/Documents/AZURE/azureprofile.json",
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

Import-Module -Name ./Modules/* -Verbose
Write-Information -MessageData "Importing Az Modules" -InformationAction $info 
Import-AllAzureModules
Write-Information -MessageData "Importing Porfile" -InformationAction $info
Import-AZprofile -ProfilePath $AZContextPath
}


PROCESS{

try{
 
    $Azcontext = Get-AzContext | Where-Object {$_.Account.Id -eq  $Account}
}
catch{
    Write-Error -Message "Cannot get current AzureConext"

} 

    try{
            if($null -eq $Azcontext){
                Write-Information -MessageData "Context not found from save Profile. Connecting to Azure" 
                Connect-AzAccount -Tenant $Azcontext.Account.Tenant.Id
                #Linux path
                if(-Not (Test-Path $AZContextPath) ){
                Write-Information -MessageData "Saving Azure Account Context."
             #   Save-AzContext -Path $AZContextPath -Force
             Get-AzDefault
             
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
        Write-Information -MessageData "The resource groups found. Nothing to do."

    }
}
END{

    $null = Disconnect-AzAccount

}