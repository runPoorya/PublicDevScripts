<#
.SYNOPSIS
    Demonstrates five parameter types with long names and defensive edge-case handling.

.DESCRIPTION
    One parameter each of type string, integer, switch, string array and date/time.
    Besides the normal PowerShell type checks, the script body handles the awkward
    inputs that usually cause trouble: empty or whitespace-only text, invisible
    control characters, zero and boundary numbers, explicit -Switch:$false,
    empty/null/duplicate/comma-joined list entries, and dates that are in the past,
    too far away or have no time zone.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER CustomerDisplayName
    Text, 1-100 characters after trimming. Leading/trailing spaces are removed
    (with a warning). Empty, whitespace-only, tabs and line breaks are rejected.
    Accented letters, emoji and other Unicode are allowed. Default: "Default Customer".

.PARAMETER MaximumRetryAttemptCount
    Whole number from 0 to 10. 0 is valid and means "do not retry".
    Negative numbers, numbers above 10 and values that are not whole numbers
    are rejected by PowerShell before the script starts. Default: 3.

.PARAMETER IncludeArchivedRecordsInOutput
    Switch. Absent = $false. -IncludeArchivedRecordsInOutput:$false also means $false.
    Example of a cross-parameter rule: it needs at least one target server.

.PARAMETER TargetServerHostNameList
    List of host names, at most 20 after cleaning. Blank and $null entries are
    skipped, duplicates (ignoring upper/lower case) are removed with a warning,
    and a single value like "srv1,srv2;srv3" is split into separate entries
    (some tools send lists that way). Each name must be a valid host name.

.PARAMETER ScheduledExecutionStartDateTime
    Optional date/time. Must be in the future and at most one year away.
    A date without a time means midnight. A value without a time zone is treated
    as local time. Prefer ISO 8601 such as "2026-12-24T18:30:00" or
    "2026-12-24T18:30:00Z" so day/month order is never ambiguous.

.EXAMPLE
    .\Edge-Case-Parameters.ps1
    Runs with all defaults.

.EXAMPLE
    .\Edge-Case-Parameters.ps1 -CustomerDisplayName "  Zoë Müller  " -MaximumRetryAttemptCount 0
    Trims the name (warns) and allows zero retries.

.EXAMPLE
    .\Edge-Case-Parameters.ps1 -TargetServerHostNameList "web01,web02;WEB01","" -IncludeArchivedRecordsInOutput
    Splits the first entry, removes the duplicate, skips the blank entry.

.EXAMPLE
    .\Edge-Case-Parameters.ps1 -CustomerDisplayName "   "
    Throws: CustomerDisplayName must not be empty or only whitespace.

.EXAMPLE
    .\Edge-Case-Parameters.ps1 -IncludeArchivedRecordsInOutput
    Throws: needs at least one target server.

.EXAMPLE
    .\Edge-Case-Parameters.ps1 -ScheduledExecutionStartDateTime "2001-01-01"
    Throws: must be in the future.
#>

[CmdletBinding()]
param (
    [AllowEmptyString()]
    [string]$CustomerDisplayName = "Default Customer",

    [ValidateRange(0, 10)]
    [int]$MaximumRetryAttemptCount = 3,

    [switch]$IncludeArchivedRecordsInOutput,

    [AllowNull()]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]]$TargetServerHostNameList = @(),

    [Nullable[datetime]]$ScheduledExecutionStartDateTime = $null
)

# ---------------------------------------------------------------- string
$customerName = $CustomerDisplayName   # a $null argument arrives here as ""
$trimmedName  = $customerName.Trim()

if ($trimmedName.Length -eq 0) {
    throw "CustomerDisplayName must not be empty or only whitespace."
}
if ($trimmedName -match '\p{Cc}') {
    throw "CustomerDisplayName must not contain control characters such as tabs or line breaks."
}
if ($trimmedName.Length -gt 100) {
    throw "CustomerDisplayName is too long ($($trimmedName.Length) characters). Maximum is 100."
}
if ($trimmedName -ne $customerName) {
    Write-Warning "CustomerDisplayName had leading/trailing whitespace; it was trimmed."
}

# ---------------------------------------------------------------- integer
# Type and range (0-10) are already enforced by the param block.
if ($MaximumRetryAttemptCount -eq 0) {
    $retryMode = "No retries"
}
else {
    $retryMode = "Up to $MaximumRetryAttemptCount retries"
}

# ---------------------------------------------------------------- string array
$hostNamePattern = '^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(\.[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)*$'
$seenHostNames   = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
$cleanHostNames  = New-Object 'System.Collections.Generic.List[string]'

foreach ($rawEntry in $TargetServerHostNameList) {
    if ($null -eq $rawEntry) { continue }

    foreach ($piece in ($rawEntry -split '[,;]')) {
        $hostName = $piece.Trim()
        if ($hostName.Length -eq 0) { continue }

        if ($hostName.Length -gt 253 -or $hostName -notmatch $hostNamePattern) {
            throw "Invalid host name in TargetServerHostNameList: '$hostName'."
        }
        if ($seenHostNames.Add($hostName)) {
            $cleanHostNames.Add($hostName)
        }
        else {
            Write-Warning "Duplicate host name ignored: '$hostName'."
        }
    }
}

if ($cleanHostNames.Count -gt 20) {
    throw "TargetServerHostNameList has $($cleanHostNames.Count) entries. Maximum is 20."
}

# ---------------------------------------------------------------- switch
# Cross-parameter rule (example): archived records only make sense with a target.
if ($IncludeArchivedRecordsInOutput.IsPresent -and $cleanHostNames.Count -eq 0) {
    throw "IncludeArchivedRecordsInOutput needs at least one entry in TargetServerHostNameList."
}

# ---------------------------------------------------------------- date/time
$scheduledUtc = $null

if ($null -ne $ScheduledExecutionStartDateTime) {
    $requested = $ScheduledExecutionStartDateTime.Value

    if ($requested -eq [datetime]::MinValue) {
        throw "ScheduledExecutionStartDateTime must be a real date, not the 'empty' date 0001-01-01."
    }

    # No time zone given -> treat as local time instead of letting .NET guess.
    if ($requested.Kind -eq [System.DateTimeKind]::Unspecified) {
        $requested = [datetime]::SpecifyKind($requested, [System.DateTimeKind]::Local)
    }

    $scheduledUtc = $requested.ToUniversalTime()
    $nowUtc       = (Get-Date).ToUniversalTime()

    if ($scheduledUtc -le $nowUtc) {
        throw "ScheduledExecutionStartDateTime must be in the future. Got: $($requested.ToString('o'))."
    }
    if ($scheduledUtc -gt $nowUtc.AddYears(1)) {
        throw "ScheduledExecutionStartDateTime is more than one year away. Got: $($requested.ToString('o'))."
    }
}

# ---------------------------------------------------------------- result
[PSCustomObject]@{
    CustomerDisplayName            = $trimmedName
    MaximumRetryAttemptCount       = $MaximumRetryAttemptCount
    RetryMode                      = $retryMode
    IncludeArchivedRecordsInOutput = $IncludeArchivedRecordsInOutput.IsPresent
    TargetServerHostNameList       = if ($cleanHostNames.Count -gt 0) { $cleanHostNames -join ', ' } else { '(none)' }
    TargetServerCount              = $cleanHostNames.Count
    ScheduledExecutionStartUtc     = if ($null -ne $scheduledUtc) { $scheduledUtc.ToString('o') } else { '(not scheduled)' }
}
