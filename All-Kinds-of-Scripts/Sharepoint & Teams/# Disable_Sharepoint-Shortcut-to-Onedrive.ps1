# Disable_Sharepoint-Shortcut-to-Onedrive.ps1

param (
    [Parameter(Mandatory=$true)]
    [string]$TenantUrl
)

# Install and import the required module
if (-not (Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable)) {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
}
Import-Module -Name Microsoft.Online.SharePoint.PowerShell -Force

# Connect to the specified tenant
Connect-SPOService -Url $TenantUrl

# Check and modify the setting for DisableAddShortCutsToOnedrive
$tenantSettings = Get-SPOTenant
if (-not $tenantSettings.DisableAddShortCutsToOnedrive) {
    Set-SPOTenant -DisableAddShortCutsToOneDrive $true
    Write-Host "Add Shortcuts to OneDrive is now disabled"
} else {
    Write-Host "Add Shortcuts to OneDrive is already disabled in the tenant"
}
