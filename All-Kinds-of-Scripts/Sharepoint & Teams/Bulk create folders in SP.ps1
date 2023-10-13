#Test
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
    $URL = "Https://sveinungkristiansen.sharepoint.com"

    try {
        # Connect to SharePoint Online with MFA authentication
        Connect-PnPOnline -Url $URL -UseWebLogin

        foreach ($item in $csvData) {
            $siteURL = $item.SiteURL
            $libraryName = $item.LibraryName
            $folderPath = $item.FolderPath

            try {
                # Create the library if it doesn't exist
                if (-not (Get-PnPList -Identity $libraryName -ErrorAction SilentlyContinue)) {
                    New-PnPList -Title $libraryName -Template DocumentLibrary
                }

                # Get the root folder of the library
                $rootFolder = Get-PnPFolder -Url $libraryName

                # Create subfolders
                $subfolders = $folderPath.Split("/")
                foreach ($folderName in $subfolders) {
                    $folderUrl = "$($rootFolder.ServerRelativeUrl)/$folderName"
                    $folder = Add-PnPFolder -Name $folderName -Folder $folderUrl -ErrorAction SilentlyContinue
                    Set-PnPFolderPermission -Name $folderUrl -List $libraryName -User "admin@skhas.com" -PermissionKind Edit

                    $rootFolder = $folder
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

# Call the function to create folders from the CSV file
Create-FoldersFromCSV -CSVPath $csvPath
