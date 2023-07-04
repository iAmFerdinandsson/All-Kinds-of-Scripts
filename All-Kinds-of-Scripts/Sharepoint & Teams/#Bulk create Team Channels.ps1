param (
    [Parameter(Mandatory=$true)]
    [string]$TenantID,

    [Parameter(Mandatory=$true)]
    [string]$ExcelPath
)

# Install and import the required module
if (-not (Get-Module -Name MicrosoftTeams -ListAvailable)) {
    Install-Module -Name MicrosoftTeams -Force
}
Import-Module -Name MicrosoftTeams -Force

# Connect to the specified tenant
Connect-MicrosoftTeams -TenantId $TenantID

# Get the CSV File
$Channels = Import-Excel $ExcelPath
    
    # Read CSV file and create channels
foreach ($Channel in $Channels) {
    try {
        $existingChannel = Get-TeamChannel -GroupId $($Channel.groupid) | Where-Object { $_.displayName -ne $Channel.Channel } -ErrorAction Stop
        if ($existingChannel) {
            New-TeamChannel -GroupId $($Channel.groupid) -DisplayName $($Channel.Channel) -MembershipType $($Channel.privacy)
            Write-Host "Channel $($Channel.Channel) created in $($Channel.groupid) with membershiptype $($Channel.privacy)"
    } else {
        Write-Host "Channel $($Channel.Channel) already exists"
    }
} catch {
    Write-Host "Channel $($Channel.Channel) couldn't be created because of error: $($_.Exception.Message)"
    }
}
