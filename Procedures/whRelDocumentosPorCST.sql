Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.whRelDocumentosPorCST

@Spid numeric(5),
@Periodo varchar(6)

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: 
 PROJETO......: LF - Livros Fiscais
 AUTOR........: 
 DATA.........: 02.03.2012
 UTILIZADO EM : Relatório de Documentos por CST
 OBJETIVO.....: 
select * from rtSPEDPISCOFINS where Linha like '|C485%'
whRelDocumentosPorCST 60,201711
------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

AS

DECLARE @DataI datetime
DECLARE @DataF datetime

SELECT @DataI = convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')  
SELECT @DataF = dateadd(day,-1,dateadd(month,+1,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')))

SELECT * 
INTO #tmpFinal
FROM rtSPEDPISCOFINS 
WHERE Spid = @Spid and CST <> '' and 
DataDocumento BETWEEN @DataI AND @DataF AND
Linha not like '|C4%'

INSERT #tmpFinal
SELECT 
@Spid ,
Linha = '',
TipoRegistro = '',
EntradaSaida = 'S' ,                
CodigoLocal,                             
NumeroDocumento = 0,
DataDocumento,
CodigoCliFor = 0,
TipoLancamentoMovimentacao = 77,
Ordem = 0,
CodigoProduto = '',                  
CodigoNaturezaOperacao = 0,
CodigoUnidadeProduto = '', 
CodigoClienteEventual = 0,                  
CST,
sum(ValorContabil),
sum(ValorItem),
sum(ValorBasePIS),          
sum(ValorBaseCOFINS),       
sum(ValorPIS),              
sum(ValorCOFINS),
sum(ValorDesconto),
ContaContabil = 0 ,
CentroCusto = 0

FROM rtSPEDPISCOFINS 
WHERE Spid = @Spid and CST <> '' and 
DataDocumento BETWEEN @DataI AND @DataF AND
Linha like '|C4%'
GROUP BY 
CodigoLocal,
DataDocumento,
CST

SELECT 
CST,
EntradaSaida,
CodigoLocal,
NumeroDocumento,
CONVERT(CHAR(10), DataDocumento,103) as DataDocumento,
CodigoCliFor,
CASE TipoLancamentoMovimentacao WHEN 1 THEN
	'Entrada Estoque'
	WHEN 7 THEN 
	'Nota Emitida'
	WHEN 9 THEN 
	'Uso/Consumo'
	WHEN 10 THEN 
	'Lancto Manual'
	WHEN 77 THEN
	'Mapa ECF'
	WHEN 90 THEN
	'Frete'
	WHEN 91 THEN
	'Frete'
	ELSE
	'Outros'
END AS TipoLancamentoMovimentacao,
CodigoProduto,
ValorContabil ,
ValorItem ,
ValorBasePIS,
ValorBaseCOFINS,
ValorPIS,
ValorCOFINS,
ValorDesconto
FROM #tmpFinal
WHERE Spid = @Spid and CST <> '' and 
DataDocumento BETWEEN @DataI AND @DataF 
ORDER BY
CST,
EntradaSaida,
CodigoLocal,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
CodigoProduto

DROP TABLE #tmpFinal