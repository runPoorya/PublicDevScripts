<#
.SYNOPSIS
    Demonstrates three parameter sets (2, 3 and 5 parameters) and their edge cases.

.DESCRIPTION
    The three sets, with every parameter that belongs to each one:

      ByIdentifier  (2 parameters)
          ItemIdentifier (mandatory), OutputFormat

      ByNameSearch  (3 parameters, DEFAULT set)
          ItemNameSearchText (mandatory), MaximumResultCount, OutputFormat

      ByFullFilter  (5 parameters)
          CreatedAfterDateTime (mandatory), ItemNameSearchText (optional here),
          CreatedBeforeDateTime, MaximumResultCount, OutputFormat

    Edge cases shown by this layout:
      * OutputFormat has no set name, so it belongs to ALL sets and never
        influences which set is chosen.
      * ItemNameSearchText and MaximumResultCount belong to TWO sets.
        ItemNameSearchText is mandatory in one set and optional in the other.
      * Mixing parameters from sets that exclude each other makes PowerShell stop
        before the script starts: "Parameter set cannot be resolved using the
        specified named parameters."
      * If only shared parameters are given (e.g. just -OutputFormat), PowerShell
        falls back to the DEFAULT set (ByNameSearch) and asks for its mandatory
        parameter. In a non-interactive run (such as ScriptRunner) this is an error.
      * Defaults for parameters are applied in the script body, because a
        parameter outside the active set must not be assumed to hold a value.

    Run this to see the three syntaxes PowerShell builds from the param block:
      Get-Command .\Edge-Case-ParameterSets.ps1 -Syntax

    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER ItemIdentifier
    Set ByIdentifier. A whole number of 1 or more.

.PARAMETER ItemNameSearchText
    Sets ByNameSearch (mandatory) and ByFullFilter (optional). 1-100 characters
    after trimming. Empty or whitespace-only text is rejected. A lone "*" is
    allowed but produces a warning because it matches everything.

.PARAMETER MaximumResultCount
    Sets ByNameSearch and ByFullFilter. Whole number from 1 to 1000. If not given,
    50 is used.

.PARAMETER CreatedAfterDateTime
    Set ByFullFilter (mandatory). Start of the date range. A future date gives a
    warning because nothing can match yet.

.PARAMETER CreatedBeforeDateTime
    Set ByFullFilter (optional). End of the date range. Must be later than
    CreatedAfterDateTime.

.PARAMETER OutputFormat
    All sets. "Object" (default), "List" or "Json".

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -ItemIdentifier 42
    Uses ByIdentifier (2 parameters in the set).

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -ItemNameSearchText "invoice" -MaximumResultCount 10
    Uses ByNameSearch. Both parameters also exist in ByFullFilter, but that set
    is ruled out because its mandatory CreatedAfterDateTime is missing.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -CreatedAfterDateTime "2026-01-01" -CreatedBeforeDateTime "2026-06-30" -ItemNameSearchText "invoice" -MaximumResultCount 25 -OutputFormat Json
    Uses ByFullFilter with all 5 parameters.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -ItemIdentifier 42 -ItemNameSearchText "invoice"
    PowerShell error: Parameter set cannot be resolved using the specified named parameters.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -ItemIdentifier 42 -MaximumResultCount 10
    Same error: MaximumResultCount does not exist in ByIdentifier.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -OutputFormat Json
    Only a shared parameter: falls back to ByNameSearch and asks for ItemNameSearchText.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -ItemNameSearchText "   "
    Throws: ItemNameSearchText must not be empty or only whitespace.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -CreatedAfterDateTime "2026-06-30" -CreatedBeforeDateTime "2026-01-01"
    Throws: CreatedBeforeDateTime must be later than CreatedAfterDateTime.
#>

