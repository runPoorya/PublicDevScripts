<#
.SYNOPSIS
    Prints a greeting message to the console, a given number of times.

.DESCRIPTION
    A minimal PowerShell script that writes a message to the output.
    By default it prints "hi" once. You can supply your own text and
    how many times it should be printed. The count must be a number,
    otherwise the script stops with an error.

.PARAMETER Message
    The text to print. Defaults to "hi".

.PARAMETER Count
    How many times to print the message. Must be a number. Defaults to 1.

.EXAMPLE
    .\hi.ps1
    Prints "hi" once.

.EXAMPLE
    .\hi.ps1 -Message "hello world" -Count 3
    Prints "hello world" three times.

.EXAMPLE
    .\hi.ps1 -Count abc
    Throws: Not a number. Expected a number.
#>

param(
    [string]$Message = "hi",

    # Taken as a string so we can show our own error instead of PowerShell's default one.
    [string]$Count = "1"
)

$number = 0
if (-not [int]::TryParse($Count, [ref]$number)) {
    throw "Not a number. Expected a number."
}

for ($i = 0; $i -lt $number; $i++) {
    Write-Output $Message
}
