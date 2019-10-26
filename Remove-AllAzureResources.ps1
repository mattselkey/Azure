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
    $Account
)

$AZModules = Get-Module | Where-Object {$_.Name -like "*Az*"}
Write-Information -MessageData "" 
if(
   
$null -eq $AZModules){Install-Module -Name Az -AllowClobber -Force}


$Azcontext = Get-AzContext | Where-Object {$_.Account -eq $Account }
 #try{
 #if($null -eq $Azcontext){Connect-AzAccount -Account $Account}
 #}
 #catch{
 #}

#$AZResouceGroups = Get-AzResourceGroup
#
#foreach($AZResouceGroup in $AZResouceGroups){
#
#Remove-AzResourceGroup -Name $AZResouceGroup.ResourceGroupName -Force


}