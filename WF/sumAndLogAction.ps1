# tolarates JSON string or already parsed object
param(
    $InputJson
)

try {
    if ($InputJson -is [string]) {
        $items = $InputJson | ConvertFrom-Json
    }
    else {
        $items = $InputJson
    }
}
catch {
    Write-Output "Invalid input, expected JSON: $InputJson"
    exit 1
}

foreach ($item in @($items)) {
    Write-Output "Text: $($item.text)"
    Write-Output "Sum:  $($item.sum)"
}
