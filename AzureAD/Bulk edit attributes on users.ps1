# This script get the attributes and information from a CSV file
# Changes the attributes of the Azure AD users and 
# Doublechecks that the users got the new attributes
# Catches and informs if something gotten wrong

# Connect to AzureAD
Connect-AzureAD

# Get CSV content
$CSVrecords = Import-Csv C:\Temp\Test.csv -Delimiter ";"

# Create arrays for skipped and failed users
$SkippedUsers = @()
$FailedUsers = @()

# Loop trough CSV records
foreach ($CSVrecord in $CSVrecords) {
    $upn = $CSVrecord.UserPrincipalName
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$upn'"  

    if ($user) {
        try {
            $user | Set-AzureADUser -CompanyName $CSVrecord.companyName -Department $CSVrecord.Department -JobTitle $CSVrecord.JobTitle -ErrorAction Stop

            if ($user.Department -eq $CSVrecord.Department -and $user.JobTitle -eq $CSVrecord.JobTitle) {
                Write-Host "Changes made for user $($user.UserPrincipalName)"
            } else {
                Write-Host "Changes not made for user $($user.userPrincipalName)"
            }
        } catch {
            $FailedUsers += $user
            Write-Host "Failed to update user $($user.UserPrincipalName): $($_.Exception.Message)"
        }
    } else {
        $SkippedUsers += $CSVrecord
        Write-Host "Did not find user $($upn)"
    }
}