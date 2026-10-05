<#
.SYNOPSIS
    Grid edge case: a script with exactly one parameter, and it is required.

.DESCRIPTION
    Tests how a parameter grid/form looks with a single row, and whether it marks
    that row as required. The script cannot run without a value, so an empty grid
    entry should be rejected.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER SingleValue
    The only parameter. Required. Any text; empty text is rejected by PowerShell.

.EXAMPLE
    .\Grid-Edge-SingleParameter.ps1 -SingleValue "hello"
    Prints: You entered: hello
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$SingleValue
)

Write-Output "You entered: $SingleValue"
