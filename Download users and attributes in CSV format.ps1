# Connect to AzureAD
Connect-AzureAD

# Get all users and select properties to export
$users = Get-AzureADUser -Filter "Department eq 'TestDepartment'" | Select-Object -Property UserPrincipalName, DisplayName, GivenName, Surname, Department, JobTitle, City, Country

# Export users to CSV file with semicolon delimiter
$users | Export-Csv -Path "C:\Temp\AzureADUsers.csv" -Delimiter ";" -NoTypeInformation
