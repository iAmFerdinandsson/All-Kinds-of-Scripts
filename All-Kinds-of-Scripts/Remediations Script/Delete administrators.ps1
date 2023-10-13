#Test
try {
    $localAdministratorUser = Get-LocalUser | Where-Object { $_.SID -match '-500' }
    $administratorsGroup = [adsi]"WinNT://$env:COMPUTERNAME/$(Get-LocalGroup -SID 'S-1-5-32-544')"
    $administratorsGroupMembers = @($administratorsGroup.Invoke('Members') | ForEach-Object { ([adsi]$_).Path } | Where-Object { $_ -notmatch $localAdministratorUser.Name -and $_ -notmatch 'WinNT://S-1-12-1-' })
    if ($administratorsGroupMembers) {
        foreach ($administratorsGroupMember in $administratorsGroupMembers) {
            $administratorsGroup.Remove($administratorsGroupMember)
        }
        Write-Host "Users was sucessfully removed from local Administrators group"
    }
    else {
        Write-Host "There were no users to remove from local Administrators group"
    }
    Exit 0
}
catch {
    Write-Host "Error removing users from local Administrators group"
    Exit 1
}