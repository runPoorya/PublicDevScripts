<#
.SYNOPSIS
    Template script with 75 parameters covering every common kind of PowerShell
    parameter, each with a default value.

.DESCRIPTION
    Every parameter has a default value, so the script runs without any input.
    It prints one row per parameter (name, type, whether it was passed, value),
    so you can try each one.

    Groups of parameters:
      * Text
      * Whole numbers
      * Decimal numbers
      * Yes/no values
      * Dates and times
      * Identifiers and special text types
      * Enumerations
      * Files and folders
      * Collections and objects
      * Security
      * Validation
      * Parameter attribute features

    Notes:
      * Nothing is mandatory. A mandatory parameter would ignore its default and
        prompt instead, so Id (ById set) is optional here.
      * Switches normally default to "off". SwitchDefaultOn shows that a switch
        can default to "on", which style checkers discourage.
      * Secret and Credential use obvious dummy values. Never store real secrets
        in a script. Their values are not printed.
      * NullAllowedValue defaults to $null on purpose (it has [AllowNull()]).
      * The two pipeline parameters (InputObject, FullName) only receive values
        when something is piped in; the report also lists all piped items.
      * Not covered: rarely used .NET types such as BigInteger, Complex, generic
        dictionaries or your own classes. They follow the same pattern:
        [TypeName]$Name = <default>.
      * Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Text
    Plain string. First positional parameter. Default: 'hi'

.PARAMETER SingleCharacter
    A single character. Default: 'x'

.PARAMETER EmptyAllowedText
    String that is allowed to be empty (the default is empty). Default: '' (empty)

.PARAMETER Number
    32-bit whole number. Second positional parameter. Default: 1

.PARAMETER SignedByteNumber
    8-bit signed whole number (-128 to 127). Default: -5

.PARAMETER ByteNumber
    8-bit unsigned whole number (0 to 255). Default: 200

.PARAMETER ShortNumber
    16-bit signed whole number. Default: -300

.PARAMETER UnsignedShortNumber
    16-bit unsigned whole number. Default: 60000

.PARAMETER UnsignedIntegerNumber
    32-bit unsigned whole number. Default: 4000000000

.PARAMETER LongNumber
    64-bit signed whole number. Default: 9000000000

.PARAMETER UnsignedLongNumber
    64-bit unsigned whole number. Default: [uint64]::MaxValue

.PARAMETER Decimal
    Double-precision number. Default: 1.5

.PARAMETER SingleFloat
    Single-precision number. Default: 2.5

.PARAMETER DecimalNumber
    Exact decimal number (good for money). Default: 19.99

.PARAMETER Flag
    Boolean that needs an explicit value, e.g. -Flag $false. Default: $true

.PARAMETER Enabled
    Switch, off by default. Present = on. Default: $false

.PARAMETER SwitchDefaultOn
    Switch that is ON by default (works, but style checkers discourage it). Turn off with -SwitchDefaultOn:$false. Default: $true

.PARAMETER Date
    Date and time. The default is calculated when the script starts (now). Default: (Get-Date), i.e. now

.PARAMETER TimeInterval
    A length of time (hours:minutes:seconds). Default: '01:30:00'

.PARAMETER DateTimeWithOffset
    Date and time including the offset from UTC. Default: '2026-01-01T12:00:00+00:00'

.PARAMETER OptionalDateAndTime
    Date that can also be set to $null. Default: '2026-06-30'

.PARAMETER UniqueIdentifier
    A GUID. Default: '00000000-0000-0000-0000-000000000001'

.PARAMETER VersionNumber
    A version number. Default: '1.2.3'

.PARAMETER WebAddress
    A URI/URL. Default: 'https://example.com/path?x=1'

.PARAMETER RegularExpression
    A compiled regular expression. Default: '^\d+$'

.PARAMETER NetworkAddress
    An IP address. Default: '127.0.0.1'

.PARAMETER MailAddressValue
    An e-mail address. Default: 'user@example.com'

.PARAMETER XmlDocumentValue
    An XML document. Default: '<root><item>1</item></root>'

.PARAMETER ScriptBlockValue
    A script block (code passed as a value). Default: { 'default script block' }

.PARAMETER TypeValue
    A .NET type. Default: [System.String]

.PARAMETER DayOfWeekChoice
    A .NET enumeration (Sunday to Saturday). Default: 'Monday'

.PARAMETER ConsoleColorChoice
    A .NET enumeration of console colors. Default: 'Cyan'

.PARAMETER FileAttributeFlags
    A flags enumeration: several values can be combined, e.g. 'ReadOnly, Hidden'. Default: 'ReadOnly, Hidden'

.PARAMETER FileObject
    A file (the file does not need to exist). A path string is converted to a FileInfo. Default: default.txt in the temp folder

