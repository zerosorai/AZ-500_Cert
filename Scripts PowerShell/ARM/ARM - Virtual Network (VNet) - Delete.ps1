
<# Virtual Network (VNet) #>

<#


#>


# Variables - Virtual Network

$vnetShortName = "qweasdzxc"
$vnetSuffix = "-vnet"
$vnetName = "${vnetShortName}${vnetSuffix}"

# subnets
$webSubnetName = "WebSubnet"
$frontendSubnetName = "FrontEndSubnet"
$backendSubnetName = "BackEndSubnet"



<# Create Virtual Network (VNet), if it does not exist #>

Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -ErrorVariable isVNetExist -ErrorAction SilentlyContinue `


If ($isVNetExist) 
{
    Write-Output "Virtual Network (VNet) does not exist"
    

    
    Write-Verbose "Creating new subnet: {$webSubnetName}"

    $webSubnet = New-AzureRmVirtualNetworkSubnetConfig `
        -Name $webSubnetName `
        -AddressPrefix "10.0.0.0/24"

    
    Write-Verbose "Creating new subnet: {$frontendSubnetName}"

    $frontendSubnet = New-AzureRmVirtualNetworkSubnetConfig `
        -Name $frontendSubnetName `
        -AddressPrefix "10.0.1.0/24"

    
    Write-Verbose "Creating new subnet: {$backendSubnetName}"

    $backendSubnet = New-AzureRmVirtualNetworkSubnetConfig `
        -Name $backendSubnetName `
        -AddressPrefix "10.0.2.0/24"



    Write-Verbose "Creating new Virtual Network (VNet): {$vnetName}"

    $vnet = New-AzureRmVirtualNetwork `
              -Name $vnetName `
              -ResourceGroupName $rgName `
              -Location $location `
              -AddressPrefix 10.0.0.0/16 `
              -Subnet $webSubnet, $frontendSubnet, $backendSubnet `
              -Tag $tags
}
Else 
{
    Write-Output "Virtual Network (VNet) exist"


    Write-Verbose "Fetching Virtual Network (VNet): {$vnetName}"

    $vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

    # list of subnets
    Write-Output "Subnets of Virtual Networks (VNet): {$vnetName}"
    $vnet.Subnets | Format-Table Name, AddressPrefix
}



Write-Verbose "Get list of all Virtual Network (VNet)"
Write-Output "Virtual Networks (VNet)"


Get-AzureRmVirtualNetwork -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap 



# list of subnets
Get-AzureRmVirtualNetwork -ResourceGroupName $rgName `
    | Select-Object -ExpandProperty Subnets `
    | Select-Object Name, AddressPrefix `
    | Format-Table -AutoSize -Wrap 



<#

Get-AzureRmVirtualNetwork `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName 

#>



<#

## Remove Virtual Network (VNet)

$vnetShortName = "qweasdzxc"
$vnetSuffix = "-vent"
$vnetName = "${vnetShortName}${vnetSuffix}"


Write-Verbose "Deleting Virtual Network (VNet): {$vnetName}"

Remove-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Force

#>




<#
## References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-virtual-network
https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-powershell
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/get-azurermvirtualnetwork?view=azurermps-6.13.0
https://github.com/robotechredmond/Azure-PowerShell-Snippets/blob/master/Azure%20Resource%20Manager%20-%20Create%20V2%20environment%20w%20VNET%20GW%20demo.ps1
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/add-azurermvirtualnetworksubnetconfig?view=azurermps-6.13.0

get data
https://github.com/anthonychu/azure-content/blob/master/articles/virtual-network/virtual-network-multiple-ip-addresses-powershell.md

#>

