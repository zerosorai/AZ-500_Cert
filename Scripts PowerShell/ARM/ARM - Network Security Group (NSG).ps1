
<# Network Security Group (NSG) #>

<#


#>


# Variables - Network Security Group (NSG)

$nsgShortName = "qweasdzxc"
$nsgSuffix = "-nsg"
$nsgName = "${nsgShortName}${nsgSuffix}"


<# Create Network Security Group (NSG), if it does not exist - Rules below are example placeholders that allow selected traffic from all sources #>

Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -ErrorVariable isNSGExist -ErrorAction SilentlyContinue `


If ($isNSGExist) 
{
    Write-Output "Network Security Group does not exist"
    


    Write-Verbose "Creating network security rule to Allow Inbound HTTP (Port: 80): {HTTP}"

    $nsgRuleHTTP = New-AzureRmNetworkSecurityRuleConfig `
        -Name "HTTP" `
        -Description "Allow Inbound HTTP" `
        -DestinationPortRange 80 `
        -Priority 100 `
        -Access Allow `
        -Direction Inbound `
        -Protocol Tcp `
        -SourceAddressPrefix * `
        -DestinationAddressPrefix * `
        -SourcePortRange * `

    
    Write-Verbose "Creating network security rule to Allow Inbound HTTPS (Port: 443): {HTTPS}"

    $nsgRuleHTTPS = New-AzureRmNetworkSecurityRuleConfig `
        -Name "HTTPS" `
        -Description "Allow Inbound HTTPS" `
        -DestinationPortRange 443 `
        -Priority 110 `
        -Access Allow `
        -Direction Inbound `
        -Protocol Tcp `
        -SourceAddressPrefix * `
        -DestinationAddressPrefix * `
        -SourcePortRange * `


    Write-Verbose "Creating network security rule to Allow Inbound RDP (Port: 3389): {RDP}"

    $nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig `
        -Name "RDP" `
        -Description "Allow Inbound RDP" `
        -DestinationPortRange 3389 `
        -Priority 400 `
        -Access Allow `
        -Direction Inbound `
        -Protocol Tcp `
        -SourceAddressPrefix * `
        -DestinationAddressPrefix * `
        -SourcePortRange * `


    Write-Verbose "Creating network security rule to Allow Inbound SSH (Port: 22): {SSH}"

    $nsgRuleSSH = New-AzureRmNetworkSecurityRuleConfig `
        -Name "SSH" `
        -Description "Allow Inbound SSH" `
        -DestinationPortRange 22 `
        -Priority 500 `
        -Access Allow `
        -Direction Inbound `
        -Protocol Tcp `
        -SourceAddressPrefix * `
        -DestinationAddressPrefix * `
        -SourcePortRange * `



    Write-Verbose "Creating Network Security Group: {$nsgName}"

    $nsg = New-AzureRmNetworkSecurityGroup `
            -Name $nsgName `
            -ResourceGroupName $rgName `
            -Location $location `
            -SecurityRules $nsgRuleHTTP, $nsgRuleHTTPS, $nsgRuleRDP, $nsgRuleSSH `
            -Tag $tags
} 
Else 
{
    Write-Output "Network Security Group exist"


    Write-Verbose "Fetching Network Security Group: {$nsgName}"

    $nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName
}




Write-Verbose "Get list of Network Security Group (NSG)"
Write-Output "Network Security Groups"


Get-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap


<#

Get-AzureRmNetworkSecurityGroup `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName

#>



<#

## Remove Network Security Group (NSG)

$nsgShortName = "qweasdzxc"
$nsgSuffix = "-nsg"
$nsgName = "${nsgShortName}${nsgSuffix}"


Write-Verbose "Deleting Network Security Group (NSG): {$nsgName}"

Remove-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -Force

#>




<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.network/get-azurermnetworksecuritygroup?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/powershell/module/azurerm.network/get-azurermnetworksecurityruleconfig?view=azurermps-6.13.0&viewFallbackFrom=azurermps-6.12.0

#>
