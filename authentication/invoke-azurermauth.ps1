function invoke-azurermauth

{
    [cmdletbinding()]
    param(
        [parameter (Mandatory=$true)][String]$SubscriptionId,
        [parameter (Mandatory=$true)][string]$tenantID,   
        [parameter (Mandatory=$false)][String]$ProfilePath,
        [parameter (Mandatory=$false)][switch]$ServicePrincipal,
        [parameter (Mandatory=$false)][pscredential]$Credential, 
        [parameter (Mandatory=$false)]
            [ValidateSet ('AzureCloud','AzureGermanCloud','AzureChinaCloud','AzureUSGovernment')]
            [String]$EnvironmentName='AzureCloud'    
        )

        try 
            {
                $AzureRMSubscription = Get-AzureRmSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop
                Write-Host
                Write-Host "Already Logged In to $($AzureRMSubscription.SubscriptionName), continuing...." -BackgroundColor DarkGreen
                Write-Host
            }

        catch 
            {   
                
                
                if(!$ServicePrincipal)
                {
                    if (!$creds){
                    
                        $creds = Get-Credential
                    
                    }
                
                    try
                    {           
                        $loginParams = @{
                            'SubscriptionId'= $SubscriptionId
                            'TenantID' = $tenantID
                            'EnvironmentName'= $EnvironmentName
                            'Credential' = $Credential 
                            'ErrorAction'='Stop'
                        }   
                        
                        $azureProfile = Login-AzureRmAccount @loginParams

                       
                        if($ProfilePath)
                            {
                                Save-AzureRmContext -Profile $azureProfile -Path $ProfilePath -Force -ErrorAction Stop
                            }
                        
                    }
                        
             
                    catch
                    {
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host
                    }

                }

                else{

                    if (!$creds){
                    
                        $creds = Get-Credential
                    
                    }
                    
                    try{

                        
                    $loginParams = @{
                        'SubscriptionId'= $SubscriptionId
                        'TenantID' = $tenantID
                        'EnvironmentName'= $EnvironmentName
                        'Credential' = $Credential
                        'ErrorAction'='Stop'}
                        
                        $azureProfile = Login-AzureRmAccount @loginParams -ServicePrincipal

                        if($ProfilePath)
                        {
                            Save-AzureRmContext -Profile $azureProfile -Path $ProfilePath -Force -ErrorAction Stop
                        }

                        }
                    
                    catch{
                        
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host

                        }
                    
                    }   

                }
}

