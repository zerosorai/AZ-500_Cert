

## To Set Verbose output
$PSDefaultParameterValues['*:Verbose'] = $true



# Variables - Common

$location = "eastus2"


$tags = New-Object 'System.Collections.Generic.Dictionary[String,object]'
$tags.Add("environment", "Production")         # Production, Staging, QA
$tags.Add("projectName", "Demo Project")
$tags.Add("projectVersion", "1.0.0")
$tags.Add("managedBy", "developer.aashishpatel@gmail.com")
$tags.Add("billTo", "Ashish Patel")
$tags.Add("tier", "Front End")                 # Front End, Back End, Data
$tags.Add("dataProfile", "Public")             # Public, Confidential, Restricted, Internal





<# Resource Group #>


# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"





# Variables - Public IP

$publicIpShortName = "qweasdzxcLB"
$publicIpSuffix = "-ip"
$publicIpName = "${publicIpShortName}${publicIpSuffix}"
$dnsPrefix  = "qweasdzxclb"
#$dnsPrefix  = "qweasdzxc$(Get-Random)"




<# Load Balancer #>

<#

Public IP address

#>

# Variables - Load Balancer

$lbShortName = "qweasdzxc"
$lbSuffix = "-lb"
$lbName = "${lbShortName}${lbSuffix}"

$lbSku = "Standard"

$frontendName = "qweasdzxcFrontEndPool"
$lbRuleName = "qweasdzxcLoadBalancerRuleWeb"
$backendPoolName = "qweasdzxcBackEndPool"
$healthProbeName = "qweasdzxcHealthProbe"
$healthProbeNameRequestPath = "/"


$natRuleName = "RDP"
$natRuleFrontEndPortStart = 4220
$natRuleBackEndPort = 3389

# linux vm
#$natRuleName = "SSH"


<# Create Load Balancer, if it does not exist #>

Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName -ErrorVariable isLBExist -ErrorAction SilentlyContinue `


If ($isLBExist) 
{
    Write-Output "Load Balancer does not exist"
    

    # public IP address
    Write-Verbose "Fetching Public IP: {$publicIpName}"

    $publicIp = Get-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $rgName 



    # Create a front-end IP configuration for the website.
    Write-Verbose "Creating front-end IP configuration: {$frontendName}"
    $frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name $frontendName -PublicIpAddress $publicIp
    #$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name $frontendName -PrivateIpAddress $privateIp -SubnetId $vnet.subnets[0].Id

    # Create the back-end address pool.
    Write-Verbose "Creating back-end address pool: {$backendPoolName}"
    $backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name $backendPoolName


<#

    # Create a load balancer. (with frontendIP, backendPool) (without probe, lbrule, natrule)
    Write-Verbose "Creating Load Balancer: {$lbName}"

    $lb = New-AzureRmLoadBalancer `
            -Name $lbName `
            -ResourceGroupName $rgName `
            -Location $location `
            -FrontendIpConfiguration $frontendIP `
            -BackendAddressPool $backendPool `
            -Sku $lbSku `
            -Tag $tags 
#>


    # Creates a load balancer probe on port 80.
    Write-Verbose "Creating a load balancer probe on port 80: {$healthProbeName}"
    $probe = New-AzureRmLoadBalancerProbeConfig `
                -Name $healthProbeName `
                -Protocol Http `
                -Port 80 `
                -RequestPath / `
                -IntervalInSeconds 360 `
                -ProbeCount 5



    # Creates a load balancer rule for port 80.
    Write-Verbose "Creating a load balancer rule for port 80: {$lbRuleName}"
    $lbrule = New-AzureRmLoadBalancerRuleConfig `
                -Name $lbRuleName `
                -Probe $probe `
                -FrontendIpConfiguration $frontendIP `
                -BackendAddressPool $backendPool `
                -FrontendPort 80 `
                -BackendPort 80 `
                -Protocol Tcp 



    # Create NAT rules.
    Write-Verbose "Creating three NAT rules for port {$natRuleBackEndPort}: {$lbRuleName}"

    $natrule1 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)1" `
                    -FrontendPort $($natRulePortStart + 1) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $frontendIP `
                    -Protocol tcp 

    $natrule2 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)2" `
                    -FrontendPort $($natRulePortStart + 2) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $frontendIP `
                    -Protocol tcp 

    $natrule3 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)3" `
                    -FrontendPort $($natRulePortStart + 3) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $frontendIP `
                    -Protocol tcp 



    # Create a load balancer.
    Write-Verbose "Creating Load Balancer: {$lbName}"

    $lb = New-AzureRmLoadBalancer `
            -Name $lbName `
            -ResourceGroupName $rgName `
            -Location $location `
            -FrontendIpConfiguration $frontendIP `
            -BackendAddressPool $backendPool `
            -Probe $probe `
            -LoadBalancingRule $lbrule `
            -InboundNatRule $natrule1,$natrule2,$natrule3 `
            -Sku $lbSku `
            -Tag $tags 


<#

$backend = Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name $backendPoolName -LoadBalancer $lb

#>

<#

    # Creates a load balancer probe on port 80.
    Write-Verbose "Creating a load balancer probe on port 80: {$healthProbeName}"

    Add-AzureRmLoadBalancerProbeConfig `
      -LoadBalancer $lb `
      -Name $healthProbeName `
      -Protocol Http `
      -Port 80 `
      -RequestPath / `
      -IntervalInSeconds 360 `
      -ProbeCount 2

    Set-AzureRmLoadBalancer -LoadBalancer $lb


