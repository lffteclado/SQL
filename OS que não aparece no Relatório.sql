SELECT * FROM tbOS WHERE NumeroOROS = 301827
union all
SELECT * FROM tbOS WHERE NumeroOROS = 301809

SELECT * FROM tbOROS WHERE NumeroOROS = 301827
union all
SELECT * FROM tbOROS  WHERE NumeroOROS = 301809

SELECT * FROM tbOROSCIT WHERE NumeroOROS = 301827 and CodigoCIT = 'C1SE'
union all
SELECT * FROM tbOROSCIT  WHERE NumeroOROS = 301809 and CodigoCIT = 'C1SE'

--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-12-04 17:45:00.000' WHERE NumeroOROS = 301827 and CodigoCIT = 'C1SE'
--update tbOROSCIT set NumeroNotaFiscalOS = 307177 WHERE NumeroOROS = 301827 and CodigoCIT = 'C1SE'

--exec dbCardiesel.dbo.whRelOSSituacaoRepresentante 'T','2017-12-01 00:00:00','2017-12-10 23:59:59','2017-12-01 00:00:00','2017-12-10 23:59:59','C1SE','C1SE',930,0,1,0,9999,'          ','ZZZZZZZZZZ'

sp_helptext whRelOSSituacaoRepresentante

301809
301830
301875
301876
301889