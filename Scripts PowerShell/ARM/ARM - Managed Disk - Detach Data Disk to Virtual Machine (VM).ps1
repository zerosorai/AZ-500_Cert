
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


$vmShortName = "Test"
$vmSuffix = "VM"
$vmName = "${vmShortName}${vmSuffix}"


$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"

$diskShortName = "TEST1"
$diskSuffix = "-DataDisk"
$diskName = "${diskShortName}${diskSuffix}"



<# Data Disk (Managed) #>

<#

Virtual Machine (VM)
Data Disk

#>

# Variables - Disk (Managed)

# logical unit number
$lun = 1



<# Create Disk (Managed), if it does not exist #>

Get-AzureRmDisk -Name $diskName -ResourceGroupName $rgName -ErrorVariable isDiskExist -ErrorAction SilentlyContinue `


If ($isDiskExist) 
{
    Write-Output "Disk (Managed) does not exist"
    


    Write-Verbose "Fetching Virtul Machine: {$vmName}"

    $vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName



    Write-Verbose "Fetching Data Disk: {$diskName}"

    $dataDisk = Get-AzureRmDisk -Name $diskName -ResourceGroupName $rgName 



    # attach data disk to virtual machine
    Write-Verbose "Add the data disk {$diskName} to the virtual machine: {$vmName}"

    $vm = Add-AzureRmVMDataDisk `
            -VM $vm `
            -Name $diskName `
            -ManagedDiskId $dataDisk.Id `
            -CreateOption Attach `
            -Lun $lun


    Update-AzureRmVM -ResourceGroupName $rgName -VM $vm
} 
Else 
{
    Write-Output "Data Disk is attached to Virtul Machine"


    Write-Verbose "Fetching Disk (Managed): {$diskName}"

    $dataDisk = Get-AzureRmDisk -Name $diskName -ResourceGroupName $rgName 
}



Write-Verbose "Get list of Disks (Managed)"
Write-Output "Disks (Managed)"


Get-AzureRmDisk -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap


<#
Get-AzureRmDisk `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy ResourceGroupName
#>





<#

# Prepare data disks in VM
# Create an RDP connection with the virtual machine. Open up PowerShell and run this script.


Get-Disk | Where partitionstyle -eq 'raw' | `
Initialize-Disk -PartitionStyle MBR -PassThru | `
New-Partition -AssignDriveLetter -UseMaximumSize | `
Format-Volume -FileSystem NTFS -NewFileSystemLabel $diskName -Confirm:$false

#>



<#

$vmShortName = "Test"
$vmSuffix = "VM"
$vmName = "${vmShortName}${vmSuffix}"


$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"

$diskShortName = "TEST1"
$diskSuffix = "-DataDisk"
$diskName = "${diskShortName}${diskSuffix}"



Write-Verbose "Detach Data Disk from Virtul Machine: {$diskName}"

Write-Verbose "Fetching Virtul Machine: {$vmName}"
$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName

Remove-AzureRmVMDataDisk -VM $vm -Name $diskName

Update-AzureRmVM -VM $vm -ResourceGroupName $rgName

#>







<#
# References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-data-disk


# detach
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/detach-disk

#>




