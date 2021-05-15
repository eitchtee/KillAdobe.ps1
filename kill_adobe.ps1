# Elevate Powershell if it's not running as admin
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        # Add "-noexit" to ArgmentList if you want the window to stay open after running
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Kill general Adobe processes
Get-Process -Name Adobe* | Stop-Process -Force
Get-Process -Name "Creative Cloud*" | Stop-Process -Force
Get-Process -Name CCLibrary | Stop-Process -Force
Get-Process -Name CCXProcess | Stop-Process -Force
Get-Process -Name CoreSync | Stop-Process -Force

# Stop background services
Get-Service -DisplayName Adobe* | Stop-Service
Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual
