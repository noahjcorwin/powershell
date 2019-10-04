$HKLMuninstall86 = Get-ChildItem 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
$installedJAVA86 = @($HKLMuninstall86 | % {Get-ItemProperty $_.pspath | Where DisplayName -like '*Java*'} | Sort-Object -Property Version -Descending)

$HKLMuninstall64 = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
$installedJAVA64 = @($HKLMuninstall64 | % {Get-ItemProperty $_.pspath | Where DisplayName -like '*Java*'} | Sort-Object -Property Version -Descending)

If ($installedJAVA86.Count -ne 0){$TopJava86 = $installedJAVA86[0].DisplayName.Split(" ")[1]+"."+$installedJAVA86[0].DisplayName.Split(" ")[3]}
Else {$TopJava86 = '8.0'}
If ($installedJAVA64.Count -ne 0){$TopJava64 = $installedJAVA64[0].DisplayName.Split(" ")[1]+"."+$installedJAVA64[0].DisplayName.Split(" ")[3]}
Else {$TopJava64 = '8.0'}

$TopJava86
$TopJava64
