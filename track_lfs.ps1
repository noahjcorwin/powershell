$size = 5 
$chunk = 1MB
Get-ChildItem -recurse | Where-Object {($_.Length /$chunk) -gt $size} | Resolve-Path -Relative | ForEach-Object { git LFS track $_ }
