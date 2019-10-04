$unpack = "${$PSScriptRoot}\unpack"
$7z = (Get-Command 7z.exe -ErrorAction SilentlyContinue).source

If ($null -eq $7z){"7zip is not installed";Break}
if(!(Test-Path $unpack)){New-Item -ItemType Directory -Path $unpack}

$isos = Get-ChildItem -Path $eq | Where-Object Extension -eq '.iso' | Select-Object -Property FullName
$isos | ForEach-Object { Invoke-Expression -Command "& `"$7z`" x $($_.FullName) -o${unpack} -aos" }
