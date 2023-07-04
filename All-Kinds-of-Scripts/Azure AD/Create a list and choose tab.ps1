Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a computer:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

$listBox.SelectionMode = 'MultiExtended'

$Credentials = Get-Credential

# Connect to your tenant
Connect-AzureAD -Credential $Credentials

# Get all users and select properties to export
$users = Get-AzureADUser | Select-Object -Property UserPrincipalName, DisplayName, Department, JobTitle

# Export users to CSV file with semicolon delimiter
$users | Export-Csv -Path "C:\Temp\AzureADUsers.csv" -Delimiter ";" -NoTypeInformation

$CSVrecords = Import-Csv "C:\Temp\AzureADUsers.csv" -Delimiter ";"
foreach ($record in $CSVrecords) {
    [void] $listBox.Items.Add($record.userPrincipalName)
}

$form.Controls.Add($listBox)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,125)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Get the selected items from the list box
    $SelectedItems = $listBox.SelectedItems

    # Array for skipped and failed users
    $SkippedUsers = @()
    $FailedUsers = @()

    # Perform your own action with the selected items
    foreach ($item in $SelectedItems) {
        # Do something with each selected item
        $UPN = $item
        $user = Get-AzureADUser -Filter "userPrincipalName eq '$UPN'"

        if ($user) {
            try {
                $user | Set-AzureADUser -CompanyName "Frend Digital AS" -Department "Digital Workplace" -ErrorAction Stop

                if ($user.companyName -eq "Frend Digital AS" -and $user.Department -eq "Digital Workplace") {
                    Write-Host "Changes made for user $($user.userPrincipalName)"
                } else {
                    Write-Host "Changes not made for user $($user.userPrincipalName)"
                }
            } catch {
                $FailedUsers += $user
                Write-Host "Failed to update user $($user.userPrincipalName): $($_.Exception.Message)"
            }
        } else {
            $SkippedUsers += $CSVrecord
            Write-Host "Did not find user $($UPN)"
        }
    }
}
