# Bulk create Security Groups

# Pre-requisite to run the script
Install-Module AzureADPreview
Import-Module AzureADPreview

param (
    [Parameter(Mandatory=$true)]
    [string]$TenantID
)

# Connection to the tenant 
Connect-AzureAD -TenantId $TenantID

# Variable to the CSV Path
Get-ChildItem $PSScriptRoot
$CSVPath = "$PSScriptRoot\PSSecGroups.csv"

# Variable to the import of the CSV file
$Groups = Import-Csv -Path $CSVPath

# The script to create all the Security Groups
foreach($Group in $Groups){
    $ExistingGroups = Get-AzureAdGroup | Where-Object {$_.displayName -eq $Groups.displayName}

        if ($ExistingGroups) {
            Write-Host "Group $($Groups.displayName) already exists."
    } else {
        New-AzureAdGroup -DisplayName $Group.DisplayName -MailEnabled $False -SecurityEnabled $True -MailNickName "NotSet"
        Write-Host "Group $($Group.displayName) created"
    }
}