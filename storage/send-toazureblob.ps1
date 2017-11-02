function send-toazureblob {


<#
 .SYNOPSIS
    Uploads a file to Azure Blob Storage

 .DESCRIPTION
    A simple script for uploading a file to Azure Blob Storage.

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER storageAccountName
    The Storage Account where the blob will be created.

 .PARAMETER storageAccountKey
    The key needed for storage access.

 .PARAMETER container
    The container location.

 .PARAMETER blobName
    The name of the new blob.

 .PARAMETER localFile
    The local file to be uploaded.
#>
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
        
$blobparams = @{"File"=$localFile;
                "Container"=$container;
                "Blob"=$blobName;
                "Context"=$context;
                "ErrorAction"='Stop'
                }
            
try{
    Set-AzureStorageBlobContent @blobparams
    }
    
catch{
    Write-Host
    Write-Host "$($Error[0])" -BackgroundColor Red
    Write-Host
    }
}

}