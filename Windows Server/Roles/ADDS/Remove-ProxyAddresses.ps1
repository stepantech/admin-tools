#Searching domain
$domain = "domain.com"

#Get the user with the address you are searching for
$users = Get-ADUser -Filter * -Properties * | Where-Object {$_.ProxyAddresses -like "SMTP:*@$domain"}

#Remove proxy address
foreach ($u in $users) {
    $proxyAddress = $u | Select-Object -ExpandProperty proxyAddresses | Where-Object {$_ -like "SMTP:*$domain"}
    $proxyAddress
    $proxyAddress | ForEach {Set-ADUser $u.SamAccountName -Remove @{ProxyAddresses=$_}}
}
