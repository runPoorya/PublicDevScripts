<#
.SYNOPSIS
    Parameters of types introduced in PowerShell 6.0 to 7.4 (requires PowerShell 7.4+).

.DESCRIPTION
    21 parameters, each named after the type it demonstrates and each with a
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
      * PowerShell 6.0
      * PowerShell 7.0 (.NET Core 3.1)
      * PowerShell 7.1 (.NET 5)
      * PowerShell 7.2 (.NET 6)
      * PowerShell 7.3 (.NET 7)
      * PowerShell 7.4 (.NET 8)
      * Newer attributes (not types)

    Notes:
      * Requires PowerShell 7.4 or later; older versions stop with a clear
        message instead of failing on the first missing type.
      * Each parameter says in which version its type first appeared.
      * Where an older relative exists in earlier versions it is named under
        "Available".

    Not covered: your own classes, and any type introduced after the newest
    version listed above.

.PARAMETER SemanticVersion
    A semantic version such as 1.2.3-beta.1 (major.minor.patch with optional pre-release). Available: PowerShell 6.0 and later (newer 7.x versions also have a [semver] shortcut); older relative: [version] (no pre-release part). Default: '1.2.3-beta.1'.

.PARAMETER Index
    A position in a sequence, optionally counted from the end (as in $array[^1]). Available: PowerShell 7.0 and later. Default: index 1 from the start.

.PARAMETER Range
    A start and end Index pair (as in $array[1..^1]). Available: PowerShell 7.0 and later. Default: from the start to the last-but-one position.

.PARAMETER Rune
    A single Unicode character, including those outside the basic 16-bit range. Available: PowerShell 7.0 and later. Default: the letter A.

.PARAMETER BigInteger
    Whole number of any size. Available: PowerShell 7.0 and later (Windows PowerShell may need Add-Type -AssemblyName System.Numerics; not verified). The [bigint] shortcut and the 100n literal suffix are PowerShell 7 features. Default: [System.Numerics.BigInteger]::Parse('123456789012345678901234567890').

.PARAMETER Complex
    Complex number (real and imaginary part). Available: PowerShell 7.0 and later (Windows PowerShell may need Add-Type -AssemblyName System.Numerics; not verified). Default: 1 + 2i.

.PARAMETER Half
    Half-precision (16-bit) floating point number. Available: PowerShell 7.1 and later. Default: 1.5.

.PARAMETER DateOnly
    A date without a time. Available: PowerShell 7.2 and later; older relative: [datetime] (always carries a time). Default: 2026-01-01.

.PARAMETER TimeOnly
    A time of day without a date. Available: PowerShell 7.2 and later; older relative: [timespan]. Default: 12:30.

.PARAMETER PriorityQueueOfStringInt32
    Queue that returns the item with the lowest priority number first. Empty by default. Available: PowerShell 7.2 and later. Default: an empty queue.

.PARAMETER Int128
    128-bit signed whole number. Available: PowerShell 7.3 and later (the [int128] shortcut appears in newer versions); older relative: [bigint]. Default: the maximum value.

.PARAMETER UInt128
    128-bit unsigned whole number. Available: PowerShell 7.3 and later. Default: the maximum value.

.PARAMETER IPNetwork
    An IP network in CIDR notation such as 10.0.0.0/8. Available: PowerShell 7.4 and later. Default: 10.0.0.0/8.

.PARAMETER TimeProvider
    A replaceable source of the current time (useful for testing). Available: PowerShell 7.4 and later. Default: the system time provider.

.PARAMETER CompositeFormat
    A pre-parsed format string such as 'Hello {0}'. Available: PowerShell 7.4 and later. Default: 'Hello {0}'.

.PARAMETER ArgumentCompletionsValue
    Tab completion suggests Alpha, Beta and Gamma ([ArgumentCompletions]); any text is accepted. Available: PowerShell 6.0 and later; Windows PowerShell 5.1 uses [ArgumentCompleter] with a script block instead. Default: 'Alpha'.

