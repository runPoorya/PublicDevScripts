<#
	.SYNOPSIS
	[sr-en]Add two values of any type. The possible values were specified by the ValidateSet attribute in the script.
	[sr-de]Zwei Werte eines beliebigen Typs summieren. Die möglichen Werte wurden durch das Attribut ValidateSet im Skript festgelegt.
	.PARAMETER ValueA
	[sr-en]Select the first value
	[sr-de]Ersten Wert auswählen
	.PARAMETER ValueB
	[sr-en]Select the second value
	[sr-de]Zweiten Wert auswählen
	.NOTES
	AI-QA test script: exclusive to the AI exploratory tests of the Form editor.
	Copy of setup/InstallSvc/ScriptMgr/examples/Common/Sum2Values.ps1 (2026-10-29).
	Do not change it without updating the knowledge graph (Q-15) and form-editor.feature.
#>
[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)]
	[ValidateSet(17, 'Script', 'Two parts o')]
	$ValueA,
	[Parameter(Mandatory = $true)]
	[ValidateSet(5, 'Runner', 'f a sentence')]
	$ValueB
)
# Add the two values, and print the result as a nice string to the report.
$result = $ValueA + $ValueB
$SRXEnv.ResultMessage = "$($ValueA) + $($ValueB) = $($result)"
$SRXEnv.ResultMessage
