# Some kind of PNP Bulk Creation of folders

$csvPath = "C:\Temp\SveinungSPFolders.csv"

# Install the SharePoint PnP PowerShell module if not already installed
if (-not (Get-Module -ListAvailable -Name SharePointPnPPowerShellOnline)) {
    Install-Module -Name SharePointPnPPowerShellOnline -Force -AllowClobber
}

# Import the SharePoint PnP PowerShell module
Import-Module -Name SharePointPnPPowerShellOnline -DisableNameChecking

Function Create-FoldersFromCSV {
    param (
        [Parameter(Mandatory = $true)][string]$CSVPath
    )

    $csvData = Import-Csv -Path $CSVPath

    foreach ($item in $csvData) {
        $siteURL = $item.SiteURL
        $libraryName = $item.LibraryName
        $folderPath = $item.FolderPath
    
    try {
        # Connect to SharePoint Online with MFA authentication
        Connect-PnPOnline -Url $siteURL -UseWebLogin

        foreach ($item in $csvData) {
            $siteURL = $item.SiteURL
            $libraryName = $item.LibraryName
            $folderPath = $item.FolderPath

            try {
                # Create the library if it doesn't exist
                if (-not (Get-PnPList -Identity $libraryName -ErrorAction SilentlyContinue)) {
                    New-PnPList -Title $libraryName -Template DocumentLibrary
                }

                # Create subfolders
                $subfolders = $folderPath.Split("/")
                foreach ($folderName in $subfolders) {
                    Add-PnPFolder -Name $folderName -Folder $libraryName -ErrorAction SilentlyContinue
                    Set-PnPFolderPermission -Name $folderpath -List $libraryName -User "admin@skhas.com" -PermissionKind Edit
                }

                Write-Host "Folder '$folderPath' created in library '$libraryName' in site '$siteURL'" -ForegroundColor Green
            }
            catch {
                Write-Host "Error creating folder '$folderPath' in library '$libraryName' in site '$siteURL': $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    finally {
        Disconnect-PnPOnline
       }
    }
}
# Call the function to create folders from the CSV file
Create-FoldersFromCSV -CSVPath $csvPath
