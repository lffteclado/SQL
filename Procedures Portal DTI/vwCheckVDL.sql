IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('vwCheckVDL'))
BEGIN
	DROP VIEW dbo.vwCheckVDL
END
GO
CREATE VIEW vwCheckVDL
/*
* VIEW CRIADA PARA FORNECER AS INFORMAÇÕES DE STATUS DO PLANO 526 - ABAIVO DO CUSTO E DESCONTO MINIMO
* AUTOR: MARCOS MORAES
* ATUALIZAÇÃO: 11/09/2017
* MOTIVO: REMANEJAMENTO DA BASE DA REDE MINEIRA PARA O SERVER 192.168.1.166 
* ATUALIZAÇÃO: 02/01/2018
* MOTIVO: REMANEJAMENTO DA BASE DA VALADARES PARA O SERVER 192.168.0.60
* AUTOR: LUÍS FELIPE 
*/
AS
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--		   from dbAutosete.dbo.tbPlanoPagamento ppAs 
--			   inner join dbAutosete.dbo.tbLocal locAS on
--				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--					inner join dbAutosete.dbo.tbLocalFT locFT on
--					locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--					locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--			from dbCalisto.dbo.tbPlanoPagamento ppAs 
--				inner join dbCalisto.dbo.tbLocal locAS on
--				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--					inner join dbCalisto.dbo.tbLocalFT locFT on
--					locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--					locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido collate database_default as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--			from dbCardiesel.dbo.tbPlanoPagamento ppAs 
--				inner join dbCardiesel.dbo.tbLocal locAS on
--				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--					inner join dbCardiesel.dbo.tbLocalFT locFT on
--					locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--					locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all 
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--	   from dbGoias.dbo.tbPlanoPagamento ppAs 
--	   inner join dbGoias.dbo.tbLocal locAS on
--	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--	   inner join dbGoias.dbo.tbLocalFT locFT on
--	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--	   locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--		locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo	   
--	   from dbPostoImperial.dbo.tbPlanoPagamento ppAs 
--	   inner join dbPostoImperial.dbo.tbLocal locAS on
--	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--	   inner join dbPostoImperial.dbo.tbLocalFT locFT on
--	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--	   locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all 
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--	   from dbRedeMineira.dbo.tbPlanoPagamento ppAs 
--	   inner join dbRedeMineira.dbo.tbLocal locAS on
--	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--	   inner join dbRedeMineira.dbo.tbLocalFT locFT on
--	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--	   locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all
--select ppAs.CodigoEmpresa as CodEmpresa,
--	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
--	   locAS.CodigoLocal as Local,	
--	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
--	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
--	   locFT.DescontoMinimoPedido as DescontoMinimo,
--	   locFT.ValorMinimoDesconto as ValorDescMinimo
--	   from dbUberlandia.dbo.tbPlanoPagamento ppAs 
--	   inner join dbUberlandia.dbo.tbLocal locAS on
--	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
--	   inner join dbUberlandia.dbo.tbLocalFT locFT on
--	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
--	   locFT.CodigoLocal = locAS.CodigoLocal
--where ppAs.CodigoPlanoPagamento = '526'
--union all 
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,	
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
	   from dbVadiesel.dbo.tbPlanoPagamento ppAs 
	   inner join dbVadiesel.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbVadiesel.dbo.tbLocalFT locFT on
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
	   locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'
union all 
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,	
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
	   from dbValadares.dbo.tbPlanoPagamento ppAs 
	   inner join dbValadares.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbValadares.dbo.tbLocalFT locFT on
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
	   locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'



