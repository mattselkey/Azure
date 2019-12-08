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
    see https://docs.microsoft.com/en-us/azure/virtual-machines/windows/encrypt-disks
#>
[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $KVRGname="MSK-KEYVAULT",
    [Parameter()]
    [String]
    $VMRGName="MSK-KEYVAULT",
    [Parameter()]
    [String]
    $vmName ="MSK-KEYVAULT"

)
 
$KeyVaultName = 'MSK-VAULT'; 
$KeyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $KVRGname; 
$diskEncryptionKeyVaultUrl = $KeyVault.VaultUri; $KeyVaultResourceId = $KeyVault.ResourceId; 

$diskEncryptionArguments = @{
    ResourceGroupName =  $VMRGname 
    VMName = $vmName
    DiskEncryptionKeyVaultUrl = $diskEncryptionKeyVaultUrl
    DiskEncryptionKeyVaultId = $KeyVaultResourceId
  }

Set-AzVMDiskEncryptionExtension @diskEncryptionArguments