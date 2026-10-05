<#
.SYNOPSIS
    Grid edge case: a parameter set is named, but there are no parameters.

.DESCRIPTION
    PowerShell builds parameter sets from the parameters that name them, so a set
    cannot really exist without at least one parameter. This script is the closest
    possible case: it declares a default parameter set name but has an empty
    param block. A grid/form should show an empty parameter area (or a message
    like "no parameters") and the script should still run.

    The output shows which parameter set PowerShell reports and how many
    parameters it sees, so you can compare that with what your grid displays.
    Works in Windows PowerShell 5.1 and PowerShell 7.

.EXAMPLE
    .\Grid-Edge-ParameterSetOnly.ps1
    Prints the reported parameter set and a parameter count of 0.
#>

[CmdletBinding(DefaultParameterSetName = 'OnlyParameterSetWithoutParameters')]
param ()

$commonParameterNames = @(
    'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
    'ErrorVariable', 'WarningVariable', 'InformationVariable',
    'OutVariable', 'OutBuffer', 'PipelineVariable'
)

$declaredParameterNames = @($MyInvocation.MyCommand.Parameters.Keys |
    Where-Object { $commonParameterNames -notcontains $_ })

[PSCustomObject]@{
    DeclaredDefaultParameterSet = 'OnlyParameterSetWithoutParameters'
    ReportedParameterSet        = $PSCmdlet.ParameterSetName
    DeclaredParameterCount      = $declaredParameterNames.Count
}
