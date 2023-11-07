$content = @'
$localadminuser = "admin"

$administratorsGroup = ([ADSI]"WinNT://$env:COMPUTERNAME").psbase.children.find("Administrators")
    $administratorsGroupMembers = $administratorsGroup.psbase.invoke("Members")
    foreach ($administratorsGroupMember in $administratorsGroupMembers) {
        $administrator = $administratorsGroupMember.GetType().InvokeMember('Name','GetProperty',$null,$administratorsGroupMember,$null) 
        if (($administrator -ne "Administrator") -and ($administrator -ne $localadminuser)) {
            $administratorsGroup.Remove("WinNT://$administrator")
                  }
    }

try {
    Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction Stop
get-localuser | Set-localUser -PasswordNeverExpires:$True
} catch [Microsoft.PowerShell.Commands.MemberExistsException] {
    Write-Warning "$member is already member"
}

# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\myScript.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false


# register script as scheduled task
$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\myScript.ps1`""
Register-ScheduledTask -TaskName "RemoveAdmin" -Trigger $Time -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "RemoveAdmin"