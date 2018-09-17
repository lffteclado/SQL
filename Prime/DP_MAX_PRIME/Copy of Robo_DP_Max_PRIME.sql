select distinct P.NumeroNotaFiscalPed as Nota,
	CASE WHEN CC.DescricaoCentroCusto  = 'PA-VENDAS TELEPECAS' THEN 'TELEPE'
         WHEN CC.DescricaoCentroCusto = 'PA-VENDAS BALCAO' THEN 'BALCAO'
	     ELSE NULL
	END AS Canal,
 CONVERT(CHAR,P.DataEmissaoNotaFiscalPed,103) as DataNotaFiscal,
CF.TipoCliFor as TipoCliente,CF.NomeCliFor as Nome,
case WHEN LEN(CONVERT(varchar(14),PC.CodigoCliFor)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), PC.CodigoCliFor))) + CONVERT(varchar(11), PC.CodigoCliFor)
       WHEN LEN(CONVERT(varchar(14), PC.CodigoCliFor)) > 11 AND LEN(CONVERT(varchar(14), PC.CodigoCliFor)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), PC.CodigoCliFor))) + CONVERT(varchar(14), PC.CodigoCliFor) 
       end as Cliente,
CF.CEPCliFor as CEP,CF.MunicipioCliFor as cidade,MU.UF as Estado, CF.DDDTelefoneCliFor as DDD, CF.TelefoneCliFor as Telefone_Principal,
CASE WHEN FC.NumeroChassi  IS NULL THEN ' '
ELSE NULL
END AS Chassi,
FC.ModeloVeiculo as Modelo,FC.AnoFabricacaoFrotaCliente as Ano,
CASE WHEN FC.PlacaVeiculo  IS NULL THEN ' '
ELSE NULL
END AS Placa,
CASE WHEN IP.CodigoProduto  IS NULL THEN ' '
ELSE IP.CodigoProduto
END AS CodigoProduto,
Replace (IP.QtdeLancamentoItemDocto, '.',',') as QuantidadeItenVendidos,
IT.PrecoBrutoItDocFT as Valor,R.CodigoRepresentante as codigo_externo
from tbPedidoComplementar AS PC INNER JOIN  tbRepresentantePedido as RP 
ON PC.NumeroPedido = RP.NumeroPedido inner join tbPedidoTK as PT on PC.NumeroPedido = PT.NumeroPedido 
inner join tbPedido as P on PC.NumeroPedido = P.NumeroPedido inner join tbRepresentanteComplementar as R 
on RP.CodigoRepresentante = R.CodigoRepresentante inner join tbCentroCusto as CC on PC.CentroCusto = CC.CentroCusto
inner join tbCliFor as CF on PC.CodigoCliFor = CF.CodigoCliFor inner join tbMunicipio as MU on CF.MunicipioCliFor = MU.Municipio 
inner join tbItemDocumento as IP on PC.NumeroNFTemporaria = IP.NumeroDocumento inner join tbItemDocumentoFT as IT 
on PC.NumeroDocumento = IT.NumeroDocumento inner join tbFrotaCliente as FC on 
PC.CodigoCliFor = FC.NumeroClientePotencialEfetivo
WHERE P.DataEmissaoNotaFiscalPed between '2013-01-01 00:00:00.000' and '2013-12-31 00:00:00.000'and P.CentroCusto in 
(20410,21310,21320,21330) and PC.DataDocumento = IP.DataDocumento and PC.DataDocumento = IT.DataDocumento 
group by P.NumeroNotaFiscalPed,CC.DescricaoCentroCusto,P.DataEmissaoNotaFiscalPed,
IT.PrecoBrutoItDocFT,CF.TipoCliFor,CF.NomeCliFor,PC.CodigoCliFor,CF.CEPCliFor,CF.MunicipioCliFor,MU.UF,
CF.DDDTelefoneCliFor,CF.TelefoneCliFor,FC.NumeroChassi,FC.ModeloVeiculo,FC.AnoFabricacaoFrotaCliente,FC.PlacaVeiculo,IP.CodigoProduto,
IP.QtdeLancamentoItemDocto,R.CodigoRepresentante

select * from tbPedidoComplementar WHERE NumeroNFTemporaria = 19

select * from  tbItemDocumento

select * from tbItemDocumentoFT

select * from tbCliForFisica



CASE WHEN FC.NumeroChassi  = 'NULL' THEN ' '
 ELSE NULL
END AS Chassi,

Quantidade Itens Vendidos select Replace([credito],'.',',') from [cdi_calculo

Replace (IP.QtdeLancamentoItemDocto, '.',',') as QuantidadeItenVendidos,