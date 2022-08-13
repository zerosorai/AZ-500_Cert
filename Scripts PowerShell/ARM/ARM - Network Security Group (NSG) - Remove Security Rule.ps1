# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


# Variables - Network Security Group (NSG)

$nsgShortName = "qweasdzxc"
$nsgSuffix = "-nsg"
$nsgName = "${nsgShortName}${nsgSuffix}"



# Variables - Security Rule (NSG) 
$ruleName = "HTTP"


<# Network Security Group (NSG) - Remove Security Rule #>

<#

Network Security Group (NSG)
Security Rule

#>


Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -ErrorVariable isNSGExist -ErrorAction SilentlyContinue `


If (!$isNSGExist) 
{
    Write-Output "Network Security Group exist"
    

    Write-Verbose "Fetching Network Security Group: {$nsgName}"
    $nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName



    Write-Verbose "Removing network security rule: {$ruleName} (Port: {$rulePort})"

    Remove-AzureRmNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg
} 
Else 
{
    Write-Output "Network Security Group does not exist"
}



<#
## References

https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/remove-azurermnetworksecurityruleconfig?view=azurermps-6.13.0

#>
