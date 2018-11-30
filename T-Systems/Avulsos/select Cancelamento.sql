



select * from NFDocumento where NumeroDocumento = 6990
select * from NFItemDocumento where NumeroDocumento = 6990
select * from NFDocumentoFT where NumeroDocumento = 6990
select * from NFItemDocumentoFT where NumeroDocumento = 6990



SELECT * FROM NFDocumentoFT (NOLOCK)
   WHERE  CodigoEmpresa = 3810 AND CodigoLocal = 0 AND CodigoCliFor = 153980000162 AND 
EntradaSaidaDocumento =  'S' AND NumeroDocumento = 6990 
AND DataDocumento = convert(datetime,'12 Jul 2010 00:00:00:000')
 AND TipoLancamentoMovimentacao = 13

select * from tbPedido where NumeroPedido = 27092

select * from tbDocumento where NumeroDocumento = 6990
