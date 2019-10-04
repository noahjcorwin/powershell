$Mac = "1A:2B:3C:4D:5E:6F"
$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_"}
[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect(([System.Net.IPAddress]::Broadcast),7)
$UdpClient.Send($MagicPacket,$MagicPacket.Length)
$UdpClient.Close()

<#
open a rdp session to the console
$sessionid=((quser $env:USERNAME | select -Skip 1) -split '\s+')[2]; tscon $sessionid /dest:console
#>
