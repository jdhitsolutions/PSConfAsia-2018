
Return "`nThis is a walkthrough demo you silly man.`n" | Write-Host -ForegroundColor red 

#region qotd

#https://gist.github.com/jdhitsolutions/6f2892bd9eb7a60fcf8533125d265361
psedit C:\scripts\Get-QOTD.ps1

qotd
#or how use in my profile
qotd | write-host -ForegroundColor Yellow

#endregion

#region comics

# https://gist.github.com/jdhitsolutions/f0bba7516e3d9a9d8d3b41b6e7c76ba2
psedit C:\scripts\Get-MyComics.ps1
#this runs as a PowerShell scheduled job daily at 5AM
psedit C:\scripts\Send-DailyComics.ps1

invoke-item Drop:\mycomics\dailycomics.html

#endregion

#region shell shortcuts

# PSReadlineHelper

#not for PowerShell Core and v2 of PSReadline
# https://github.com/jdhitsolutions/PSReadlineHelper
Find-Module PSReadlineHelper

#I use my local copy - only in the consolehost
# demo module

#type extensions
# https://github.com/jdhitsolutions/PSTypeExtensionTools

Find-Module PSTypeExtensionTools

#this is called in my profile
(dir c:\scripts\*-extensions.json).fullname | foreach { Import-PSTypeExtension $_ }

dir c:\scripts\*.xml | select name, sizeKB, modified

Get-PSTypeExtension system.io.fileinfo
get-command -Module pstypeextensiontools
Add-PSTypeExtension -TypeName system.io.fileinfo -MemberType ScriptProperty -MemberName ModifiedAge -Value {(Get-Date) - $this.modified}
dir c:\scripts\*.xml | select name, sizeKB, modified, modifiedage | sort modifiedage -Descending

help Import-PSTypeExtension -ex

dir c:\scripts\*-extensions.json
psedit C:\scripts\measure-extensions.json

dir c:\scripts\*.ps1 | measure size -sum | Select Count, SumMB

#select functions
get-process | sort WS -Descending | first 5
dir S:\*.ps1 | sort modified | last 10
help select-first
help select-last

#auto completes
psedit S:\myAutoCompleters.ps1

#psdefaultparameterValues
$PSDefaultParameterValues

#endregion

#region tickle events

# https://github.com/jdhitsolutions/myTickle
find-module mytickle
# Import-Module s:\mytickle
get-command -module mytickle
get-variable tickle*

get-tickleevent -Next 30
gte -name christmas
gte -Offline Drop:\work\tickle.csv

Add-TickleEvent -Event "Foo" -Date (Get-Date).Adddays(1)
gte
Show-TickleEvent

#endregion

#region calendar

# https://github.com/jdhitsolutions/PSCalendar
Find-Module PSCalendar
import-module pscalendar
gcm -mod pscalendar

get-calendar
#show autocompletion for month and year
cal -Month December -Year 2018 -HighlightDate 12/1, 12/25, 12/24
Show-Calendar -Month December -Year 2018 -HighlightDate 12/1, 12/25, 12/24

#combining
$days = (Get-TickleEvent -Offline Drop:\work\tickle.csv -next 90).date
Get-Calendar -Start 10/1/2018 -End 12/1/2018 -HighlightDate $days
Show-GuiCalendar -Start 10/1/2018 -End 12/1/2018 -HighlightDate $days

#Show transparency changes!

#endregion

#region scheduled reminders

# https://github.com/jdhitsolutions/MyReminder

Find-Module Myreminder
import-module Myreminder
get-command -module MyReminder
New-ScheduledReminderJob -Message "Hello, Singapore"

remind -Message "Do Something" -At "10/20/2018 8:00AM" -Once -JobName Something

psedit S:\Set-TickleReminder.ps1

Get-scheduledreminderjob

#endregion

#region tasks

# https://github.com/jdhitsolutions/MyTasks
Find-Module MyTasks
get-command -Module mytasks | group noun
Get-MyTaskCategory
Get-MyTask
Get-MyTask -Category Project
Show-MyTask -DaysDue 7

New-MyTask -Name "psasia-followup" -Days 7 -Category Event
gmt
gmt psasia-followup | smt -Progress 30 -Passthru
Complete-MyTask psasia-followup

#endregion

#region remoteops

# https://github.com/jdhitsolutions/PSRemoteOperations

Find-Module PSRemoteOperations
import-module C:\scripts\PSRemoteOperations -force
gcm -mod psremoteoperations
get-variable psremote*

New-PSRemoteOperation -Computername FOO -Scriptblock { restart-service wuauserv}
dir $PSRemoteOpPath
psedit $PSRemoteOpPath\foo*.psd1

help Register-PSRemoteOperationWatcher 

#let's run a command at home
$sb = {
    Add-TickleEvent -Name "Halloween" -Date "10/31/2018 6:00PM"
    Get-TickleEvent -all | Export-CSV -Path C:\users\jeff\Dropbox\work\tickle.csv
}
nro -Computername bovine320 -Scriptblock $sb -Initialization {import-module C:\scripts\MyTickle} -Passthru

dir $PSRemoteOpArchive
Get-PSRemoteOperationResult -Computername think51 -Newest 1
gro -Computername bovine320 -Newest 1

gte -Offline Drop:\work\tickle.csv -next 15

# also option for using CMS messages
# In development for PowerShell Core on non-Windows

#endregion

#region Follow-Up

# How do you use PowerShell to run *your* day?

#endregion