.PARAMETER FolderObject
    A folder. A path string is converted to a DirectoryInfo. Default: the temp folder

.PARAMETER List
    Array of strings, e.g. -List a,b,c Default: @('a', 'b')

.PARAMETER Numbers
    Array of whole numbers. Default: @(1, 2, 3)

.PARAMETER DecimalList
    Array of decimal numbers. Default: @(1.5, 2.5)

.PARAMETER DateList
    Array of dates. Default: @('2026-01-01', '2026-02-01')

.PARAMETER BooleanList
    Array of booleans. Default: @($true, $false)

.PARAMETER ByteList
    Array of bytes. Default: @(1, 2, 3)

.PARAMETER CharList
    Array of characters. Default: @('a', 'b')

.PARAMETER ObjectList
    Array that can mix any kinds of values. Default: @('text', 42, $true)

.PARAMETER PlainArray
    Untyped array. Default: @(1, 'two', 3.0)

.PARAMETER Options
    Hashtable, e.g. -Options @{ Key = 'Value' } Default: @{ Key1 = 'Value1'; Key2 = 2 }

.PARAMETER OrderedDictionaryValue
    Dictionary that keeps the order of its keys. Default: ([ordered]@{ First = 1; Second = 2 })

.PARAMETER ArrayListValue
    ArrayList (an array that can grow). Default: @('x', 'y')

.PARAMETER GenericListValue
    Generic list of strings. Default: @('p', 'q')

.PARAMETER PowerShellObjectValue
    A PowerShell object with properties. Default: ([PSCustomObject]@{ Name = 'default'; Value = 1 })

.PARAMETER AnyObject
    Explicit [object]: accepts any value. Default: 42

.PARAMETER UntypedValue
    No type declared at all: accepts any value. Default: 'untyped default'

.PARAMETER NullAllowedValue
    Value that is allowed to be $null (the default is $null). Default: $null

.PARAMETER Secret
    Secure string. The default is a harmless dummy; never put real secrets in a script. The value is never printed. Default: a dummy secure string

.PARAMETER Credential
    User name and password. The default is a harmless dummy. Only the user name is printed. Default: a dummy credential (user 'dummy-user')

.PARAMETER NotEmpty
    String that must not be null or empty. Default: 'value'

.PARAMETER NotNullValue
    String that must not be null. Default: 'not null'

.PARAMETER ShortText
    String of 1 to 20 characters. Default: 'short'

.PARAMETER PatternText
    Two capital letters, a dash and four digits. Default: 'AB-1234'

.PARAMETER DriveLetter
    A drive letter with a colon, e.g. "C:". Default: 'C:'

.PARAMETER Level
    Only Low, Medium or High (not case sensitive). Default: 'Medium'

.PARAMETER CaseSensitiveChoice
    Only "Yes" or "No", exactly in that upper/lower case. Default: 'Yes'

.PARAMETER Percent
    Whole number from 1 to 100. Default: 50

.PARAMETER Ratio
    Number from 0 to 1. Default: 0.5

.PARAMETER Folder
    Path of an existing folder (checked with a script). Default: the temp folder

.PARAMETER CountLimitedList
    Array with 1 to 5 entries. Default: @('a', 'b')

.PARAMETER AllowedEmptyList
    Array that is allowed to be empty (the default is empty). Default: @() (empty)

.PARAMETER AliasedParameter
    Can also be used as -Short or -S. Default: 'alias default'

.PARAMETER HelpMessageParameter
    Has a help message (shown only if the parameter were mandatory and prompted). Default: 'help default'

.PARAMETER HiddenParameter
    Hidden from tab completion and help, but still usable. Default: 'hidden default'

.PARAMETER CompletedParameter
    Tab completion suggests Apple, Banana and Cherry, but any text is accepted. Default: 'Apple'

.PARAMETER InputObject
    Accepts values from the pipeline, e.g. "a","b" | .\All-Parameters.ps1 Default: @() (nothing piped)

.PARAMETER FullName
    Takes the FullName property of piped objects, e.g. Get-ChildItem | .\All-Parameters.ps1 Default: 'default.txt'

.PARAMETER RemainingArguments
    Collects any extra, unnamed arguments. Default: @() (none)

.PARAMETER Name
    Parameter set ByName (the default set). Cannot be combined with -Id. Alias: -N Default: 'default'

.PARAMETER Id
    Parameter set ById. Cannot be combined with -Name. Not mandatory, so it has a default like all others. Default: 1

.EXAMPLE
    .\All-Parameters.ps1
    Runs with all default values.

.EXAMPLE
    .\All-Parameters.ps1 "hello" 5 -Enabled -Level High -List x,y,z
    Text and Number are positional; the rest is named.

.EXAMPLE
    .\All-Parameters.ps1 -Id 42
    Uses the ById parameter set.

