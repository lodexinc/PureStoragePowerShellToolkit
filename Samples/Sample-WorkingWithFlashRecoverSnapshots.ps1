#
# Requires Pure Storage PowerShell Toolkit v2.8.0.430
#

# Import PowerShell Modules
Import-Module PureStoragePowerShell

# Variables
$PureObj = @{
    IP = "?"
    ParentVol = "?"
    ParentVolSize = "100G"
    ParentVolSuffix = "?"
    VerifyVol = "?"
    VerifyHost = "?"
    NewVol = "?"
}

# Connect to Pure Storage FlashArray.
$FASession = Get-PfaAPIToken -FlashArray $PureObj.IP -Credential(Get-Credential) | Connect-PfaController

# Create new volume and host to test.
New-PfaVolume -Name $PureObj.ParentVol -Size $PureObj.ParentVolSize -Session $FASession
New-PfaHost -Name $PureObj.VerifyHost -Session $FASession

# Create snapshot of PARENT volume.
New-PfaSnapshot -Volumes $PureObj.ParentVol -Suffix $PureObj.ParentVolSuffix -Session $FASession

# Create new volume from PARENT snapshot.
New-PfaVolume -Source $PureObj.ParentVol+"."+$PureObj.ParentVolSuffix -Name $PureObj.VerifyVol -Session $FASession

# Connect new volume to verification server.
Connect-PfaHost -Name $PureObj.VerifyHost -Volume $PureObj.VerifyVol -Session $FASession

# Rescan verification server bus for new Pure Storage volume and online.
Register-PfaHostVolumes -Computername $PureObj.VerifyHost

# Disconnect and remove Old Parent volume primary host.
Disconnect-PfaVolume -Volume $PureObj.ParentVol+"."+$PureObj.ParentVolSuffix -Host $PureObj.VerifyHost -Session $FASession
Remove-PfaVolume -Name $PureObj.ParentVol+"."+$PureObj.ParentVolSuffix -Eradicate -Session $FASession

# Create new snapshot of new PARENT database volume, ADVWORKS-CHILD
New-PfaSnapshot -SnapshotVolume $PureObj.VerifyVol -SnapshotSuffix $PureObj.ParentVolSuffix -Session $FASession

# Create new volume from NEW PARENT snapshot.
New-PfaVolume -Source $PureObj.ParenVol.$PureObj.ParentVolSuffix -Name $PureObj.NewVol -Session $FASession