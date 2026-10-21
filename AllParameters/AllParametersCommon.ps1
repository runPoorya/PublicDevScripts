<#
.SYNOPSIS
    Parameters of every common PowerShell type, for Windows PowerShell 5.1 and PowerShell 7+.

.DESCRIPTION
    120 parameters, each named after the type it demonstrates and each with a
    default value, so the script runs without any input. It prints one row per
    parameter (name, type, whether it was passed, value).

    Why there are four scripts: PowerShell cannot load a script that declares a
    type its version does not have, and no single PowerShell version has every
    type. The complete set is therefore split by version:
      * All-Parameters.ps1                           Windows PowerShell 5.1 and PowerShell 7+
      * All-Parameters-PowerShell7.ps1               PowerShell 7.4 or later (types from 6.0 to 7.4)
      * All-Parameters-PowerShell7.5Plus.ps1         PowerShell 7.5 or later
      * All-Parameters-WindowsPowerShell-Legacy.ps1  Windows PowerShell 5.1 only
    Reference: PowerShell 7.0 = .NET Core 3.1, 7.1 = .NET 5, 7.2 = .NET 6,
    7.3 = .NET 7, 7.4 = .NET 8, 7.5 = .NET 9. A type that came with a .NET
    version is available from the matching PowerShell version onward.

    This script covers these groups:
      * Basic types
      * Whole numbers
      * Decimal numbers
      * Date, time and culture
      * Identifiers, addresses and special text types
      * Wrapper types
      * Security
      * Files and system objects
      * PowerShell hosting and remoting
      * CIM (management infrastructure)
      * Enumerations
      * Arrays
      * Collections
      * Validation attributes (not types)
      * Parameter attribute features (not types)

    Notes:
      * Nothing is mandatory (a mandatory parameter ignores its default and
        prompts instead), so -Id of the ById set is optional too.
      * Objects that cannot be created from nothing (certificate, runspace,
        remoting session, CIM objects, PowerShell instance) default to $null.
      * SecureString and PSCredential use obvious dummy values. Never store real
        secrets in a script. Their values are not printed.
      * The pipeline parameters (InputObject, FullName) only receive values when
        something is piped in; the report also lists all piped items.
      * The last two groups demonstrate attributes, not types; they are kept
        from the earlier version of this script.
      * Several types have an older relative, mentioned under "Available".

    Not covered: your own classes, and any type introduced after the newest
    version listed above.

.PARAMETER Object
    Any value, no conversion. Same as declaring no type. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'any value'.

.PARAMETER String
    Text. Also the first positional parameter. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'hi'.

.PARAMETER Char
    A single character (a one-character string is converted). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'x'.

.PARAMETER Boolean
    True/false that must be given explicitly, e.g. -Boolean $false. Prefer a switch for on/off options. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $true.

.PARAMETER SwitchParameter
    On/off option without a value; absent means false. Written [switch]. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $false.

.PARAMETER PSObject
    The wrapper PowerShell puts around objects; here an object with properties. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: ([PSCustomObject]@{ Name = 'default'; Value = 1 }).

.PARAMETER PSCustomObject
    Object with properties you define; a hashtable passed in is converted. Available: PowerShell 3.0 and later (the [pscustomobject] shortcut); the older [psobject] is the related type from PowerShell 1.0/2.0. Default: ([PSCustomObject]@{ Name = 'default'; Value = 1 }).

.PARAMETER PSReference
    Pass-by-reference wrapper written [ref]; the value is read from .Value. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [ref]0.

.PARAMETER Byte
    8-bit unsigned whole number, 0 to 255. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 200.

.PARAMETER SByte
    8-bit signed whole number, -128 to 127. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: -5.

.PARAMETER Int16
    16-bit signed whole number. Also written [short]. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: -300.

.PARAMETER UInt16
    16-bit unsigned whole number, 0 to 65535. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 60000.

.PARAMETER Int32
    32-bit signed whole number. Also written [int]. Second positional parameter. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 1.

.PARAMETER UInt32
    32-bit unsigned whole number. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 4000000000.

.PARAMETER Int64
    64-bit signed whole number. Also written [long]. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 9000000000.

.PARAMETER UInt64
    64-bit unsigned whole number. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [uint64]::MaxValue.

