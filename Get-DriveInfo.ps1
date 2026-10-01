<#
.SYNOPSIS
    Shows size and free space for a selected local drive.

.DESCRIPTION
    Takes a drive letter with a colon (for example "C:") as its parameter.
    In ScriptRunner, the value for -DriveLetter is picked from the dropdown
    that is filled by the query script which lists the local drives
    (it returns the WMI device IDs such as "C:").

.PARAMETER DriveLetter
    The drive to inspect, written as a letter followed by a colon, e.g. "C:".
    Required.

.EXAMPLE
    .\Get-DriveInfo.ps1 -DriveLetter "C:"
    Shows the size and free space of drive C:.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$DriveLetter
)

# Checked here (not with ValidatePattern) so the custom message also works in Windows PowerShell 5.1.
if ($DriveLetter -notmatch '^[A-Za-z]:$') {
    throw "DriveLetter must be a letter followed by a colon, e.g. ""C:"". Got: ""$DriveLetter"""
}

$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($DriveLetter.ToUpper())'"

if (-not $disk) {
    throw "Drive $DriveLetter was not found."
}

[PSCustomObject]@{
    Drive   = $disk.DeviceID
    Label   = $disk.VolumeName
    SizeGB  = [math]::Round($disk.Size / 1GB, 2)
    FreeGB  = [math]::Round($disk.FreeSpace / 1GB, 2)
    FreePct = if ($disk.Size) { [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1) } else { 0 }
}
