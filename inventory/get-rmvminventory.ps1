function get-RMVMInventory 
    {
        [cmdletbinding()]
        param(
            [parameter (Mandatory=$true)][String]$SubscriptionId
        )

        try {
                Select-AzureRmSubscription -Subscription $SubscriptionId -ErrorAction Stop
                write-host $(Get-AzureRmContext)
                $vms = @()
                $VMs += Get-AzureRmResource | where {$_.ResourceType -eq 'Microsoft.Compute/virtualMachines' -or `
                    $_.ResourceType -eq 'Microsoft.ClassicCompute/virtualMachines'}
                #Write-Host $vms
                foreach ($VM in $VMs){
                    write-host $VM
                    $azureVM = Get-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName
                
                    $Status = Get-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Status | `
                            select -ExpandProperty Statuses | ?{ $_.Code -match "PowerState" } |`
                            select -ExpandProperty DisplayStatus
                                
                    $nicName = $($azureVM.NetworkProfile.NetworkInterfaces.id).Split('/') | select-object -Last 1 
                    $nicAdapter = Get-AzureRmNetworkInterface -ResourceGroupName $azureVM.ResourceGroupName -Name $nicName
                    $PrivateIP = $nicAdapter.IpConfigurations.PrivateIpAddress  #what about more than one IP?
                
                    try{
                        $publicIPID = $nicAdapter.IpConfigurations.PublicIpAddress.Id.Split('/') | Select-Object -Last 1 -ErrorAction Stop
                        $publicIP = (Get-AzureRmPublicIpAddress -ResourceGroupName $vm.ResourceGroupName -Name $publicIPID).IpAddress
                    }
                
                    catch{                     
                        $publicIP = $false    
                    }
                
                #should make this more elegant.
                    $VM | Add-Member -MemberType NoteProperty -Name osFamily `
                        -Value  $($azureVM.StorageProfile.OsDisk.OsType) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name osType `
                        -Value $($azureVM.StorageProfile.ImageReference.Publisher) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name osVersion `
                        -Value $($azureVM.StorageProfile.ImageReference.Sku) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name PrivateIP -Value $PrivateIP -Force
                    $VM | Add-Member -MemberType NoteProperty -Name PublicIP -Value $publicIP -Force
                    $VM | Add-Member -MemberType NoteProperty -Name PowerStatus -Value $Status -Force

                }
                return $VMs
            }
        
        catch
            {
                Write-Host
                Write-Host "$($Error[0])" -BackgroundColor Red
                Write-Host
            }

    }