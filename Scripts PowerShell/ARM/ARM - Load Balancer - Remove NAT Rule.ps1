

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



<# Load Balancer (LB) - Remove NAT Rule #>

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






$rgName="qweasdzxc-rg"
$lbName="qweasdzxc-lb"
$frontendName = "qweasdzxcFrontEndPool"




<# NAT Rule #>

<#

Load Balancer (LB)


#>

# Variables - NAT Rule

$lbRuleName = "TestNatRule"
$natRuleFrontEndPort = 3350
$natRuleBackEndPort = 3350





Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName -ErrorVariable isLBExist -ErrorAction SilentlyContinue `


if (!$isLBExist) 
{
    Write-Output "Load Balancer exist"
    


    Write-Verbose "Fetching Load Balancer (LB): {$lbName}"
    $lb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName 


    #Write-Verbose "Fetching Backend Pool: {$backendPoolName}"
    #$backend = Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name $backendPoolName -LoadBalancer $lb
    
    Write-Verbose "Fetching Frontend IP config: {$frontendName}"
    $frontendIP = Get-AzureRmLoadBalancerFrontendIpConfig -Name $frontendName -LoadBalancer $lb
    #$frontendIP = $lb.FrontendIpConfigurations[0]


    Write-Verbose "Creating NAT rules: {$lbRuleName}"

    Add-AzureRmLoadBalancerInboundNatRuleConfig `
        -LoadBalancer $lb `
        -Name $lbRuleName `
        -FrontendIPConfiguration $frontendIP `
        -FrontendPort $natRuleFrontEndPort `
        -BackendPort $natRuleBackEndPort `
        -Protocol "Tcp" `
        -EnableFloatingIP

    Set-AzureRmLoadBalancer -LoadBalancer $lb

} 
else 
{
    Write-Output "Load Balancer does not exist"
}


<#

    # Remove NAT rule

    Write-Verbose "Fetching Load Balancer (LB): {$lbName}"
    $lb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName 


    Write-Verbose "Removing NAT rule: {$lbRuleName} from Load Balancer (LB): {$lbName}"
    
    Remove-AzureRmLoadBalancerInboundNatRuleConfig -Name $lbRuleName -LoadBalancer $lb 

    Set-AzureRmLoadBalancer -LoadBalancer $lb

#>





<#
  
##########################################


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



#>




<#
# References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

#>


