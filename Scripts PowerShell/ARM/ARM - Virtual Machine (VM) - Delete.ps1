

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


<# Virtual Network (VNet) #>

<#


#>


# Variables - Virtual Network

$vnetShortName = "qweasdzxc"
$vnetSuffix = "-vnet"
$vnetName = "${vnetShortName}${vnetSuffix}"

# subnets
$webSubnetName = "WebSubnet"
$frontendSubnetName = "FrontEndSubnet"
$backendSubnetName = "BackEndSubnet"

# Variables - Public IP

$publicIpShortName = "qweasdzxc"
$publicIpSuffix = "-ip"
$publicIpName = "${publicIpShortName}${publicIpSuffix}"
$dnsPrefix  = "qweasdzxc"
#$dnsPrefix  = "qweasdzxc$(Get-Random)"

# Variables - Network Security Group

$nsgShortName = "qweasdzxc"
$nsgSuffix = "-nsg"
$nsgName = "${nsgShortName}${nsgSuffix}"




<# Network Interface (NIC) #>

<#

Virtual Network (VNet)
Subnet
Public IP address
Network Security Group (NSG) 

#>


# Variables - Network Interface (NIC)

$nicShortName = "qweasdzxc"
$nicSuffix = "-nic"
$nicName = "${nicShortName}${nicSuffix}"

$subnetName = "WebSubnet"


$asShortName = "qweasdzxc"
$avSetSuffix = "-as"
$asName = "${asShortName}${avSetSuffix}"



<# Virtul Machine #>

<#

Network Interface (NIC)
Availability Set (AS)

#>

# Variables - Virtul Machine

$vmShortName = "Test"
$vmSuffix = "VM"
$vmName = "${vmShortName}${vmSuffix}"

$username = "aashish"
$password = "Password@1234"


$vmSize = "Standard_D1"
$vmSKU = "2016-Datacenter"

# linux virtual machine
# $vmSKU = "14.04.2-LTS"


$osDiskShortName = "${vmName}"
$osDiskSuffix = "-osdisk"
$osDiskName = "${osDiskShortName}${osDiskSuffix}"
$osDiskSize = 128


<#
# way 2

$vmImageName = "Win2016Datacenter"
$openPorts = "80,443,3389,22"
#>



