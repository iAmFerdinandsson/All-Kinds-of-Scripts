#Unique identifier for Users
$MemberSID = "S-1-\d{1}-\d{2}-\d{10}-\d{10}-\d{10}-\d{4}"
#Local Administrator group SID "S-1-5-32-544"
$LocalAdminGroup = (Get-LocalGroupMember -SID "S-1-5-32-544").sid.value -match $MemberSID
$


Get-
try {
    if ($LocalAdminGroup) {
        try{
            foreach ($SID in $LocalAdminGroup) {
                
            }
        }
    }
}
catch {
    <#Do this if a terminating exception happens#>
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
}



Try {
    if ($LocalAdminGroup) {
        Try{
            foreach ($SID in $LocalAdminGroup) { 
                Remove-LocalGroupMember -SID "S-1-5-32-544" -Member $SID
                Write-Host "Removed user from admin group"
            }
        } Catch {
            $Errordescription = "Failed to remove Local Administrators"
            Throw "$Errordescription, $_"
            $Return = 1
        }

        $Return = 0
    }Else {
        Write-Host "No User Found"
        $Return = 0
    }
} Finally{
    If($null -eq $Return){
        $Return = 1
    }
    $Return
    #Exit $Return
}

$SidPaths = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | Select name
 
$SID = @()
foreach ($SidPath in $SidPaths) {
$SIDNumber = $SidPath.name -replace '[\\/]' -replace ' ','' -Replace 'HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindowsNTCurrentVersionProfileList',''
$SID += $SIDNumber
}
 
$SID
