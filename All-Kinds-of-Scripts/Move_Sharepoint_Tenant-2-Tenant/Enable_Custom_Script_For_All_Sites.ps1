Get-Module -Name "PNP.powershell"
Import-Module -Name "PNP.powershell"
Install-Module -Name "PNP.Powershell" -Force

#Parameters
$TenantURL =  "https://m365x47578672.sharepoint.com/"
  
#Get Credentials to connect
$Credential = Get-Credential
 
#Frame Tenant Admin URL from Tenant URL
$TenantAdminURL = $TenantURL.Insert($TenantURL.IndexOf("."),"-admin")

# Grant Permission to user PNP
Register-PnPManagementShellAccess

#Connect to Admin Center
Connect-PnPOnline -Url $TenantAdminURL -Credentials $Credential
  
#Get All Site collections - Filter BOT and MySite Host
$Sites = Get-PnPTenantSite -Filter "Url -like '$TenantURL' -and Url -notlike 'portals/hub'"
 
#Iterate through all sites
$Sites | ForEach-Object {
    Write-host "Processing Site Collection:"$_.URL
 
    #Enable Custom Script
    If ($_.DenyAddAndCustomizePages -ne "Disabled")
    {
        $_.DenyAddAndCustomizePages = "Disabled"
        $_.Update() | Out-Null
        $_.Context.ExecuteQuery()
        Write-host "`tCustom Script has been Enabled!" -f Green
    }
    Else
    {
        Write-host "`tCustom Script is Already Enabled!" -f Yellow
    }
}


#Read more: https://www.sharepointdiary.com/2017/12/how-to-enable-custom-script-in-sharepoint-online.html#ixzz7wls7Q3um