
param(
[parameter (Mandatory=$true)][guid]$subscriptionID,
[parameter (Mandatory=$true)][String]$storageAccountName,
[parameter (Mandatory=$true)][String]$storageAccountKey,
[parameter (Mandatory=$true)][String]$container,
[parameter (Mandatory=$true)][String]$blobName, 
[parameter (Mandatory=$true)][String]$localFile
)


$contextparams = @{"StorageAccountName"=$storageAccountName;
                  "StorageAccountKey"=$storageAccountKey;
                  "ErrorAction"='Stop';
                  }

$blobparams = @{"File"=$localFile;
               "Container"=$container;
               "Blob"=$blobName;
               "Context"=$context;
               "ErrorAction"='Stop'
                }

try{
$context = New-AzureStorageContext @contextparams 
}

catch{
Write-Host
Write-Host "$($Error[0])" -BackgroundColor Red
Write-Host
}
    
if($context)
    {
        try{
        Set-AzureStorageBlobContent @blobparams
        }
    
        catch{
        Write-Host
        Write-Host "$($Error[0])" -BackgroundColor Red
        Write-Host
        }
}