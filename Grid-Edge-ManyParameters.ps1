<#
.SYNOPSIS
    Grid edge case: a script with very many parameters (50).

.DESCRIPTION
    Tests how a parameter grid/form copes with a long list: scrolling, layout,
    and finding required fields. The parameters rotate through seven types
    (text, whole number, decimal, switch, choice, date/time, list) so the grid
    has to render every input kind many times.

    Things worth checking in the grid:
      * Parameter26Choice is required and sits in the middle of the list.
      * Parameter50String is required and is the very last parameter.
      * Everything else has a default value, so only those two need input.
      * Order of the fields should match the order in the param block.

    The script prints one row per declared parameter (name, whether it was
    passed, value). Add -Verbose to also see how many parameters were declared.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Parameter01String
    Text, parameter 1 of 50.

.PARAMETER Parameter02Integer
    Whole number, parameter 2 of 50.

.PARAMETER Parameter03Decimal
    Number with decimals, parameter 3 of 50.

.PARAMETER Parameter04Switch
    Switch, parameter 4 of 50.

.PARAMETER Parameter05Choice
    Choice of Low, Medium or High, parameter 5 of 50.

.PARAMETER Parameter06DateTime
    Date/time, parameter 6 of 50.

.PARAMETER Parameter07List
    List of text values, parameter 7 of 50.

.PARAMETER Parameter08String
    Text, parameter 8 of 50.

.PARAMETER Parameter09Integer
    Whole number, parameter 9 of 50.

.PARAMETER Parameter10Decimal
    Number with decimals, parameter 10 of 50.

.PARAMETER Parameter11Switch
    Switch, parameter 11 of 50.

.PARAMETER Parameter12Choice
    Choice of Low, Medium or High, parameter 12 of 50.

.PARAMETER Parameter13DateTime
    Date/time, parameter 13 of 50.

.PARAMETER Parameter14List
    List of text values, parameter 14 of 50.

.PARAMETER Parameter15String
    Text, parameter 15 of 50.

.PARAMETER Parameter16Integer
    Whole number, parameter 16 of 50.

.PARAMETER Parameter17Decimal
    Number with decimals, parameter 17 of 50.

.PARAMETER Parameter18Switch
    Switch, parameter 18 of 50.

.PARAMETER Parameter19Choice
    Choice of Low, Medium or High, parameter 19 of 50.

.PARAMETER Parameter20DateTime
    Date/time, parameter 20 of 50.

.PARAMETER Parameter21List
    List of text values, parameter 21 of 50.

.PARAMETER Parameter22String
    Text, parameter 22 of 50.

.PARAMETER Parameter23Integer
    Whole number, parameter 23 of 50.

.PARAMETER Parameter24Decimal
    Number with decimals, parameter 24 of 50.

.PARAMETER Parameter25Switch
    Switch, parameter 25 of 50.

.PARAMETER Parameter26Choice
    Choice of Low, Medium or High, parameter 26 of 50. Required.

.PARAMETER Parameter27DateTime
    Date/time, parameter 27 of 50.

.PARAMETER Parameter28List
    List of text values, parameter 28 of 50.

.PARAMETER Parameter29String
    Text, parameter 29 of 50.

.PARAMETER Parameter30Integer
    Whole number, parameter 30 of 50.

.PARAMETER Parameter31Decimal
    Number with decimals, parameter 31 of 50.

.PARAMETER Parameter32Switch
    Switch, parameter 32 of 50.

.PARAMETER Parameter33Choice
    Choice of Low, Medium or High, parameter 33 of 50.

.PARAMETER Parameter34DateTime
    Date/time, parameter 34 of 50.

.PARAMETER Parameter35List
    List of text values, parameter 35 of 50.

.PARAMETER Parameter36String
    Text, parameter 36 of 50.

.PARAMETER Parameter37Integer
    Whole number, parameter 37 of 50.

.PARAMETER Parameter38Decimal
    Number with decimals, parameter 38 of 50.

.PARAMETER Parameter39Switch
    Switch, parameter 39 of 50.

.PARAMETER Parameter40Choice
    Choice of Low, Medium or High, parameter 40 of 50.

.PARAMETER Parameter41DateTime
    Date/time, parameter 41 of 50.

.PARAMETER Parameter42List
    List of text values, parameter 42 of 50.

.PARAMETER Parameter43String
    Text, parameter 43 of 50.

