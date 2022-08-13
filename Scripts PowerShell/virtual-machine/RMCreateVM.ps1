#Obtener información de imágenes de máquinas virtuales de Azure Rm
function Get-AzureRmVMImageInfos(){
	param
    (
      [string]
	  $RmProfilePath =$(throw "Parameter missing: -RmProfilePath RmProfilePath"),
	  [string]
	  $LocationName =$(throw "Parameter missing: -Location Location"),
      [string]
      $PublisherName = 'Microsoft',
      [string]
      $OfferName = 'windows'
    )
    Select-AzureRmProfile –Path $RmProfilePath -ErrorAction Stop
    $Location = Get-AzureRmLocation | Where-Object {$_.Location -eq $LocationName}
	If(-not($Location)) { Throw "The location does not exist." }
    $PublisherName = '*'+$PublisherName+'*'
    $OfferName='*'+$OfferName+'*'
    $lstPublishers = Get-AzureRMVMImagePublisher -Location $LocationName | Where-object { $_.PublisherName –like $PublisherName }
    ForEach ($pub in $lstPublishers) {
       #recibiendo
       $lstOffers = Get-AzureRMVMImageOffer -Location $LocationName -PublisherName $pub.PublisherName  | Where-object { $_.Offer –like $OfferName }
       ForEach ($off in $lstOffers) {
         Get-AzureRMVMImageSku -Location $LocationName -PublisherName $pub.PublisherName -Offer $off.Offer | Format-Table -Auto
	   }
    }
}

#checando ubicacion
function Check-AzureRmLocation(){
    param
    (
	  [string]
	  $LocationName =$(throw "Parameter missing: -LocationName LocationName")
    )
     Write-Host "Check location $LocationName" -ForegroundColor Green
     $Location = Get-AzureRmLocation | Where-Object {$_.Location -eq $LocationName}
	 If(-not($Location)) {
       Write-Host "The location" $LocationName "does not exist." -ForegroundColor Red
       return $false
     }
     Else{
       return $true
     }
}

#Verifique el grupo de recursos, si no, créelo.
function Check-AzureRmResourceGroup(){
     param
    (
      [string]
	  $ResourceGroupName =$(throw "Parameter missing: -ResourceGroupName ResourceGroupName"),
	  [string]
	  $LocationName =$(throw "Parameter missing: -LocationName LocationName")
    )
     Write-Host "Check resource group $ResourceGroupName, if not, created it." -ForegroundColor Green
     Try
     {
         $ResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -Location $LocationName -ErrorAction Stop
	     If(-not($ResourceGroup)) {
             Write-Host "Creating resource group" $ResourceGroupName "..." -ForegroundColor Green
             New-AzureRmResourceGroup -Name $ResourceGroupName -Location $LocationName  -ErrorAction Stop
             return $true
         }
         Else{
             return $true
         }
    }
    Catch
    {
        Write-Host -ForegroundColor Red "Create resource group" $LocationName "failed." $_.Exception.Message
        return $false
    }
}

#Auto generar cuenta de tienda.
function AutoGenerate-AzureRmStorageAccount(){
     param
    (
      [string]
	  $ResourceGroupName =$(throw "Parameter missing: -ResourceGroupName ResourceGroupName"),
	  [string]
	  $LocationName =$(throw "Parameter missing: -LocationName LocationName")
    )
   
    while($true){
         $RandomNum = Get-Random -minimum 100 -maximum 999
         $Prefix = $ResourceGroupName -replace "-", ""
         $Prefix = $Prefix.ToLower()
        # El nombre de la cuenta de almacenamiento debe tener entre 3 y 24 caracteres de longitud y usar números y letras minúsculas únicamente.
         $StorageAccountName = $Prefix+"disks"+$RandomNum
        Try
        {
          $IsAvailability =Get-AzureRmStorageAccountNameAvailability -Name $StorageAccountName -ErrorAction Stop
          If($IsAvailability)
          {
             Write-Host "Auto generate store account $StorageAccountName" -ForegroundColor Green
             $StorageAcc = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -SkuName "Standard_LRS" -Kind "Storage" -Location $LocationName  -ErrorAction Stop
             return $StorageAcc.PrimaryEndpoints.Blob.ToString()
          }
        }
        Catch
        {
          Write-Host -ForegroundColor Red "Auto generate storage account failed" $_.Exception.Message
          return $false
        }
    }
}
#Generar interfaz de red automáticamente.
function AutoGenerate-AzureRmNetworkInterface(){
     param
    (
      [string]
	  $ResourceGroupName =$(throw "Parameter missing: -ResourceGroupName ResourceGroupName"),
	  [string]
	  $LocationName =$(throw "Parameter missing: -LocationName LocationName"),
      [string]
	  $VMName =$(throw "Parameter missing: -VMName VMName")
    )
   
    Try
    {
          $RandomNum = Get-Random -minimum 100 -maximum 999
          $SubnetName = "subnetdefault"+$RandomNum
          $VnetName = $ResourceGroupName+"-vnet"+$RandomNum
          $IpName = $VMName+"-ip"+$RandomNum
          $NicName = $VMName+"-ni"+$RandomNum

          Write-Host "Auto generate network interface $NicName" -ForegroundColor Green
          
          $Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 10.0.0.0/24 -ErrorAction Stop     
          $Vnet = New-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix 10.0.0.0/16 -Subnet $Subnet -ErrorAction Stop        
         
          $Pip = New-AzureRmPublicIpAddress -Name $IpName -ResourceGroupName $ResourceGroupName -Location $LocationName -AllocationMethod Dynamic -ErrorAction Stop       
          
          $Nic = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $Pip.Id -ErrorAction Stop

          return $Nic.Id
    }
    Catch
    {
          Write-Host -ForegroundColor Red "Auto generate network interface" $_.Exception.Message
          return $false
    }
}

