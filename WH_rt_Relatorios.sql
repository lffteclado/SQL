exec dbCardiesel_I.dbo.whRelOSSituacao 'A','2015-01-01 00:00:00:000','2015-06-03 23:59:59:000','2015-01-01 00:00:00:000','2015-06-03 23:59:59:000',
'    ','ZZZZ',930,0,1,'          ','ZZZZZZZZZZ','1             ','99999999999999','S',0,99999999,0,9999,'1             ',
'99999999999999','F',NULL,NULL,'V','V','                      ','ZZZZZZZZZZZZZZZZZZZZZZ','                      ',
'ZZZZZZZZZZZZZZZZZZZZZZ'

GO

select Distinct NumeroOROS,CodigoCIT,NomeCliFor,DataAberturaOS,NomeRepresentante,PlacaVeiculoOS,StatusOSCIT
from rtRelOSSituacao 

select * from rtRelOSSituacao where StatusOSCIT = 'A' AND 
DataAberturaOS between'2015-01-01'AND '2015-06-03'


SELECT DISTINCT CI.NumeroOROS AS OS,CI.CodigoCIT AS CIT,CF.NomeCliFor AS CLIENTE,CONVERT(varchar,OS.DataAberturaOS,103) 
AS DATA_ABERTURA,RP.NomeRepresentante AS REPRESENTANTE,VO.PlacaVeiculoOS AS PLACA