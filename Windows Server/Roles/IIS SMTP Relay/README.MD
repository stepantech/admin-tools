# Instalace IIS Simple SMTP

1) Instalace SMTP role
```powershell
Install-WindowsFeature -Name SMTP-Server -IncludeAllSubFeature -IncludeManagementTools -Restart
```

2) Nastavení služby na Automatické spuštění po restartu
```powershell
Set-Service SMTPSVC -StartupType Automatic
Get-Service SMTPSVC | Select Name, Status, StartType
```