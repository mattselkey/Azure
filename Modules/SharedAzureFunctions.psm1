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


function Import-localAZProfile{
[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $ProfilePath 
)

    Write-Information -MessageData "Loading Azure from location $($ProfilePath)." -InformationAction Continue
    try{
        $AzContent = Import-AzContext -Path $ProfilePath  -ErrorAction stop
        
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
        else{
        Write-Information -MessageData "Azure Modules are loaded."
        Update-Module -Name Az
        }

}

Export-ModuleMember -Function *