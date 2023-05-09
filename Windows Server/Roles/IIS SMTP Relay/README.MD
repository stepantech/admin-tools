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


## Vytvoření Inboud connectoru v Exchange Online
```powershell
#Připojení do Exchange Online
Connect-ExchangeOnline -UserPrincipalName <UPN>

#Získání veřejné IP adresy
$PublicIp =  (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

#Vytvoření Connectoru
New-InboundConnector -Name "IIS SMTP Relay" -ConnectorType OnPremises -SenderDomains *.contoso.com -SenderIPAddresses $PublicIP