CREATE VIEW vwCheckVDL
/*
* VIEW CRIADA PARA FORNECER AS INFORMAÇÕES DE STATUS DO PLANO 526 - ABAIVO DO CUSTO E DESCONTO MINIMO
* AUTOR: MARCOS MORAES
* ATUALIZAÇÃO: 11/09/2017
* MOTIVO: REMANEJAMENTO DA BASE DA REDE MINEIRA PARA O SERVER 192.168.1.166 
*/
AS
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
		   from dbAutosete.dbo.tbPlanoPagamento ppAs 
			   inner join dbAutosete.dbo.tbLocal locAS on
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					inner join dbAutosete.dbo.tbLocalFT locFT on
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
			from dbCalisto.dbo.tbPlanoPagamento ppAs 
				inner join dbCalisto.dbo.tbLocal locAS on
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					inner join dbCalisto.dbo.tbLocalFT locFT on
					locFT.CodigoEmpresa = locAS.CodigoEmpresa and
					locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'
union all
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,	
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido collate database_default as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
			from dbCardiesel_I.dbo.tbPlanoPagamento ppAs 
				inner join dbCardiesel_I.dbo.tbLocal locAS on
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					inner join dbCardiesel_I.dbo.tbLocalFT locFT on
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
	   from dbGoias.dbo.tbPlanoPagamento ppAs 
	   inner join dbGoias.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbGoias.dbo.tbLocalFT locFT on
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
	   from dbPostoImperialDP.dbo.tbPlanoPagamento ppAs 
	   inner join dbPostoImperialDP.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbPostoImperialDP.dbo.tbLocalFT locFT on
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
	   locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'
union all 
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
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,	
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
	   from dbUberlandia.dbo.tbPlanoPagamento ppAs 
	   inner join dbUberlandia.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbUberlandia.dbo.tbLocalFT locFT on
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
	   from dbValadaresCNV.dbo.tbPlanoPagamento ppAs 
	   inner join dbValadaresCNV.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbValadaresCNV.dbo.tbLocalFT locFT on
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
	   locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'


