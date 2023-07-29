# Přenesení nastavení na jiný server

## Export nastavení ze současného serveru
``` Powershell
Export-DhcpServer -ComputerName “servername.domainname.com” -Leases -File “C:\DHCP\OldDHCPConf.xml” –Verbose
```

## Import nastavení na novém serveru
``` Powershell
Import-DhcpServer -Leases –File “C:\DHCP\OldDHCPConf.xml” -BackupPath “C:\DHCP\Backup” –Verbose
```