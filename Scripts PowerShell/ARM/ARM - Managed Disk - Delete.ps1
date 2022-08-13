
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




$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"



<# Disk (Managed) #>

<#


#>

# Variables - Disk (Managed)

$diskShortName = "TEST1"
$diskSuffix = "-DataDisk"
$diskName = "${diskShortName}${diskSuffix}"

$diskSizeGB = 100



<# Create Disk (Managed), if it does not exist #>

Get-AzureRmDisk -Name $diskName -ResourceGroupName $rgName -ErrorVariable isDiskExist -ErrorAction SilentlyContinue `


If ($isDiskExist) 
{
    Write-Output "Disk (Managed) does not exist"


    Write-Verbose "Creating Disk (Managed): {$diskName}"

    $diskConfig = New-AzureRmDiskConfig `
            -Location $location `
            -DiskSizeGB $diskSizeGB `
            -CreateOption Empty `
            -Tag $tags 

    $dataDisk = New-AzureRmDisk `
            -DiskName $diskName `
            -ResourceGroupName $rgName `
            -Disk $diskConfig `
} 
Else 
{
    Write-Output "Disk (Managed) exist"


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

$diskShortName = "TEST1"
$diskSuffix = "-DataDisk"
$diskName = "${diskShortName}${diskSuffix}"


$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"



Write-Verbose "Delete Data Disk: {$diskName}"

$jobDiskDelete = Remove-AzureRmDisk -Name $diskName -ResourceGroupName $rgName -Force -AsJob

$jobDiskDelete

#>



<#
# References

https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-data-disk

#>




