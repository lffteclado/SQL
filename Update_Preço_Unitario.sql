SELECT DISTINCT CI.NumeroOROS AS OS,CI.CodigoCIT AS CIT,CF.NomeCliFor AS CLIENTE,CONVERT(varchar,OS.DataAberturaOS,103) 
AS DATA_ABERTURA,RP.NomeRepresentante AS REPRESENTANTE,VO.PlacaVeiculoOS AS PLACA
FROM    tbOROSCIT AS CI
INNER JOIN tbOROS AS OS ON CI.NumeroOROS = OS.NumeroOROS
INNER JOIN tbCliFor AS CF ON CI.CodigoCliFor = CF.CodigoCliFor
INNER JOIN tbRepresentanteComplementar AS RP ON CI.CodigoRepresentante = RP.CodigoRepresentante
INNER JOIN tbVeiculoOS AS VO ON OS.ChassiVeiculoOS = VO.ChassiVeiculoOS
INNER JOIN tbProgramacaoOficinaPO AS PO ON CI.NumeroOROS = PO.NumeroOROS
WHERE  CI.StatusOSCIT = 'A' AND OS.DataAberturaOS BETWEEN '03-05-2015' AND '03-06-2015' AND 
CI.FlagOROS = 'S' AND CI.CodigoCIT != 'P1'
AND CI.DataEncerramentoOSCIT IS NULL
ORDER  BY CI.NumeroOROS

SELECT * FROM tbOSCIT WHERE StatusOSCIT = 'A' and 


SELECT DISTINCT CI.NumeroOROS AS OS,CI.CodigoCIT AS CIT,CF.NomeCliFor AS CLIENTE,CONVERT(varchar,OS.DataAberturaOS,103) 
AS DATA_ABERTURA,RP.NomeRepresentante AS REPRESENTANTE,VO.PlacaVeiculoOS AS PLACA
FROM    tbOROSCIT AS CI
INNER JOIN tbOROS AS OS ON CI.NumeroOROS = OS.NumeroOROS
INNER JOIN tbOS AS O ON CI.NumeroOROS = O.NumeroOROS
INNER JOIN tbCliFor AS CF ON CI.CodigoCliFor = CF.CodigoCliFor
INNER JOIN tbRepresentanteComplementar AS RP ON CI.CodigoRepresentante = RP.CodigoRepresentante
INNER JOIN tbVeiculoOS AS VO ON OS.ChassiVeiculoOS = VO.ChassiVeiculoOS
INNER JOIN tbProgramacaoOficinaPO AS PO ON CI.NumeroOROS = PO.NumeroOROS
WHERE  CI.StatusOSCIT = 'A' AND O.StatusOS = 'A' and OS.DataEntradaVeiculoOS between'2013-01-01'AND '2015-06-03' and
CI.FlagOROS = 'S' AND O.FlagOROS = 'S' AND CI.CodigoCIT != 'P1' and CI.NumeroOROS = O.NumeroOROS 
AND CI.DataEncerramentoOSCIT IS NULL AND OS.DataEncerramentoOS IS NULL
ORDER BY CI.NumeroOROS,CI.CodigoCIT

select * from sysobjects where name like '%tbO%' 

select * from tbOROSCIT where NumeroOROS = 278832

SELECT * FROM tbOROS where NumeroOROS = 278832

select * from tbOROS