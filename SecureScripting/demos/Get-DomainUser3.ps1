#requires -module ActiveDirectory

Return "`nThis is a walkthrough demo you doofus.`n" | Write-Host -ForegroundColor red 

#Using configuration data

Function Get-DomainUser {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = "Enter the path to the psd1 file")]
        [ValidateScript( {Test-Path $_})]
        [string]$ConfigurationData,
        [string]$Department
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

        #import the configuration data into the function
        $config = Import-PowerShellDataFile -Path $ConfigurationData
       
        #use the configuration data values
        $paramhash = @{
            SearchBase = $config.ou
            Server     = "$($config.dc).$($config.domain)"
            Filter     = "*"
            properties = "Name", "SamAccountName", "UserPrincipalName", "Description", "Enabled"
        }

        properties = "Name", "SamAccountName", "UserPrincipalName", "Description", "Enabled"
        if ($Department) {
            $paramhash.filter = "Department -eq '$Department'"
            $paramhash.properties += "Title", "Department"
        }

        
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting user accounts from $($config.ou)"
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Connecting to domain controller $(($config.dc).toupper())"
        $paramhash | out-string | write-verbose
    
        Get-ADUser @paramhash
    
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end 

} #close Get-DomainUser

Get-Domainuser -ConfigurationData C:\scripts\domain.configdata.psd1 -Department sales -Verbose

