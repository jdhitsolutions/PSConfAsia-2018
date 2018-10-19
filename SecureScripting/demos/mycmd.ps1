#requires -version 5.1
#requires -module SMBShare

Function Get-Something {
    [cmdletbinding()]
    Param([string]$Computername = $env:computername)

    [pscustomobject]@{
        Computername = $computername.toUpper()
        DayOfWeek    = (Get-Date).DayOfWeek
        OS           = (Get-Ciminstance -ClassName win32_operatingsystem -Property caption -ComputerName $computername).Caption
        LuckyNumber  = (Get-Random -Minimum 1 -Maximum 100)
        Shares       = (Get-SMBShare -cimsession $Computername | Select Name, Path)
    }

}