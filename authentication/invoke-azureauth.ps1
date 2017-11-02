
function invoke-azureauth.ps1

{

    param
        (

        [parameter (Mandatory=$false)][String]$ProfilePath,
        [parameter (Mandatory=$false)][String]$Environment,
        [parameter (Mandatory=$false)][String]$SubscriptionId

        
        )

        try 
            {

                $AzureRMSubscription = Get-AzureRmSubscription -ErrorAction Stop
                Write-Host
                Write-Host "Already Logged In to $($AzureRMSubscription.SubscriptionName), continuing...." -BackgroundColor DarkGreen
                Write-Host
            }

        catch 
            {
                if($profilePath)
                    {
                        try
                            {
                                $Profile = Login-AzureRmAccount -ErrorAction Stop -
                                Save-AzureRmProfile -Profile $Profile -Path $ProfilePath -ErrorAction Stop
                            }
                        
                        catch
                            {
                                Write-Host
                                Write-Host "$($Error[0])" -BackgroundColor Red
                                Write-Host
                            }
                    }

                else 
                    {
                        try
                            {
                                Login-AzureRmAccount -ErrorAction Stop
                            }
                        catch
                            {
                                Write-Host
                                Write-Host "$($Error[0])" -BackgroundColor Red
                                Write-Host
                            }
            
                    }

        }
}