#>


<#

    # Creates a load balancer rule (for port 80).
    Write-Verbose "Creating a load balancer rule (for port 80): {$lbRuleName}"

    $probe = Get-AzureRmLoadBalancerProbeConfig -Name $healthProbeName -LoadBalancer $lb 

    Add-AzureRmLoadBalancerRuleConfig `
      -LoadBalancer $lb `
      -Name $lbRuleName `
      -Probe $probe `
      -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
      -BackendAddressPool $lb.BackendAddressPools[0] `
      -FrontendPort 80 `
      -BackendPort 80 `
      -Protocol Tcp 

    Set-AzureRmLoadBalancer -LoadBalancer $lb

#>


<#
#$rgName="qweasdzxc-rg"
#$lbName="qweasdzxc-lb"

$lbRuleName = "TestNatRule"
$natRuleFrontEndPort = 3350
$natRuleBackEndPort = 3350

    # Create NAT rule.

    Write-Verbose "Fetching Load Balancer: {$lbName}"

    $lb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName 


    Write-Verbose "Creating NAT rules: {$lbRuleName}"

    Add-AzureRmLoadBalancerInboundNatRuleConfig `
        -LoadBalancer $lb `
        -Name $lbRuleName `
        -FrontendIPConfiguration $lb.FrontendIpConfigurations[0] `
        -FrontendPort $natRuleFrontEndPort `
        -BackendPort $natRuleBackEndPort `
        -Protocol "Tcp" `
        -EnableFloatingIP

    Set-AzureRmLoadBalancer -LoadBalancer $lb



    # Remove NAT rule

    Write-Verbose "Fetching Load Balancer: {$lbName}"

    $lb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName 


    Write-Verbose "Removing NAT rule: {$lbRuleName}"
    
    Remove-AzureRmLoadBalancerInboundNatRuleConfig `
        -LoadBalancer $lb `
        -Name $lbRuleName `

    Set-AzureRmLoadBalancer -LoadBalancer $lb

#>
} 
else 
{
    Write-Output "Load Balancer exist"


    Write-Verbose "Fetching Load Balancer: {$lbName}"

    $lb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName 
}



Write-Verbose "Get list of Load Balancers"
Write-Output "Load Balancers"


Get-AzureRmLoadBalancer `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName


<#
Write-Verbose "Removing Load Balancer"


Write-Verbose "Delete Load Balancer: {$lbName}"

$jobLBDelete = Remove-AzureRmResourceGroup -Name $lbName -ResourceGroupName $rgName -Force -AsJob

$jobLBDelete

#>





<#
# References

https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-create-standard-load-balancer-powershell
https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-get-started-ilb-arm-ps#step-3-assign-the-nic-to-a-vm
https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-windows-powershell-sample-create-nlb-vm?toc=%2fpowershell%2fmodule%2ftoc.json
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

# Add Probe and LB Rule
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

# NAT Rule
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/add-azurermloadbalancerinboundnatruleconfig?view=azurermps-6.13.0


# load balancer
https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview

# internal
https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-get-started-ilb-arm-ps#step-3-assign-the-nic-to-a-vm

#>


