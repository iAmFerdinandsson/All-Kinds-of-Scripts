# Run the following PowerShell commands one at a time:

Set-ExecutionPolicy Unrestricted

$LiveCred = Get-Credential

Install-Module -Name ExchangeOnlineManagement -Force
Import-Module -Name ExchangeOnlineManagement -Force

Connect-ExchangeOnline -Credential $LiveCred

Enable-OrganizationCustomization

# The Enable command may take a long time to run and may error out. If so, wait a few minutes and run it again.
New-ManagementRoleAssignment -Role "ApplicationImpersonation" -User "admin@sveinungkristiansen.onmicrosoft.com"

# Make sure to replace "admin@domain.com" in the PowerShell command above with the admin account being used