#Crear una máquina virtual de Windows usando el Administrador de recursos
function New-AzureVMByRM(){
     param
    (
      [string]
	  $RmProfilePath =$(throw "Parameter missing: -RmProfilePath RmProfilePath"),
      [string]
	  $ResourceGroupName =$(throw "Parameter missing: -ResourceGroupName ResourceGroupName"),
	  [string]
	  $LocationName =$(throw "Parameter missing: -LocationName LocationName"),
      [string]
	  $VMName =$(throw "Parameter missing: -VMName VMName"),
      [string]
	  $VMSizeName ="Standard_DS1",
      [string]
      $PublisherName = 'MicrosoftVisualStudio',
      [string]
      $OfferName = 'Windows',
      [string]
      $SkusName = '10-Enterprise-N',
      [string]
      $UserName = 'sorai',
      [string]
      $Password = 'Sor@i2345678'

    )
   
    Try
    {
      #1. Inicie sesión en Azure por perfil o Login-AzureRmAccount
        #Login-AzureRmAccount
        #Save-AzureRmProfile -Ruta "C:\PS\azureaccount.json"
         Write-Host "Login Azure by profile" -ForegroundColor Green   
       Select-AzureRmProfile –Path $RmProfilePath -ErrorAction Stop

       #2. ubicacion
       if(Check-AzureRmLocation -LocationName $LocationName){
          #3. verificar recurso
          if(Check-AzureRmResourceGroup -LocationName $LocationName -ResourceGroupName $ResourceGroupName){
             #4. Checar images  
             Write-Host "Check VM images $SkusName" -ForegroundColor Green    
             If(Get-AzureRMVMImageSku -Location $LocationName -PublisherName $PublisherName -Offer $OfferName -ErrorAction Stop | Where-Object {$_.Skus -eq $SkusName}){
                 #5. checar VM
                 If(Get-AzureRmVM -Name $VMName -ResourceGroupName $ResourceGroupName -ErrorAction Ignore){
                     Write-Host -ForegroundColor Red "VM $VMName has already exist."
                 }
                 else{
                    #6. Check tamaño
                    Write-Host "check VM Size $VMSizeName" -ForegroundColor Green  
                    If(Get-AzureRmVMSize -Location $LocationName | Where-Object {$_.Name -eq $VMSizeName})
                    {
                       #7. Crear alacenamiento
                      $BlobURL = AutoGenerate-AzureRmStorageAccount -Location $LocationName -ResourceGroupName $ResourceGroupName
                      If($BlobURL){
                        #8. Crear interfaz de red
                        $Nid = AutoGenerate-AzureRmNetworkInterface -Location $LocationName -ResourceGroupName $ResourceGroupName -VMName $VMName
                        If($Nid){
                            Write-Host "Creating VM $VMName ..." -ForegroundColor Green 
                             
                           #10.Establezca el nombre y la contraseña de la cuenta de administrador para la máquina virtual.
                            $StrPass = ConvertTo-SecureString -String $Password -AsPlainText -Force
                            $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UserName, $StrPass)

                            #11.Elija el tamaño de la máquina virtual, configure el nombre de la computadora y la credencial
                            $VM = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSizeName -ErrorAction Stop
                            $VM = Set-AzureRmVMOperatingSystem -VM $VM -Windows -ComputerName $VMName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate -ErrorAction Stop
                           
                            #12.Elija la imagen de origen
                            $VM = Set-AzureRmVMSourceImage -VM $VM -PublisherName $PublisherName -Offer $OfferName -Skus $SkusName -Version "latest" -ErrorAction Stop
                           
                            #13.Agregue la interfaz de red a la configuración.
                            $VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $Nid -ErrorAction Stop
                           
                           #14.Agregar almacenamiento que utilizará el disco duro virtual.
                            $BlobPath = "vhds/"+$SkusName+"Disk.vhd"
                            $OSDiskUri = $BlobURL + $BlobPath
                            $DiskName = "windowsvmosdisk"
                            $VM = Set-AzureRmVMOSDisk -VM $VM -Name $DiskName -VhdUri $OSDiskUri -CreateOption fromImage -ErrorAction Stop

                            #15.al fin crear la maquina
                            New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VM -ErrorAction Stop
                            Write-Host "Successfully created a virtual machine $VMName" -ForegroundColor Green  
                        }
                      }
                    }
                    Else
                    {
                       Write-Host -ForegroundColor Red "VM Size $VMSizeName does nott exist."
                    }
                    
                 }
             }
              Else{
                 Write-Host -ForegroundColor Red "VM images does not exist."
             }
          }
       }
      
    }
    Catch
    {
          Write-Host -ForegroundColor Red "Create a virtual machine $VMName failed" $_.Exception.Message
          return $false
    }
}


New-AzureVMByRM  -ResourceGroupName ocoslab-tanyue -LocationName eastasia -VMName vm-frta-test01 -RmProfilePath C:\Work\PS\azureaccount.json