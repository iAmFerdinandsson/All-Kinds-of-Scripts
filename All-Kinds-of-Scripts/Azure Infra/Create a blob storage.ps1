#Test
$storageAccountName = "labenvstorageaccount03"
$storageAccountKey = "g/PvoCeeDXCil1rrJUM6ivnPhGEbDZPD4c6MnDqRIAE/ZUoMGNFVKW4nflgvT/2P+5xSs6XwHkSE+ASt87q/AA=="
$containerName = "myblob02"

# Create a new storage context
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Create a new blob storage container
New-AzStorageContainer -Name $containerName -Permission Blob -Context $ctx
