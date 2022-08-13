
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



<# Create Resource Group, if it does not exist #>

Get-AzureRmResourceGroup -Name $rgName -ErrorVariable isRGExist -ErrorAction SilentlyContinue `


If ($isRGExist) 
{
    Write-Output "Resource Group does not exist"
    

    Write-Verbose "Creating new Resource Group: {$rgName}"

    $rg = New-AzureRmResourceGroup `
            -Name $rgName `
            -Location $location `
            -Tag $tags
} 
Else 
{
    Write-Output "Resource Group exist"


    Write-Verbose "Fetching Resource Group: {$rgName}"

    $rg = Get-AzureRmResourceGroup -Name $rgName 
}



Write-Verbose "Get list of Resource Groups"
Write-Output "Resource Groups"


Get-AzureRmResourceGroup `
    | Select-Object ResourceGroupName, Location `
    | Format-Table -AutoSize -Wrap -GroupBy Location


<#

## Remove Resource Group

$rgShortName = "qweasdzxc"
$rgSuffix = "-rg"
$rgName = "${rgShortName}${rgSuffix}"


Write-Verbose "Delete Resource Group: {$rgName}"

Remove-AzureRmResourceGroup -Name $rgName -Force

#>




<#
## References

https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermresourcegroup?view=azurermps-6.13.0
https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/remove-azurermresourcegroup?view=azurermps-6.13.0

# Naming Conventions
https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions

# Format table
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-6

# PowerShell style guide
https://github.com/PoshCode/PowerShellPracticeAndStyle
https://poshcode.gitbooks.io/powershell-practice-and-style/Style-Guide/Introduction.html

#>




