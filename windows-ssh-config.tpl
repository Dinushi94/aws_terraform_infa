add-content -path c:/users/Dinumsi/.ssh/config -value @'

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentifyFile ${identifyFile}
'@