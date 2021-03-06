function get-RMVMInventory 
    {
        [cmdletbinding()]
        param(
            [parameter (Mandatory=$true)][String]$SubscriptionId,
            [parameter (Mandatory=$false)][String]$ResourceGroupName,
            [parameter (Mandatory=$false)][switch]$detailed
        )

        try {
                $ValidateSubscription = Select-AzureRmSubscription -Subscription $SubscriptionId -ErrorAction Stop #capture in variable to hide host output.
               
                $vms = @()
                
                if($ResourceGroupName) {$AzureVMs = get-azurermvm -ResourceGroupName $ResourceGroupName}
                else{$AzureVMs = get-azurermvm}

                if($detailed){
                foreach ($AzureVM in $AzureVMs){
                    
                    $VM = New-Object -TypeName PSCustomObject

                    $vm | Add-Member -MemberType NoteProperty -Name VMName -Value $($AzureVM.Name) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name osFamily -Value  $($azureVM.StorageProfile.OsDisk.OsType) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name osType -Value $($azureVM.StorageProfile.ImageReference.Publisher) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name osVersion -Value $($azureVM.StorageProfile.ImageReference.Sku) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name Location -Value $($azureVM.Location) -Force
                    $vm | Add-Member -MemberType NoteProperty -Name Vmid -Value $($AzureVM.Vmid) -Force
                    $vm | Add-member -MemberType NoteProperty -Name ResourceGroup -Value $($AzureVM.ResourceGroupName) -Force

                    
                    try{
                    $PowerStatus = (Get-AzureRmVM -Name $AzureVM.Name -ResourceGroupName $AzureVM.ResourceGroupName -Status -ErrorAction Stop).statuses | where {$_.Code -match "powerstate"}
                    $VM | Add-Member -MemberType NoteProperty -Name powerState -Value  $($PowerStatus.Code) -Force
                    $VM | Add-Member -MemberType NoteProperty -Name DisplayStatus -Value  $($PowerStatus.DisplayStatus) -Force
                 
                    }
                    catch{
                        $VM | Add-Member -MemberType NoteProperty -Name powerState -Value  $null -Force
                        $VM | Add-Member -MemberType NoteProperty -Name DisplayStatus -Value  $null -Force
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host
                    }

                    try{
                        $ProvisioningStatus = (Get-AzureRmVM -Name $AzureVM.Name -ResourceGroupName $AzureVM.ResourceGroupName -Status -ErrorAction Stop).statuses | where {$_.Code -match "ProvisioningState"}
                        $VM | Add-Member -MemberType NoteProperty -Name provisioningState -Value  $($ProvisioningStatus.Code) -Force
                        $VM | Add-Member -MemberType NoteProperty -Name provisioningTime -Value  $($ProvisioningStatus.Time) -Force
                    }
                    
                    catch{
                        
                        $VM | Add-Member -MemberType NoteProperty -Name provisioningState -Value  $null -Force
                        $VM | Add-Member -MemberType NoteProperty -Name provisioningTime -Value  $null -Force
                        
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host
                    } 

                    $nicID = $azureVm.NetworkProfile.NetworkInterfaces.id
                    $nicName = $($azureVM.NetworkProfile.NetworkInterfaces.id).Split('/') | select-object -Last 1
                    $nicResourceGroup = ($nicID.Split('/'))[4] 
                    
                    try{
                    $nicAdapter = Get-AzureRmNetworkInterface -ResourceGroupName $nicResourceGroup -Name $nicName -ErrorAction Stop
                    $VM | Add-Member -MemberType NoteProperty -Name PrivateIP -Value  $($nicAdapter.IpConfigurations.PrivateIpAddress) -Force
                    }
                    
                    catch{
                        $VM | Add-Member -MemberType NoteProperty -Name PrivateIP -Value  $null -Force
                        Write-Host
                        Write-Host "$($Error[0])" -BackgroundColor Red
                        Write-Host
                    }
                
                    try{
                        $publicIPID = $nicAdapter.IpConfigurations.PublicIpAddress.Id.Split('/') | Select-Object -Last 1
                        $publicIPResourceGroup = ($nicAdapter.IpConfigurations.PublicIpAddress.Id.split('/'))[4]
                        $publicIP = (Get-AzureRmPublicIpAddress -ResourceGroupName $publicIPResourceGroup -Name $publicIPID -ErrorAction Stop).IpAddress
                        $VM | Add-Member -MemberType NoteProperty -Name PublicIP -Value  $publicIP -Force
                    }
                
                    catch{                     
                        $publicIP = $false
                        $VM | Add-Member -MemberType NoteProperty -Name PublicIP -Value  $publicIP -Force
                           
                    }
                
                #should make this more elegant.
                   
                $vms += $vm
                }
            }
            else{

                foreach($azureVM in $AzureVMs)
                    {
                        $VM = New-Object -TypeName PSCustomObject
                        
                        $vm | Add-Member -MemberType NoteProperty -Name VMName -Value $($AzureVM.Name) -Force
                        $VM | Add-Member -MemberType NoteProperty -Name osFamily -Value  $($azureVM.StorageProfile.OsDisk.OsType) -Force
                        $VM | Add-Member -MemberType NoteProperty -Name osType -Value $($azureVM.StorageProfile.ImageReference.Publisher) -Force
                        $VM | Add-Member -MemberType NoteProperty -Name osVersion -Value $($azureVM.StorageProfile.ImageReference.Sku) -Force
                        $VM | Add-Member -MemberType NoteProperty -Name Location -Value $($azureVM.Location) -Force
                        $vm | Add-member -MemberType NoteProperty -Name ResourceGroup -Value $($AzureVM.ResourceGroupName) -Force

                        $vms += $vm

                    }

            }    
                return $vms
            }
        
        catch
            {
                Write-Host
                Write-Host "$($Error[0])" -BackgroundColor Red
                Write-Host
            }

    }