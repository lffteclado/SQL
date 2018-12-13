
xp_cmdshell 'net use /delete I:' 
GO 
xp_cmdshell 'net use I: \\192.168.1.165\IMPORT /user:192.168.1.165\ADMINISTRATOR venus99 /PERSISTENT:YES'  

xp_cmdshell 'net use /delete W:' 
GO
xp_cmdshell 'net use W: \\192.168.1.28\IMPORT_CARDIESEL /user:192.168.1.28\ADMINISTRATOR venus99 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.1.3\IMPORT /user:192.168.1.3\ADMINISTRATOR venus99 /PERSISTENT:YES'  

xp_cmdshell 'net use /delete G:' 
GO 
xp_cmdshell 'net use G: \\192.168.1.30\IMPORT /user:192.168.1.30\ADMINISTRATOR venus99 /PERSISTENT:YES'  

xp_cmdshell 'net use /delete U:' 
GO 
xp_cmdshell 'net use U: \\192.168.1.27\IMPORT /user:192.168.1.27\ADMINISTRATOR venus99 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete N:' 
GO 
xp_cmdshell 'net use N: \\192.168.1.17\IMPORT_AUTOSETE /user:192.168.1.17\ADMINISTRATOR venus99 /PERSISTENT:YES' 


xp_cmdshell 'dir \\192.168.1.3\IMPORT_VALADARES\*.*'

xp_cmdshell 'dir \\192.168.1.30\IMPORT\*.*'

xp_cmdshell 'dir \\192.168.1.165\IMPORT\*.*'

xp_cmdshell 'dir \\192.168.1.28\IMPORT_CARDIESEL\*.*'

xp_cmdshell 'dir \\192.168.1.30\IMPORT\*.*'

xp_cmdshell 'dir \\192.168.1.27\IMPORT\*.*'

xp_cmdshell 'dir \\192.168.1.17\IMPORT_AUTOSETE\*.*'