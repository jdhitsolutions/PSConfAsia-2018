
Return "`nThis is a walkthrough demo you doofus.`n" | Write-Host -ForegroundColor red 

#requires -module ActiveDirectory


#run in my domain
enter-pssession -vmname win10 -Credential company\artd

<# prep demos

get-aduser -filter * -SearchBase "DC=Company,DC=pri" | 
Move-ADObject -TargetPath 'OU=Employees,DC=Company,DC=pri'

get-aduser sams | set-aduser -title "Sales Manager"
get-aduser sonyas | set-aduser -title "Sales Asst"
get-aduser samanthas | set-aduser -title "Sales Asst"
get-aduser 'G.Guillary' | set-aduser -title "Sales Agent I"

$d = @"
@{
    OU = "OU=Employees,DC=Company,DC=pri"
    Domain = "company.pri"
    DC = "dom1"
}
"@
$d | out-file -filepath c:\scripts\domain.configdata.psd1
#>

Function Get-DomainUser {
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$OU = "OU=Employees,DC=Company,DC=pri",
        [string]$Department
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        
        $domain = "company.pri"   # <--- hard coded values
        $dc = "dom1"              # <--- hard coded values

        $paramhash = @{
            SearchBase = ""
            Server     = "$dc.$domain"
            Filter     = "*"
            properties = "Name", "SamAccountName", "UserPrincipalName", "Description", "Enabled"
        }
        
        if ($Department) {
            $paramhash.filter = "Department -eq '$Department'"
            $ParamHash.properties += "Title", "Department"
        }
        
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting user accounts from $OU"
        $paramhash.SearchBase = $OU

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Connecting to domain controller $($dc.toupper())"
        $paramhash | out-string | Write-Verbose
        Get-ADUser @paramhash
        
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end 

} #close Get-DomainUser

Get-Domainuser -Department sales -Verbose