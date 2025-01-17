add-content -path c:/users/privat/.ssh/config -value @'
Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityfile}
'@
