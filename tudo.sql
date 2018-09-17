--apontamento travadado
select * from tbApontamentoPendentePO

delete from tbApontamentoPendentePO

select * from tbDocumentoNFe where NumeroDocumento = 304477

select * from tbDMSTransitoNFe where NumeroDocumento = 304477

select * from tbLocal

select * from sysobjects where name like 'tb%Servi%'


select * from tbTipoServicoNFSE

/* sp_spaceused tbProdutoFT tamanho da tabela (KB) e total de linhas  */

--encontrar um funcionário
select tbColaboradorGeral where NumeroRegistro = '3327'

select XmlNFE,NumeroDocumento from tbDMSTransitoNFe 
								  where CodigoCliFor = '22144554000103' 
								  and DataGeracaoXML between '2016-01-27' and '2016-01-28' 
					                          and NumeroDocumento = 55611

--XML de Nota Parada no Gerenciador
select XmlNFE from tbDMSTransitoNFe where NumeroDocumento like '%69063%' for xml path

--Notas Paradas no Gerenciador
select * from tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'


select top (2) XmlNFE, NumeroDocumento from tbDMSTransitoNFe

--Cliente com Crédito Bloqueado no Modulo Veículos
select BloqueioVendaVeiculoFloorPlan, * from tbClienteCredito where BloqueioVendaVeiculoFloorPlan = 'F' and CodigoCliFor = '13290620000154' and CodigoEmpresa = 930
-- update tbClienteCredito set BloqueioVendaVeiculoFloorPlan = 'F' where CodigoCliFor = '13290620000154' and CodigoEmpresa = 930
-- update tbClienteCredito set BloqueioVendaVeiculo = 'F' where CodigoCliFor = '13290620000154' and CodigoEmpresa = 930

--Desconto Invisivel
-- update tbPlanoPagamento set DescontoInvisivelPlanoPagto = 'F' where CodigoPlanoPagamento = '511'
select DescontoInvisivelPlanoPagto from tbPlanoPagamento where CodigoPlanoPagamento = '511'

/* Alterar Preço Unitátio Pedido */

--update tbItemPedido set PrecoUnitarioItemPed = '' where CodigoItemPed =  CodigoEmpresa = '' and CodigoLocal =  and CentroCusto =  and NumeroPedido = ''

--select * from vwCheckVDL

sp_helpuser


--BEGIN TRANSACTION
--GO
--update tempProdutoImportados set Tipo = 'F' where Codigo = 'A9400000399'

--COMMIT TRANSACTION/* SEM O COOMMIT TRANSACTION CONSEGUE FAZER O ROLLBACK */

--ROLLBACK /* DESFAZER A ULTIMA AÇÃO REALIZADA CASO NÃO TENHA USADO O COMMIT TRANSACTION */

select * from tbFormulariosSistema where CodigoSistema = 'CE' and DescricaoFormulario like '%Pesquisa%'

--select * from tbLogOrderDelete where NumeroPedido = '237022'
--select * from tbLogRequestItemDelete where NumeroPedido = '237022'

select * from tbRegraContabilFP where CCustoContabilRegraFP = 0


--select * from tbApontamentoPendentePO

--delete from tbApontamentoPendentePO

--select * from tbDocumento where CodigoCliFor = 7284321200656

--select * from sysobjects where name like 'tb%egraContabil%'

--select CodigoUsuario, NomeUsuario, UsuarioAtivo from tbUsuarios where UsuarioAtivo = 'V'

--select CodigoUsuario, NomeUsuario, UsuarioAtivo from tbUsuarios where NomeUsuario like 'R%'

sp_helptext sp_AcertoPlanoVDL

select * from tbPlanoPagtoVDL

-- insert into tbPlanoPagtoVDL (Cont,CodPlano, PerPlano) values (22, '920', 14.40)

sp_help tbPlanoPagtoVDL 

-- execute sp_AcertoPlanoVDL

/* Liberar OS encerrada para transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'A' where CodigoEmpresa = 2620 and CodigoLocal = 0 and NumeroOROS = 147328 and CodigoCIT = 'CN'

alter table tbOROSCIT enable trigger tnu_DSPa_StatusOSCIT

*/

/*Bloquear OS encerrada para transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'N' where CodigoEmpresa = 2620 and CodigoLocal = 0 and NumeroOROS = 147328 and CodigoCIT = 'CN'

alter table tbOROSCIT enable trigger tnu_DSPa_StatusOSCIT

*/


/* Lote com NF emitida mas em aberto
update tbFichaControlePedidoCapa set NotaFiscal = 70372, DataNotaFiscal = '2017-05-15', NotaFiscalPecas = 663581, DataNotaFiscalPecas = '2017-05-15' where CodigoEmpresa = 2620 and CodigoLocal = 0 and NumeroLote = 14407
*/


--********************************************************************


-- create VIEW vwCheckVDL
as
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
union all
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


select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B084167N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B437318N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B031310N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B2066'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B233593N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B549129N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B624698N'
select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'B742756N'

sp_help spLFichaControlePedidoItem tbFichaControlePedidoItem
select * from sysobjects where name like 'tb%ControlePedido%'
select * from tbFichaControlePedidoFicha where NumeroLote
select * from tbFichaControlePedidoCapa where NumeroPedidoPecas = '194556'
where Descricao like '%BANDA%' - XZU2%

--Localizar o codigo de uma tela

--select * from tbFormulariosSistema where CodigoSistema = 'FP'
--select * from tbFormulariosSistema where DescricaoFormulario  like '%eiculo%'



--Utilizando susbtring
 select tbCC.CodigoCliFor, 
		tbCF.NomeCliFor,
		tbCC.CodigoPlanoPagamento 
		from tbClienteComplementar tbCC
		inner join tbCliFor tbCF on
		tbCF.CodigoCliFor = tbCC.CodigoCliFor
		 where substring (tbCC.CodigoPlanoPagamento,1,1) = 8