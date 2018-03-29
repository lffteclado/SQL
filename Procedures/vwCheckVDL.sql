CREATE VIEW vwCheckVDL
/*
* VIEW CRIADA PARA FORNECER AS INFORMAÇÕES DE STATUS DO PLANO 526 - ABAIVO DO CUSTO E DESCONTO MINIMO
* AUTOR: MARCOS MORAES
* ATUALIZAÇÃO: 11/09/2017
* MOTIVO: REMANEJAMENTO DA BASE DA REDE MINEIRA PARA O SERVER 192.168.1.166 
* ATUALIZAÇÃO: 02/01/2018
* MOTIVO: REMANEJAMENTO DA BASE DA VALADARES PARA O SERVER 192.168.0.60
* AUTOR: LUÍS FELIPE 
* ATUALIZAÇÃO: 11/01/2018
* MOTIVO: REMANEJAMENTO DA BASE DA CARDIESEL PARA O SERVER 192.168.0.60
* AUTOR: LUÍS FELIPE 
* ATUALIZAÇÃO: 01/02/2018
* MOTIVO: REMANEJAMENTO DEFINITIVO DE TODAS AS BASES PARA O SERVER 192.168.0.60
* AUTOR: LUÍS FELIPE 
*/
AS
--AUTO SETE
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
		   FROM dbAutosete.dbo.tbPlanoPagamento ppAs 
			   INNER JOIN dbAutosete.dbo.tbLocal locAS ON
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					INNER JOIN dbAutosete.dbo.tbLocalFT locFT ON
					locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
					locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--CALISTO
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
			FROM dbCalisto.dbo.tbPlanoPagamento ppAs 
				INNER JOIN dbCalisto.dbo.tbLocal locAS ON
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					INNER JOIN dbCalisto.dbo.tbLocalFT locFT ON
					locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
					locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--CARDIESEL
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido COLLATE database_default AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
FROM dbCardiesel.dbo.tbPlanoPagamento ppAs 
INNER JOIN dbCardiesel.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
INNER JOIN dbCardiesel.dbo.tbLocalFT locFT ON
       locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--GOIAS
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
	   FROM dbGoias.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbGoias.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbGoias.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--POSTO IMPERIAL
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
		locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo	   
	 FROM dbPostoimperial.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbPostoimperial.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbPostoimperial.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--REDE MINEIRA
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
	   FROM dbRedeMineira.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbRedeMineira.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbRedeMineira.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--UBERLANDIA
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
	   FROM dbUberlandia.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbUberlandia.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbUberlandia.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--VADIESEL
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
	   FROM dbVadiesel.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbVadiesel.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbVadiesel.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
UNION ALL
--VALADARES
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,	
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
	   FROM dbValadares.dbo.tbPlanoPagamento ppAs 
	   INNER JOIN dbValadares.dbo.tbLocal locAS ON
	   locAS.CodigoEmpresa = ppAs.CodigoEmpresa
	   INNER JOIN dbValadares.dbo.tbLocalFT locFT ON
	   locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
	   locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'
--MONTES CLAROS
UNION ALL
SELECT ppAs.CodigoEmpresa AS CodEmpresa,
	   locAS.DescricaoLocal COLLATE database_default AS NomeEmpresa,
	   locAS.CodigoLocal AS Local,
	   ppAs.BloqueadoPlanoPagto COLLATE database_default AS PlanoBloqueio,
	   locFT.DadosEmpresaPreImpresso COLLATE database_default AS VendaAbaixoCusto,
	   locFT.DescontoMinimoPedido AS DescontoMinimo,
	   locFT.ValorMinimoDesconto AS ValorDescMinimo
		   FROM dbMontesClaros.dbo.tbPlanoPagamento ppAs 
			   INNER JOIN dbMontesClaros.dbo.tbLocal locAS ON
				locAS.CodigoEmpresa = ppAs.CodigoEmpresa
					INNER JOIN dbMontesClaros.dbo.tbLocalFT locFT ON
					locFT.CodigoEmpresa = locAS.CodigoEmpresa AND
					locFT.CodigoLocal = locAS.CodigoLocal
WHERE ppAs.CodigoPlanoPagamento = '526'











