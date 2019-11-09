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

    Write-Information -MessageData "Loading Azure from location $($ProfilePath)." -InformationAction $info
    try{
        $AzContent = Import-AzContext -Path $ProfilePath -ErrorAction Stop
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

    Write-Information -MessageData "Checking if Azure Modules are loaded. Loading if needed" -InformationAction $info
    $AZModules = Get-InstalledModule -Name Az

    if(($null -eq $AZModules)){
        Write-Information -MessageData "Azure Modules are not loaded, loading Modules" -InformationAction $info
        Find-Module -Name Az | Install-Module -AllowPrerelease -AllowClobber -Force
    
        }
        else{
        Write-Information -MessageData "Azure Modules are loaded. Checking for latest" -InformationAction $info
        Update-Module -AllowPrerelease -Name Az -Force
        }

}

Export-ModuleMember -Function *