.PARAMETER Parameter44Integer
    Whole number, parameter 44 of 50.

.PARAMETER Parameter45Decimal
    Number with decimals, parameter 45 of 50.

.PARAMETER Parameter46Switch
    Switch, parameter 46 of 50.

.PARAMETER Parameter47Choice
    Choice of Low, Medium or High, parameter 47 of 50.

.PARAMETER Parameter48DateTime
    Date/time, parameter 48 of 50.

.PARAMETER Parameter49List
    List of text values, parameter 49 of 50.

.PARAMETER Parameter50String
    Text, parameter 50 of 50. Required.

.EXAMPLE
    .\Grid-Edge-ManyParameters.ps1 -Parameter26Choice High -Parameter50String "last one"
    Supplies only the two required parameters; the other 48 use their defaults.

.EXAMPLE
    .\Grid-Edge-ManyParameters.ps1 -Parameter26Choice Low -Parameter50String "x" -Parameter04Switch -Verbose
    Also turns on one switch and shows the declared parameter count.
#>

[CmdletBinding()]
param (
    [string]$Parameter01String = "Text 01",

    [int]$Parameter02Integer = 2,

    [double]$Parameter03Decimal = 3.5,

    [switch]$Parameter04Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter05Choice = 'Medium',

    [datetime]$Parameter06DateTime = '2026-01-01',

    [string[]]$Parameter07List = @('a', 'b'),

    [string]$Parameter08String = "Text 08",

    [int]$Parameter09Integer = 9,

    [double]$Parameter10Decimal = 10.5,

    [switch]$Parameter11Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter12Choice = 'Medium',

    [datetime]$Parameter13DateTime = '2026-01-01',

    [string[]]$Parameter14List = @('a', 'b'),

    [string]$Parameter15String = "Text 15",

    [int]$Parameter16Integer = 16,

    [double]$Parameter17Decimal = 17.5,

    [switch]$Parameter18Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter19Choice = 'Medium',

    [datetime]$Parameter20DateTime = '2026-01-01',

    [string[]]$Parameter21List = @('a', 'b'),

    [string]$Parameter22String = "Text 22",

    [int]$Parameter23Integer = 23,

    [double]$Parameter24Decimal = 24.5,

    [switch]$Parameter25Switch,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter26Choice,

    [datetime]$Parameter27DateTime = '2026-01-01',

    [string[]]$Parameter28List = @('a', 'b'),

    [string]$Parameter29String = "Text 29",

    [int]$Parameter30Integer = 30,

    [double]$Parameter31Decimal = 31.5,

    [switch]$Parameter32Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter33Choice = 'Medium',

    [datetime]$Parameter34DateTime = '2026-01-01',

    [string[]]$Parameter35List = @('a', 'b'),

    [string]$Parameter36String = "Text 36",

    [int]$Parameter37Integer = 37,

    [double]$Parameter38Decimal = 38.5,

    [switch]$Parameter39Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter40Choice = 'Medium',

    [datetime]$Parameter41DateTime = '2026-01-01',

    [string[]]$Parameter42List = @('a', 'b'),

    [string]$Parameter43String = "Text 43",

    [int]$Parameter44Integer = 44,

    [double]$Parameter45Decimal = 45.5,

    [switch]$Parameter46Switch,

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Parameter47Choice = 'Medium',

    [datetime]$Parameter48DateTime = '2026-01-01',

    [string[]]$Parameter49List = @('a', 'b'),

    [Parameter(Mandatory = $true)]
    [string]$Parameter50String
)

$commonParameterNames = @(
    'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
    'ErrorVariable', 'WarningVariable', 'InformationVariable',
    'OutVariable', 'OutBuffer', 'PipelineVariable'
)

$declaredParameterNames = @($MyInvocation.MyCommand.Parameters.Keys |
    Where-Object { $commonParameterNames -notcontains $_ })

Write-Verbose "Declared parameters: $($declaredParameterNames.Count)"

foreach ($parameterName in $declaredParameterNames) {
    $value = Get-Variable -Name $parameterName -ValueOnly -ErrorAction SilentlyContinue

    if ($value -is [array]) { $display = $value -join ', ' }
    else                    { $display = [string]$value }

    [PSCustomObject]@{
        Name   = $parameterName
        Passed = $PSBoundParameters.ContainsKey($parameterName)
        Value  = $display
    }
}
