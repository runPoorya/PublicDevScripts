<#
.SYNOPSIS
    Prints a greeting message to the console.

.DESCRIPTION
    A minimal PowerShell script that writes a message to the output.
    By default it prints "hi", but you can supply your own text.

.PARAMETER Message
    The text to print. Defaults to "hi".

.EXAMPLE
    .\hi.ps1
    Prints "hi".

.EXAMPLE
    .\hi.ps1 -Message "hello world"
    Prints "hello world".
#>

param(
    [string]$Message = "hi"
)

Write-Output $Message
