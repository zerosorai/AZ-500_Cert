

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"




# Variables - Network Interface (NIC)

$nicShortName = "qweasdzxc"
$nicSuffix = "-nic"
$nicName = "${nicShortName}${nicSuffix}"

$subnetName = "WebSubnet"


# Variables - Public IP

$publicIpShortName = "qweasdzxc2"
$publicIpSuffix = "-ip"
$publicIpName = "${publicIpShortName}${publicIpSuffix}"



<# Network Interface (NIC) - Remove Public IP #>
# NOTE: It only remove Public IP Address assignment from NIC's IP Config

<#

Network Interface (NIC)
Public IP address (Not required)

#>



Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -ErrorVariable isNICExist -ErrorAction SilentlyContinue `


If (!$isNICExist) 
{
    Write-Output "Network Interface (NIC) exist"


    Write-Verbose "Fetching Network Interface (NIC): {$nicName}"
    $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName


    Write-Verbose "Removing Public IP from Network Interface (NIC): {$nicName}"

    # Featch first IP configuration
    $nic.IpConfigurations[0].PublicIpAddress = $null 
    Set-AzureRmNetworkInterface -NetworkInterface $nic

    # NOT WORKING
    #Remove-AzureRmNetworkInterfaceIpConfig -Name $publicIpName -NetworkInterface $nic
} 
Else 
{
    Write-Output "Network Interface (NIC) does not exist"
}





<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/remove-azurermnetworkinterfaceipconfig?view=azurermps-6.13.0

#>




