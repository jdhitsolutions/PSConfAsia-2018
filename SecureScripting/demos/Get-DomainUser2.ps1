Return "`nThis is a walkthrough demo you doofus.`n" | Write-Host -ForegroundColor red 

#better approaches instead of relying on hard coded values
# set as parameter values

#requires -module ActiveDirectory

Function Get-DomainUser {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$OU,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Domain,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DC,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Department
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #default properties to display
        $properties = "Name", "SamAccountName", "UserPrincipalName", "Description", "Enabled"
               
    } #begin

    Process {

        $paramhash = @{
            SearchBase = $null
            Server     = "$($dc).$($domain)"
            Filter     = "*"
            Properties = $properties
        }

        
        if ($Department) {
            $paramhash.filter = "Department -eq '$Department'"
            $paramhash.properties += "Title", "Department"
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting user accounts from $OU"
        $paramhash.SearchBase = $OU

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Connecting to domain controller $($dc.toupper())"
        $paramhash | out-string | write-verbose
        Get-ADUser @paramhash
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end 

} #close Get-DomainUser

$data = @"
"OU","Domain","DC"
"OU=Employees,DC=company,DC=pri","company.pri","dom1"
"@

$data | ConvertFrom-Csv | Get-Domainuser -Verbose -Department sales | 
    Select Name, Title, Department

#or use PSDefaultParameterValues
$PSDefaultParameterValues.Add("Get-DomainUser:OU", "OU=Employees,DC=company,DC=pri")
$PSDefaultParameterValues.Add("Get-DomainUser:Domain", "company.pri")
$PSDefaultParameterValues.Add("Get-DomainUser:DC", "dom1")

get-domainuser -Department manufacturing