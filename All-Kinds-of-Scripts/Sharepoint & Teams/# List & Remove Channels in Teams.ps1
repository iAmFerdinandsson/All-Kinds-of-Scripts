# Install and import the required module
if (-not (Get-Module -Name MicrosoftTeams -ListAvailable)) {
    Install-Module -Name MicrosoftTeams -Force
}
Import-Module -Name MicrosoftTeams -Force

# Create Selection Box
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75, 120)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150, 120)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Please make a selection from the list below:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10, 40)
$listBox.Size = New-Object System.Drawing.Size(260, 20)

$listBox.SelectionMode = 'MultiExtended'

$TenantID = Read-Host -Prompt "Enter the Tenant ID"
Connect-MicrosoftTeams -TenantId $TenantID

try {
    # Retrieve Teams and add them to the list box
    $teams = Get-Team
    foreach ($team in $teams) {
        [void]$listBox.Items.Add($team.DisplayName)
    }
} catch {
    Write-Host "Error occurred while retrieving Teams: $($_.Exception.Message)"
}

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $teamDisplayName = $listBox.SelectedItem.ToString()
    $team = Get-Team -DisplayName $teamDisplayName

    $channelForm = New-Object System.Windows.Forms.Form
    $channelForm.Text = 'Channel Selection Form'
    $channelForm.Size = New-Object System.Drawing.Size(300, 200)
    $channelForm.StartPosition = 'CenterScreen'

    $channelOKButton = New-Object System.Windows.Forms.Button
    $channelOKButton.Location = New-Object System.Drawing.Point(75, 120)
    $channelOKButton.Size = New-Object System.Drawing.Size(75, 23)
    $channelOKButton.Text = 'OK'
    $channelOKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $channelForm.AcceptButton = $channelOKButton
    $channelForm.Controls.Add($channelOKButton)

    $channelCancelButton = New-Object System.Windows.Forms.Button
    $channelCancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $channelCancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $channelCancelButton.Text = 'Cancel'
    $channelCancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $channelForm.CancelButton = $channelCancelButton
    $channelForm.Controls.Add($channelCancelButton)

    $channelLabel = New-Object System.Windows.Forms.Label
    $channelLabel.Location = New-Object System.Drawing.Point(10, 20)
    $channelLabel.Size = New-Object System.Drawing.Size(280, 20)
    $channelLabel.Text = "Please select a channel from the '$teamDisplayName' Team:"
    $channelForm.Controls.Add($channelLabel)

    $channelListBox = New-Object System.Windows.Forms.Listbox
    $channelListBox.Location = New-Object System.Drawing.Point(10, 40)
    $channelListBox.Size = New-Object System.Drawing.Size(260, 20)

    $channelListBox.SelectionMode = 'MultiExtended'

    try {
        # Retrieve channels for the selected Team and add them to the list box
        $channels = Get-TeamChannel -GroupId $team.GroupId
        foreach ($channel in $channels) {
            [void]$channelListBox.Items.Add($channel.DisplayName)
        }
    } catch {
        Write-Host "Error occurred while retrieving channels for Team '$teamDisplayName': $($_.Exception.Message)"
    }

    $channelListBox.Height = 70
    $channelForm.Controls.Add($channelListBox)
    $channelForm.Topmost = $true

    $channelResult = $channelForm.ShowDialog()

    if ($channelResult -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $selectedChannels = $channelListBox.SelectedItems | ForEach-Object {$_.ToString()}
        foreach ($channelName in $selectedChannels) {
            try {
                Remove-TeamChannel -GroupId $team.GroupId -DisplayName $channelName
                Write-Host "Channel '$channelName' removed from Team '$teamDisplayName'."
            } catch {
                Write-Host "Error occurred while removing channel '$channelName': $($_.Exception.Message)"
            }
        }
    }
}
