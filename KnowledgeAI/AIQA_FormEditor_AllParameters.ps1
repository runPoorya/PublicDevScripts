[CmdletBinding()]
param (
    [string]$Text = 'hi',
    [int]$Number = 1,
    $Decimal = 1.5,
    [switch]$Enabled,
    [bool]$Flag = $true,
    [datetime]$Date = (Get-Date),
    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Level = 'Medium',
    [ValidateRange(1, 100)]
    [int]$Percent = 50,
    [ValidateLength(1, 20)]
    [string]$ShortText = 'short',
    [ValidatePattern('^[A-Za-z]:$')]
    [string]$DriveLetter = 'C:',
    [string]$Folder = $env:TEMP,
    [ValidateNotNullOrEmpty()]
    [string]$NotEmpty = 'value',
    [string[]]$List = @('a', 'b'),
    [int[]]$Numbers = @(1, 2, 3),
    [hashtable]$Options = @{ Key = 'Value' },
    [securestring]$Secret,
    [pscredential]$Credential,
    [Parameter(ParameterSetName = 'ByName')]
    [string]$Name = 'default',
    [Parameter(Mandatory, ParameterSetName = 'ById')]
    [int]$Id,
    [string[]]$InputObject
)

# AI-QA test script: exclusive to the AI exploratory tests of the Form editor.
# It mirrors "Public Test Scripts/AllParameters.ps1" as captured on dev on 2026-10-29.
# Do not change it without updating the knowledge graph (Q-15) and form-editor.feature.

$lines = foreach ($key in $PSBoundParameters.Keys) {
    $value = $PSBoundParameters[$key]
    if ($value -is [securestring]) { $value = '***' }
    elseif ($value -is [pscredential]) { $value = "credential:$($value.UserName)" }
    elseif ($value -is [hashtable]) { $value = ($value.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ';' }
    elseif ($value -is [array]) { $value = $value -join ',' }
    "$key=$value"
}
$result = "ParameterSet=$($PSCmdlet.ParameterSetName); " + ($lines -join '; ')
$result
if ($SRXEnv) { $SRXEnv.ResultMessage = $result }