[CmdletBinding(DefaultParameterSetName = 'ByNameSearch')]
param (
    # ---- Only in ByIdentifier ------------------------------------------------
    [Parameter(ParameterSetName = 'ByIdentifier', Mandatory = $true)]
    [ValidateRange(1, 2147483647)]
    [int]$ItemIdentifier,

    # ---- In ByNameSearch (mandatory) and ByFullFilter (optional) -------------
    # AllowEmptyString lets an empty value reach the script so we can show our own message.
    [Parameter(ParameterSetName = 'ByNameSearch', Mandatory = $true)]
    [Parameter(ParameterSetName = 'ByFullFilter')]
    [AllowEmptyString()]
    [string]$ItemNameSearchText,

    # ---- In ByNameSearch and ByFullFilter ------------------------------------
    [Parameter(ParameterSetName = 'ByNameSearch')]
    [Parameter(ParameterSetName = 'ByFullFilter')]
    [ValidateRange(1, 1000)]
    [int]$MaximumResultCount,

    # ---- Only in ByFullFilter ------------------------------------------------
    [Parameter(ParameterSetName = 'ByFullFilter', Mandatory = $true)]
    [datetime]$CreatedAfterDateTime,

    [Parameter(ParameterSetName = 'ByFullFilter')]
    [datetime]$CreatedBeforeDateTime,

    # ---- In ALL sets (no set name) -------------------------------------------
    [Parameter()]
    [ValidateSet('Object', 'List', 'Json')]
    [string]$OutputFormat = 'Object'
)

$setName = $PSCmdlet.ParameterSetName

# ---------------------------------------------------------------- defaults
$resultLimit = 50
if ($PSBoundParameters.ContainsKey('MaximumResultCount')) {
    $resultLimit = $MaximumResultCount
}

# ---------------------------------------------------------------- name text
$nameText = $null
if ($PSBoundParameters.ContainsKey('ItemNameSearchText')) {
    $nameText = $ItemNameSearchText.Trim()

    if ($nameText.Length -eq 0) {
        throw "ItemNameSearchText must not be empty or only whitespace."
    }
    if ($nameText.Length -gt 100) {
        throw "ItemNameSearchText is too long ($($nameText.Length) characters). Maximum is 100."
    }
    if ($nameText -match '^\*+$') {
        Write-Warning "ItemNameSearchText '$nameText' matches everything."
    }
}

# ---------------------------------------------------------------- date range
$afterDate  = $null
$beforeDate = $null

if ($setName -eq 'ByFullFilter') {
    if ($CreatedAfterDateTime -eq [datetime]::MinValue) {
        throw "CreatedAfterDateTime must be a real date, not the 'empty' date 0001-01-01."
    }
    $afterDate = $CreatedAfterDateTime

    if ($afterDate -gt (Get-Date)) {
        Write-Warning "CreatedAfterDateTime is in the future; no records can match yet."
    }

    if ($PSBoundParameters.ContainsKey('CreatedBeforeDateTime')) {
        $beforeDate = $CreatedBeforeDateTime
        if ($beforeDate -le $afterDate) {
            throw "CreatedBeforeDateTime must be later than CreatedAfterDateTime."
        }
    }
}

# ---------------------------------------------------------------- description
switch ($setName) {
    'ByIdentifier' {
        $description = "Look up the single item with identifier $ItemIdentifier."
    }
    'ByNameSearch' {
        $description = "Search items by name '$nameText', returning at most $resultLimit."
    }
    'ByFullFilter' {
        $description = "Search items created after $($afterDate.ToString('s'))"
        if ($null -ne $beforeDate) { $description += " and before $($beforeDate.ToString('s'))" }
        if ($null -ne $nameText)   { $description += " with name '$nameText'" }
        $description += ", returning at most $resultLimit."
    }
}

# ---------------------------------------------------------------- result
$result = [PSCustomObject]@{
    ParameterSet     = $setName
    PassedParameters = (($PSBoundParameters.Keys | Sort-Object) -join ', ')
    Description      = $description
    ItemIdentifier   = if ($setName -eq 'ByIdentifier') { $ItemIdentifier } else { '(n/a)' }
    ItemNameSearch   = if ($null -ne $nameText) { $nameText } else { '(n/a)' }
    ResultLimit      = if ($setName -eq 'ByIdentifier') { '(n/a)' } else { $resultLimit }
    CreatedAfter     = if ($null -ne $afterDate) { $afterDate.ToString('s') } else { '(n/a)' }
    CreatedBefore    = if ($null -ne $beforeDate) { $beforeDate.ToString('s') } else { '(n/a)' }
    OutputFormat     = $OutputFormat
}

switch ($OutputFormat) {
    'Object' { $result }
    'List'   { $result | Format-List | Out-String }
    'Json'   { $result | ConvertTo-Json }
}
