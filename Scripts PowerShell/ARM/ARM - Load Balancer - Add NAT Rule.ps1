

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



<# Remove NIC to LB #>

<#

Network Interface (NIC)
Load Balancer (LB)

#>

# Variables - common

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


$nicShortName = "qweasdzxc"
$nicSuffix = "-nic"
$nicName = "${nicShortName}${nicSuffix}"


$lbShortName = "qweasdzxc"
$lbSuffix = "-lb"
$lbName = "${lbShortName}${lbSuffix}"


  


# Network Interface (NIC)
Write-Verbose "Featching Network Interface (NIC): {$nicName}"
$nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName



# Add VM's Network Interface (NIC) to the load balancer

Write-Verbose "Featching Load Balancer (LB): {$lbName}"
$lb = Get-AzureRMLoadBalancer -Name $lbName -ResourceGroupName $rgName

Write-Verbose "Attaching/Adding VM's Network Interface (NIC) {$nicName} to the load balancer: {$lbName}"

#$nic.IpConfigurations[0].LoadBalancerBackendAddressPools = $lb.BackendAddressPools[0]

#Set-AzureRmNetworkInterface -NetworkInterface $nic




$nic.LoadBalancerInboundNatRule = $lb.InboundNatRules[0]

Set-AzureRmNetworkInterface -NetworkInterface $nic


<#

#>




<#
# References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

#>


