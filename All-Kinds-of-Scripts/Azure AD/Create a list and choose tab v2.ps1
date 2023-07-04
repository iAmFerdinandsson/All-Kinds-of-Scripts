Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a User'
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(175,340)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(250,340)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a user:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(300,300)
$listBox.Height = 300

$listBox.SelectionMode = 'MultiExtended'

$Credentials = Get-Credential

# Connect to your tenant

# Check if the AzureAD module is installed
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    # Install the AzureAD module
    Install-Module -Name AzureAD -Scope CurrentUser -Force
}

# Check if the AzureAD module is imported
if (-not (Get-Module -Name AzureAD)) {
    # Import the AzureAD module
    Import-Module -Name AzureAD
}

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
$labelSize = "100, 20"
$labelLocation = 
$textBoxSize = "200, 40"

$companyLabel = New-Object System.Windows.Forms.Label
$companyLabel.Location = New-Object System.Drawing.Point(410, 128)
$companyLabel.Size = New-Object System.Drawing.Size($labelSize)
$companyLabel.Text = "Company Name:"
$form.Controls.Add($companyLabel)

$companyTextBox = New-Object System.Windows.Forms.TextBox
$companyTextBox.Location = New-Object System.Drawing.Point(510, 125)
$companyTextBox.Size = New-Object System.Drawing.Size($textBoxSize)
$form.Controls.Add($companyTextBox)

$departmentLabel = New-Object System.Windows.Forms.Label
$departmentLabel.Location = New-Object System.Drawing.Point(410, 153)
$departmentLabel.Size = New-Object System.Drawing.Size($labelSize)
$departmentLabel.Text = "Department:"
$form.Controls.Add($departmentLabel)

$departmentTextBox = New-Object System.Windows.Forms.TextBox
$departmentTextBox.Location = New-Object System.Drawing.Point(510, 150)
$departmentTextBox.Size = New-Object System.Drawing.Size($textBoxSize)
$form.Controls.Add($departmentTextBox)

$jobTitleLabel = New-Object System.Windows.Forms.Label
$jobTitleLabel.Location = New-Object System.Drawing.Point(410, 178)
$jobTitleLabel.Size = New-Object System.Drawing.Size($labelSize)
$jobTitleLabel.Text = "Job Title:"
$form.Controls.Add($jobTitleLabel)

$jobTitleTextBox = New-Object System.Windows.Forms.TextBox
$jobTitleTextBox.Location = New-Object System.Drawing.Point(510, 175)
$jobTitleTextBox.Size = New-Object System.Drawing.Size($textBoxSize)
$form.Controls.Add($jobTitleTextBox)

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
        $CompanyName = $companyTextBox.Text
        $Department = $departmentTextBox.Text
        $JobTitle = $jobTitleTextBox.text

        if ($user) {
            try {
                $user | Set-AzureADUser -CompanyName $CompanyName -Department $Department -JobTitle $JobTitle -ErrorAction Stop
                
                # Get the updated user object and check its properties
                $updatedUser = Get-AzureADUser -filter "userPrincipalName eq '$UPN'"
                if ($updatedUser.companyname -eq $CompanyName -and $updatedUser.Department -eq $Department -and $updatedUser.JobTitle -eq $JobTitle) {
                    Write-Host "Changes made for user $($updatedUser.userPrincipalName)"
                } else {
                    $SkippedUsers += $user
                    Write-Host "Changes not made for user $($user.userPrincipalName)"
                }
            } catch {
                $FailedUsers += $user
                Write-Host "Failed to update user $($user.userPrincipalName)"
            }
        } else {
            Write-Host "User $($UPN) not found in Azure AD"
        }        
    }
}

# Export log to CSV file with semicolon delimiter
$log = $FailedUsers | Select-Object -Property UserPrincipalName, Error | ConvertTo-Csv -Delimiter ";" -NoTypeInformation
$log = $SkippedUsers | Select-Object -Property UserPrincipalName, Error | ConvertTo-Csv -Delimiter ";" -NoTypeInformation
$log | Out-File -FilePath "C:\Temp\AzureADUsers_Log.csv"

# Show review message box
$message = "Changes made for $($SelectedItems.Count) users.`nErrors encountered for $($FailedUsers.Count) users.`n`nDo you want to view the log file?"
$caption = "Review Changes"
$icon = [System.Windows.Forms.MessageBoxIcon]::Question
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$result = [System.Windows.Forms.MessageBox]::Show($message, $caption, $buttons, $icon)

# Open log file if user clicks Yes
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Invoke-Item "C:\Temp\AzureADUsers_Log.csv"
}
