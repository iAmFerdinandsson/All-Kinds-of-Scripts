$ShortcutName = "Connect Shares"
$desiredBootScriptFolder = Join-Path $env:ProgramData -ChildPath $scriptName
$desiredBootScriptPath = Join-Path $desiredBootScriptFolder -ChildPath "$scriptName.ps1"
$desiredVBSScriptPath = Join-Path $desiredBootScriptFolder -ChildPath "$scriptName.vbs"

# Set the path to the start menu
$startMenu = "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Komatsu Forest\Connect"

# Set the path to the shortcut
$Shortcut = "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Komatsu Forest\Connect Shares.lnk" 

# Check if the shortcut exists
if (Test-Path $Shortcut) {
    Write-Host "Shortcut already exists."
} else {
    $ShortcutPath = Join-Path $env:SystemRoot -ChildPath "System32\wscript.exe"
    $ShortcutArguments = "`"$desiredVBSScriptPath`" `"$desiredBootScriptPath`""
    $ShortcutIconLocation = "$($env:SystemRoot)\System32\shell32.dll,149"
    if (-not (Test-Path -Path "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\$ShortcutFolderName"))
    {
        New-Item -ItemType Directory -Path "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Komatsu Forest" | Out-Null
    }
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut("$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Komatsu Forest\$ShortcutName.lnk") 
    $Shortcut.TargetPath = $ShortcutPath
    $Shortcut.Arguments = $ShortcutArguments
    $Shortcut.IconLocation = $ShortcutIconLocation
    $Shortcut.Save()
    [Runtime.InteropServices.Marshal]::ReleaseComObject($WScriptShell) | Out-Null
}
