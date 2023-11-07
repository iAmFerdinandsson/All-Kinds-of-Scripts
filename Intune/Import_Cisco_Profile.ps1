    ## Variables: Script
    # File Path for Cisco AnyConnect Profile XML file
    $filePath = 'Join-Path $env:ProgramData 'Cisco\Cisco AnyConnect Secure Mobility Client\Profile\AnyConnectProfile.xsd''
    # Original and replacement string for AutoReconnect value
    $findAutoReconnect = '<xs:element name="AutoReconnect" default="true" minOccurs="0">'
    $replaceAutoReconnect = '<xs:element name="AutoReconnect" default="false" minOccurs="0">'
    # Original and replacement string for ConnectOnStartup Value
    $findConnectOnStartup =  '<xs:element name="AutoConnectOnStart" default="true" minOccurs="0">'
    $replaceConnectOnStartup = '<xs:element name="AutoConnectOnStart" default="false" minOccurs="0">'

    #RegistryValues
    $registryPath = 'HKCU:\Software\CommunityBlog\Scripts'
    $Name = 'Version'
    $Value = '42'
    $itemProperty = "Get-ItemProperty -Path $Path -Name $Name"

# Function to update the registry value
function Set-RegistryValue {
    param (
        [string]$registryPath,
        [string]$Name,
        [string]$Value
    )

    # Check if the registry path exists, create it if necessary
    if (Test-Path -Path $registryPath) {
     
    try{
        # Set the registry value
        Set-ItemProperty -Path $Path -Name $Name -Value $Value
    if ($itemProperty -ne )
    }  
}

# Check if the file exists
if (Test-Path -Path $filePath -PathType Leaf) {
    try {
        # Read the XML file content
        $xmlContent = Get-Content -Path $filePath -Raw

        # Store the original content for comparison
        $originalXmlContent = $xmlContent

        # Replace the elements' content
        $updatedXmlContent = $xmlContent -replace [regex]::Escape($findAutoReconnect), $replaceAutoReconnect
        $updatedXmlContent = $updatedXmlContent -replace [regex]::Escape($findConnectOnStartup), $replaceConnectOnStartup

        # Check if the content was changed
        if ($originalXmlContent -ne $updatedXmlContent) {
            # Write the updated content back to the file
            $updatedXmlContent | Set-Content -Path $filePath -Force

            Write-Host "Content changed. New content:"
            Write-Host "Check $filePath for new content"
            Write-Host "Value changed"
            } else {
                Write-Host "Content was already updated."
            }
        } catch {
            Write-Host "Failed to process the XML file: $_"
        }
    } else {
        Write-Host "File not found"
}

