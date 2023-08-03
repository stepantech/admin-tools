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

### Windows Server 2022 oprava
ve Windows Server 2022 je chyba a po odeslání emailu služba havaruje

#### Oprava
1) Zastav služby *Simple Mail Transfer Protocol (SMTP)* a *IIS Admin Service service*
2) Jako Administrator otevři C:\Windows\System32\inetsrv\MetaBase.xml v Poznámkovém bloku
   1) Najdi řádek **<IIsSmtpServer Location ="/LM/SmtpSvc/1"** (jednička nakonci je důležitá)
   2) Přidej řádek **RelayIpList=""**
   2) Ulož změny
3) Nastartuj služby *Simple Mail Transfer Protocol (SMTP)* a *IIS Admin Service service*
4) **Důležité:** v *IIS 6.0 Manager* klikni pravým tlačítkem myši na [SMTP Virtual Server #1] -> Properties -> Advanced
   1) Klikni na tlačítko **Connection** a hned potom na OK, stejně s **Relay**
5) Klikni na OK a zavři [SMTP Virtual Server #1] okno

## Vytvoření Inboud connectoru v Exchange Online
```powershell
#Připojení do Exchange Online
Connect-ExchangeOnline -UserPrincipalName <UPN>

#Získání veřejné IP adresy
$PublicIp =  (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

#Vytvoření Connectoru
New-InboundConnector -Name "IIS SMTP Relay" -ConnectorType OnPremises -SenderDomains *.contoso.com -SenderIPAddresses $PublicIP