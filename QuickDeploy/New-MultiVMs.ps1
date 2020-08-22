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
    $vmSize = "Standard_B2ms",
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


#Virtual Network
$networkName = "$($ResourcePreFixName)-VNET"
$vNetParams = @{

    ResourceGroupName = $ResourceGroupName
    Location = $Location
    Name = $networkName
    AddressPrefix = "10.0.0.0/16"

}
$virtualNetwork = New-AzVirtualNetwork @vNetParams

$subnetParams = @{
    Name = "default" 
    AddressPrefix = "10.0.0.0/24"
    VirtualNetwork = $virtualNetwork
}

Add-AzVirtualNetworkSubnetConfig @subnetParams

$virtualNetwork | Set-AzVirtualNetwork
$vNet = Get-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName


#Virtual Machines
$nicPrefix = "NIC"
$publisherName = "MicrosoftWindowsServer"
$offer = "WindowsServer"
$skus = "2016-Datacenter"
$credential = Get-Credential -Message "Enter a username and password for the virtual machine(s)."


#Create
for($i = 0; $i -le $NumberOfVMs -1; $i++)  
{
$CurrentVM = $NumberOfVMs[$i]    
$ServerName = "VM-$($CurrentVM)"

#Virtual Nic Splat    
$virtualNicParams = @{
    Name = "$($nicPrefix)_$($ServerName)"
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    SubnetId = "$($vNet.Subnets[0].Id)"
}

#Create new virtual Network Interface
 $NetworkCard = New-AzNetworkInterface @virtualNicParams
 
$VirtualMachineConfig = New-AzVMConfig -VMName $ServerName -VMSize $VMSize
$newVMParams = @{
        VM = $VirtualMachineConfig
        Windows = $true
        computerName = $ServerName
        Credential = $credential
        ProvisionVMAgent = $True
        EnableAutoUpdate = $True
    }

$VirtualMachineConfig = Set-AzVMOperatingSystem @newVMParams
 
$VirtualMachineConfig = Add-AzVMNetworkInterface -VM $VirtualMachineConfig -Id $NetworkCard.Id

$vmSourceParams = @{

    VM = $VirtualMachineConfig
    PublisherName = $publisherName
    Offer = $offer
    Skus = $skus
    Version = "latest"
}

$VirtualMachine = Set-AzVMSourceImage @vmSourceParams
 
$newVmParams = @{
    ResourceGroupName = $ResourceGroupName 
    Location = $Location
    VM = $VirtualMachine
    Verbose = $True
}

New-AzVM @newVmParams

}
