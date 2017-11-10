--EXECUTE whObtemInfoArqPrecos @VcArqImport = '3140_0000_prcamb0197',@InCodigoEmpresa = 3140

EXECUTE whObtemInfoArqPrecos @VcArqImport = '0262_0000_prcamb0138',@InCodigoEmpresa = 130

--select * from tbEmpresa

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.1.3\IMPORT /user:192.168.1.3\ADMINISTRATOR $$VDL0707@ /PERSISTENT:YES'  

xp_cmdshell 'dir \\192.168.1.3\IMPORT_VALADARES\*.*'