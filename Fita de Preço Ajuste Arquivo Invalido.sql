--EXECUTE whObtemInfoArqPrecos @VcArqImport = '3140_0000_prcamb0197',@InCodigoEmpresa = 3140

EXECUTE whObtemInfoArqPrecos @VcArqImport = '0930_0000_prcamb0208',@InCodigoEmpresa = 930

--select * from tbEmpresa

xp_cmdshell 'net use /delete X:' 
GO 
xp_cmdshell 'net use X: \\192.168.1.3\IMPORT /user:192.168.1.3\ADMINISTRATOR $$VDL0707@ /PERSISTENT:YES'  

xp_cmdshell 'dir \\192.168.1.3\IMPORT_VALADARES\*.*'