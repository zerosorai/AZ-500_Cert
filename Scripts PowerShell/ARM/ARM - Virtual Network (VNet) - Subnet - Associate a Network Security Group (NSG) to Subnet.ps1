
<# Associate a Network Security Group (NSG) to Subnet #>

<#
Virtual Network (VNet)
Network Security Group (NSG)

#>


# Variables - Subnet

$subnetShortName = "Test"
$subnetSuffix = "Subnet"
$subnetName = "${subnetShortName}${subnetSuffix}"



<# Associate a Network Security Group (NSG) to Subnet, if it does not exist #>

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -ErrorVariable isSubnetExist -ErrorAction SilentlyContinue `


if (!$isSubnetExist) 
{
    Write-Output "Subnet exist"
    

    # Network Security Group (NSG) 
    Write-Verbose "Fetching Network Security Group (NSG): {$nsgName}"
    $nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName


    # Virtual Network (VNet)
    Write-Verbose "Fetching Virtual Network (VNet): {$vnetName}"
    $vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName


    Write-Verbose "Associating a Network Security Group (NSG): {$nsgName} to Subnet (VNet): {$subnetName}"
    Set-AzureRmVirtualNetworkSubnetConfig `
        -Name $subnetName `
        -VirtualNetwork $vnet `
        -NetworkSecurityGroup $nsg


    # updates the existing virtual network with the updated subnet.
    $vnet | Set-AzureRmVirtualNetwork
}
else 
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

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/set-azurermvirtualnetworksubnetconfig?view=azurermps-6.13.0

#>

