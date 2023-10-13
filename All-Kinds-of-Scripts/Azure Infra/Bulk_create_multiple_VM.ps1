#Test
Connect-AzAccount

Get-AzSubscription
Select-AzSubscription -Subscription "My Subscription"


# Variables
#Resource Group
$locationName = "westeurope"
$ResourceGroupName = "AZ-RG-DEMO"

#Virtual Network
$networkName = "AZ-VNET"
$nicName = "NIC-"
$vnet = Get-AzVirtualNetwork `
    -Name $NetworkName `
    -ResourceGroupName $ResourceGroupName

#Virtual Machines
$computerNames = @("VM-01","VM-02")
$vmSize = "Standard\_B2ms"
$publisherName = "MicrosoftWindowsServer"
$offer = "WindowsServer"
$skus = "2016-Datacenter"

$credential = Get-Credential

# Azure Resource Deployment
for($i = 0; $i -le $ComputerName.count -1; $i++)
{

 $NIC = New-AzNetworkInterface `
    -Name ($NICName+$ComputerName[$i]) `
    -ResourceGroupName $ResourceGroupName `
    -Location $LocationName `
    -SubnetId $Vnet.Subnets[0].Id

 $VirtualMachine = New-AzVMConfig `
    -VMName $ComputerName[$i] `
    -VMSize $VMSize
 $VirtualMachine = Set-AzVMOperatingSystem `
    -VM $VirtualMachine `
    -Windows `
    -ComputerName $ComputerName[$i] `
    -Credential $Credential `
    -ProvisionVMAgent  `
    -EnableAutoUpdate

 $VirtualMachine = Add-AzVMNetworkInterface `
    -VM $VirtualMachine `
    -Id $NIC.Id
 $VirtualMachine = Set-AzVMSourceImage `
    -VM $VirtualMachine `
    -PublisherName $publisherName `
    -Offer $offer `
    -Skus $skus `
    -Version latest

 New-AzVM `
    -ResourceGroupName $ResourceGroupName `
    -Location $LocationName `
    -VM $VirtualMachine `
    -Verbose
}