.EXAMPLE
    "x","y" | .\All-Parameters.ps1
    Passes values through the pipeline.

.EXAMPLE
    .\All-Parameters.ps1 -Percent 150
    PowerShell rejects the value because it is outside 1-100.
#>

[CmdletBinding(DefaultParameterSetName = 'ByName')]
param (
    # ---- Text --------------------------------------------------------
    [Parameter(Position = 0)]
    [string]$Text = 'hi',

    [char]$SingleCharacter = 'x',

    [AllowEmptyString()]
    [string]$EmptyAllowedText = '',

    # ---- Whole numbers -----------------------------------------------
    [Parameter(Position = 1)]
    [int]$Number = 1,

    [sbyte]$SignedByteNumber = -5,

    [byte]$ByteNumber = 200,

    [int16]$ShortNumber = -300,

    [uint16]$UnsignedShortNumber = 60000,

    [uint32]$UnsignedIntegerNumber = 4000000000,

    [long]$LongNumber = 9000000000,

    [uint64]$UnsignedLongNumber = [uint64]::MaxValue,

    # ---- Decimal numbers ---------------------------------------------
    [double]$Decimal = 1.5,

    [single]$SingleFloat = 2.5,

    [decimal]$DecimalNumber = 19.99,

    # ---- Yes/no values -----------------------------------------------
    [bool]$Flag = $true,

    [switch]$Enabled = $false,

    [switch]$SwitchDefaultOn = $true,

    # ---- Dates and times ---------------------------------------------
    [datetime]$Date = (Get-Date),

    [timespan]$TimeInterval = '01:30:00',

    [System.DateTimeOffset]$DateTimeWithOffset = '2026-01-01T12:00:00+00:00',

    [Nullable[datetime]]$OptionalDateAndTime = '2026-06-30',

    # ---- Identifiers and special text types --------------------------
    [guid]$UniqueIdentifier = '00000000-0000-0000-0000-000000000001',

    [version]$VersionNumber = '1.2.3',

    [uri]$WebAddress = 'https://example.com/path?x=1',

    [regex]$RegularExpression = '^\d+$',

    [System.Net.IPAddress]$NetworkAddress = '127.0.0.1',

    [System.Net.Mail.MailAddress]$MailAddressValue = 'user@example.com',

    [xml]$XmlDocumentValue = '<root><item>1</item></root>',

    [scriptblock]$ScriptBlockValue = { 'default script block' },

    [type]$TypeValue = [System.String],

    # ---- Enumerations ------------------------------------------------
    [System.DayOfWeek]$DayOfWeekChoice = 'Monday',

    [System.ConsoleColor]$ConsoleColorChoice = 'Cyan',

    [System.IO.FileAttributes]$FileAttributeFlags = 'ReadOnly, Hidden',

    # ---- Files and folders -------------------------------------------
    [System.IO.FileInfo]$FileObject = (Join-Path ([System.IO.Path]::GetTempPath()) 'default.txt'),

    [System.IO.DirectoryInfo]$FolderObject = ([System.IO.Path]::GetTempPath()),

    # ---- Collections and objects -------------------------------------
    [string[]]$List = @('a', 'b'),

    [int[]]$Numbers = @(1, 2, 3),

    [double[]]$DecimalList = @(1.5, 2.5),

    [datetime[]]$DateList = @('2026-01-01', '2026-02-01'),

    [bool[]]$BooleanList = @($true, $false),

    [byte[]]$ByteList = @(1, 2, 3),

    [char[]]$CharList = @('a', 'b'),

    [object[]]$ObjectList = @('text', 42, $true),

    [array]$PlainArray = @(1, 'two', 3.0),

    [hashtable]$Options = @{ Key1 = 'Value1'; Key2 = 2 },

    [System.Collections.Specialized.OrderedDictionary]$OrderedDictionaryValue = ([ordered]@{ First = 1; Second = 2 }),

    [System.Collections.ArrayList]$ArrayListValue = @('x', 'y'),

    [System.Collections.Generic.List[string]]$GenericListValue = @('p', 'q'),

    [psobject]$PowerShellObjectValue = ([PSCustomObject]@{ Name = 'default'; Value = 1 }),

    [object]$AnyObject = 42,

    $UntypedValue = 'untyped default',

    [AllowNull()]
    [object]$NullAllowedValue = $null,

    # ---- Security ----------------------------------------------------
    [securestring]$Secret = (ConvertTo-SecureString 'DummySecret' -AsPlainText -Force),

    [pscredential]$Credential = (New-Object System.Management.Automation.PSCredential('dummy-user', (ConvertTo-SecureString 'DummyPassword' -AsPlainText -Force))),

    # ---- Validation --------------------------------------------------
    [ValidateNotNullOrEmpty()]
    [string]$NotEmpty = 'value',

    [ValidateNotNull()]
    [string]$NotNullValue = 'not null',

    [ValidateLength(1, 20)]
    [string]$ShortText = 'short',

    [ValidatePattern('^[A-Z]{2}-\d{4}$')]
    [string]$PatternText = 'AB-1234',

    [ValidatePattern('^[A-Za-z]:$')]
    [string]$DriveLetter = 'C:',

    [ValidateSet('Low', 'Medium', 'High')]
    [string]$Level = 'Medium',

    [ValidateSet('Yes', 'No', IgnoreCase = $false)]
    [string]$CaseSensitiveChoice = 'Yes',

    [ValidateRange(1, 100)]
    [int]$Percent = 50,

    [ValidateRange(0.0, 1.0)]
    [double]$Ratio = 0.5,

    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
    [string]$Folder = ([System.IO.Path]::GetTempPath()),

    [ValidateCount(1, 5)]
    [string[]]$CountLimitedList = @('a', 'b'),

    [AllowEmptyCollection()]
    [string[]]$AllowedEmptyList = @(),

    # ---- Parameter attribute features --------------------------------
    [Alias('Short', 'S')]
    [string]$AliasedParameter = 'alias default',

    [Parameter(HelpMessage = 'Text shown when PowerShell prompts for this parameter')]
    [string]$HelpMessageParameter = 'help default',

    [Parameter(DontShow = $true)]
    [string]$HiddenParameter = 'hidden default',

    [ArgumentCompleter({ param($commandName, $parameterName, $wordToComplete) 'Apple', 'Banana', 'Cherry' | Where-Object { $_ -like "$wordToComplete*" } })]
    [string]$CompletedParameter = 'Apple',

    [Parameter(ValueFromPipeline = $true)]
    [string[]]$InputObject = @(),

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$FullName = 'default.txt',

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArguments = @(),

    [Parameter(ParameterSetName = 'ByName')]
    [Alias('N')]
    [string]$Name = 'default',

    [Parameter(ParameterSetName = 'ById')]
    [int]$Id = 1
)

