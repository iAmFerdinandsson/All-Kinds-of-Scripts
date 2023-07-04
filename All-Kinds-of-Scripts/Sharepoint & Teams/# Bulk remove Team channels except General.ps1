param (
    [Parameter(Mandatory=$true)]
    [string]$TenantID,

    [Parameter(Mandatory=$true)]
    [string]$GroupID
)

$GroupID = "0178afdb-c7cc-4d3f-becb-2918e35a0a46"
$Channels = Get-TeamChannel -GroupId $GroupID | Where-Object { $_.displayName -ne "General" }

foreach ($Channel in $Channels) {
    try {
        Remove-TeamChannel -GroupId $GroupID -DisplayName $Channel.displayName
        Write-Host "Channel $($Channel.displayName) removed from Team"
        $Return = 1
    } catch {
        Write-Host "Channel $($Channel.displayName) not removed or encountered an error"
        $Return = 0
    }
}Contoso marketing