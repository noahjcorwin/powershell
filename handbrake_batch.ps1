$source = 'C:\source'
$dest = "$source\720p"
​
if(-not(Test-Path $dest)){New-Item -ItemType Directory -Path $dest}
​
$hbcli = "$PSScriptRoot\HandBrakeCLI.exe"
$encoder = 'x264'
$format = 'av_mp4'
$quality = '25'
$framerate = '30'
$audio = 'av_aac'
$maxheight = '720'
​
$filelist = Get-ChildItem -Path $source -File -Recurse | Where-Object -Property FullName -NE $dest
​
$filelist | ForEach-Object {
  $in = $_.FullName
  $out = $in.Replace($source,$dest)
  If($null -ne $_.Directory){ 
    $parent = "$dest$($_.DirectoryName.Replace($source,''))"
    If(-not(Test-Path $parent)){New-Item -ItemType Directory -Path $parent} 
  }
  start-process $hbcli -ArgumentList "-i $in -o $out -e $encoder -f $format -q $quality -E $audio -Y $maxheight -O" -wait
}
