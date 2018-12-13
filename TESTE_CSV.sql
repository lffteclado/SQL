exec master..xp_cmdshell  'bcp "SELECT CodigoUsuario, NomeUsuario FROM [dbCardiesel].[dbo].[tbUsuarios]" queryout C:\TESTE\bcp_outputTable.CSV -c -t; -T -S SRVSQLDEALER\VDLSQLDB'

--select top 1 * from [dbCardiesel].[dbo].[tbUsuarios]