begin {
    $commonParameterNames = @(
        'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
        'ErrorVariable', 'WarningVariable', 'InformationVariable',
        'OutVariable', 'OutBuffer', 'PipelineVariable'
    )
    $pipedItems = New-Object 'System.Collections.Generic.List[string]'

    function ConvertTo-DisplayText {
        param ($Value)

        if ($null -eq $Value)                                       { return '$null' }
        if ($Value -is [System.Security.SecureString])              { return '(secure string, hidden)' }
        if ($Value -is [System.Management.Automation.PSCredential]) { return "user: $($Value.UserName), password hidden" }
        if ($Value -is [scriptblock])                               { return '{ ' + $Value.ToString().Trim() + ' }' }
        if ($Value -is [xml])                                       { return $Value.OuterXml }
        if ($Value -is [System.IO.FileSystemInfo])                  { return $Value.FullName }
        if ($Value -is [datetime])                                  { return $Value.ToString('s') }
        if ($Value -is [System.Collections.IDictionary]) {
            return (($Value.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '; ')
        }
        if (($Value -is [System.Collections.IEnumerable]) -and ($Value -isnot [string])) {
            return ((@($Value) | ForEach-Object { ConvertTo-DisplayText $_ }) -join ', ')
        }
        return [string]$Value
    }
}

process {
    # Runs once per piped item (or once when nothing is piped).
    foreach ($item in $InputObject) {
        $pipedItems.Add([string]$item)
    }
}

end {
    $declaredParameters = $MyInvocation.MyCommand.Parameters
    $declaredNames = @($declaredParameters.Keys | Where-Object { $commonParameterNames -notcontains $_ })

    Write-Verbose "Declared parameters: $($declaredNames.Count)"

    [PSCustomObject]@{
        Name   = '(parameter set)'
        Type   = ''
        Passed = ''
        Value  = $PSCmdlet.ParameterSetName
    }

    foreach ($parameterName in $declaredNames) {
        $type = $declaredParameters[$parameterName].ParameterType
        if ($type.IsGenericType) {
            $typeText = ($type.Name -replace '`\d+$', '') + '[' + (($type.GetGenericArguments() | ForEach-Object { $_.Name }) -join ',') + ']'
        }
        else {
            $typeText = $type.Name
        }

        [PSCustomObject]@{
            Name   = $parameterName
            Type   = $typeText
            Passed = $PSBoundParameters.ContainsKey($parameterName)
            Value  = ConvertTo-DisplayText (Get-Variable -Name $parameterName -ValueOnly -ErrorAction SilentlyContinue)
        }
    }

    [PSCustomObject]@{
        Name   = '(all piped items)'
        Type   = ''
        Passed = ($pipedItems.Count -gt 0)
        Value  = ($pipedItems -join ', ')
    }
}
