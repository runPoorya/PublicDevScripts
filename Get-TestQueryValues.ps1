<#
.SYNOPSIS
    Query script that supplies a fixed list of values for a dropdown parameter.

.DESCRIPTION
    Use this as the query behind the two query parameters of
    Test-FormUrlAndQueryFeatures.ps1 (QueryAllowCustomValues and
    QueryNoCustomValues). It returns five values, one of them with spaces, so
    you can compare picking a listed value with typing a custom one.

    Values go into ResultList (what the parameter receives) and display texts
    into ResultList2 (what the dropdown shows). Outside ScriptRunner it just
    prints the list.

    If you change the values here, change $knownQueryValues in
    Test-FormUrlAndQueryFeatures.ps1 as well.
    Works in Windows PowerShell 5.1 and PowerShell 7.
#>

[CmdletBinding()]
param ()

$items = @(
    @{ Value = 'Alpha';             Text = 'Alpha (first)' },
    @{ Value = 'Beta';              Text = 'Beta (second)' },
    @{ Value = 'Gamma';             Text = 'Gamma (third)' },
    @{ Value = 'Delta';             Text = 'Delta (fourth)' },
    @{ Value = 'Value with spaces'; Text = 'Value with spaces (edge case)' }
)

foreach ($item in $items) {
    Write-Host "$($item.Value): $($item.Text)"

    if ($SRXEnv) {
        $null = $SRXEnv.ResultList.Add($item.Value)
        $null = $SRXEnv.ResultList2.Add($item.Text)
    }
}