.PARAMETER IntPtr
    Pointer-sized integer (32 or 64 bits depending on the process). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+); newer 7.x versions also offer the [nint] shortcut for the same idea. Default: [System.IntPtr]::Zero.

.PARAMETER UIntPtr
    Unsigned pointer-sized integer. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+); newer 7.x versions also offer the [nuint] shortcut. Default: [System.UIntPtr]::Zero.

.PARAMETER Single
    Single-precision floating point number. Also written [float]. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 2.5.

.PARAMETER Double
    Double-precision floating point number. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 3.14159.

.PARAMETER Decimal
    Exact decimal number with 28-29 digits; good for money. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 19.99.

.PARAMETER DateTime
    Date and time. The default is calculated at start (now). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: (Get-Date), i.e. now.

.PARAMETER TimeSpan
    A length of time (hours:minutes:seconds). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '01:30:00'.

.PARAMETER DateTimeOffset
    Date and time including the offset from UTC. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '2026-01-01T12:00:00+00:00'.

.PARAMETER TimeZoneInfo
    A time zone. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [System.TimeZoneInfo]::Utc.

.PARAMETER CultureInfo
    A language/region setting; a name such as 'de-DE' is converted. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [System.Globalization.CultureInfo]::InvariantCulture.

.PARAMETER Encoding
    A text encoding object (UTF8, ASCII, Unicode ...). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [System.Text.Encoding]::UTF8.

.PARAMETER Guid
    A globally unique identifier. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '00000000-0000-0000-0000-000000000001'.

.PARAMETER Version
    A version number such as 1.2.3 (up to four parts). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '1.2.3'.

.PARAMETER Uri
    A web address / URI. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'https://example.com/path?x=1'.

.PARAMETER Regex
    A compiled regular expression. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '^\d+$'.

.PARAMETER XmlDocument
    An XML document. Written [xml]; the underlying type is System.Xml.XmlDocument. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '<root><item>1</item></root>'.

.PARAMETER MailAddress
    An e-mail address (System.Net.Mail.MailAddress). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'user@example.com'.

.PARAMETER IPAddress
    An IPv4 or IPv6 address. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '127.0.0.1'.

.PARAMETER IPEndPoint
    An IP address plus port. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 127.0.0.1:8080.

.PARAMETER PhysicalAddress
    A MAC (hardware) address. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 00-11-22-33-44-55.

.PARAMETER ScriptBlock
    A block of code passed as a value. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: { 'default script block' }.

.PARAMETER Type
    A .NET type; a name such as 'System.Int32' is converted. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [System.String].

.PARAMETER NullableOfInt32
    A whole number that may also be $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 5.

.PARAMETER NullableOfDateTime
    A date/time that may also be $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '2026-06-30'.

.PARAMETER SecureString
    Encrypted-in-memory text. The default is a harmless dummy; never store real secrets in a script. Never printed. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: a dummy secure string.

.PARAMETER PSCredential
    User name plus password. The default is a harmless dummy. Only the user name is printed. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: a dummy credential (user 'dummy-user').

.PARAMETER X509Certificate
    A certificate (also accepts X509Certificate2 objects). A certificate cannot be made from nothing, so the default is $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER X500DistinguishedName
    A certificate subject name such as 'CN=Default'. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: CN=Default.

.PARAMETER FileInfo
    A file (it need not exist); a path string is converted. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: default.txt in the temp folder.

.PARAMETER DirectoryInfo
    A folder; a path string is converted. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: the temp folder.

.PARAMETER FileSystemInfo
    Base type of files and folders; here a folder object. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: the temp folder object.

.PARAMETER Process
    A running process object. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: the current PowerShell process.

.PARAMETER Exception
    A .NET exception object. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: an exception with the text 'default exception'.

.PARAMETER ErrorRecord
    A PowerShell error record. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: an error record with the text 'default error'.

.PARAMETER PSVariable
    A PowerShell variable object (name and value). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: variable 'Name' = 'Value'.

.PARAMETER PSNoteProperty
    A note property (name and value) that can be added to objects. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: note property 'Name' = 'Value'.

.PARAMETER CancellationToken
    A token used to signal that an operation should stop. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: [System.Threading.CancellationToken]::None.

.PARAMETER PowerShell
    A PowerShell instance used to run commands from code. Default $null (creating one at start would leak resources). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER Runspace
    A PowerShell execution environment. Default $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER InitialSessionState
    The starting configuration of a runspace. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: the default session state.

