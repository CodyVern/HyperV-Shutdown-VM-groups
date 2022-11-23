
$servers = "PC1, PC2"
$groupA = @("vm1")
$groupB = @("vm2", "vm2")
$groupC = @("vm3", "vm4")
$groupD = @("vm5")
#...


function ShutDownGroupThenWait ($group) { #Input vm group (array) into function

    #================ VM PRESENCE VERIFIER ===================#

    $VMS = Get-VM -ComputerName $servers
    Write-Host ""
    Write-Host ""

    foreach($name in $group){
    if(-not ($VMS | Where-Object {$_.Name -eq $name})) #If any VM isn't present return TRUE
    { 
        Write-Host " "
        Write-Host ("[!] No connection to virtual machine: " + $name) -BackgroundColor Red
        Start-Sleep 5
        Write-Host  "[?] The shutdown has been aborted. Please verify connection to all vm's"
        Pause
        exit
    }
    else
    {
        #Write-Host ("VM present: " + $name)
    }
    }#end while

    write-host "All VMs are present"

    #====================== VM SHUTDOWNS ========================#

    foreach($name in $group)
    {
        Start-Sleep 1
        Write-Host ("Commencing shutdown: " + $name)
        stop-vm -Computername $servers -name $name -AsJob #-AsJob will start the shutdown then procceed with the script
    }                                                     #as apposed to halting the script until the single vm is fully shutdown

    #====================== VM STATE CHECKER ====================#

    $allShutdown = $false
    while($allShutdown -eq $false)
    {
        #start-sleep 10
        $vmstate = Get-VM -ComputerName $servers -name $group

        $ready = $true
        if( -not ($vmstate | Where-Object {($_.state) -eq 'off'})) #If any VM isn't OFF return TRUE
        {
            $ready = $false
            Write-Host "Group not fully shutdown, wait 10 seconds..."
        }
        else 
        {
            $allShutdown = $true;
            write-host "All VMs within group are shutdown, proceeding to next group..."
        }
        start-sleep 10
    }#end while

}#end function

ShutDownGroupThenWait $groupA
ShutDownGroupThenWait $groupB
ShutDownGroupThenWait $groupC
ShutDownGroupThenWait $groupD


#==================================================================================================

Write-Host ""
Write-Host ""
Write-Host "[+] All provided VMs are shutdown" -BackgroundColor Green