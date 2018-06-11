--import_autosete (\\192.168.0.58)
--import_calisto (\\192.168.0.58)
--import_montesclaros (\\192.168.0.58)
--import_cardiesel (\\192.168.0.58)
--temp_calisto (\\192.168.0.58)
--import_montesclaros
--192.168.0.58\import_valadares


xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_calisto /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete Z:' 
GO 
xp_cmdshell 'net use Z: \\192.168.0.58\temp_calisto /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_autosete /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_imperial /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_montesclaros /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_cardiesel /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_montesclaros /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.0.58\import_valadares /user:192.168.0.58\admin !matrix16 /PERSISTENT:YES' 



xp_cmdshell 'dir \\192.168.0.58\import_calisto\*.*'

xp_cmdshell 'dir \\192.168.0.58\temp_calisto\*.*'

xp_cmdshell 'dir \\192.168.0.58\import_imperial\*.*'

xp_cmdshell 'dir \\192.168.0.58\import_montesclaros\*.*'

xp_cmdshell 'dir \\192.168.0.58\import_valadares\*.*'

         