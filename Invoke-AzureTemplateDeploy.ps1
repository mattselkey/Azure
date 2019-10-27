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
    $Resourcegroup,
    [String]
    $Location
)

BEGIN{
    function Import-AZprofile{
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $AZContextPath
        )

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

}


PROCESS{

Connect-AzAccount
$templateUri = "./ARM_Templates/"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -Location $location

}

END{



}