<# Create Virtul Machine, if it does not exist #>

Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName -ErrorVariable isVMExist -ErrorAction SilentlyContinue `


If ($isVMExist) 
{
    Write-Output "Virtul Machine (VM) does not exist"


    # Network Interface (NIC)
    Write-Verbose "Creating Network Interface (NIC): {$nicName}"
    $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName 


    # Availability Set (AS)
    Write-Verbose "Fetching Availability Set: {$asName}"
    $as = Get-AzureRmAvailabilitySet -Name $asName -ResourceGroupName $rgName 
    

    # User credential
    $passwordSecure = ConvertTo-SecureString -String $password -AsPlainText -Force
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $passwordSecure

    <#
        # ask for username and password prompt
        Write-Output "Enter a username and password for the virtual machine"
        $cred = Get-Credential -Message "Enter a username and password for the virtual machine."
    #>



    # Create a virtual machine configuration

    Write-Verbose "Creating a Virtul Machine: {$vmName}"


    $vmConfig = New-AzureRmVMConfig `
      -VMName $vmName `
      -VMSize $vmSize `
      -AvailabilitySetId $as.Id
    
    $vmConfig = Set-AzureRmVMOSDisk `
        -VM $vmConfig `
        -Name $osDiskName `
        -CreateOption FromImage `
        -Windows `
        -DiskSizeInGB $osDiskSize `
        -StorageAccountType StandardLRS `

    $vmConfig = Set-AzureRmVMOperatingSystem `
      -VM $vmConfig `
      -Windows `
      -ComputerName $vmName `
      -Credential $cred
    
    $vmConfig = Set-AzureRmVMSourceImage `
      -VM $vmConfig `
      -PublisherName MicrosoftWindowsServer `
      -Offer WindowsServer `
      -Skus $vmSKU `
      -Version latest
    
    $vmConfig = Add-AzureRmVMNetworkInterface `
      -VM $vmConfig `
      -Id $nic.Id
    
    $vmConfig = Set-AzureRmVMBootDiagnostics `
      -VM $vmConfig `
      -Disable

        

    $vm = New-AzureRmVM `
        -VM $vmConfig `
        -ResourceGroupName $rgName `
        -Location $location 



<#      
   # OS Disk: Other options (Not working)
    
    # OS Disk (Managed Disk)
    #Write-Verbose "Fetching OS Disk: {$osDiskName}"
    #$osDisk = Get-AzureRmDisk -DiskName $osDiskName -ResourceGroupName $rgName 


    $vmConfig = Set-AzureRmVMOSDisk `
        -VM $vmConfig `
        -Name $osDiskName `
        -CreateOption Empty `
        -Windows `
        -ManagedDiskId $osDisk.Id `
       Standard SSD 
           
    $vmConfig = Set-AzureRmVMOSDisk `
        -VM $vmConfig `
        -Name $osDiskName `
        -Caching ReadWrite `
        -CreateOption Empty `
        -DiskSizeInGB 100 `
        -Windows
#>


<#
    # way 2 - shortcut way and use default configuration

    $vmConfig = New-AzureRmVMConfig `
                    -VMName $vmName `
                    -VMSize $vmSize `
                    -Tag $tags `
                    -AvailabilitySetId $as.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus $vmSKU -Version latest | `
    Add-AzureRmVMNetworkInterface -Id $nic.Id
    
    # linux virtual machine
    #Set-AzureRmVMOperatingSystem -Linux -ComputerName $vmName -Credential $cred -DisablePasswordAuthentication |
    #Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus $vmSKU -Version latest |
    
    # linux virtual machine
    # Configure SSH Keys
    #$sshPublicKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
    #Add-AzureRmVMSshPublicKey -VM $vmconfig -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"


    $vm = New-AzureRmVM `
            -VM $vmConfig `
            -ResourceGroupName $rgName `
            -Location $location 

#>

<#
    # way 3 - shortcut way and use default configuration

    $vmParams = @{
          Name = $vmName
          ResourceGroupName = $rgName
          Location = $location
          ImageName = $vmImageName
          Credential = $cred
          PublicIpAddressName = $publicIpName
          VirtualNetworkName = $vnetName
          SubnetName = $vnetName
          OpenPorts = $openPorts
          Tag = $tags
        }

    $vm = New-AzureRmVM @vmParams
#>



<#
    # verify the Name of the VM and the admin account we created
    $vm.OSProfile | Select-Object ComputerName,AdminUserName


    #get specific information about the network configuration
    $vm | Get-AzureRmNetworkInterface | `
          Select-Object -ExpandProperty IpConfigurations | `
          Select-Object Name, PrivateIpAddress 

    # Get Public IP address
    $publicIp = Get-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $rgName

    $publicIp | Select-Object Name, IpAddress, @{label='FQDN';expression={$_.DnsSettings.Fqdn}}
#>
} 
Else 
{
    Write-Output "Virtul Machine (VM) exist"


    Write-Verbose "Fetching Virtul Machine (VM): {$vmName}"

    $vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName
}



Write-Verbose "Get list of Virtul Machines"
Write-Output "Virtul Machines"


Get-AzureRmVM -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap


# Private IP Address
Get-AzureRmNetworkInterface | Where-Object { $_.VirtualMachine.ID -match "^.*resourceGroups/$rgName.*virtualMachines/.*$vmName.*" } | 
    Select-Object @{L='VMName';ex = {$_.VirtualMachine.Id -replace '^.*/'}}, @{L='PrivateIpAddress';ex = {$_.IpConfigurations.PrivateIpAddress}}



# Get-AzureRmNetworkInterface -ResourceGroupName Rmilne-Tailspintoys-Canada | ForEach { $Interface = $_.Name; $IPs = $_ | Get-AzureRmNetworkInterfaceIpConfig | Select PrivateIPAddress; Write-Host $Interface $IPs.PrivateIPAddress }
# Get-AzureRmVM | ?{$_.ReplicationMode -ne “Replica”} | Select -ExpandProperty NetworkProfile | Select VMName, IPAddresses, Status
# Get-AzureRmVM | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}

<#

Get-AzureRmVM -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName

#>


<#

$vmShortName = "TestVM"
$vmSuffix = ""
$vmName = "${vmShortName}${vmSuffix}"


Write-Verbose "Delete Virtul Machine: {$vmName}"

$jobVMDelete = Remove-AzureRmVM -Name $vmName -ResourceGroupName $rgName -Force -AsJob

$jobVMDelete


#>


<#
## References

# all resource in azure
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm

https://docs.microsoft.com/en-us/powershell/azure/azureps-vm-tutorial?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/powershell-samples?toc=%2fpowershell%2fmodule%2ftoc.json

# credentials
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-6

# Load balance traffic between highly available virtual machines
https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-windows-powershell-sample-create-nlb-vm?toc=%2fpowershell%2fmodule%2ftoc.json

Linux
https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-powershell-sample-create-vm?toc=%2fpowershell%2fmodule%2ftoc.json

Other options
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/change-availability-set

OS Disk
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/change-availability-set
https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmosdisk?view=azurermps-6.13.0
http://www.networknet.nl/apps/wp/archives/2877
https://docs.microsoft.com/en-us/dotnet/api/microsoft.azure.management.compute.models.storageaccounttypes?view=azure-dotnet

Change Disk
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/change-availability-set


Get VM private IP Address
https://stackoverflow.com/questions/50270873/how-do-i-get-the-ip-addresses-and-names-of-vm-in-avariable

Add IP Config
https://github.com/anthonychu/azure-content/blob/master/articles/virtual-network/virtual-network-multiple-ip-addresses-powershell.md

#>

