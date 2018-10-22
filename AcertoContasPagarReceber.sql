alter table rtRelCPDoctosPagar alter column NumeroTitulo char(20)
alter table rtRelCRDoctosReceber alter column NoDias numeric(10)


exec dbo.whRelCPDoctosPagar 260,'2018-07-13 00:00:00','F',0,9999,'1900-01-01 00:00:00','9999-12-31 23:59:59','F',0,99,0,99,NULL

exec dbPostoimperial.dbo.whRelCRDoctosReceber 2890,'2018-07-13 00:00:00','F',0,9999,'1900-01-01 00:00:00','2999-12-31 23:59:59','F','F',0,99,0,99,'F','1900-01-01 00:00:00','2999-12-31 23:59:59','    ','ZZZZ',NULL




sp_helptext whRelCPDoctosPagar

(0 linhas afetadas)
Msg 8152, Nível 16, Estado 14, Procedimento dbValadares.dbo.whRelCPDoctosPagar, Linha 38 [Linha de Início do Lote 0]
String or binary data would be truncated.
The statement has been terminated.