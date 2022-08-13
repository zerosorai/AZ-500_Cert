

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



<# Resource Group #>


# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


# Variables - Network Interface (NIC)

$nicShortName = "qweasdzxc2"
$nicSuffix = "-nic"
$nicName = "${nicShortName}${nicSuffix}"

# Variables - Virtual Network

$vnetShortName = "qweasdzxc"
$vnetSuffix = "-vnet"
$vnetName = "${vnetShortName}${vnetSuffix}"

# subnet
$subnetName = "WebSubnet"




<# Network Interface (NIC) - Change the subnet of a network interface #>

<#

Network Interface (NIC)
Virtual Network (VNet)

Props:
Subnet Name

#>




Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -ErrorVariable isNICExist -ErrorAction SilentlyContinue `


if (!$isNICExist) 
{
    Write-Output "Network Interface (NIC) exist"


    # Virtual Network (VNet)
    Write-Verbose "Fetching Virtual Network (VNet): {$vnetName}"
    $vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName


    # Subnet
    Write-Verbose "Fetching Subnet: {$subnetName}"
    $subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

    
    # Network Interface (NIC) 
    Write-Verbose "Fetching Network Interface (NIC): {$nicName}"
    $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName


    Write-Verbose "Changing the subnet of a Network Interface (NIC): {$nicName}"

    $nic.IpConfigurations[0].Subnet.Id = $subnet.Id

    $nic | Set-AzureRmNetworkInterface
} 
else 
{
    Write-Output "Network Interface (NIC) does not exist"
}



<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/set-azurermnetworkinterface?view=azurermps-6.13.0

#>