.PARAMETER PositiveRange
    Only numbers greater than 0 ([ValidateRange('Positive')]). Available: PowerShell 6.2 and later (older: [ValidateRange(1, [int]::MaxValue)]). Default: 1.

.PARAMETER NegativeRange
    Only numbers less than 0 ([ValidateRange('Negative')]). Available: PowerShell 6.2 and later. Default: -1.

.PARAMETER NonNegativeRange
    Only numbers of 0 or more ([ValidateRange('NonNegative')]). Available: PowerShell 6.2 and later. Default: 0.

.PARAMETER NonPositiveRange
    Only numbers of 0 or less ([ValidateRange('NonPositive')]). Available: PowerShell 6.2 and later. Default: 0.

.PARAMETER CustomErrorMessagePattern
    Digits only, with your own error message ([ValidatePattern] with ErrorMessage). Available: PowerShell 6.0 and later (the ErrorMessage option does not exist in Windows PowerShell 5.1). Default: '123'.
.EXAMPLE
    .\All-Parameters-PowerShell7.ps1
    Runs with all default values.

.EXAMPLE
    .\All-Parameters-PowerShell7.ps1 -PositiveRange 0
    PowerShell rejects the value because 0 is not greater than 0.
#>

#requires -Version 7.4
#requires -PSEdition Core

[CmdletBinding()]
param (
    # ---- PowerShell 6.0 ------------------------------------------------
    [System.Management.Automation.SemanticVersion]$SemanticVersion = '1.2.3-beta.1',

    # ---- PowerShell 7.0 (.NET Core 3.1) --------------------------------
    [System.Index]$Index = ([System.Index]::new(1, $false)),

    [System.Range]$Range = ([System.Range]::new([System.Index]::new(0, $false), [System.Index]::new(1, $true))),

    [System.Text.Rune]$Rune = ([System.Text.Rune]::new([char]'A')),

    [System.Numerics.BigInteger]$BigInteger = [System.Numerics.BigInteger]::Parse('123456789012345678901234567890'),

    [System.Numerics.Complex]$Complex = [System.Numerics.Complex]::new(1.0, 2.0),

    # ---- PowerShell 7.1 (.NET 5) ---------------------------------------
    [System.Half]$Half = [System.Half]::Parse('1.5', [System.Globalization.CultureInfo]::InvariantCulture),

    # ---- PowerShell 7.2 (.NET 6) ---------------------------------------
    [System.DateOnly]$DateOnly = [System.DateOnly]::new(2026, 1, 1),

    [System.TimeOnly]$TimeOnly = [System.TimeOnly]::new(12, 30),

    [System.Collections.Generic.PriorityQueue[string,int]]$PriorityQueueOfStringInt32 = [System.Collections.Generic.PriorityQueue[string,int]]::new(),

    # ---- PowerShell 7.3 (.NET 7) ---------------------------------------
    [System.Int128]$Int128 = [System.Int128]::MaxValue,

    [System.UInt128]$UInt128 = [System.UInt128]::MaxValue,

    # ---- PowerShell 7.4 (.NET 8) ---------------------------------------
    [System.Net.IPNetwork]$IPNetwork = [System.Net.IPNetwork]::Parse('10.0.0.0/8'),

    [System.TimeProvider]$TimeProvider = [System.TimeProvider]::System,

    [System.Text.CompositeFormat]$CompositeFormat = [System.Text.CompositeFormat]::Parse('Hello {0}'),

    # ---- Newer attributes (not types) ----------------------------------
    [ArgumentCompletions('Alpha', 'Beta', 'Gamma')]
    [string]$ArgumentCompletionsValue = 'Alpha',

    [ValidateRange('Positive')]
    [int]$PositiveRange = 1,

    [ValidateRange('Negative')]
    [int]$NegativeRange = -1,

    [ValidateRange('NonNegative')]
    [int]$NonNegativeRange = 0,

    [ValidateRange('NonPositive')]
    [int]$NonPositiveRange = 0,

    [ValidatePattern('^\d+$', ErrorMessage = 'Digits only, please.')]
    [string]$CustomErrorMessagePattern = '123'
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
