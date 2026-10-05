<#
.SYNOPSIS
    Demonstrates five parameter sets (2, 3, 5, 5 and 5 parameters) and their edge cases.

.DESCRIPTION
    The five sets, with every parameter that belongs to each one:

      ByIdentifier  (2 parameters)
          ItemIdentifier (mandatory), OutputFormat

      ByNameSearch  (3 parameters, DEFAULT set)
          ItemNameSearchText (mandatory), MaximumResultCount, OutputFormat

      ByFullFilter  (5 parameters)
          CreatedAfterDateTime (mandatory), ItemNameSearchText (optional here),
          CreatedBeforeDateTime, MaximumResultCount, OutputFormat

      ByLocationFilter  (5 parameters)
          LocationCountryCode (mandatory), LocationCityName,
          MinimumDistanceInKilometers, MaximumDistanceInKilometers, OutputFormat

      ByOwnerFilter  (5 parameters)
          OwnerEmailAddress (mandatory), OwnerDepartmentName, OwnerIsActiveOnly,
          MinimumItemCountPerOwner, OutputFormat

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
      * ByLocationFilter and ByOwnerFilter share nothing with the other sets
        except OutputFormat, so any one of their own parameters is enough to
        pick the set (their mandatory parameter is then asked for).
      * A switch selects its set even when passed as false:
        -OwnerIsActiveOnly:$false still resolves to ByOwnerFilter and still
        requires OwnerEmailAddress.

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

.PARAMETER LocationCountryCode
    Set ByLocationFilter (mandatory). Two letters such as "DE"; upper/lower case
    and surrounding spaces are normalised. Longer names like "Germany" are rejected.

.PARAMETER LocationCityName
    Set ByLocationFilter (optional). 1-100 characters after trimming. Empty or
    whitespace-only text is rejected.

.PARAMETER MinimumDistanceInKilometers
    Set ByLocationFilter (optional). Number from 0 to 20000 (decimals allowed).

.PARAMETER MaximumDistanceInKilometers
    Set ByLocationFilter (optional). Number from 0 to 20000. Must not be smaller
    than MinimumDistanceInKilometers; equal values give a warning (zero-width range).

.PARAMETER OwnerEmailAddress
    Set ByOwnerFilter (mandatory). A basic e-mail address check (text@text.text),
    at most 254 characters. Converted to lower case.

.PARAMETER OwnerDepartmentName
    Set ByOwnerFilter (optional). 1-100 characters after trimming.

.PARAMETER OwnerIsActiveOnly
    Set ByOwnerFilter (switch). Passing it as false still selects this set.

.PARAMETER MinimumItemCountPerOwner
    Set ByOwnerFilter (optional). Whole number from 0 to 1000000. 0 is allowed but
    gives a warning because it filters nothing.

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

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -LocationCountryCode " de " -LocationCityName "Berlin" -MinimumDistanceInKilometers 5 -MaximumDistanceInKilometers 50 -OutputFormat List
    Uses ByLocationFilter with all 5 parameters. The country code becomes "DE".

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -OwnerEmailAddress "Anna@Example.com" -OwnerDepartmentName "Finance" -OwnerIsActiveOnly -MinimumItemCountPerOwner 3 -OutputFormat Json
    Uses ByOwnerFilter with all 5 parameters. The e-mail address becomes lower case.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -LocationCountryCode DE -OwnerEmailAddress anna@example.com
    PowerShell error: Parameter set cannot be resolved (the two sets exclude each other).

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -LocationCountryCode "Germany"
    Throws: LocationCountryCode must be a two-letter code.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -LocationCountryCode DE -MinimumDistanceInKilometers 50 -MaximumDistanceInKilometers 5
    Throws: MaximumDistanceInKilometers must not be smaller than MinimumDistanceInKilometers.

.EXAMPLE
    .\Edge-Case-ParameterSets.ps1 -OwnerIsActiveOnly:$false
    Still selects ByOwnerFilter, so it asks for OwnerEmailAddress.
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

    # ---- Only in ByLocationFilter (4 own parameters + OutputFormat = 5) -------
    [Parameter(ParameterSetName = 'ByLocationFilter', Mandatory = $true)]
    [AllowEmptyString()]
    [string]$LocationCountryCode,

    [Parameter(ParameterSetName = 'ByLocationFilter')]
    [AllowEmptyString()]
    [string]$LocationCityName,

    [Parameter(ParameterSetName = 'ByLocationFilter')]
    [ValidateRange(0, 20000)]
    [double]$MinimumDistanceInKilometers,

    [Parameter(ParameterSetName = 'ByLocationFilter')]
    [ValidateRange(0, 20000)]
    [double]$MaximumDistanceInKilometers,

    # ---- Only in ByOwnerFilter (4 own parameters + OutputFormat = 5) ----------
    [Parameter(ParameterSetName = 'ByOwnerFilter', Mandatory = $true)]
    [AllowEmptyString()]
    [string]$OwnerEmailAddress,

    [Parameter(ParameterSetName = 'ByOwnerFilter')]
    [AllowEmptyString()]
    [string]$OwnerDepartmentName,

    [Parameter(ParameterSetName = 'ByOwnerFilter')]
    [switch]$OwnerIsActiveOnly,

    [Parameter(ParameterSetName = 'ByOwnerFilter')]
    [ValidateRange(0, 1000000)]
    [int]$MinimumItemCountPerOwner,

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

# ---------------------------------------------------------------- location filter
$locationFilter = '(n/a)'
$countryCode    = $null
$cityName       = $null
$hasMinimum     = $PSBoundParameters.ContainsKey('MinimumDistanceInKilometers')
$hasMaximum     = $PSBoundParameters.ContainsKey('MaximumDistanceInKilometers')

