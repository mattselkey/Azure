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
    https://docs.microsoft.com/en-us/azure/virtual-machines
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$False)]
    [String]
    $ResourcePreFixName="MultiVM",
    [Parameter(Mandatory=$False)]
    [String]
    $Location="northeurope",   
    [Parameter(Mandatory=$True)]
    [Int32]
    $NumberOfVMs, 
    [Parameter(Mandatory=$False)]
    [String]
    $vmSize = "Standard_B2ms"  
)

Connect-AzAccount
$sub = Get-AzSubscription 
Select-AzSubscription -Subscription $sub.Name

#Resource Group
$ResourceGroupName = "$($ResourcePreFixName)_RG"
 
#Virtual Network 
$networkName = "$($ResourcePreFixName)-VNET"
$nicPrefix = "NIC-"
$vnet = Get-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName
 
#Virtual Machines
$publisherName = "MicrosoftWindowsServer"
$offer = "WindowsServer"
$skus = "2016-Datacenter"
$credential = Get-Credential

#Create
for($i = 0; $i -le $NumberOfVMs.count; $i++)  
{
$CurrentVM = $NumberOfVMs[$i] + 1    
$ServerName = "VM_$($CurrentVM)"

#Virtual Nic Splat    
$virtualNicParams = @{
    Name = "$($nicPrefix)_$($ServerName)"
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    SubnetId = "$($Vnet.Subnets[0].Id)"
}

#Create new virtual Network Interface
 $NIC = New-AzNetworkInterface @virtualNicParams
 
$VirtualMachine = New-AzVMConfig -VMName $ServerName -VMSize $VMSize

$newVMParams = @{
        VM = $ServerName
        Windows = $true
        computerName = $ServerName
        Credential = $credential
        ProvisionVMAgent = $True
        EnableAutoUpdate = $True
    }

 $VirtualMachine = Set-AzVMOperatingSystem @$newVMParams
 
 $VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id

$newVMParams = @{
    VM = $ServerName
    Windows = $true
    computerName = $ServerName
    Credential = $credential
    ProvisionVMAgent = $True
    EnableAutoUpdate = $True
    }

$vmSourceParams = @{

    VM = $VirtualMachine
    PublisherName = $publisherName
    Offer = $offer
    Skus = $skus
    Version = $latest
}

$VirtualMachine = Set-AzVMSourceImage @vmSourceParams
 
$newVmParams = @{
    ResourceGroupName = $ResourceGroupName 
    Location = $LocationName
    VM = $VirtualMachine
    Verbose = $True
}

New-AzVM -ResourceGroupName @newVmParams

}
