

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

$feName = "qweasdzxcFrontEndPool"
$bepoolName = "qweasdzxcBackEndPool"
$healthProbeName = "qweasdzxcHealthProbe"
$healthProbeNameRequestPath = "/"
$lbRuleName = "qweasdzxcLoadBalancerRuleWeb"
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
    Write-Verbose "Creating front-end IP configuration: {$feName}"
    $feIp = New-AzureRmLoadBalancerFrontendIpConfig -Name $feName -PublicIpAddress $publicIp


    # Create the back-end address pool.
    Write-Verbose "Creating back-end address pool: {$bepoolName}"
    $bepool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name $bepoolName


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
                -Protocol Tcp `
                -FrontendPort 80 -BackendPort 80 `
                -FrontendIpConfiguration $feip -BackendAddressPool $bePool



    # Create NAT rules.
    Write-Verbose "Creating three NAT rules for port {$natRuleBackEndPort}: {$lbRuleName}"

    $natrule1 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)1" `
                    -FrontendPort $($natRulePortStart + 1) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $feip `
                    -Protocol tcp 

    $natrule2 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)2" `
                    -FrontendPort $($natRulePortStart + 2) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $feip `
                    -Protocol tcp 

    $natrule3 = New-AzureRmLoadBalancerInboundNatRuleConfig `
                    -Name "$($natRuleName)3" `
                    -FrontendPort $($natRulePortStart + 3) `
                    -BackendPort $natRuleBackEndPort `
                    -FrontendIpConfiguration $feip `
                    -Protocol tcp 



    # Create a load balancer.
    Write-Verbose "Creating Load Balancer: {$lbName}"

    $lb = New-AzureRmLoadBalancer `
            -Name $lbName `
            -ResourceGroupName $rgName `
            -Location $location `
            -FrontendIpConfiguration $feip `
            -BackendAddressPool $bepool `
            -Probe $probe `
            -LoadBalancingRule $lbrule `
            -InboundNatRule $natrule1,$natrule2,$natrule3 `
            -Tag $tags 
} 
Else 
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

https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-windows-powershell-sample-create-nlb-vm?toc=%2fpowershell%2fmodule%2ftoc.json

# load balancer
https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview

#>


