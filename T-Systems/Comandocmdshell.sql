exec xp_cmdshell 'net use z: \\192.168.1.165\import\IMPORT_LONDRINA /user:master "system4523"'
exec xp_cmdshell 'dir \\192.168.1.165\import\IMPORT_LONDRINA\*'
exec xp_cmdshell 'dir z:\*'
--exec xp_cmdshell 'net use z: /delete'














