select distinct
    CASE WHEN PC.CodigoEmpresa  = '1200' THEN '23738000'
    ELSE NULL
    END as CTCLI,
	 P.NumeroNotaFiscalPed as Nota,
	CASE WHEN CC.DescricaoCentroCusto  = 'PA-VENDAS TELEPECAS' THEN 'TELEPE'
         WHEN CC.DescricaoCentroCusto = 'PA-VENDAS BALCAO' THEN 'BALCAO'
		 WHEN CC.DescricaoCentroCusto = 'OFICINA MECANICA' THEN 'OFICINA'
	     ELSE NULL
	END AS Canal,
 CONVERT(CHAR,P.DataEmissaoNotaFiscalPed,103) as DataNotaFiscal,
CF.NomeCliFor as Nome,CF.TipoCliFor as TipoCliente,
case WHEN LEN(CONVERT(varchar(14),PC.CodigoCliFor)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), PC.CodigoCliFor))) + CONVERT(varchar(11), PC.CodigoCliFor)
       WHEN LEN(CONVERT(varchar(14), PC.CodigoCliFor)) > 11 AND LEN(CONVERT(varchar(14), PC.CodigoCliFor)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), PC.CodigoCliFor))) + CONVERT(varchar(14), PC.CodigoCliFor) 
       end as Cliente,
CF.CEPCliFor as CEP,CF.MunicipioCliFor as cidade,MU.UF as Estado, CF.DDDTelefoneCliFor as DDD, CF.TelefoneCliFor as Telefone_Principal,
CASE WHEN FC.NumeroChassi  IS NULL THEN ' '
ELSE NULL
END AS Chassi,
CASE WHEN FC.ModeloVeiculo IS NOT NULL THEN '' 
ELSE NULL
END as Modelo,
CASE WHEN FC.AnoFabricacaoFrotaCliente IS NOT NULL THEN ''
ELSE NULL
END as Ano,
CASE WHEN FC.PlacaVeiculo  IS NULL THEN ' '
ELSE NULL
END AS Placa,
CASE WHEN IP.CodigoProduto  IS NULL THEN 'MEC'
ELSE IP.CodigoProduto
END AS CodigoProduto,
Replace (IP.QtdeLancamentoItemDocto, ',','.') as QuantidadeItenVendidos,
Replace (IP.ValorBaseICMS3ItemDocto, ',','.') as Valor,
R.CodigoRepresentante as codigo_externo
from tbPedidoComplementar AS PC INNER JOIN  tbRepresentantePedido as RP 
ON PC.NumeroPedido = RP.NumeroPedido inner join tbPedidoTK as PT on PC.NumeroPedido = PT.NumeroPedido 
inner join tbPedido as P on PC.NumeroPedido = P.NumeroPedido inner join tbRepresentanteComplementar as R 
on RP.CodigoRepresentante = R.CodigoRepresentante inner join tbCentroCusto as CC on PC.CentroCusto = CC.CentroCusto
inner join tbCliFor as CF on PC.CodigoCliFor = CF.CodigoCliFor inner join tbMunicipio as MU on CF.MunicipioCliFor = MU.Municipio 
inner join tbItemDocumento as IP on PC.NumeroNFTemporaria = IP.NumeroDocumento inner join tbFrotaCliente as FC on 
PC.CodigoCliFor = FC.NumeroClientePotencialEfetivo
WHERE P.DataEmissaoNotaFiscalPed between '2015-06-12 00:00:00.000' and '2015-06-15 00:00:00.000'and P.CentroCusto in 
(20410,21310,21320,21330) and PC.DataDocumento = IP.DataDocumento
group by PC.CodigoEmpresa,P.NumeroNotaFiscalPed,CC.DescricaoCentroCusto,P.DataEmissaoNotaFiscalPed,
IP.ValorBaseICMS3ItemDocto,CF.NomeCliFor,CF.TipoCliFor,PC.CodigoCliFor,CF.CEPCliFor,CF.MunicipioCliFor,MU.UF,
CF.DDDTelefoneCliFor,CF.TelefoneCliFor,FC.NumeroChassi,FC.ModeloVeiculo,FC.AnoFabricacaoFrotaCliente,FC.PlacaVeiculo,IP.CodigoProduto,
IP.QtdeLancamentoItemDocto,R.CodigoRepresentante

select * from tbPedidoComplementar WHERE NumeroNFTemporaria = 19

select * from  tbItemDocumento where NumeroDocumento = 6920 and EntradaSaidaDocumento = 'S' ValorBaseICMS3ItemDocto

select * from  tbItemDocumento where NumeroDocumento = 6916

select * from tbCentroCusto

select * from tbPedidoComplementar where NumeroDocumento = 6920

select * from tbPedidoComplementar where NumeroDocumento = 6916

select * from sysobjects where name like '%tbO%' 

select * from tbOROSCITComplementar



CASE WHEN FC.NumeroChassi  = 'NULL' THEN ' '
 ELSE NULL
END AS Chassi,

Quantidade Itens Vendidos select Replace([credito],'.',',') from [cdi_calculo

Replace (IP.QtdeLancamentoItemDocto, '.',',') as QuantidadeItenVendidos,