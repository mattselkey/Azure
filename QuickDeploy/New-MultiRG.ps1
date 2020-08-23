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

$RGNameprefix = "RG"
Get-AzLocation  | Select-Object Location | Sort-Object -Property Location
for($i = 0; $i -le $NumberOfRGs -1; $i++)  
{
    
    $Location = Read-Host -Prompt "In which location should this RG reside."
    New-AzResourceGroup -Name "$($RGNameprefix)$($i + 1)" -Location $Location 
}