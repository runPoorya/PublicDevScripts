param(
    [string]$InputJson = @'
[
  {
    "text": "hiToWF",
    "sum": 9
  }
]
'@
)

$items = $InputJson | ConvertFrom-Json

foreach ($item in @($items)) {
    Write-Output "Text: $($item.text)"
    Write-Output "Sum:  $($item.sum)"
}
