function invoke-azurermauth

{
    [cmdletbinding()]
    param(
        [parameter (Mandatory=$true)][String]$SubscriptionId,
        [parameter (Mandatory=$true)][string]$tenantID,   
        [parameter (Mandatory=$false)][String]$ProfilePath,
        [parameter (Mandatory=$false)][switch]$ServicePrincipal, 
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
                {try
                    {           
                        $loginParams = @{
                            'SubscriptionId'= $SubscriptionId
                            'TenantID' = $tenantID
                            'EnvironmentName'= $EnvironmentName
                            'ErrorAction'='Stop'
                        }   
                        
                        $azureProfile = Login-AzureRmAccount @loginParams

                        <#
                        not super happy about this.
                        would rather pass creds in and out as a PScred object, but getting
                        the issues outlined here:
                        https://stackoverflow.com/questions/10036271/how-to-convert-parameter-type-into-a-different-object-type
                        So...in order to have crednetials that I can pass to a background process, I must do the following.
                        #>

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

                    $Creds = Get-Credential
                    
                    try{
                    $loginParams = @{
                        'SubscriptionId'= $SubscriptionId
                        'TenantID' = $tenantID
                        'EnvironmentName'= $EnvironmentName
                        'Credential' = $Creds
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

