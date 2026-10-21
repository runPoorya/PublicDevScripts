<#
.SYNOPSIS
    Parameters of types introduced with PowerShell 7.5 (.NET 9). Requires PowerShell 7.5+.

.DESCRIPTION
    2 parameters, each named after the type it demonstrates and each with a
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
      * PowerShell 7.5 (.NET 9)

    Notes:
      * Requires PowerShell 7.5 or later.
      * Only two types are listed because I know of no others from .NET 9
        that are worth a parameter. Tell me your PowerShell version if you want
        types from newer releases added.

    Not covered: your own classes, and any type introduced after the newest
    version listed above.

.PARAMETER Lock
    A lightweight lock object for thread synchronisation. Available: PowerShell 7.5 and later. Default: a new lock.

.PARAMETER OrderedDictionaryOfStringInt32
    Generic dictionary that keeps insertion order. Empty by default. Available: PowerShell 7.5 and later; older relative: [System.Collections.Specialized.OrderedDictionary] (untyped). Default: an empty dictionary.
.EXAMPLE
    .\All-Parameters-PowerShell7.5Plus.ps1
    Runs with all default values.
#>

#requires -Version 7.5
#requires -PSEdition Core

[CmdletBinding()]
param (
    # ---- PowerShell 7.5 (.NET 9) ---------------------------------------
    [System.Threading.Lock]$Lock = [System.Threading.Lock]::new(),

    [System.Collections.Generic.OrderedDictionary[string,int]]$OrderedDictionaryOfStringInt32 = [System.Collections.Generic.OrderedDictionary[string,int]]::new()
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
