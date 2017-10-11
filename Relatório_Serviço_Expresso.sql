SELECT nome_Cliente AS 'Cliente',
	   numeroOS AS 'OS',
	   CIT,
	   data_Inicial AS 'Data/Hora Inicial',
	   data_final AS 'Data/Hora Final',
	   Box
FROM tbClienteAcompEXP
WHERE CodigoEmpresa = 930
AND CodigoLocal = 0
--and data_Inicial between '2017-09-01 00:00:00.000' and '2017-09-30 23:59:59.999'