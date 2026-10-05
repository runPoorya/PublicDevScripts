
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
