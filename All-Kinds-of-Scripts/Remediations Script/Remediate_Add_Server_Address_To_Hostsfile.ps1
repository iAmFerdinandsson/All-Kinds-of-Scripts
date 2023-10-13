#Test
#=============================================================================================================================
#
# Script Name:     Remediate_Add_Server_Address_To_Hostsfile.ps1
# Description:     Adds Server Address Fileserver01.aadds.balticgruppen.se to Hostsfile if it doesn't detect Server Address
#
#=============================================================================================================================

# Define Variables

$HostsFile = "$($env:SystemRoot)\system32\drivers\etc\hosts"
$ServerAddress = "10.240.0.11 fileserver01.aadds.balticgruppen.se"

If ((Get-Content -Path "$HostsFile") | where-object { $_ -eq $ServerAddress}) { 

    Write-Output "$ServerAddress line exists in file"
    
} else {
    Add-Content -Path "$HostsFile" -Value "$ServerAddress"
}

Try {
    $Detection = (Get-Content -Path "$HostsFile") | where-object { $_ -eq $ServerAddress}
}Catch {

}
If ($Detection) {
    exit(0) 
} else {
    exit(1) 
}
