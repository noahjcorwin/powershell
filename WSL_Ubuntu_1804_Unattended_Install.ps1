[CmdletBinding(DefaultParameterSetName = "install")]
Param(
    [Parameter(ParameterSetName = "install", Mandatory = $True, HelpMessage = "Enter username")]$user,
    [Parameter(ParameterSetName = "install", Mandatory = $True, HelpMessage = "Enter password")]$pass,
    [switch][Parameter(ParameterSetName = "clean", Mandatory = $True)]$clean
)

function Install-WSL1804 {
    ### UNATTENDED 1804 WSL INSTALL ###
    $1804 = 'https://aka.ms/wsl-ubuntu-1804' ### UBUNTU 18.04 DIRECT LINK ###
    $OutFile = 'C:\WSL\ubuntu1804.appx'
    $OutFileZip = $OutFile.Replace('appx', 'zip')
    $DestinationPath = 'C:\WSL\Ubuntu1804\'

    If ((Test-Path -Path 'C:\WSL') -ne $true) {New-Item -ItemType Directory -Name 'WSL' -Path 'C:\'}
    Start-BitsTransfer -Source $1804 -Destination $OutFile
    Move-Item $OutFile -Destination $OutFileZip
    Expand-Archive $OutFileZip -DestinationPath $DestinationPath
    Remove-Item -Path $OutFileZip

    Start-Process "$DestinationPath\ubuntu1804.exe" -ArgumentList "install --root" -Wait
    Start-Process "$DestinationPath\ubuntu1804.exe" -ArgumentList "run adduser $user --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password" -Wait
    Start-Process "$DestinationPath\ubuntu1804.exe" -ArgumentList "run echo `'${user}:${pass}`' | sudo chpasswd" -Wait
    Start-Process "$DestinationPath\ubuntu1804.exe" -ArgumentList "run usermod -aG sudo $user" -Wait
    Start-Process "$DestinationPath\ubuntu1804.exe" -ArgumentList "config --default-user $user" -Wait
}

function Remove-WSL {
    ### WSL CLEAN UP ###
    $WSL = 'C:\WSL'
    Get-ChildItem -Path $WSL -Recurse | Where-Object {-not $_.PSIsContainer } | Remove-Item -Force
    Remove-Item -Path $WSL -Recurse -Force

    Get-ChildItem 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss' | Remove-Item   
    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss' -Name DefaultDistribution
}

If(-not ($null -eq $user)){ Install-WSL1804 }
Else { If($clean.IsPresent){ Remove-WSL } }
