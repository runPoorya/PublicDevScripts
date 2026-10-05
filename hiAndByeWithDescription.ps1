<#
.SYNOPSIS
    Prints a greeting message a given number of times, followed by a goodbye message.

.DESCRIPTION
    A minimal PowerShell script that writes a message to the output.
    By default it prints "hi" once, then "good bye". You can supply your own
    greeting text, how many times it should be printed, and the goodbye text.
    The count must be a number, otherwise the script stops with an error.

.PARAMETER Message
    The greeting text to print. Defaults to "hi".

.PARAMETER Count
    How many times to print the greeting. Must be a number. Defaults to 1.

.PARAMETER GoodBye
    The goodbye text printed after the greeting. Defaults to "good bye".

.EXAMPLE
    .\hi.ps1
    Prints "hi" once, then "good bye".

.EXAMPLE
    .\hi.ps1 -Message "hello world" -Count 3 -GoodBye "see you"
    Prints "hello world" three times, then "see you".

.EXAMPLE
    .\hi.ps1 -Count abc
    Throws: Not a number. Expected a number.
#>

param(
    [string]$Message = "hi",

    # Taken as a string so we can show our own error instead of PowerShell's default one.
    [string]$Count = "1",

    [string]$GoodBye = "good bye"
)

$number = 0
if (-not [int]::TryParse($Count, [ref]$number)) {
    throw "Not a number. Expected a number."
}

for ($i = 0; $i -lt $number; $i++) {
    Write-Output $Message
}

Write-Output $GoodBye
