

<# Virtul Machine - Configuration #>


# Variables - Virtul Machine

$vmShortName = "Test"
$vmSuffix = "VM"
$vmName = "${vmShortName}${vmSuffix}"



Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName -ErrorVariable isVMExist -ErrorAction SilentlyContinue `


If (!$isVMExist) 
{
    Write-Output "Virtul Machine exist"

  # IIS
  Set-AzureRmVMExtension `
    -VMName $vmName `
    -ResourceGroupName $rgName `
    -Location = $location `
    -ExtensionName IIS `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.4 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}' `

<#
    # IIS - way 2 (In VM)

    # Install IIS
    Install-WindowsFeature -name Web-Server -IncludeManagementTools

    # Remove default htm file
    remove-item  C:\inetpub\wwwroot\iisstart.htm

    #Add custom htm file
    Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("Hello World from host" + $env:computername)
#>

} 
Else 
{
    Write-Output "Virtul Machine does not exist"
}



<#
## References

# configure IIS 
https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-create-gateway-arm

#>

