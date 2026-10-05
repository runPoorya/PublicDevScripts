<#
.SYNOPSIS
    Grid edge case: a script with very few parameters (2).

.DESCRIPTION
    Tests how a parameter grid/form looks when there is almost nothing to fill in:
    one text field and one switch, both optional. The script can be run without
    entering anything, which also checks that the grid does not insist on input
    when no parameter is required.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Greeting
    Text to print. Defaults to "hi".

.PARAMETER Shout
    Switch. Prints the greeting in upper case.

.EXAMPLE
    .\Grid-Edge-FewParameters.ps1
    Prints "hi".

.EXAMPLE
    .\Grid-Edge-FewParameters.ps1 -Greeting "hello" -Shout
    Prints "HELLO".
#>

[CmdletBinding()]
param (
    [string]$Greeting = "hi",

    [switch]$Shout
)

if ($Shout) {
    Write-Output $Greeting.ToUpperInvariant()
}
else {
    Write-Output $Greeting
}
