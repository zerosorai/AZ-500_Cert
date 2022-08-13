

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



<# Remove NIC from LB #>

<#

Network Interface (NIC)

#>

# Variables - common

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


$nicShortName = "qweasdzxc"
$nicSuffix = "-nic"
$nicName = "${nicShortName}${nicSuffix}"





# Network Interface (NIC)
Write-Verbose "Featching Network Interface (NIC): {$nicName}"
$nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName



# Remove a VM's Network Interface (NIC) from the load balancer
Write-Verbose "Detaching/Removing VM's Network Interface (NIC) {$nicName} from the load balancer"
        
$nic.Ipconfigurations[0].LoadBalancerBackendAddressPools = $null

Set-AzureRmNetworkInterface -NetworkInterface $nic








<#

#>





<#
# References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

#>


