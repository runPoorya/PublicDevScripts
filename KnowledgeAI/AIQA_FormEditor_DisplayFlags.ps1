<#
	.SYNOPSIS
	AI-QA: parameters with ASRDisplay flags that the script fixes (ReadOnly, Invisible), next to a plain parameter.
	.PARAMETER ReadOnlyText
	Protected by the script (ASRDisplay(ReadOnly)) with a default
	.PARAMETER ReadOnlyNumber
	Protected by the script (ASRDisplay(ReadOnly)), integer
	.PARAMETER ReadOnlyHidden
	Protected and hidden by the script (ASRDisplay(ReadOnly,Invisible))
	.PARAMETER PlainText
	No flags: control parameter, Editable by default
	.NOTES
	AI-QA test script: exclusive to the AI exploratory tests of the Form editor.
	Created 2026-11-03 for bug 16784 (View-only badge appears only after clicking the edit pen).
	Syntax as in setup/InstallSvc/ScriptMgr/examples/Common/InputValidation.ps1.
	Do not change it without updating the knowledge graph.
#>
[CmdletBinding()]
param (
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[string]$ReadOnlyText = 'Read-only information',
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly)')]
	[int]$ReadOnlyNumber = 42,
	[Parameter(HelpMessage = 'ASRDisplay(ReadOnly,Invisible)')]
	[string]$ReadOnlyHidden = 'hidden value',
	[string]$PlainText = 'editable'
)
"ReadOnlyText   : $ReadOnlyText"
"ReadOnlyNumber : $ReadOnlyNumber"
"ReadOnlyHidden : $ReadOnlyHidden"
"PlainText      : $PlainText"
