select * into tbItemDocumentoBKP001762 from tbItemDocumento where CodigoLocal = 0 and NumeroDocumento = 1763 and DataDocumento = '2009-11-23'
insert tbItemDocumentoBKP001762
select * from tbItemDocumento where CodigoLocal = 0 and NumeroDocumento = 822 and DataDocumento = '2009-11-23' and EntradaSaidaDocumento ='S'

insert NFItemDocumento
select * from tbItemDocumentoBKP001762 --order by SequenciaItemDocumento
set 
--SequenciaItemDocumento = SequenciaItemDocumento + 17,
NumeroDocumento = 1762, TipoLancamentoMovimentacao = 13


select * into tbPedidoBKP0010407 from tbPedido where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbPedidoComplementarBKP0010407 from tbPedidoComplementar where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbOROSCITPedidoBKP0010407 from tbOROSCITPedido where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbPedidoOSBKP0010407 from tbPedidoOS where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbPedidoVendaBKP0010407 from tbPedidoVenda where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbComissaoPedidoBKP0010407 from tbComissaoPedido where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbDuplicataPedidoBKP0010407 from tbDuplicataPedido where CodigoLocal = 0 and NumeroPedido = 17896 and SequenciaPedido = 1
select * into tbItemPedidoBKP0010407 from tbItemPedido where CodigoLocal = 0 and NumeroPedido = 17896 --and SequenciaPedido = 1

select * from tbItemPedidoBKP0010407 --set ItemPedido = ItemPedido + 17,
--SequenciaPedido = 1
--where SequenciaPedido = 2

update tbPedidoBKP0010407 set NumeroPedido = 10407, StatusPedidoPed = 9, NumeroNotaFiscalPed = 1762, DataEmissaoNotaFiscalPed = '2009-11-23', AtualizadoEstoquePed = 'V', AtualizadoContabilidadePed = 'F', NumeroControlePed = 0, NumeroControleFaturaped = 0, TipoTratamentoNFDigitadaPedido = 'P', CodigoNaturezaOperacao = 512220
update tbPedidoComplementarBKP0010407 set NumeroPedido = 10407, NumeroNFTemporaria = 1762, CodigoCliFor = null, EntradaSaidaDocumento = null, NumeroDocumento =null, DataDocumento = null, TipoLancamentoMovimentacao = null 
update tbOROSCITPedidoBKP0010407 set NumeroPedido = 10407
update tbPedidoOSBKP0010407 set NumeroPedido = 10407
update tbPedidoVendaBKP0010407 set NumeroPedido = 10407
update tbComissaoPedidoBKP0010407 set NumeroPedido = 10407
update tbDuplicataPedidoBKP0010407 set NumeroPedido = 10407
update tbItemPedidoBKP0010407 set NumeroPedido = 10407

update tbPedidoBKP0010407 set ValorContabilPed = 4801.66, TotalProdutosPed = 4801.66, TotalPecasPed = 3185.96, TotalServicosPed = 1284.64, TotalCombLubrificantesPed = 331.06, ValorICMSPed = .64, BaseICMS1Ped = 5.35, BaseICMS3Ped = 4796.31, BaseIPI2Ped = 4801.66, BasePISPed = 1284.64, ValorPisPed = 21.2, BaseCOFINSPed = 1284.64, ValorCOFINSPed = 97.63, EspecieNotaFiscalPed = 'NFE'

insert tbPedido select * from tbPedidoBKP0010407
insert tbPedidoComplementar select * from tbPedidoComplementarBKP0010407
insert tbOROSCITPedido select * from tbOROSCITPedidoBKP0010407
insert tbPedidoOS select * from tbPedidoOSBKP0010407
insert tbPedidoVenda select * from tbPedidoVendaBKP0010407
insert tbComissaoPedido select * from tbComissaoPedidoBKP0010407
insert tbDuplicataPedido select * from tbDuplicataPedidoBKP0010407
insert tbItemPedido select * from tbItemPedidoBKP0010407
