# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"

# Variables - Virtual Network

$vnetShortName = "qweasdzxc"
$vnetSuffix = "-vnet"
$vnetName = "${vnetShortName}${vnetSuffix}"




<# Remove Subnet - from Virtual Network (VNet) #>

<#
Virtual Network (VNet)

#>


# Variables - Subnet

$subnetShortName = "Test"
$subnetSuffix = "subnet"
$subnetName = "${subnetShortName}${subnetSuffix}"
$addressPrefix = "10.0.6.0/24"



<# Create Subnet (in VNet), if it does not exist #>

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -ErrorVariable isSubnetExist -ErrorAction SilentlyContinue `


If (!$isSubnetExist) 
{
    Write-Output "Subnet exist"


    Write-Verbose "Fetching Virtual Network: {$vnetName}"

    $vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName


    Write-Verbose "Removing Subnet: {$subnetName}"

    Remove-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet


    # updates the existing virtual network with the new subnet.
    $vnet | Set-AzureRmVirtualNetwork

}
Else 
{
    Write-Output "Subnet does not exist"
}



Write-Verbose "Get list of all subnets"
Write-Output "Subnets"


Write-Verbose "Fetching Virtual Network: {$vnetName}"

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName


Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet `
    | Select-Object Name, AddressPrefix `
    | Format-Table -AutoSize -Wrap



<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/remove-azurermvirtualnetworksubnetconfig?view=azurermps-6.13.0

#>

