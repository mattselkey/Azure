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
    $AZContextPath="/home/mskey/Documents/AZURE/azureprofile.json"
)

BEGIN{
function Import-AZprofile{
    Write-Information -MessageData "Logging into Azure using saved profile" -InformationAction Continue 
    try{
        $AzContent = Import-AzContext -Path $AZContextPath -ErrorAction stop
        #Import-AzContext -Path $AZContextPath 
        return $AzContent
    }
    catch{
        Write-Error -Message "Error loading profile: $($_)"
        Pause
        exit
    }
}

function Import-AllAzureModules{

    Write-Information -MessageData "Checking if Azure Modules are loaded. Loading if needed" -InformationAction Continue
    $AZModules = Get-Module | Where-Object {($_.Name -like "*Az.*")} 
    #$AZResourceManagerModules = Get-Module | Where-Object {($_.Name -like "AzureRM*")}
    
    if(($null -eq $AZModules)){
        Write-Information -MessageData "Azure Modules are not loaded, loading Modules" -InformationAction Continue 
        Find-Module -Name Az | Install-Module -AllowClobber -Force
    
        }
    #elseif (($null -eq $AZResourceManagerModules)) {
    #    Write-Information -MessageData "Azure Resouce Manager Modules are not loaded, loading Modules" -InformationAction Continue 
    #    #Find-Module -Name AzureRM* | Install-Module -AllowClobber -Force    
    #}
        else{
        Write-Information -MessageData "Azure Modules are loaded." -InformationAction Continue 
        }

}

Import-AllAzureModules
Import-AZprofile 
}


PROCESS{

try{
 
    $Azcontext = Get-AzContext | Where-Object {$_.Account.Id -eq  $Account}
    $Azcontext.Account.Id
    $Azcontext.Tenant
}
catch{
    Write-Error -Message "Cannot get current AzureConext"

} 

    try{
            if($null -eq $Azcontext){
                Write-Information -MessageData "Context not found from save Profile. Connecting to Azure" -InformationAction Continue
                Connect-AzAccount -Tenant $Azcontext.Account.Tenant.Id
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
            Write-Information -MessageData "Removing resource group $($AZResouceGroup.ResourceGroupName)" -InformationAction Continue
                Remove-AzResourceGroup -Name $AZResouceGroup.ResourceGroupName -Force
        }
    }
    else{
        Write-Information -MessageData "The resource groups found. Nothing to do."

    }
}
END{

    Disconnect-AzAccount

}