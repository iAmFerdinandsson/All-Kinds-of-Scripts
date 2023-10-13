#Test
$Mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited  
$data = @()  
foreach ($Mailbox in $mailboxes){  
    $temp = Get-Mailbox $Mailbox.PrimarySmtpAddress | select DisplayName,WindowsEmailAddress,TotalItemSize,LastLogonTime  
    $temp2 = Get-MailboxStatistics $Mailbox.PrimarySmtpAddress | Select TotalItemSize,LastLogonTime  
    $temp.TotalItemSize = $temp2.TotalItemSize  
    $temp.LastLogonTime = $temp2.LastLogonTime  
    $data += $temp  
    Write-Host $Mailbox.PrimarySmtpAddress "Checked"  
}  
$data | Export-csv c:\temp\Result.csv -NoTypeInformation