.PARAMETER PSModuleInfo
    Information about a module (as returned by Get-Module). Default $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER PSSession
    A remoting session (as returned by New-PSSession). Default $null. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER PSSessionOption
    Options for a remoting session. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: default session options.

.PARAMETER CimInstance
    An object returned by the CIM cmdlets. Default $null. Available: Windows PowerShell 3.0 and later, PowerShell 7+ (replaces the older WMI types, see the Legacy script). Default: $null.

.PARAMETER CimSession
    A connection used by the CIM cmdlets. Default $null. Available: Windows PowerShell 3.0 and later, PowerShell 7+. Default: $null.

.PARAMETER CimClass
    A CIM class definition. Default $null. Available: Windows PowerShell 3.0 and later, PowerShell 7+. Default: $null.

.PARAMETER DayOfWeek
    Sunday to Saturday. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Monday'.

.PARAMETER ConsoleColor
    The 16 console colors. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Cyan'.

.PARAMETER FileAttributes
    A flags enumeration: several values can be combined, e.g. 'ReadOnly, Hidden'. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'ReadOnly, Hidden'.

.PARAMETER StringComparison
    How strings are compared. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'OrdinalIgnoreCase'.

.PARAMETER DateTimeKind
    Unspecified, Utc or Local. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Utc'.

.PARAMETER EnvironmentVariableTarget
    Process, User or Machine. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Process'.

.PARAMETER ErrorCategory
    The category of a PowerShell error. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'NotSpecified'.

.PARAMETER ActionPreference
    What to do on an error/warning (Continue, Stop, SilentlyContinue ...). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Continue'.

.PARAMETER ExecutionPolicy
    PowerShell script execution policy values. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'RemoteSigned'.

.PARAMETER Array
    Untyped array (System.Array). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1, 'two', 3.0).

.PARAMETER StringArray
    Array of text, e.g. -StringArray a,b,c Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('a', 'b').

.PARAMETER Int32Array
    Array of whole numbers. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1, 2, 3).

.PARAMETER DoubleArray
    Array of decimal numbers. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1.5, 2.5).

.PARAMETER DateTimeArray
    Array of dates. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('2026-01-01', '2026-02-01').

.PARAMETER BooleanArray
    Array of true/false values. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @($true, $false).

.PARAMETER ByteArray
    Array of bytes (binary data). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1, 2, 3).

.PARAMETER CharArray
    Array of characters. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('a', 'b').

.PARAMETER ObjectArray
    Array that can mix any kinds of values. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('text', 42, $true).

.PARAMETER Hashtable
    Key/value pairs without a guaranteed order, e.g. -Hashtable @{ Key = 'Value' } Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @{ Key1 = 'Value1'; Key2 = 2 }.

.PARAMETER OrderedDictionary
    Key/value pairs that keep their order. Available: all versions; the [ordered] shortcut for creating one needs PowerShell 3.0 or later. Default: ([ordered]@{ First = 1; Second = 2 }).

.PARAMETER ArrayList
    An array that can grow (older collection type). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('x', 'y').

.PARAMETER Queue
    First-in, first-out collection (older, non-generic). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1, 2).

.PARAMETER Stack
    Last-in, first-out collection (older, non-generic). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @(1, 2).

.PARAMETER SortedList
    Key/value pairs kept sorted by key (older, non-generic). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @{ b = 2; a = 1 }.

.PARAMETER BitArray
    A compact array of bits. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: two bits: True, False.

.PARAMETER ListOfString
    Generic list of text. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('p', 'q').

.PARAMETER QueueOfString
    Generic first-in, first-out collection. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('p', 'q').

.PARAMETER StackOfString
    Generic last-in, first-out collection. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('p', 'q').

.PARAMETER HashSetOfString
    Generic set: no duplicates. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('p', 'q').

.PARAMETER SortedSetOfString
    Generic set kept sorted. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('q', 'p').

.PARAMETER DictionaryOfStringInt32
    Generic dictionary (text keys, whole-number values). Empty by default. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: an empty dictionary.

.PARAMETER SortedDictionaryOfStringInt32
    Generic dictionary sorted by key. Empty by default. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: an empty dictionary.

