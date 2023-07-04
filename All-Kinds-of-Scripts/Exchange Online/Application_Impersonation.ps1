# Run the following PowerShell commands one at a time:

Set-ExecutionPolicy Unrestricted

$LiveCred = Get-Credential

Install-Module -Name ExchangeOnlineManagement
Import-Module -Name ExchangeOnlineManagement

Connect-ExchangeOnline -Credential $LiveCred

Enable-OrganizationCustomization

# The Enable command may take a long time to run and may error out. If so, wait a few minutes and run it again.
New-ManagementRoleAssignment -Role "ApplicationImpersonation" -User "arne@icondistribution.no"

# Make sure to replace "admin@domain.com" in the PowerShell command above with the admin account being used


#Remove ApplicationImpersonation
Get-ManagementRoleAssignment -Role ApplicationImpersonation
$role = Get-ManagementRoleAssignment -role applicationimpersonation | Remove-ManagementRoleAssignment