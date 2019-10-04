$execute = 'C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$argument = '-File "C:\scripts\myscript.ps1"'
$taskpath = "\Folder"
$taskname = 'myscript'
$user = 'SYSTEM'
$scheduleObject = New-Object -ComObject schedule.service
$scheduleObject.connect()
Try {$scheduleObject.GetFolder($folder)}
Catch {
    $rootFolder = $scheduleObject.GetFolder("\")
    $rootFolder.CreateFolder($taskpath)
}
$action = New-ScheduledTaskAction -Execute $execute -Argument $argument
$time = New-ScheduledTaskTrigger -Once -At $(Get-Date)
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName $taskname -TaskPath $taskpath -Trigger $time -Action $action -User $user -Settings $settings
Start-ScheduledTask -TaskName "Folder\$taskname"
Unregister-ScheduledTask -TaskName "$taskname" -Confirm:$false
