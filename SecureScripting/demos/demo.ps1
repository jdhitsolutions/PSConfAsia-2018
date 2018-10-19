#use data files to create sterile code

Return "`nThis is a walkthrough demo you doofus.`n" | Write-Host -ForegroundColor red 

#region passwords as json

# https://github.com/jdhitsolutions/PSJsonCredential
# Install-module PSJsonCredential

get-command -Module PSJsonCredential
#process
help Export-PSCredentialToJson -Examples
help Get-PSCredentialFromJson
help Import-PSCredentialFromJson

$cred = Get-Credential "company\artd"
Export-PSCredentialToJson -Path c:\work\art.json -Credential $cred -Passthru -Verbose
psedit c:\work\art.json
Get-PSCredentialFromJson -Path c:\work\art.json

$impcred = Import-PSCredentialFromJson -Path C:\work\art.json -Verbose

$impcred
$impcred.GetNetworkCredential().Password

#endregion

#region CMS

cls
#protect any file or content

$a = Protect-CmsMessage -to "CN=jeff@jdhitsolutions.com" -Content "I am the walrus"
$a
Unprotect-CmsMessage -Content $a

psedit .\mycmd.ps1
#remove the function for the demo
dir function:get-something | del

Protect-CmsMessage -To "CN=jeff@jdhitsolutions.com" -Path .\mycmd.ps1 -OutFile .\cmscmd.ps1
cat .\cmscmd.ps1

Unprotect-CmsMessage -Path .\cmscmd.ps1 

psedit .\Import-MyCommand.ps1
. .\Import-MyCommand.ps1
Import-MyCommand .\cmscmd.ps1 -Verbose

Get-Something

#endregion

#region scripting options

cls
#open all these files before the demo
psedit .\Get-DomainUser.ps1
psedit .\Get-DomainUser2.ps1
psedit .\Get-DomainUser3.ps1
psedit .\domain.configdata.psd1

#endregion

#region Next steps

# How could some of these ideas be combined?
# What other ideas do you have?
# JEA?

#endregion