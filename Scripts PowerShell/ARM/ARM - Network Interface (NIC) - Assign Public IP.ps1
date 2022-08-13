# Variables - Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


# Variables - Network Security Group (NSG)

$nsgShortName = "qweasdzxc"
$nsgSuffix = "-nsg"
$nsgName = "${nsgShortName}${nsgSuffix}"



<# Network Security Group (NSG) - Add Security Rule #>

<#

Network Security Group (NSG)

#>

# Variables - Security Rule (NSG) 

$ruleName = "HTTP"
$ruleDescription = "Allow Inbound HTTP"
$rulePort = 80
$rulePriority = 100


Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -ErrorVariable isNSGExist -ErrorAction SilentlyContinue `


If (!$isNSGExist) 
{
    Write-Output "Network Security Group exist"
    

    Write-Verbose "Fetching Network Security Group: {$nsgName}"
    $nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName



    Write-Verbose "Creating network security rule: {$ruleName} (Port: {$rulePort})"


    $nsg | `
    
    Add-AzureRmNetworkSecurityRuleConfig `
        -Name $ruleName `
        -Description $ruleDescription `
        -DestinationPortRange $rulePort `
        -Priority $rulePriority `
        -Access Allow `
        -Direction Inbound `
        -Protocol Tcp `
        -SourceAddressPrefix * `
        -DestinationAddressPrefix * `
        -SourcePortRange * | ` 
    
    Set-AzureRmNetworkSecurityGroup
} 
Else 
{
    Write-Output "Network Security Group does not exist"
}





<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/add-azurermnetworksecurityruleconfig?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/new-azurermnetworksecurityruleconfig?view=azurermps-6.13.0

#>
