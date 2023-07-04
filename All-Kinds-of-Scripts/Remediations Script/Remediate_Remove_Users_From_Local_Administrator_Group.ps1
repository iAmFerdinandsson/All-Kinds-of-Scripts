#=============================================================================================================================
#
# Script Name:     Remediate_Remove_Users_From_Local_Administrator_Group.ps1
# Description:     Remove Users from Local Administrator Group
#
#=============================================================================================================================

# Define Variables

#Unique identifier for Users
$MemberSID = "S-1-\d{1}-\d{2}-\d{10}-\d{10}-\d{10}-\d{4}"
#Local Administrator group SID "S-1-5-32-544"
$LocalAdminGroup = (Get-LocalGroupMember -SID "S-1-5-32-544").sid.value -match $MemberSID

Try {
    if ($LocalAdminGroup) {
        Try{
            foreach ($SID in $LocalAdminGroup) { 
                Remove-LocalGroupMember -SID "S-1-5-32-544" -Member $SID
            }
        } Catch {
            $Errordescription = "Failed to remove Local Administrators"
            Throw "$Errordescription, $_"
            $Return = 1
        }

        $Return = 0
    }Else {
        write-host "No User Found"
        $Return = 0
    }
} Finally{
    If($null -eq $Return){
        $Return = 1
    }
    Exit $Return
}

