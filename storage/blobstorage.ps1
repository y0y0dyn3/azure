

param(
[parameter (Mandatory=$true)][guid]$subscriptionID,
[parameter (Mandatory=$true)][String]$storageAccountName,
[parameter (Mandatory=$true)][String]$storageAccountKey,
[parameter (Mandatory=$true)][String]$container,
[parameter (Mandatory=$true)][String]$blobName, 
[parameter (Mandatory=$true)][String]$localFile,
[parameter (Mandatory=$true)][string]$ProfilePath
)



##
function Set-AzureRMLogin {
 
param(

[parameter (Mandatory=$false)][String]$ProfilePath

)

try {

    $AzureRMSubscription = Get-AzureRmSubscription -ErrorAction Stop
    Write-Host "Already Logged In to $($AzureRMSubscription.SubscriptionName), continuing...."
    
    }

catch {



if($profilePath){
    
    $Profile = Login-AzureRmAccount
    Save-AzureRmProfile -Profile $Profile -Path $ProfilePath   
    
    }

else {
    Login-AzureRmAccount
    }


}

}


Set-AzureRMLogin

$resourceGroupName = Get-AzureRmStorageAccount | where {$_.StorageAccountName -eq $StorageAccountName} #place into try catch with RGN and Name

if($resourceGroupName) #will go away with resource group try/catch.
    {
     
    $context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey # place in try/catch
    
    
    try{
    Set-AzureStorageBlobContent -File $localFile -Container $container -Blob $blobName -Context $context -ErrorAction Stop
    }
    catch{
    
    Write-Host "$($Error[0])"
    
    }

    }

else{

    Write-Host -ForegroundColor DarkRed "So Sorry!  The Storage Account: $StorageAccountName, may not be valid.  Please verify the account."

    }










