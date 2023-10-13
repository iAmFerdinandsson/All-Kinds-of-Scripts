# List All Administrators

# Params
param (
    [Parameter(Mandatory=$true)]
    [string]$TenantID
)

# Install and import the required module
if (-not (Get-Module -Name AzureADPreview -ListAvailable)){
    Install-Module -Name AzureADPreview -Force
}
Import-Module -Name AzureADPreview -Force

# Connection to the tenant 
Connect-AzureAD -TenantId $TenantID

# List All Administrators 
$AllRoleAssignments = ForEach ($Role in (Get-AzureADMSRoleDefinition)) {
    $RoleAssignment = Get-AzureADMSRoleAssignment -Filter "roleDefinitionId eq '$($Role.Id)'"
    if($RoleAssignment) {
        $User = Get-AzureADObjectByObjectId -ObjectIds $RoleAssignment.PrincipalId
        if($User.ObjectType -eq "User") {
            $User | Select-Object DisplayName,UserPrincipalName,ObjectType
        }
    }
}
$AllRoleAssignments | Sort-Object -Unique "UserPrincipalName" | Export-csv -Encoding utf8 -NoTypeInformation -Path C:\temp\AAD_Admins.csv