.PARAMETER KeyValuePairOfStringInt32
    One key/value pair. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: key = 1.

.PARAMETER TupleOfInt32String
    A fixed group of two values of different types. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: (1, 'a').

.PARAMETER AnyValue
    No type declared at all: accepts any value (the same as Object). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'untyped default'.

.PARAMETER NullAllowedObject
    Value that is allowed to be $null (has [AllowNull()]; the default is $null). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: $null.

.PARAMETER NotEmpty
    Text that must not be null or empty ([ValidateNotNullOrEmpty]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'value'.

.PARAMETER NotNullValue
    Text that must not be null ([ValidateNotNull]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'not null'.

.PARAMETER EmptyAllowedText
    Text that may be empty ([AllowEmptyString]); the default is empty. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: '' (empty).

.PARAMETER ShortText
    Text of 1 to 20 characters ([ValidateLength]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'short'.

.PARAMETER PatternText
    Two capital letters, a dash and four digits ([ValidatePattern]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'AB-1234'.

.PARAMETER DriveLetter
    A drive letter with a colon, e.g. "C:" ([ValidatePattern]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'C:'.

.PARAMETER Level
    Only Low, Medium or High, not case sensitive ([ValidateSet]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Medium'.

.PARAMETER CaseSensitiveChoice
    Only "Yes" or "No", exactly in that case ([ValidateSet] with IgnoreCase = $false). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'Yes'.

.PARAMETER Percent
    Whole number from 1 to 100 ([ValidateRange]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 50.

.PARAMETER Ratio
    Number from 0 to 1 ([ValidateRange]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 0.5.

.PARAMETER Folder
    Path of an existing folder ([ValidateScript]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: the temp folder.

.PARAMETER CountLimitedList
    Array with 1 to 5 entries ([ValidateCount]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @('a', 'b').

.PARAMETER AllowedEmptyList
    Array that may be empty ([AllowEmptyCollection]); the default is empty. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @() (empty).

.PARAMETER AliasedParameter
    Can also be used as -Short or -S ([Alias]). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'alias default'.

.PARAMETER HelpMessageParameter
    Has a help message shown when PowerShell prompts for it (HelpMessage). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'help default'.

.PARAMETER HiddenParameter
    Hidden from tab completion and help but still usable (DontShow). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'hidden default'.

.PARAMETER CompletedParameter
    Tab completion suggests Apple, Banana and Cherry; any text is accepted. Available: PowerShell 5.0 and later ([ArgumentCompleter]). Default: 'Apple'.

.PARAMETER InputObject
    Accepts values from the pipeline (ValueFromPipeline), e.g. "a","b" | .\All-Parameters.ps1 Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @() (nothing piped).

.PARAMETER FullName
    Takes the FullName property of piped objects (ValueFromPipelineByPropertyName). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'default.txt'.

.PARAMETER RemainingArguments
    Collects extra, unnamed arguments (ValueFromRemainingArguments). Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: @() (none).

.PARAMETER Name
    Parameter set ByName (the default set). Cannot be combined with -Id. Alias: -N Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 'default'.

.PARAMETER Id
    Parameter set ById. Cannot be combined with -Name. Not mandatory, so it can have a default. Available: all versions (Windows PowerShell 5.1 and PowerShell 7+). Default: 1.
.EXAMPLE
    .\All-Parameters.ps1
    Runs with all default values.

.EXAMPLE
    .\All-Parameters.ps1 "hello" 5 -SwitchParameter -Level High -StringArray x,y,z
    String and Int32 are positional; the rest is named.

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
    # ---- Basic types ---------------------------------------------------
    [object]$Object = 'any value',

    [Parameter(Position = 0)]
    [string]$String = 'hi',

    [char]$Char = 'x',

    [bool]$Boolean = $true,

    [switch]$SwitchParameter = $false,

    [psobject]$PSObject = ([PSCustomObject]@{ Name = 'default'; Value = 1 }),

    [pscustomobject]$PSCustomObject = ([PSCustomObject]@{ Name = 'default'; Value = 1 }),

    [ref]$PSReference = [ref]0,

    # ---- Whole numbers -------------------------------------------------
    [byte]$Byte = 200,

    [sbyte]$SByte = -5,

    [int16]$Int16 = -300,

    [uint16]$UInt16 = 60000,

    [Parameter(Position = 1)]
    [int32]$Int32 = 1,

    [uint32]$UInt32 = 4000000000,

    [int64]$Int64 = 9000000000,

    [uint64]$UInt64 = [uint64]::MaxValue,

    [System.IntPtr]$IntPtr = [System.IntPtr]::Zero,

    [System.UIntPtr]$UIntPtr = [System.UIntPtr]::Zero,

    # ---- Decimal numbers -----------------------------------------------
    [single]$Single = 2.5,

    [double]$Double = 3.14159,

    [decimal]$Decimal = 19.99,

    # ---- Date, time and culture ----------------------------------------
    [datetime]$DateTime = (Get-Date),

    [timespan]$TimeSpan = '01:30:00',

    [System.DateTimeOffset]$DateTimeOffset = '2026-01-01T12:00:00+00:00',

    [System.TimeZoneInfo]$TimeZoneInfo = [System.TimeZoneInfo]::Utc,

    [cultureinfo]$CultureInfo = [System.Globalization.CultureInfo]::InvariantCulture,

    [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8,

    # ---- Identifiers, addresses and special text types -----------------
    [guid]$Guid = '00000000-0000-0000-0000-000000000001',

    [version]$Version = '1.2.3',

    [uri]$Uri = 'https://example.com/path?x=1',

    [regex]$Regex = '^\d+$',

    [xml]$XmlDocument = '<root><item>1</item></root>',

    [mailaddress]$MailAddress = 'user@example.com',

    [ipaddress]$IPAddress = '127.0.0.1',

    [System.Net.IPEndPoint]$IPEndPoint = ([System.Net.IPEndPoint]::new([System.Net.IPAddress]::Loopback, 8080)),

    [System.Net.NetworkInformation.PhysicalAddress]$PhysicalAddress = ([System.Net.NetworkInformation.PhysicalAddress]::Parse('00-11-22-33-44-55')),

    [scriptblock]$ScriptBlock = { 'default script block' },

    [type]$Type = [System.String],

    # ---- Wrapper types -------------------------------------------------
    [Nullable[int]]$NullableOfInt32 = 5,

    [Nullable[datetime]]$NullableOfDateTime = '2026-06-30',

    # ---- Security ------------------------------------------------------
    [securestring]$SecureString = (ConvertTo-SecureString 'DummySecret' -AsPlainText -Force),

    [pscredential]$PSCredential = (New-Object System.Management.Automation.PSCredential('dummy-user', (ConvertTo-SecureString 'DummyPassword' -AsPlainText -Force))),

    [X509Certificate]$X509Certificate = $null,

    [X500DistinguishedName]$X500DistinguishedName = ([X500DistinguishedName]::new('CN=Default')),

    # ---- Files and system objects --------------------------------------
    [System.IO.FileInfo]$FileInfo = (Join-Path ([System.IO.Path]::GetTempPath()) 'default.txt'),

    [System.IO.DirectoryInfo]$DirectoryInfo = ([System.IO.Path]::GetTempPath()),

    [System.IO.FileSystemInfo]$FileSystemInfo = (Get-Item -LiteralPath ([System.IO.Path]::GetTempPath())),

    [System.Diagnostics.Process]$Process = (Get-Process -Id $PID),

    [System.Exception]$Exception = (New-Object System.Exception('default exception')),

    [System.Management.Automation.ErrorRecord]$ErrorRecord = (New-Object System.Management.Automation.ErrorRecord((New-Object System.Exception('default error')), 'DefaultErrorId', [System.Management.Automation.ErrorCategory]::NotSpecified, $null)),

    [System.Management.Automation.PSVariable]$PSVariable = (New-Object System.Management.Automation.PSVariable('Name', 'Value')),

    [System.Management.Automation.PSNoteProperty]$PSNoteProperty = (New-Object System.Management.Automation.PSNoteProperty('Name', 'Value')),

    [System.Threading.CancellationToken]$CancellationToken = [System.Threading.CancellationToken]::None,

    # ---- PowerShell hosting and remoting -------------------------------
    [powershell]$PowerShell = $null,

    [System.Management.Automation.Runspaces.Runspace]$Runspace = $null,

    [System.Management.Automation.Runspaces.InitialSessionState]$InitialSessionState = ([System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()),

    [System.Management.Automation.PSModuleInfo]$PSModuleInfo = $null,

    [System.Management.Automation.Runspaces.PSSession]$PSSession = $null,

    [System.Management.Automation.Remoting.PSSessionOption]$PSSessionOption = (New-PSSessionOption),

    # ---- CIM (management infrastructure) -------------------------------
    [ciminstance]$CimInstance = $null,

    [cimsession]$CimSession = $null,

    [cimclass]$CimClass = $null,

    # ---- Enumerations --------------------------------------------------
    [System.DayOfWeek]$DayOfWeek = 'Monday',

    [System.ConsoleColor]$ConsoleColor = 'Cyan',

    [System.IO.FileAttributes]$FileAttributes = 'ReadOnly, Hidden',

    [System.StringComparison]$StringComparison = 'OrdinalIgnoreCase',

    [System.DateTimeKind]$DateTimeKind = 'Utc',

    [System.EnvironmentVariableTarget]$EnvironmentVariableTarget = 'Process',

    [System.Management.Automation.ErrorCategory]$ErrorCategory = 'NotSpecified',

    [System.Management.Automation.ActionPreference]$ActionPreference = 'Continue',

    [Microsoft.PowerShell.ExecutionPolicy]$ExecutionPolicy = 'RemoteSigned',

    # ---- Arrays --------------------------------------------------------
    [array]$Array = @(1, 'two', 3.0),

    [string[]]$StringArray = @('a', 'b'),

    [int[]]$Int32Array = @(1, 2, 3),

    [double[]]$DoubleArray = @(1.5, 2.5),

    [datetime[]]$DateTimeArray = @('2026-01-01', '2026-02-01'),

    [bool[]]$BooleanArray = @($true, $false),

    [byte[]]$ByteArray = @(1, 2, 3),

    [char[]]$CharArray = @('a', 'b'),

    [object[]]$ObjectArray = @('text', 42, $true),

    # ---- Collections ---------------------------------------------------
    [hashtable]$Hashtable = @{ Key1 = 'Value1'; Key2 = 2 },

    [System.Collections.Specialized.OrderedDictionary]$OrderedDictionary = ([ordered]@{ First = 1; Second = 2 }),

    [System.Collections.ArrayList]$ArrayList = @('x', 'y'),

    [System.Collections.Queue]$Queue = @(1, 2),

    [System.Collections.Stack]$Stack = @(1, 2),

    [System.Collections.SortedList]$SortedList = @{ b = 2; a = 1 },

    [System.Collections.BitArray]$BitArray = ([System.Collections.BitArray]::new([bool[]]@($true, $false))),

    [System.Collections.Generic.List[string]]$ListOfString = @('p', 'q'),

    [System.Collections.Generic.Queue[string]]$QueueOfString = @('p', 'q'),

    [System.Collections.Generic.Stack[string]]$StackOfString = @('p', 'q'),

    [System.Collections.Generic.HashSet[string]]$HashSetOfString = @('p', 'q'),

    [System.Collections.Generic.SortedSet[string]]$SortedSetOfString = @('q', 'p'),

    [System.Collections.Generic.Dictionary[string,int]]$DictionaryOfStringInt32 = [System.Collections.Generic.Dictionary[string,int]]::new(),

    [System.Collections.Generic.SortedDictionary[string,int]]$SortedDictionaryOfStringInt32 = [System.Collections.Generic.SortedDictionary[string,int]]::new(),

    [System.Collections.Generic.KeyValuePair[string,int]]$KeyValuePairOfStringInt32 = [System.Collections.Generic.KeyValuePair[string,int]]::new('key', 1),

    [System.Tuple[int,string]]$TupleOfInt32String = [System.Tuple]::Create(1, 'a'),

    $AnyValue = 'untyped default',

    [AllowNull()]
    [object]$NullAllowedObject = $null,

    # ---- Validation attributes (not types) -----------------------------
    [ValidateNotNullOrEmpty()]
    [string]$NotEmpty = 'value',

    [ValidateNotNull()]
    [string]$NotNullValue = 'not null',

    [AllowEmptyString()]
    [string]$EmptyAllowedText = '',

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

    # ---- Parameter attribute features (not types) ----------------------
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
        if ($Value -is [System.Management.Automation.PSReference])  { return 'ref -> ' + (ConvertTo-DisplayText $Value.Value) }
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
