create procedure [dbo].[testespDesconto]
@DataInicial datetime,
@DataFinal  datetime

as

/* dbCardiesel */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLCar
		from dbCardiesel.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbAutoSete */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLAut
		from dbAutosete.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbCalisto */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLCal
		from dbCalisto.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbGoias */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLGoi
		from dbGoias.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbPostoimperial */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLPos
		from dbPostoimperial.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbRedeMineira */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLRed
		from dbRedeMineira.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbUberlandia */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLUbe
		from dbUberlandia.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbVadiesel */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLVad
		from dbVadiesel.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor
/* dbValadares */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLVal
		from dbValadares.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor

/* dbMontesClaros */
select NumeroDocumento,DataDocumento,CodigoCliFor,datediff(day,min(DataDocumento),max(DataVenctoDoctoRecPag)) as Prazo into #tmpRecVDLVal
		from dbMontesClaros.dbo.tbDoctoRecPag where DataDocumento between @DataInicial and @DataFinal
		and EntradaSaidaDocumento = 'S'
		group by NumeroDocumento,DataDocumento,CodigoCliFor



select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbCardiesel.dbo.tbDocumento tbDoc 
	inner join dbCardiesel.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLCar tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
		

union all



select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbAutosete.dbo.tbDocumento tbDoc 
	inner join dbAutosete.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLAut tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all

select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbCalisto.dbo.tbDocumento tbDoc 
	inner join dbCalisto.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLCal tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbGoias.dbo.tbDocumento tbDoc 
	inner join dbGoias.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLGoi tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbPostoimperial.dbo.tbDocumento tbDoc 
	inner join dbPostoimperial.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLPos tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbRedeMineira.dbo.tbDocumento tbDoc 
	inner join dbRedeMineira.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLRed tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbUberlandia.dbo.tbDocumento tbDoc 
	inner join dbUberlandia.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLUbe tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbVadiesel.dbo.tbDocumento tbDoc 
	inner join dbVadiesel.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLVad tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')
union all
select	tbDoc.CodigoEmpresa ,
		tbDoc.CodigoLocal,
		tbDoc.NumeroDocumento,
		tbDoc.DataDocumento,
		tbDoc.CodigoCliFor,
		tbDoc.ValorContabilDocumento,
		case 
			when (tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento <> 0 )
			then (tbDoc.TotalDescontoDocumento * 100)/tbDoc.ValorContabilDocumento
			when ( tbPed.PercDescontoPed = 0 and tbDoc.TotalDescontoDocumento = 0 and tbPed.TotalDescontoPecasPed <> 0)
				then (tbPed.TotalDescontoPecasPed * 100)/tbDoc.ValorContabilDocumento
				else
			tbPed.PercDescontoPed
		end as Desconto,
		tbTmp.Prazo,
		tbDoc.TotalDescontoDocumento,
		tbPed.PercDescontoPed,
		tbPed.PercDescontoPecasPed,
		tbPed.PercDescontoServicosPed,
		tbPed.PercDescontoCombLubPed,
		tbPed.TotalDescontoPecasPed,
		tbPed.TotalDescontoCombLubrifPed,
		tbPed.TotalDescontoServicosPed,
		
		--tbPed.TotalProdutosPed,
		--tbPed.CentroCusto,
		--tbPed.NumeroPedido,	
		--tbPed.SequenciaPedido,
		--tbPed.CodigoNaturezaOperacao,
		--tbPed.OrigemPedido,
		--tbPed.StatusPedidoPed,
		--tbPed.PercDescontoPecasPed,
		--tbPed.PercDescontoServicosPed,
		--tbPed.TotalDescontoPecasPed,
		tbPed.CodigoPlanoPagamento collate database_default as Plano
		
				from dbValadares.dbo.tbDocumento tbDoc 
	inner join dbValadares.dbo.tbPedido tbPed on 
		tbDoc.NumeroPedidoDocumento = tbPed.NumeroPedido
		and tbDoc.NumeroSequenciaPedidoDocumento = tbPed.SequenciaPedido
		and tbDoc.DataEmissaoDocumento = tbPed.DataEmissaoNotaFiscalPed
	left join #tmpRecVDLVal tbTmp on
		tbDoc.NumeroDocumento = tbTmp.NumeroDocumento
		and tbDoc.DataDocumento = tbTmp.DataDocumento
		--and tbDoc.CodigoCliFor = tbTmp.NumeroDocumento
		
	
		where tbDoc.DataDocumento between @DataInicial and @DataFinal
			  and tbDoc.TipoLancamentoMovimentacao = 7
			  and tbDoc.EntradaSaidaDocumento = 'S'
			  and tbDoc.EspecieDocumento = 'NFE'
			  and tbDoc.CondicaoNFCancelada <> 'V'
			  and tbPed.CodigoNaturezaOperacao not in (132210,199000,599225,594222,599324,594907)
			  and tbPed.CodigoPlanoPagamento not in('799','800','801','802','803')

drop table #tmpRecVDLCar
drop table #tmpRecVDLAut
drop table #tmpRecVDLCal
drop table #tmpRecVDLGoi
drop table #tmpRecVDLPos
drop table #tmpRecVDLRed
drop table #tmpRecVDLUbe
drop table #tmpRecVDLVad
drop table #tmpRecVDLVal

