--exec dbCardiesel.dbo.whRelCGListaLanctosContabeis 930,0,0,'  ','ZZ','2018-02-26 00:00:00','2018-02-28 00:00:00',0,99999999,'A','F'

exec whRelCGListaLanctosContabeis 1200,0,0,'FT','FT','2017-12-01 00:00:00','2018-02-28 23:59:00',0,99999999,'A','F'

--SELECT COUNT (*) FROM tbMovimentoContabil WHERE OrigemLancamentoMovtoContabil = 'CG' AND CodigoLocal = 0

--SELECT TOP 10 * FROM tbMovimentoContabil

--sp_helptext whRelCGListaLanctosContabeis