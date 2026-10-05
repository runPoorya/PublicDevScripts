<#
.SYNOPSIS
    Test script for form behaviour: splatting query parameter, URL-set values
    (visible and hidden fields) and "allow custom values" on query parameters.

.DESCRIPTION
    The script does nothing useful by itself. It prints one report row per
    parameter showing whether the value was passed and what it was, so you can
    see what the form actually delivered. The UI behaviour itself (for example
    whether a setting can be switched on) has to be checked by eye in the form.

    TEST 1 - Splatting query parameter (negative test)
      Parameter: SplattingQueryParameter (hashtable)
      Expected in the UI: it must NOT be possible to show this parameter as
      read-only in the form. Try to set it and confirm the UI prevents it.
      The script only reports whether a hashtable arrived and its keys.

    TEST 2 - URL parameter sets values of VISIBLE form fields
      Parameters: VisibleTextField, VisibleNumberField, VisibleChoiceField
      Defaults are "default-visible", 111 and "Red". Set other values through
      the URL. Expected: the fields show the URL values and the report says
      "Value supplied by caller".

    TEST 3 - URL parameter sets values of HIDDEN form fields
      Parameters: HiddenTextField, HiddenNumberField
      Hide these two fields in the form. Defaults are "default-hidden" and 222.
      Expected: values from the URL still arrive although the fields are not
      shown. Without a URL value the report says "Default value used".

    TEST 4 - Query parameters with "allow custom values" (sidebar setting)
      Parameters: QueryAllowCustomValues, QueryNoCustomValues
      Both use the query script Get-TestQueryValues.ps1.
      Switch "allow custom values" ON for QueryAllowCustomValues and OFF for
      QueryNoCustomValues. Expected (identical to the behaviour before the
      setting moved to the sidebar):
        * listed value picked      -> "Value from query list" for both
        * custom text typed        -> accepted for the ON parameter and reported
                                      as "CUSTOM value (not in query list)"
        * custom text typed (OFF)  -> the form should not allow it. If a custom
                                      value shows up in the report for
                                      QueryNoCustomValues, the form let it through.
      This script deliberately has no ValidateSet on these parameters, so the
      form is the only thing that can reject a custom value.

    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER SplattingQueryParameter
    Test 1. A hashtable (for the splatting query parameter). Optional.

.PARAMETER VisibleTextField
    Test 2. Text. Default "default-visible".

.PARAMETER VisibleNumberField
    Test 2. Whole number. Default 111.

.PARAMETER VisibleChoiceField
    Test 2. Red, Green or Blue. Default "Red".

.PARAMETER HiddenTextField
    Test 3. Text, meant to be hidden in the form. Default "default-hidden".

.PARAMETER HiddenNumberField
    Test 3. Whole number, meant to be hidden in the form. Default 222.

.PARAMETER QueryAllowCustomValues
    Test 4. Value from the query; custom values switched ON in the sidebar.

.PARAMETER QueryNoCustomValues
    Test 4. Value from the query; custom values switched OFF in the sidebar.

.EXAMPLE
    .\Test-FormUrlAndQueryFeatures.ps1
    Everything at its default; shows the baseline report.

.EXAMPLE
    .\Test-FormUrlAndQueryFeatures.ps1 -VisibleTextField "from url" -HiddenTextField "hidden from url" -QueryAllowCustomValues "my own value"
    Simulates URL-set values and a custom query value.

.EXAMPLE
    .\Test-FormUrlAndQueryFeatures.ps1 -SplattingQueryParameter @{ Key1 = 'a'; Key2 = 'b' }
    Simulates a splatting parameter delivering two keys.
#>

[CmdletBinding()]
param (
    # ---- Test 1: splatting query parameter -----------------------------------
    [hashtable]$SplattingQueryParameter,

    # ---- Test 2: visible fields ----------------------------------------------
    [string]$VisibleTextField = 'default-visible',
    [int]$VisibleNumberField = 111,
    [ValidateSet('Red', 'Green', 'Blue')]
    [string]$VisibleChoiceField = 'Red',

    # ---- Test 3: hidden fields -----------------------------------------------
    [string]$HiddenTextField = 'default-hidden',
    [int]$HiddenNumberField = 222,

    # ---- Test 4: query parameters --------------------------------------------
    [string]$QueryAllowCustomValues = '',
    [string]$QueryNoCustomValues = ''
)

# Must match the values returned by Get-TestQueryValues.ps1.
$knownQueryValues   = @('Alpha', 'Beta', 'Gamma', 'Delta', 'Value with spaces')
$boundParameterNames = @($PSBoundParameters.Keys)

function New-ReportRow {
    param (
        [string]$TestArea,
        [string]$ParameterName,
        $Value,
        [string]$Check
    )

    [PSCustomObject]@{
        TestArea  = $TestArea
        Parameter = $ParameterName
        Passed    = ($boundParameterNames -contains $ParameterName)
        Value     = [string]$Value
        Check     = $Check
    }
}

function Get-SuppliedCheck {
    param ([string]$ParameterName)

    if ($boundParameterNames -contains $ParameterName) { 'Value supplied by caller' }
    else                                                { 'Default value used' }
}

function Get-QueryCheck {
    param ([string]$Value)

    if ([string]::IsNullOrEmpty($Value))      { 'No value selected' }
    elseif ($knownQueryValues -ccontains $Value) { 'Value from query list' }
    else                                      { 'CUSTOM value (not in query list)' }
}

# ---------------------------------------------------------------- test 1
if ($null -ne $SplattingQueryParameter) {
    $splatDisplay = ($SplattingQueryParameter.GetEnumerator() |
        ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '; '
    $splatCheck = "Received a hashtable with $($SplattingQueryParameter.Count) key(s)"
}
else {
    $splatDisplay = ''
    $splatCheck   = 'No hashtable received'
}
New-ReportRow '1 Splatting' 'SplattingQueryParameter' $splatDisplay $splatCheck

# ---------------------------------------------------------------- test 2
New-ReportRow '2 URL visible' 'VisibleTextField'   $VisibleTextField   (Get-SuppliedCheck 'VisibleTextField')
New-ReportRow '2 URL visible' 'VisibleNumberField' $VisibleNumberField (Get-SuppliedCheck 'VisibleNumberField')
New-ReportRow '2 URL visible' 'VisibleChoiceField' $VisibleChoiceField (Get-SuppliedCheck 'VisibleChoiceField')

# ---------------------------------------------------------------- test 3
New-ReportRow '3 URL hidden' 'HiddenTextField'   $HiddenTextField   (Get-SuppliedCheck 'HiddenTextField')
New-ReportRow '3 URL hidden' 'HiddenNumberField' $HiddenNumberField (Get-SuppliedCheck 'HiddenNumberField')

# ---------------------------------------------------------------- test 4
New-ReportRow '4 Query custom ON'  'QueryAllowCustomValues' $QueryAllowCustomValues (Get-QueryCheck $QueryAllowCustomValues)
New-ReportRow '4 Query custom OFF' 'QueryNoCustomValues'    $QueryNoCustomValues    (Get-QueryCheck $QueryNoCustomValues)
