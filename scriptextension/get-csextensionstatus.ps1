
function get-csextensionstatus {
    [cmdletbinding()]
    param(
     [parameter (Mandatory=$true)][string]$vmName,
     [parameter (Mandatory=$false)][string]$ResourceGroupName,
     [parameter (Mandatory=$true)][string]$ExtensionName
     
    )

    try {
        
        $extensionParams = @{
            'ResourceGroupName' = "$ResourceGroupName";
            'VMName' = "$vmName";
            'Name' = "$ExtensionName";
            'ErrorAction' = 'Stop'
        }
        
        
        $Extension = Get-AzureRmVMExtension @extensionParams -Status
        
        if ($Extension)
            {
                return $Extension
            }
        
        else {
            return $null
        }


    
        }
    
    catch {
        
        Write-Host
        Write-Host "$($Error[0])" -BackgroundColor Red
        Write-Host

        }

}