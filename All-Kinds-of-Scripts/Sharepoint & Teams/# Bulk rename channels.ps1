$Channels = Import-CSV "C:/Temp/SKHTeamsChannels.csv"
$GroupID = "0178afdb-c7cc-4d3f-becb-2918e35a0a46"

foreach ($Channel in $Channels) {
    $existingChannel = Get-TeamChannel -GroupId $GroupID | Where-Object { $_.displayName -eq $Channel.Channel }
    
    $currentDisplayName = $Channel.channel
    $newDisplayName = $currentDisplayName + " v1"

        if ($existingChannel) {
            Set-TeamChannel -GroupId $GroupID -CurrentDisplayName $currentDisplayName -NewDisplayName $newDisplayName
                Write-Host "Channel $currentDisplayName renamed to $newDisplayName"
    } else {
        Write-Host "Channel name $newDisplayName already correct"
    }
}
