

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



<# Network Interface (NIC) - Dissociate a Network Security Group from a network interface #>

<#

Network Interface (NIC)

#>




Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -ErrorVariable isNICExist -ErrorAction SilentlyContinue `


if (!$isNICExist) 
{
    Write-Output "Network Interface (NIC) exist"

    
    # Network Interface (NIC) 
    Write-Verbose "Fetching Network Interface (NIC): {$nicName}"
    $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName


    Write-Verbose "Associate Network Security Group (NSG): {$nsgName} to Network Interface (NIC): {$nicName}"
    $nic.NetworkSecurityGroup = $null

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




