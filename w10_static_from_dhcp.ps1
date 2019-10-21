$path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$name = 'SearchList'
$dd = 'defaultdomain.com'
$searchlist = (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue).SearchList
switch ($searchlist) {
    ''                             { $searchlist = $value }
    {$searchlist -notmatch $value} { $searchlist = $searchlist+","+$value }
}
New-ItemProperty -Path $path -Name $name -Value $value -PropertyType String -Force

$ii = (Get-DnsClient | Where-Object ConnectionSpecificSuffix -EQ $dd).InterfaceIndex
$nipa = Get-NetIPAddress -InterfaceIndex $ii -AddressFamily IPv4
$nipc = Get-NetIPConfiguration -InterfaceIndex $ii
$dcsa = Get-DnsClientServerAddress -InterfaceIndex $ii -AddressFamily IPv4

$ip = [string]$nipa.IPv4Address
$pl = [int]$nipa.PrefixLength
$gw = ($nipc | ForEach-Object IPv4DefaultGateway).NextHop
$dsa = $dcsa.ServerAddresses

$objcount = ($ii | Measure-Object).Count
If ($objcount -eq 1){

    Start-Job -ArgumentList @($ii,$ip,$pl,$gw,$dsa,$dd) -ScriptBlock {
	
        param ($ii,$ip,$pl,$gw,$dsa,$dd)
        Set-DnsClientServerAddress -InterfaceIndex $ii -ServerAddresses $dsa
        Set-NetIPInterface -InterfaceIndex $ii -DHCP Disabled
        Get-NetAdapter -InterfaceIndex $ii | Remove-NetIPAddress -Confirm:$false
        New-NetIpAddress -InterfaceIndex $ii -IPAddress $ip -DefaultGateway $gw -PrefixLength $pl -AddressFamily IPv4
        Set-DnsClient -InterfaceIndex $ii -ConnectionSpecificSuffix $dd

    } | Wait-Job
}
Else { Write-Output "Failed to set static ip from DHCP" | Out-File 'C:\Users\Public\Desktop\STATIC IP FAILED.txt' -Encoding default }
