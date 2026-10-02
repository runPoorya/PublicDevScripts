<#
.SYNOPSIS
    Template script showing the most common kinds of PowerShell parameters.

.DESCRIPTION
    Every parameter type and validation attribute below is a copy-paste example.
    The script prints what it received, so you can try each one.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Text
    A plain string with a default value.

.PARAMETER Number
    A whole number. Anything that is not a number is rejected by PowerShell.

.PARAMETER Decimal
    A number with decimals.

.PARAMETER Enabled
    A switch: present = $true, absent = $false.

.PARAMETER Flag
    A boolean that needs an explicit value, e.g. -Flag $false.

.PARAMETER Level
    Only "Low", "Medium" or "High" are accepted (also gives a dropdown/tab completion).

.PARAMETER Percent
    A whole number between 1 and 100.

.PARAMETER ShortText
    A string between 1 and 20 characters.

.PARAMETER DriveLetter
    A drive letter with a colon, e.g. "C:" (checked with a regular expression).

.PARAMETER Folder
    A path to an existing folder (checked with a script).

.PARAMETER Date
    A date/time, e.g. "2026-10-02".

.PARAMETER List
    A list of strings, e.g. -List a,b,c

.PARAMETER Numbers
    A list of whole numbers, e.g. -Numbers 1,2,3

.PARAMETER Options
    A hashtable, e.g. -Options @{ Key = 'Value' }

.PARAMETER Secret
    A secure string (never printed by this script).

.PARAMETER Credential
    A user name and password pair (the password is never printed).

.PARAMETER Name
    Only used in the "ByName" parameter set. Alias: -N

.PARAMETER Id
    Mandatory in the "ById" parameter set. Cannot be combined with -Name.

.PARAMETER InputObject
    Accepts values from the pipeline, e.g. "a","b" | .\All-Parameters.ps1

.EXAMPLE
    .\All-Parameters.ps1
    Runs with all default values.

.EXAMPLE
    .\All-Parameters.ps1 -Text "hello" -Number 5 -Enabled -Level High -List a,b,c

.EXAMPLE
    .\All-Parameters.ps1 -Id 42
    Uses the "ById" parameter set.

.EXAMPLE
    "x","y" | .\All-Parameters.ps1
    Passes values through the pipeline.
#>

[CmdletBinding(DefaultParameterSetName = 'ByName')]
param (
    # --- Basic types ---
    [string]$Text = "hi",
    [int]$Number = 1,
    [double]$Decimal = 1.5,
    [switch]$Enabled,
    [bool]$Flag = $true,
    [datetime]$Date = (Get-Date),

    # --- Validation ---
    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Level = 'Medium',

    [ValidateRange(1, 100)]
    [int]$Percent = 50,

    [ValidateLength(1, 20)]
    [string]$ShortText = "short",

    [ValidatePattern('^[A-Za-z]:$')]
    [string]$DriveLetter = "C:",

    [ValidateScript({ Test-Path -Path $_ -PathType Container })]
    [string]$Folder = $env:TEMP,

    [ValidateNotNullOrEmpty()]
    [string]$NotEmpty = "value",

    # --- Collections ---
    [string[]]$List = @('a', 'b'),
    [int[]]$Numbers = @(1, 2, 3),
    [hashtable]$Options = @{ Key = 'Value' },

    # --- Sensitive values ---
    [SecureString]$Secret,
    [PSCredential]$Credential,

    # --- Parameter sets (use one or the other) ---
    [Parameter(ParameterSetName = 'ByName')]
    [Alias('N')]
    [string]$Name = 'default',

    [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
    [int]$Id,

    # --- Pipeline input ---
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$InputObject
)

begin {
    $piped = @()
}

process {
    if ($InputObject) { $piped += $InputObject }
}

end {
    [PSCustomObject]@{
        ParameterSet = $PSCmdlet.ParameterSetName
        Text         = $Text
        Number       = $Number
        Decimal      = $Decimal
        Enabled      = $Enabled.IsPresent
        Flag         = $Flag
        Date         = $Date
        Level        = $Level
        Percent      = $Percent
        ShortText    = $ShortText
        DriveLetter  = $DriveLetter
        Folder       = $Folder
        NotEmpty     = $NotEmpty
        List         = $List -join ', '
        Numbers      = $Numbers -join ', '
        Options      = ($Options.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ', '
        Secret       = if ($Secret) { '(provided)' } else { '(not provided)' }
        Credential   = if ($Credential) { $Credential.UserName } else { '(not provided)' }
        Name         = if ($PSCmdlet.ParameterSetName -eq 'ByName') { $Name } else { '(n/a)' }
        Id           = if ($PSCmdlet.ParameterSetName -eq 'ById') { $Id } else { '(n/a)' }
        Piped        = $piped -join ', '
        PassedByUser = ($PSBoundParameters.Keys -join ', ')
    }
}