if ($setName -eq 'ByLocationFilter') {
    $countryCode = $LocationCountryCode.Trim().ToUpperInvariant()
    if ($countryCode -notmatch '^[A-Z]{2}$') {
        throw "LocationCountryCode must be a two-letter code such as ""DE"". Got: ""$LocationCountryCode""."
    }

    if ($PSBoundParameters.ContainsKey('LocationCityName')) {
        $cityName = $LocationCityName.Trim()
        if ($cityName.Length -eq 0) {
            throw "LocationCityName must not be empty or only whitespace."
        }
        if ($cityName.Length -gt 100) {
            throw "LocationCityName is too long ($($cityName.Length) characters). Maximum is 100."
        }
    }

    if ($hasMinimum -and $hasMaximum) {
        if ($MaximumDistanceInKilometers -lt $MinimumDistanceInKilometers) {
            throw "MaximumDistanceInKilometers must not be smaller than MinimumDistanceInKilometers."
        }
        if ($MaximumDistanceInKilometers -eq $MinimumDistanceInKilometers) {
            Write-Warning "Minimum and maximum distance are equal; the range has zero width."
        }
    }

    $locationParts = @("country=$countryCode")
    if ($null -ne $cityName) { $locationParts += "city=$cityName" }
    if ($hasMinimum)         { $locationParts += "min=$MinimumDistanceInKilometers km" }
    if ($hasMaximum)         { $locationParts += "max=$MaximumDistanceInKilometers km" }
    $locationFilter = $locationParts -join '; '
}

# ---------------------------------------------------------------- owner filter
$ownerFilter    = '(n/a)'
$ownerEmail     = $null
$departmentName = $null
$hasMinimumItems = $PSBoundParameters.ContainsKey('MinimumItemCountPerOwner')

if ($setName -eq 'ByOwnerFilter') {
    $ownerEmail = $OwnerEmailAddress.Trim().ToLowerInvariant()
    if ($ownerEmail.Length -eq 0) {
        throw "OwnerEmailAddress must not be empty or only whitespace."
    }
    if ($ownerEmail.Length -gt 254) {
        throw "OwnerEmailAddress is too long ($($ownerEmail.Length) characters). Maximum is 254."
    }
    if ($ownerEmail -notmatch '^[^@\s]+@[^@\s]+\.[^@\s]+$') {
        throw "OwnerEmailAddress is not a valid e-mail address. Got: ""$OwnerEmailAddress""."
    }

    if ($PSBoundParameters.ContainsKey('OwnerDepartmentName')) {
        $departmentName = $OwnerDepartmentName.Trim()
        if ($departmentName.Length -eq 0) {
            throw "OwnerDepartmentName must not be empty or only whitespace."
        }
        if ($departmentName.Length -gt 100) {
            throw "OwnerDepartmentName is too long ($($departmentName.Length) characters). Maximum is 100."
        }
    }

    if ($hasMinimumItems -and $MinimumItemCountPerOwner -eq 0) {
        Write-Warning "MinimumItemCountPerOwner is 0, which does not filter anything."
    }

    $ownerParts = @("owner=$ownerEmail")
    if ($null -ne $departmentName) { $ownerParts += "department=$departmentName" }
    $ownerParts += "activeOnly=$($OwnerIsActiveOnly.IsPresent)"
    if ($hasMinimumItems)          { $ownerParts += "minItems=$MinimumItemCountPerOwner" }
    $ownerFilter = $ownerParts -join '; '
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
    'ByLocationFilter' {
        $description = "Find items located in country $countryCode"
        if ($null -ne $cityName) { $description += ", city '$cityName'" }
        if ($hasMinimum -and $hasMaximum) {
            $description += ", between $MinimumDistanceInKilometers and $MaximumDistanceInKilometers km away"
        }
        elseif ($hasMinimum) {
            $description += ", at least $MinimumDistanceInKilometers km away"
        }
        elseif ($hasMaximum) {
            $description += ", at most $MaximumDistanceInKilometers km away"
        }
        $description += "."
    }
    'ByOwnerFilter' {
        $description = "Find items owned by $ownerEmail"
        if ($null -ne $departmentName) { $description += " in department '$departmentName'" }
        if ($OwnerIsActiveOnly.IsPresent) { $description += ", active owners only" }
        if ($hasMinimumItems) { $description += ", with at least $MinimumItemCountPerOwner items each" }
        $description += "."
    }
}

# ---------------------------------------------------------------- result
$result = [PSCustomObject]@{
    ParameterSet     = $setName
    PassedParameters = (($PSBoundParameters.Keys | Sort-Object) -join ', ')
    Description      = $description
    ItemIdentifier   = if ($setName -eq 'ByIdentifier') { $ItemIdentifier } else { '(n/a)' }
    ItemNameSearch   = if ($null -ne $nameText) { $nameText } else { '(n/a)' }
    ResultLimit      = if ($setName -in 'ByNameSearch', 'ByFullFilter') { $resultLimit } else { '(n/a)' }
    CreatedAfter     = if ($null -ne $afterDate) { $afterDate.ToString('s') } else { '(n/a)' }
    CreatedBefore    = if ($null -ne $beforeDate) { $beforeDate.ToString('s') } else { '(n/a)' }
    LocationFilter   = $locationFilter
    OwnerFilter      = $ownerFilter
    OutputFormat     = $OutputFormat
}

switch ($OutputFormat) {
    'Object' { $result }
    'List'   { $result | Format-List | Out-String }
    'Json'   { $result | ConvertTo-Json }
}
