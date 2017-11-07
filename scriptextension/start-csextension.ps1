function start-extension 
    {
        [cmdletbinding()]
        param(
            [parameter (Mandatory=$true)][psobject]$Target,
            [parameter (Mandatory=$false)][string]$uri,
            [parameter (Mandatory=$true)][string]$ExtensionName,
            [parameter (Mandatory=$true)][string]$ExtensionType,
            [parameter (Mandatory=$true)][string]$Publisher,
            [parameter (Mandatory=$true)][string]$Version,
            [parameter (Mandatory=$true)][string]$command,
            [parameter (Mandatory=$true)][string]$SubscriptionID
        )

        try {

            Set-AzureRmContext -Subscription $SubscriptionID -ErrorAction Stop
            $vm = Get-AzureRmVm -ResourceGroupName $Target.ResourceGroupName -ResourceGroupName -Name $Target.Name
            $customScriptExtensions = $($vm.Extensions) | where {$_.VirtualMachineExtensionType -eq $ExtensionType}
            
            try #change to loop that checks status Dont want to remove if in progress....
                {
                    $removeParms = @{

                        "VMName" = $($vm.Name);
                        "ResourceGroupName" =  $($vm.ResourceGroupName);
                        "Name" =  $($customScriptExtensions.Name);
                        "ErrorAction" = "stop"
                    }
                    
                    Remove-AzureRmVMExtension @removeParms -Force

                    $PublicConfiguration = @{
                        "fileUris" = [Object[]]$uri;
                        "timestamp" = $timestamp;
                        "commandToExecute" = $command
                    }
                    
                    $CSEParams = @{
                        "ResourceGroupName" = "$($vm.ResourceGroupName)";
                        "VMName" = "$($vm.Name)";
                        "Location" = "$($vm.Location)";
                        "Name" = $ExtensionName;
                        "Publisher" = $Publisher;
                        "ExtensionType" = $ExtensionType;
                        "TypeHandlerVersion" = $Version;
                        "Settings" = $PublicConfiguration;
                        "ErrorAction" = "Stop"
                    }
    
                    try {
                        Set-AzureRmVMExtension @CSEParams
                        #may need to put next section in a do-while.
                        $VMstatus = Get-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -status | where {$_.Name -eq $ExtensionName}
                        return $VMstatus.Extensions.Statuses.DisplayStatus
                    } 
                    
                    catch{
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host
                    } 
                }

                catch{
                    Write-Host
                    Write-Host "$($Error[0])" -BackgroundColor Red
                    Write-Host
                }       
        }
        catch {

            Write-Host
            Write-Host "$($Error[0])" -BackgroundColor Red
            Write-Host
        }
    }