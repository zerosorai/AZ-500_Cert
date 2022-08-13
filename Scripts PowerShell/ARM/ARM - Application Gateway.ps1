
<# Application Gateway #>


# Variables - Application Gateway

$agwShortName = "aabbccdd12"
$agwSuffix = "-agw"
$agwName = "${agwShortName}${agwSuffix}"



<# Create Application Gateway, if it does not exist #>

Get-AzureRmApplicationGateway -Name $agwName -ErrorVariable isAGWExist -ErrorAction SilentlyContinue `


If ($isAGWExist) 
{
    Write-Output "Application Gateway does not exist"
    


    Write-Verbose "Create the IP configurations and frontend port"

    $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetFullName

    $publicIP = Get-AzureRmPublicIPAddress -ResourceGroupName $rgName -Name $publicIpFullName 

    $subnet = $vnet.Subnets[0]

    $gipconfig = New-AzureRmApplicationGatewayIPConfiguration -Name myAGIPConfig -Subnet $subnet

    $fipconfig = New-AzureRmApplicationGatewayFrontendIPConfig -Name myAGFrontendIPConfig -PublicIPAddress $publicIP

    $frontendport = New-AzureRmApplicationGatewayFrontendPort -Name myFrontendPort -Port 80



    Write-Verbose "Creating new Application Gateway: {$agwName}"

    $agw = New-AzureRmApplicationGateway `
              -Name $agwName `
              -ResourceGroupName $rgName `
              -Location $location `
              -BackendAddressPools $backendPool `
              -BackendHttpSettingsCollection $poolSettings `
              -FrontendIpConfigurations $fipconfig `
              -GatewayIpConfigurations $gipconfig `
              -FrontendPorts $frontendport `
              -HttpListeners $defaultlistener `
              -RequestRoutingRules $frontendRule `
              -Sku $sku

} 
Else 
{
    Write-Output "Application Gateway exist"

    Write-Verbose "Fetching Application Gateway: {$agwName}"


    $agw = Get-AzureRmApplicationGateway `
            -Name $agwName 
}



Write-Verbose "Get list of Application Gateway"

Write-Output "Application Gateways"


Get-AzureRmApplicationGateway -ResourceGroupName $rgName `
| Select-Object Name, ResourceGroupName, Location `
| Format-Table -AutoSize -Wrap



<#

Get-AzureRmApplicationGateway `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName

#>





<#

https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-create-gateway-arm

#>

