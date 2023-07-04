$ApplicationName = "UninstallString DisplayName"
$ApplicationVersion = "UninstallString DisplayVersion"

function Get-ApplicationInstalled {
    param (
        [string]$Name,
        [string]$Version
    )
    try {
        $Application = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall |
            Get-ItemProperty | Where-Object { $_.DisplayName -eq "$Name" } | Sort-Object -Unique

       if ($Application.DisplayVersion -and [version]$Application.DisplayVersion -ge [version]$Version) {
            Write-Host "$Name v$Version is installed"
            return 0
        }
        else {
            Write-Host "$Name v$Version is not installed"
            return 1
        }
    }
    catch {
        Write-Host "Error checking installed application"
        return 1
    }
}

$ExitCode = Get-ApplicationInstalled -Name $ApplicationName -Version $ApplicationVersion

Exit $ExitCode
