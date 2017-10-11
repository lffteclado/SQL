--sp_helptext whEliminarEstruturaDocumento

--EXECUTE whEliminarEstruturaDocumento @CodigoEmpresa = 262,@CodigoLocal = 0,@EntradaSaidaDocumento = 'E',@NumeroDocumento = '14339',@DataDocumento = '2017-03-07 00:00',@CodigoCliFor = '1765514000109',@TipoLancamentoMovimentacao = '7'

execute spLDoctoRecPag @CodigoEmpresa = 262,@CodigoLocal = 0,@EntradaSaidaDocumento = 'E',@NumeroDocumento = '14339',@DataDocumento = '2017-03-07 00:00',@CodigoCliFor = '1765514000109',@TipoLancamentoMovimentacao = '7'

SELECT * FROM tbDoctoRecPag (NOLOCK)
   WHERE  CodigoEmpresa = 262 AND CodigoLocal = 0 AND EntradaSaidaDocumento =  'E' AND NumeroDocumento = 14339 AND DataDocumento = convert(datetime,'07 Mar 2017 00:00:00:000') AND CodigoCliFor = 1765514000109 AND TipoLancamentoMovimentacao = 7 