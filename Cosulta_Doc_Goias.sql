-- script consulta entrada documento Goias MATRIZ p/ Goias MATRIZ
execute whLDocumentoLFIntervalo @CodigoEmpresa = 2630,@CodigoLocal = 0,@DaDataDocumento = '2014-01-01 00:00',@AteDataDocumento = '2014-12-31 00:00',@EntradaSaidaDocumento = 'E',@TipoLancamentoMovimentacao = Null,@NumeroDocumentoInicial = 0,@NumeroDocumentoFinal = 999999999,@CodigoCliFor = 153980000162
