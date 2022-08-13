# Login
Login-AzureRmAccount

# Variables for common values
$location = "westeurope"
$resourceGroup = "demo-resgroup-0"
$vmName = "demovm-0"
$publicIP = "spublicip-1"
$subnet = "subnet-1"
$vnet = "vnet-1"
$nsg = "nsg-1"
$nsgrdp = "nsgrdp-1"
$nsgwww = "nsgwww-1"
$nsgweb1 = "nsgweb1-1"
$nsgweb2 = "nsgweb2-1"
$nsgsp = "nsgps-1"
$nic = "nic-1"

# Create resource group
New-AzureRmResourceGroup -ResourceGroupName $resourceGroup -Location $location

# Get vm credentials
$cred = Get-Credential

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
    -Name $subnet `
    -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Name $vnet `
    -AddressPrefix 192.168.0.0/16 `
    -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$publicIP = New-AzureRmPublicIpAddress `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -AllocationMethod Static `
    -IdleTimeoutInMinutes 4 `
    -Name $publicIP

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig `
    -Name $nsgrdp `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1000 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389 `
    -Access Allow

# Create an inbound network security group rule for port 80
$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig `
    -Name $nsgwww `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1001 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 80 `
    -Access Allow

# Create an inbound network security group rule for port 8081
$nsgRuleWeb1 = New-AzureRmNetworkSecurityRuleConfig `
    -Name $nsgweb1 `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1002 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 8081 `
    -Access Allow

# Create an inbound network security group rule for port 8082
$nsgRuleWeb2 = New-AzureRmNetworkSecurityRuleConfig `
    -Name $nsgweb2 `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1003 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 8082 `
    -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Name $nsg `
    -SecurityRules $nsgRuleRDP,$nsgRuleWeb,$nsgRuleWeb1,$nsgRuleWeb2

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface `
    -Name $nic `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -SubnetId $vnet.Subnets[0].Id `
    -PublicIpAddressId $publicIP.Id `
    -NetworkSecurityGroupId $nsg.Id

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_D1 | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer `
    -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

# Create a virtual machine using the configuration
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

# Install IIS, .NET Framework
Set-AzureRmVMExtension -ResourceGroupName $resourceGroup `
    -ExtensionName IIS `
    -VMName $vmName `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.4 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server,Web-Mgmt-Tools,Web-Asp-Net45,NET-Framework-Features;powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}' `
    -Location $location

# Get public ip address of the machine
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup