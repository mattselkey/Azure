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
    [Parameter(Mandatory=$False)]
    [String]
    $ResourcePreFixName="MultiAS",
    [Parameter(Mandatory=$True)]
    [int32]
    $NumberOfRGs,
    [Parameter(Mandatory=$False)]
    [String]
    $context = "Visual Studio Premium with MSDN" 

)
$currentContext = Get-AzContext | Where-Object {$_.Subscription.Name  -EQ $context}

if(!$currentContext){
    Connect-AzAccount
}
$sub = Get-AzSubscription 
Select-AzSubscription -Subscription $sub.Name

#Resource Group
$ResourceGroupName = "$($ResourcePreFixName)_RG"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location



for($i = 0; $i -le $NumberOfRGs -1; $i++)  
{


New-AzureRmAvailabilitySet -ResourceGroupName "ResourceGroup11" -Name "AvailabilitySet03" -Location "West US"
}