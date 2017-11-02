function New-AzureRmStorageAccount
{
param(
 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [Parameter(Mandatory=$True)]
 [string]
 $Location,

 [Parameter(Mandatory=$True)]
 [string]
 $Name,

 [Parameter(Mandatory=$True)]
 [string]
 $SkuName,

 [Parameter(Mandatory=$False)]
 [string]
 $AccessTier,
 
 [Parameter(Mandatory=$False)]
 [boolean]
 $AssignIdentity,
 
 [Parameter(Mandatory=$False)]
 [string]
 $CustomDomainName,
 
 [Parameter(Mandatory=$False)]
 [string]
 $EnableEncryptionService,
 
 [Paremeter(Mandatory=$False)]
 [boolean]
 $EnableHttpsTrafficOnly,
 
 [Paremeter(Mandatory=$False)]
 [string]
 $InformationAction,
 
 [Paremeter(Mandatory=$False)]
 [string]
 $kind,
 
 [Paremeter(Mandatory=$False)]
 [string]
 $tag,
 
 [Paremeter(Mandatory=$False)]
 [boolean]
 $UseSubDomain
)

New-AzureRmStorageAccount

}