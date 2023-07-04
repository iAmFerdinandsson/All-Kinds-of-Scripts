# Bulk create Security Groups

# Pre-requisite to run the script
Install-Module AzureADPreview
Import-Module AzureADPreview

# Connection to the tenant 
Connect-AzureAD -TenantId "d0c997f4-3706-4b20-8b6f-f1aa6eb940ac"

# Variable to the CSV Path
$CSVPath = "C:\Temp\SKHSecurityGroups.csv"

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