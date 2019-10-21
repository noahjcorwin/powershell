$ii = 1 ### known interface index ###
$ip = '192.168.1.100'
$gw = '192.168.1.1'
$mask = '255.255.255.0'
$adapter = Get-WmiObject win32_networkadapterconfiguration -filter "InterfaceIndex = $ii"
$dns = @('192.168.1.1','8.8.8.8'.'1.1.1.1')
$adapter.SetDNSServerSearchOrder($dns)
$adapter.EnableStatic($ip,$mask)
$adapter.SetGateways($gw,1)
