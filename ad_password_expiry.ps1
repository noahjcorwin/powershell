$user = 'username'
(Get-ADUser -Identity $user -Properties msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' | ForEach-Object -Process {[datetime]::FromFileTime($_)}
