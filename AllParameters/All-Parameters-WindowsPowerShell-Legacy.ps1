<#
.SYNOPSIS
    Parameters of legacy types that exist only in Windows PowerShell (WMI v1 and ADSI shortcuts).

.DESCRIPTION
    5 parameters, each named after the type it demonstrates and each with a
    default value, so the script runs without any input. It prints one row per
    parameter (name, type, whether it was passed, value).

    Why there are four scripts: PowerShell cannot load a script that declares a
    type its version does not have, and no single PowerShell version has every
    type. The complete set is therefore split by version:
      * All-Parameters.ps1                           Windows PowerShell 5.1 and PowerShell 7+
      * All-Parameters-PowerShell7.ps1               PowerShell 7.4 or later (types from 6.0 to 7.4)
      * All-Parameters-PowerShell7.5Plus.ps1         PowerShell 7.5 or later
      * All-Parameters-WindowsPowerShell-Legacy.ps1  Windows PowerShell 5.1 only
    Reference: PowerShell 7.0 = .NET Core 3.1, 7.1 = .NET 5, 7.2 = .NET 6,
    7.3 = .NET 7, 7.4 = .NET 8, 7.5 = .NET 9. A type that came with a .NET
    version is available from the matching PowerShell version onward.

    This script covers these groups:
      * Windows PowerShell only (WMI v1 and ADSI shortcuts)

    Notes:
      * Windows only. The WMI v1 shortcuts ([wmi], [wmiclass], [wmisearcher])
        were removed in PowerShell 6; use the CIM types in All-Parameters.ps1
        ([ciminstance], [cimclass], Get-CimInstance) in newer versions.
      * [adsi] and [adsisearcher] may also work in PowerShell 7 on Windows; this
        has not been verified.
      * The defaults are created when the script starts: [wmi] connects to the
        local WMI service, and [adsi] binds to the local computer.

    Not covered: your own classes, and any type introduced after the newest
    version listed above.

.PARAMETER WMI
    A WMI object (System.Management.ManagementObject) from a WMI path. Connects to WMI when the script starts. Available: Windows PowerShell 5.1 and older. Related newer type: [ciminstance] (CIM); WMI v1 was removed in PowerShell 6+. Default: \\.\root\cimv2:Win32_OperatingSystem=@.

.PARAMETER WMIClass
    A WMI class (System.Management.ManagementClass). Available: Windows PowerShell 5.1 and older. Related newer type: [cimclass]. Default: \\.\root\cimv2:Win32_Process.

.PARAMETER WMISearcher
    A WMI query (System.Management.ManagementObjectSearcher); nothing runs until you call .Get(). Available: Windows PowerShell 5.1 and older. Related newer cmdlet: Get-CimInstance -Query. Default: 'SELECT * FROM Win32_Process'.

.PARAMETER ADSI
    An Active Directory/directory-service object (System.DirectoryServices.DirectoryEntry); here the local computer. Available: Windows PowerShell 5.1 and older; may also work in PowerShell 7 on Windows (not verified). Default: WinNT://<this computer>.

.PARAMETER ADSISearcher
    A directory search (System.DirectoryServices.DirectorySearcher) with an LDAP filter; nothing runs until you call .FindAll(). Available: Windows PowerShell 5.1 and older; may also work in PowerShell 7 on Windows (not verified). Default: (objectClass=user).
.EXAMPLE
    .\All-Parameters-WindowsPowerShell-Legacy.ps1
    Runs with all default values.
#>

#requires -Version 5.1
#requires -PSEdition Desktop

[CmdletBinding()]
param (
    # ---- Windows PowerShell only (WMI v1 and ADSI shortcuts) -----------
    [wmi]$WMI = '\\.\root\cimv2:Win32_OperatingSystem=@',

    [wmiclass]$WMIClass = '\\.\root\cimv2:Win32_Process',

    [wmisearcher]$WMISearcher = 'SELECT * FROM Win32_Process',

    [adsi]$ADSI = "WinNT://$env:COMPUTERNAME",

    [adsisearcher]$ADSISearcher = '(objectClass=user)'
)

$commonParameterNames = @(
    'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
    'ErrorVariable', 'WarningVariable', 'InformationVariable',
    'OutVariable', 'OutBuffer', 'PipelineVariable'
)

function ConvertTo-DisplayText {
    param ($Value)

    if ($null -eq $Value)                                       { return '$null' }
    if ($Value -is [System.Security.SecureString])              { return '(secure string, hidden)' }
    if ($Value -is [System.Management.Automation.PSCredential]) { return "user: $($Value.UserName), password hidden" }
    if ($Value -is [System.Management.Automation.PSReference])  { return 'ref -> ' + (ConvertTo-DisplayText $Value.Value) }
    if ($Value -is [scriptblock])                               { return '{ ' + $Value.ToString().Trim() + ' }' }
    if ($Value -is [xml])                                       { return $Value.OuterXml }
    if ($Value -is [System.IO.FileSystemInfo])                  { return $Value.FullName }
    if ($Value -is [datetime])                                  { return $Value.ToString('s') }
    if ($Value -is [System.Collections.IDictionary]) {
        return (($Value.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '; ')
    }
    if (($Value -is [System.Collections.IEnumerable]) -and ($Value -isnot [string])) {
        return ((@($Value) | ForEach-Object { ConvertTo-DisplayText $_ }) -join ', ')
    }
    return [string]$Value
}

$declaredParameters = $MyInvocation.MyCommand.Parameters
$declaredNames = @($declaredParameters.Keys | Where-Object { $commonParameterNames -notcontains $_ })

Write-Verbose "Declared parameters: $($declaredNames.Count)"

[PSCustomObject]@{
    Name   = '(parameter set)'
    Type   = ''
    Passed = ''
    Value  = $PSCmdlet.ParameterSetName
}

foreach ($parameterName in $declaredNames) {
    $type = $declaredParameters[$parameterName].ParameterType
    if ($type.IsGenericType) {
        $typeText = ($type.Name -replace '`\d+$', '') + '[' + (($type.GetGenericArguments() | ForEach-Object { $_.Name }) -join ',') + ']'
    }
    else {
        $typeText = $type.Name
    }

    [PSCustomObject]@{
        Name   = $parameterName
        Type   = $typeText
        Passed = $PSBoundParameters.ContainsKey($parameterName)
        Value  = ConvertTo-DisplayText (Get-Variable -Name $parameterName -ValueOnly -ErrorAction SilentlyContinue)
    }
}
