CREATE VIEW vwCheckVDL
as
select ppAs.CodigoEmpresa as CodEmpresa,
	   locAS.DescricaoLocal collate database_default as NomeEmpresa,
	   locAS.CodigoLocal as Local,
	   ppAs.BloqueadoPlanoPagto collate database_default as PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso collate database_default as VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido as DescontoMinimo,
	   locFT.ValorMinimoDesconto as ValorDescMinimo
		   from dbMontesClaros.dbo.tbPlanoPagamento ppAs 
			   inner join dbMontesClaros.dbo.tbLocal locAS on
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					inner join dbMontesClaros.dbo.tbLocalFT locFT on
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
	   from dbRedeMineira.dbo.tbPlanoPagamento ppAs 
	   inner join dbRedeMineira.dbo.tbLocal locAS on
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   inner join dbRedeMineira.dbo.tbLocalFT locFT on
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa and
	   locFT.CodigoLocal = locAS.CodigoLocal
where ppAs.CodigoPlanoPagamento = '526'