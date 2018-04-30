---Relação de clientes que compraram(apenas notas de saida) nos ultimos 5 anos

select C.CodigoCliFor,C.NomeCliFor,C.MunicipioCliFor,M.UF,
CASE WHEN C.EmailCliFor is null THEN ''
ELSE C.EmailCliFor
END EmailCliFor,
CASE WHEN C.EmailNFe  is null THEN ''
ELSE C.EmailNFe 
END EmailNFe
from tbCliFor as C
inner join tbDocumentoNFe as DN ON C.CodigoCliFor = DN.CodigoCliFor inner join tbMunicipio as M ON C.MunicipioCliFor = M.Municipio
WHERE C.ClienteAtivo = 'V' and DataDocumento between '2010-06-15 00:00:00.000' and '2015-06-15 00:00:00.000' 
and DN.EntradaSaidaDocumento = 'S'
