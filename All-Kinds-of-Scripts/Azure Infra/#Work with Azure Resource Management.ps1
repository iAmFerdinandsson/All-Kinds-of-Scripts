#Test
#Work with Azure Resource Management
Get-Module Az
Install-Module Az
Connect-AzAccount

New-AzVm `
    -ResourceGroupName "CrmTestingResourceGroup" `
    -Name "CrmUnitTests" `
    -Image "UbuntuLTS"
    ...

#Create a new Resource Group
New-AzResourceGroup -Name RG01 -Location "Norway East"

$Location = (Get-AzResourceGroup -Name RG01).Location
$RGName = "RG01"

# Create and get a new Az Disk
$diskConfig = New-AzDiskConfig `
-Location $Location `
-CreateOption Empty `
-DiskSizeGB 32 `
-SKU Standard_LRS

New-AzDisk `
-ResourceGroupName $rgName `
-diskName $diskName `
-Disk $diskConfig

Get-AzDisk -ResourceGroupName $rgName -name $diskName
New-AzDiskUpdateConfig -DiskSize 64 | Update-AzDisk -ResourceGroupName $rgName -DiskName $diskName
(Get-AzDisk -ResourceGroupName $rgName -name $diskName).sku

# Create a new Template
$templateFile = "C:\Users\Joakim Ferdinansson\Documents\CDX Environment\ExportedTemplate-RG01\template.json"
New-AzResourceGroupDeployment `
  -Name blanktemplate `
  -ResourceGroupName RG01-TemplateTest `
  -TemplateFile $templateFile

  New-AzStorageContainer -ResourceGroupName $ResourceGroup -Storageccount $Storageaccount -Name $blob -Permission Blob
  New-AzStorageContext -StorageAccountName -StorageAccountKey

  # Create a VM in Azure
$Credential = Get-Credential
$ResourceGroup = Get-AzResourceGroup -Name "LABENV-RG01"
$VMName = "LABENV-VM02"
$Location = "North Europe"
$VirtualNetwork = Get-AzVirtualNetwork -Name "LABENV-VM01-vnet"
$SecurityGroup = Get-AzNetworkSecurityGroup -Name "LABENV-VM01-nsg"
$PublicIPAddress = Get-AzPublicIpAddress -Name "LABENV-VM01-ip"
$OpenPorts = "80,3389"



  New-AzVm `
    -Credential $Credential `
    -ResourceGroupName $ResourceGroup `
    -Name $VMName `
    -Location $Location `
    -VirtualNetworkName $VirtualNetwork `
    -SecurityGroupName $SecurityGroup `
    -PublicIpAddressName $PublicIPAddress `
    -OpenPorts 80,3389


    # Storageaccount03

    New-AzResourceGroup -Name "LABENV-RG03" -Location "North Europe"
    New-AzStorageAccount -Name "labenvstorageaccount03" -ResourceGroupName "LABENV-RG03" -SkuName "Standard_GRS" -Location "North Europe"
    New-AzVirtualNetwork -Name "labenvstorageaccount03-Vnet" -ResourceGroupName "LABENV-RG03" -Location "North Europe" -AddressPrefix "10.0.0.0/16"   

    (Get-AzStorageAccountNetworkRuleSet -ResourceGroupName "LABENV-RG03" -AccountName "labenvstorageaccount03").VirtualNetworkRules
    
    Get-AzVirtualNetwork -ResourceGroupName "LABENV-RG03" -Name "labenvstorageaccount03-Vnet" | Set-AzVirtualNetworkSubnetConfig -Name "labenvstorageaccount03-subnet" -AddressPrefix "10.0.0.0/24" -ServiceEndpoint "Microsoft.Storage" | Set-AzVirtualNetwork
    
    $subnet = Get-AzVirtualNetwork -ResourceGroupName "LABENV-RG03" -Name "labenvstorageaccount03-Vnet" | Get-AzVirtualNetworkSubnetConfig -Name "labenvstorageaccount03-subnet"
    Add-AzStorageAccountNetworkRule -ResourceGroupName "LABENV-RG03" -Name "labenvstorageaccount03" -VirtualNetworkResourceId $subnet.Id
    
    $subnet = Get-AzVirtualNetwork -ResourceGroupName "LABENV-RG03" -Name "labenvstorageaccount03-Vnet" | Get-AzVirtualNetworkSubnetConfig -Name "labenvstorageaccount03-subnet"
    Remove-AzStorageAccountNetworkRule -ResourceGroupName "LABENV-RG03" -Name "labenvstorageaccount03" -VirtualNetworkResourceId $subnet.Id