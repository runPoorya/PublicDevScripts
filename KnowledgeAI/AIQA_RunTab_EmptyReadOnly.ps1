<#
	.SYNOPSIS
	AI-QA: one empty, read-only (ASRDisplay(ReadOnly)) parameter per Run tab field type, plus editable controls.
	.PARAMETER RoText
	Read-only string, no default
	.PARAMETER RoNumber
	Read-only integer, no default
	.PARAMETER RoMultiline
	Read-only multiline string, no default
	.PARAMETER RoPassword
	Read-only password (ASRDisplay(Password)), no default
	.PARAMETER RoSecure
	Read-only securestring, no default
	.PARAMETER RoChoice
	Read-only ValidateSet, no default
	.PARAMETER RoChoices
	Read-only ValidateSet string array, no default
	.PARAMETER RoRange
	Read-only ValidateRange 1..100, no default
	.PARAMETER RoLength
	Read-only ValidateLength 1..20, no default
	.PARAMETER RoPattern
	Read-only ValidatePattern, no default
	.PARAMETER RoDateTime
	Read-only datetime, no default
	.PARAMETER RoDate
	Read-only date (ASRDisplay(Date)), no default
	.PARAMETER RoList
	Read-only string array, no default
	.PARAMETER RoFile
	Read-only file upload (ASRDisplay(FromFile)), no default
	.PARAMETER EdText
	Editable control: string, no default
	.PARAMETER EdChoice
	Editable control: ValidateSet, no default
	.NOTES
	AI-QA test script: exclusive to the AI exploratory tests of the Run tab.
	Created 2026-11-03 for bug 16790 ("Enter a value" shown on an empty read-only field).
	All parameters are optional and have no default, so every field is empty on the Run tab.
	Do not change it without updating the knowledge graph.
#>
[CmdletBinding()]
param (
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[string]$RoText,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[int]$RoNumber,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly,Multiline)')]
	[string]$RoMultiline,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly,Password)')]
	[string]$RoPassword,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[securestring]$RoSecure,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[ValidateSet('Low', 'Medium', 'High')]
	[string]$RoChoice,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[ValidateSet('Red', 'Green', 'Blue')]
	[string[]]$RoChoices,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[ValidateRange(1, 100)]
	[int]$RoRange,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[ValidateLength(1, 20)]
	[string]$RoLength,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[ValidatePattern('^[A-Za-z]:$')]
	[string]$RoPattern,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[datetime]$RoDateTime,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly,Date)')]
	[string]$RoDate,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[string[]]$RoList,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly,FromFile)')]
	[string]$RoFile,
	[string]$EdText,
	[ValidateSet('Low', 'Medium', 'High')]
	[string]$EdChoice
)
$PSBoundParameters.GetEnumerator() | ForEach-Object { "{0} = {1}" -f $_.Key, $_.Value }
