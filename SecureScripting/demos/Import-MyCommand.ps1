
Function Import-MyCommand {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript( {Test-Path $_})]
        [string]$Path
    )

    $file = ".\temp.ps1"
    #"$([System.IO.Path]::GetTempFileName()).ps1"

    Write-verbose "Unprotecting content from $path"
    $content = Unprotect-CmsMessage -Path $Path

    Set-Content -Path $file -Value $content

    write-verbose "Create a temporary module from $file"
    $sb = [scriptblock]::Create($content)

    New-Module -ScriptBlock $sb -ov m | Import-Module

    #delete it
    write-Verbose "Deleting $file"
    del $file

    #get function names
    $new = (Get-Command -module $m.name -CommandType function).name
    $m = @"
You can now use these commands: 
$($New | Out-String)
"@

    write-host $m -ForegroundColor yellow
}