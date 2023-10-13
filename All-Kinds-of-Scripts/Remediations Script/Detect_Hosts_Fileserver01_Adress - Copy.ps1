#Test
#=============================================================================================================================
#
# Script Name:     Detect_Local_Administrator_Group.ps1
# Description:     Detects if Local Administrator Group Exists
#
#=============================================================================================================================

# Define Variables

$LocalAdminGroup = Get-LocalGroup -SID "S-1-5-32-544"
if ($LocalAdminGroup) {
    Write-Host "LocalAdmin"
    exit(0)
} else {
    exit(1)
}
