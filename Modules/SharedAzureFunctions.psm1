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
param (
    [Parameter(Mandatory=$true)]
    [String]
    $ProfilePath,
    [Parameter(Mandatory=$false)]
    [Bool]
    $Silent=$true
)

if($Silent){
    $InformationPreference="SilentlyContinue"
}
else{
    $InformationPreference="Continue"
}


    Write-Information -MessageData "Loading Azure from location $($ProfilePath)."
    try{
        
        Test-Path($ProfilePath){
        $AzContent = Import-AzContext -Path $ProfilePath -ErrorAction Stop
        #Import-AzContext -Path $AZContextPath 
        }else{
            Write-Information -MessageData "Cannot find Azure profile in path $($ProfilePath). Performing manual logon."
            Connect-AzAccount  
        }
        
        return $AzContent
    }
    catch{
        Write-Error -Message "Error loading profile: $($_)"
        Pause
        exit
    }
}

function Import-AllAzureModules{
    param (
        [Parameter(Mandatory=$false)]
        [Bool]
        $Silent=$true
    )
    if($Silent){
        $InformationPreference="SilentlyContinue"
    }
    else{
        $InformationPreference="Continue"
    }

    Write-Information -MessageData "Checking if Azure Modules are loaded. Loading if needed"
    $AZModules = Get-InstalledModule -Name Az -ErrorAction SilentlyContinue

    if(($null -eq $AZModules)){
        Write-Information -MessageData "Azure Modules are not loaded, loading Modules"
        Find-Module -Name Az | Install-Module -AllowClobber -Force
    
        }
        else{
        Write-Information -MessageData "Azure Modules are loaded. Checking for latest"
        Update-Module -Name Az -Force
        }

}

Export-ModuleMember -Function *