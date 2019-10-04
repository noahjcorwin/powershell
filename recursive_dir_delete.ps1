$parent = 'C:\mydir'
Get-ChildItem -Path $parent -Recurse | Where-Object {-not $_.PSIsContainer } | Remove-Item -Force
Remove-Item -Path $parent -Recurse -Force
