
<# Availability Set #>

<#


#>


# Variables - Availability Set

$asShortName = "qweasdzxc"
$avSetSuffix = "-as"
$asName = "${asShortName}${avSetSuffix}"



<# Create an Azure Availability Set for VM high availability, if it does not exist #>

Get-AzureRmAvailabilitySet -Name $asName -ResourceGroupName $rgName -ErrorVariable isASExist -ErrorAction SilentlyContinue `

If ($isASExist) 
{
    Write-Output "Availability Set does not exist"
    

    Write-Verbose "Creating new Availability Set: {$asName}"

    $as = New-AzureRmAvailabilitySet `
            -Name $asName `
            -ResourceGroupName $rgName `
            -Location $location `
            -Sku Aligned `
            -PlatformFaultDomainCount  2 `
            -PlatformUpdateDomainCount 5 `
            -Tag $tags 
                

# -Sku 'Aligned' ` # Aligned: For managed disks or Classic: For unmanaged disks
} 
Else 
{
    Write-Output "Availability Set exist"


    Write-Verbose "Fetching Availability Set: {$asName}"

    $as = Get-AzureRmAvailabilitySet -Name $asName -ResourceGroupName $rgName
}




Write-Verbose "Get list of Availability Set"
Write-Output "Availability Sets"


Get-AzureRmAvailabilitySet -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap 


<#

Get-AzureRmAvailabilitySet -ResourceGroupName $rgName `
    | Select-Object Name, ResourceGroupName, Location `
    | Format-Table -AutoSize -GroupBy ResourceGroupName -Wrap 

#>



<#

## Remove Availability Set

$asShortName = "qweasdzxc"
$avSetSuffix = "-as"
$asName = "${asShortName}${avSetSuffix}"


Write-Verbose "Deleting Availability Set: {$asName}"

Remove-AzureRmAvailabilitySet -Name $asName -ResourceGroupName $rgName -Force

#>





<#
# References

https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/new-azurermavailabilityset?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermresourcegroup?view=azurermps-6.13.0

#>
