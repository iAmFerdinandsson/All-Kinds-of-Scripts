# Install and import the required module
if (-not (Get-Module -Name MicrosoftTeams -ListAvailable)) {
    Install-Module -Name MicrosoftTeams -Force
}
Import-Module -Name MicrosoftTeams -Force

#Create Selection Box
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

# Connect to Microsoft Teams
try {
    #$tenantId = Read-Host -Prompt 'Enter the Tenant ID'
    Connect-MicrosoftTeams

    (Get-Team).displayname
    $TeamDisplayname = Read-Host -Prompt 'Enter the displayname for the Team where the channels are stored'
    $GroupID = (Get-Team -DisplayName $TeamDisplayname).groupid

    # Retrieve Teams channels and add them to the list box
    $channels = Get-TeamChannel -GroupId $GroupID
    foreach ($channel in $channels) {
        [void]$listBox.Items.Add($channel.DisplayName)
    }
} catch {
    Write-Host "Error occurred while connecting to Microsoft Teams or retrieving channels: $($_.Exception.Message)"
}

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $selectedItems = $listBox.SelectedItems | ForEach-Object {$_.ToString()}
    foreach ($item in $selectedItems) {
        try {
            Remove-TeamChannel -GroupId $GroupID -DisplayName $item
            Write-Host "Channel '$item' removed from the Team"
        } catch {
            Write-Host "Error occurred while removing channel '$item': $($_.Exception.Message)"
        }
    }
}
