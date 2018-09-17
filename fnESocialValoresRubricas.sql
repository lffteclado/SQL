IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('fnESocialValoresRubricas'))
	DROP FUNCTION dbo.fnESocialValoresRubricas
GO
CREATE FUNCTION dbo.fnESocialValoresRubricas
/* INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------------
 EMPRESA......: T-SYSTEMS
 PROJETO......: Folha de Pagamento
 AUTOR........: Edson Marson	
 DATA.........: 25/08/2017
 UTILIZADO EM : whArquivosFPEsocialXML.sql
 OBJETIVO.....: Adequação da legislação do eSocial versao 2.3 
                Ticket 257863/2017 - FM 16245/2017	

 ALTERACAO....: Edson Marson - 30/09/2017
 OBJETIVO.....: Adequação da legislação do eSocial versao 2.3 Etapa 3 
                Ticket 257863/2017 - FM 16319/2017	

 ALTERACAO....: Edson Marson - 13/12/2017
 OBJETIVO.....: Diversas correções durante testes-validação junto ao portal T-Systems.
 				Ticket 270977/2017

 ALTERACAO....: Edson Marson - 09/05/2018
 OBJETIVO.....: Correções para o arquivo S-2299 com valores.
				Ticket 277565/2018

 ALTERACAO....: Edson Marson - 18/05/2018
 OBJETIVO.....: Correções para o arquivo S-1200 com valores.
				Ticket 277565/2018 - Fase II

 ALTERACAO....: Edson Marson - 05/06/2018
 OBJETIVO.....: Correções para os arquivos S-1295/S-1298/S-1299.
				Ticket 277565/2018 - Fase III - Ajustes

select dbo.fnESocialValoresRubricas (1608, 0, 'F', 57, 'S-1210', 2, '201507', '2015-07-31', 'D')
-------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC */
(
	@CodigoEmpresa		NUMERIC(4),
	@CodigoLocal		NUMERIC(4),
	@TipoColaborador	CHAR(1),
	@NumeroRegistro		NUMERIC(8),
	@NomeArquivo		CHAR(6),
	@IndApuracao		NUMERIC(1),
	@PerApuracao		CHAR(6),
	@DataPagamento		DATETIME	= NULL,
	@TipoRubrica		CHAR(1)		= NULL
)
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @curLinha		VARCHAR(8000)
	DECLARE @Saida			VARCHAR(8000)

	SELECT @Saida = ''

	IF @NomeArquivo = 'S-1200'
	BEGIN
		IF @TipoColaborador = 'T'
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	'<itensRemun>' + 
						'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 						'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
						CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						ELSE
							''
						END
					ELSE
 						'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
					END +		
					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
						CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
							''
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
						END
					ELSE
 						'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
					END +
 					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
						CASE WHEN c.RotinaCalculo = 100 THEN
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																			FROM  tbItemMovimentoFolhaTerc tmp

																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento

																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp.CodigoEvento		= b.CodigoEvento
																			AND tmp1.RotinaCalculo		= 100
																	  ),0))))),',','.') +
 							'</vrUnit>'
						ELSE
							CASE WHEN c.RotinaCalculo = 101 THEN
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																			FROM  tbItemMovimentoFolhaTerc tmp

																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento

																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp.CodigoEvento		= b.CodigoEvento
																			AND tmp1.RotinaCalculo		= 101 
																	  ),0))))),',','.') +
 								'</vrUnit>'
							ELSE
								''
							END
						END
 					ELSE
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT ABS(tmp.ValorEvento)
																			FROM  tbItemMovimentoFolhaTerc tmp
																			
																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento
																			
																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp.CodigoEvento		= b.CodigoEvento
																			AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																	  ),0))))),',','.') +
 						'</vrUnit>'
 					END +
 						'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
					'</itensRemun>'  
			FROM tbMovimentoFolhaTerc a

			INNER JOIN tbItemMovimentoFolhaTerc b
			ON  b.CodigoEmpresa			= a.CodigoEmpresa
			AND b.CodigoLocal			= a.CodigoLocal
			AND b.TipoColaborador		= a.TipoColaborador
			AND	b.NumeroRegistro		= a.NumeroRegistro
			AND b.PeriodoCompetencia	= a.PeriodoCompetencia
			AND b.RotinaPagamento		= a.RotinaPagamento
			AND b.DataPagamento			= a.DataPagamento

			INNER JOIN tbEvento c
			ON  c.CodigoEmpresa			= b.CodigoEmpresa
			AND c.CodigoEvento			= b.CodigoEvento
			AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
			AND c.CodigoRubricaESocial	> 0
			AND (
						(@IndApuracao  = 6 AND c.BaseIrrfESocial NOT IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- não leva estas incidencias
					OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial NOT IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- não leva estas incidencias
				)
			
			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoCompetencia	= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
		ELSE -- tipo colaborador = F ou E
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	'<itensRemun>' + 
						'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 						'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
						CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						ELSE
							''
						END
					ELSE
 						'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
					END +		
					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
						CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
							''
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
						END
					ELSE
 						'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
					END +
 					CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
						CASE WHEN c.RotinaCalculo = 100 THEN
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT (ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END)
																			FROM  tbItemMovimentoFolha tmp

																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento

																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp.CodigoEvento		= b.CodigoEvento
																			AND tmp1.RotinaCalculo		= 100 
																	  ),0))))),',','.') +
							'</vrUnit>'
						ELSE
							CASE WHEN c.RotinaCalculo = 101 THEN
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																			FROM  tbItemMovimentoFolha tmp

																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento

																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp.CodigoEvento		= b.CodigoEvento
																			AND tmp1.RotinaCalculo		= 101 
																	  ),0))))),',','.') +
								'</vrUnit>'
							ELSE
								''
							END
						END
 					ELSE
							'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																		( 
																			SELECT ABS(tmp.ValorEvento)
																			FROM  tbItemMovimentoFolha tmp
																			
																			INNER JOIN tbEvento tmp1
																			ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																			AND tmp1.CodigoEvento	= tmp.CodigoEvento
																			
																			WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																			AND tmp.CodigoLocal			= b.CodigoLocal
																			AND tmp.TipoColaborador		= b.TipoColaborador
																			AND	tmp.NumeroRegistro		= b.NumeroRegistro
																			AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																			AND tmp.RotinaPagamento		= b.RotinaPagamento
																			AND tmp.DataPagamento		= b.DataPagamento
																			AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																	  ),0))))),',','.') +
 						'</vrUnit>'
 					END +
 						'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
					'</itensRemun>'  
			FROM tbMovimentoFolha a

			INNER JOIN tbItemMovimentoFolha b
			ON  b.CodigoEmpresa			= a.CodigoEmpresa
			AND b.CodigoLocal			= a.CodigoLocal
			AND b.TipoColaborador		= a.TipoColaborador
			AND	b.NumeroRegistro		= a.NumeroRegistro
			AND b.PeriodoCompetencia	= a.PeriodoCompetencia
			AND b.RotinaPagamento		= a.RotinaPagamento
			AND b.DataPagamento			= a.DataPagamento

			INNER JOIN tbEvento c
			ON  c.CodigoEmpresa			= b.CodigoEmpresa
			AND c.CodigoEvento			= b.CodigoEvento
			AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
			AND c.CodigoRubricaESocial	> 0
			AND (
						(@IndApuracao  = 6 AND c.BaseIrrfESocial NOT IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- não leva estas incidencias
					OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial NOT IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- não leva estas incidencias
				)
			
			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoCompetencia	= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
	END
	ELSE 
	IF @NomeArquivo = 'S-1210'
	BEGIN
		IF @TipoColaborador = 'T'
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	
					CASE WHEN @IndApuracao = 6 THEN
						'<detRubrFer>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.RotinaCalculo = 300 OR c.RotinaCalculo = 304 THEN
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							ELSE
								''
							END
						ELSE
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						END +		
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
								''
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
							END
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
						END +
 						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
							CASE WHEN c.RotinaCalculo = 300 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolhaTerc tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 300 -- ferias normais
																		  ),0))))),',','.') +
 								'</vrUnit>'
							ELSE
								CASE WHEN c.RotinaCalculo = 304 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolhaTerc tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 304 -- abono ferias 
																		  ),0))))),',','.') +
 									'</vrUnit>'
								ELSE
									''
								END
							END
 						ELSE
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento)
																				FROM  tbItemMovimentoFolhaTerc tmp
																				
																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento
																				
																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																		  ),0))))),',','.') +
 							'</vrUnit>'
 						END +
 							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
							CASE WHEN c.CodigoRubricaESocial = 9213 AND c.BaseIrrfESocial IN (51, 52, 53, 54, 55) THEN 
							'<penAlim>' + (
											SELECT TOP 1 '<cpfBenef>' + COALESCE(RTRIM(LTRIM(d.CPFBeneficiario)),'') + '</cpfBenef>' +
													'<dtNasctoBenef>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataNascimento)),2,4),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataNascimento)),2,2),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,d.DataNascimento)),2,2),'') + 
													'</dtNasctoBenef>' +
													'<nmBenefic>' + COALESCE(RTRIM(LTRIM(d.NomeBeneficiario)),'') + '</nmBenefic>' +
													'<vlrPensao>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vlrPensao>' 
											FROM tbBeneficiario d
											
											WHERE d.CodigoEmpresa	= b.CodigoEmpresa
											AND   d.CodigoLocal		= b.CodigoLocal
											AND   d.TipoColaborador	= b.TipoColaborador
											AND   d.NumeroRegistro  = b.NumeroRegistro
											AND   (
													   d.CodigoEvento		= b.CodigoEvento
													OR d.CodigoEvento13Sal	= b.CodigoEvento
													OR ( d.CodigoEventoFerias = b.CodigoEvento OR c.RotinaCalculo = 566 ) -- 566=Reflexo Férias
												   )	
										   ) +
							'</penAlim>' 
							ELSE 
								'' 
							END +
						'</detRubrFer>'
					ELSE -- não é pagto Férias
						'<retPgtoTot>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
							CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
								CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 									'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
								ELSE
									''
								END
							ELSE
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							END +		
							CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
								CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
									''
								ELSE
 									'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
								END
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
							END +
 							CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
								CASE WHEN c.RotinaCalculo = 100 THEN
									'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																				( 
																					SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																					FROM  tbItemMovimentoFolhaTerc tmp

																					INNER JOIN tbEvento tmp1
																					ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																					AND tmp1.CodigoEvento	= tmp.CodigoEvento

																					WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																					AND tmp.CodigoLocal			= b.CodigoLocal
																					AND tmp.TipoColaborador		= b.TipoColaborador
																					AND	tmp.NumeroRegistro		= b.NumeroRegistro
																					AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																					AND tmp.RotinaPagamento		= b.RotinaPagamento
																					AND tmp.DataPagamento		= b.DataPagamento
																					AND tmp.CodigoEvento		= b.CodigoEvento
																					AND tmp1.RotinaCalculo		= 100
																			  ),0))))),',','.') +
 									'</vrUnit>'
								ELSE
									CASE WHEN c.RotinaCalculo = 101 THEN
									'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																				( 
																					SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																					FROM  tbItemMovimentoFolhaTerc tmp

																					INNER JOIN tbEvento tmp1
																					ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																					AND tmp1.CodigoEvento	= tmp.CodigoEvento

																					WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																					AND tmp.CodigoLocal			= b.CodigoLocal
																					AND tmp.TipoColaborador		= b.TipoColaborador
																					AND	tmp.NumeroRegistro		= b.NumeroRegistro
																					AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																					AND tmp.RotinaPagamento		= b.RotinaPagamento
																					AND tmp.DataPagamento		= b.DataPagamento
																					AND tmp.CodigoEvento		= b.CodigoEvento
																					AND tmp1.RotinaCalculo		= 101 
																			  ),0))))),',','.') +
 										'</vrUnit>'
									ELSE
										''
									END
								END
 							ELSE
									'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																				( 
																					SELECT ABS(tmp.ValorEvento)
																					FROM  tbItemMovimentoFolhaTerc tmp
																					
																					INNER JOIN tbEvento tmp1
																					ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																					AND tmp1.CodigoEvento	= tmp.CodigoEvento
																					
																					WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																					AND tmp.CodigoLocal			= b.CodigoLocal
																					AND tmp.TipoColaborador		= b.TipoColaborador
																					AND	tmp.NumeroRegistro		= b.NumeroRegistro
																					AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																					AND tmp.RotinaPagamento		= b.RotinaPagamento
																					AND tmp.DataPagamento		= b.DataPagamento
																					AND tmp.CodigoEvento		= b.CodigoEvento
																					AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																			  ),0))))),',','.') +
 								'</vrUnit>'
 							END +
 							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
							CASE WHEN c.CodigoRubricaESocial = 9213 AND c.BaseIrrfESocial IN (51, 52, 53, 54, 55) THEN 
							'<penAlim>' + (
											SELECT TOP 1 '<cpfBenef>' + COALESCE(RTRIM(LTRIM(d.CPFBeneficiario)),'') + '</cpfBenef>' +
													'<dtNasctoBenef>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataNascimento)),2,4),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataNascimento)),2,2),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,d.DataNascimento)),2,2),'') + 
													'</dtNasctoBenef>' +
													'<nmBenefic>' + COALESCE(RTRIM(LTRIM(d.NomeBeneficiario)),'') + '</nmBenefic>' +
													'<vlrPensao>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vlrPensao>' 
											FROM tbBeneficiario d
											
											WHERE d.CodigoEmpresa	= b.CodigoEmpresa
											AND   d.CodigoLocal		= b.CodigoLocal
											AND   d.TipoColaborador	= b.TipoColaborador
											AND   d.NumeroRegistro  = b.NumeroRegistro
											AND   (
													   d.CodigoEvento		= b.CodigoEvento
													OR d.CodigoEvento13Sal	= b.CodigoEvento
													OR ( d.CodigoEventoFerias = b.CodigoEvento OR c.RotinaCalculo = 566 ) -- 566=Reflexo Férias
												   )	
										   ) +
							'</penAlim>' 
							ELSE 
								'' 
							END +
						'</retPgtoTot>'
					END
			FROM tbMovimentoFolhaTerc a

			INNER JOIN tbItemMovimentoFolhaTerc b
			ON  b.CodigoEmpresa			= a.CodigoEmpresa
			AND b.CodigoLocal			= a.CodigoLocal
			AND b.TipoColaborador		= a.TipoColaborador
			AND	b.NumeroRegistro		= a.NumeroRegistro
			AND b.PeriodoCompetencia	= a.PeriodoCompetencia
			AND b.RotinaPagamento		= a.RotinaPagamento
			AND b.DataPagamento			= a.DataPagamento

			INNER JOIN tbEvento c
			ON  c.CodigoEmpresa			= b.CodigoEmpresa
			AND c.CodigoEvento			= b.CodigoEvento
			AND c.CodigoRubricaESocial	> 0
			AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
			AND (
						(@IndApuracao  = 6 AND c.BaseIrrfESocial IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- só leva estas incidencias
					OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- só leva estas incidencias
				)
			
			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoPagamento		= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
		ELSE -- tipo colaborador = F ou E
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	
					CASE WHEN @IndApuracao = 6 THEN
						'<detRubrFer>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.RotinaCalculo = 300 OR c.RotinaCalculo = 304 THEN
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							ELSE
								''
							END
						ELSE
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						END +		
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
								''
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
							END
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
						END +
 						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
							CASE WHEN c.RotinaCalculo = 300 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT (ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END)
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 300 -- ferias normais 
																		  ),0))))),',','.') +
								'</vrUnit>'
							ELSE
								CASE WHEN c.RotinaCalculo = 304 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 304 -- abono ferias 
																		  ),0))))),',','.') +
									'</vrUnit>'
								ELSE
									''
								END
							END
 						ELSE
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento)
																				FROM  tbItemMovimentoFolha tmp
																				
																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento
																				
																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																		  ),0))))),',','.') +
 							'</vrUnit>'
 						END +
 							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
							CASE WHEN c.CodigoRubricaESocial = 9213 AND c.BaseIrrfESocial IN (51, 52, 53, 54, 55) THEN 
							'<penAlim>' + (
											SELECT TOP 1 '<cpfBenef>' + COALESCE(RTRIM(LTRIM(d.CPFBeneficiario)),'') + '</cpfBenef>' +
													'<dtNasctoBenef>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataNascimento)),2,4),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataNascimento)),2,2),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,d.DataNascimento)),2,2),'') + 
													'</dtNasctoBenef>' +
													'<nmBenefic>' + COALESCE(RTRIM(LTRIM(d.NomeBeneficiario)),'') + '</nmBenefic>' +
													'<vlrPensao>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vlrPensao>' 
											FROM tbBeneficiario d
											
											WHERE d.CodigoEmpresa	= b.CodigoEmpresa
											AND   d.CodigoLocal		= b.CodigoLocal
											AND   d.TipoColaborador	= b.TipoColaborador
											AND   d.NumeroRegistro  = b.NumeroRegistro
											AND   (
													   d.CodigoEvento		= b.CodigoEvento
													OR d.CodigoEvento13Sal	= b.CodigoEvento
													OR ( d.CodigoEventoFerias = b.CodigoEvento OR c.RotinaCalculo = 566 ) -- 566=Reflexo Férias
												   )	
										   ) +
							'</penAlim>' 
							ELSE 
								'' 
							END +
						'</detRubrFer>'
					ELSE -- não é pagto Férias
						'<retPgtoTot>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
 							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							ELSE
								''
							END
						ELSE
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						END +		
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
								''
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
							END
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
						END +
 						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
							CASE WHEN c.RotinaCalculo = 100 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT (ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END)
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 100 
																		  ),0))))),',','.') +
								'</vrUnit>'
							ELSE
								CASE WHEN c.RotinaCalculo = 101 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 101 
																		  ),0))))),',','.') +
									'</vrUnit>'
								ELSE
									''
								END
							END
 						ELSE
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento)
																				FROM  tbItemMovimentoFolha tmp
																				
																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento
																				
																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																		  ),0))))),',','.') +
 							'</vrUnit>'
 						END +
 							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
							CASE WHEN c.CodigoRubricaESocial = 9213 AND c.BaseIrrfESocial IN (51, 52, 53, 54, 55) THEN 
							'<penAlim>' + (
											SELECT TOP 1 '<cpfBenef>' + COALESCE(RTRIM(LTRIM(d.CPFBeneficiario)),'') + '</cpfBenef>' +
													'<dtNasctoBenef>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataNascimento)),2,4),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataNascimento)),2,2),'') + '-' +
																		COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,d.DataNascimento)),2,2),'') + 
													'</dtNasctoBenef>' +
													'<nmBenefic>' + COALESCE(RTRIM(LTRIM(d.NomeBeneficiario)),'') + '</nmBenefic>' +
													'<vlrPensao>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vlrPensao>' 
											FROM tbBeneficiario d
											
											WHERE d.CodigoEmpresa	= b.CodigoEmpresa
											AND   d.CodigoLocal		= b.CodigoLocal
											AND   d.TipoColaborador	= b.TipoColaborador
											AND   d.NumeroRegistro  = b.NumeroRegistro
											AND   (
													   d.CodigoEvento		= b.CodigoEvento
													OR d.CodigoEvento13Sal	= b.CodigoEvento
													OR ( d.CodigoEventoFerias = b.CodigoEvento OR c.RotinaCalculo = 566 ) -- 566=Reflexo Férias
												   )	
										   ) +
							'</penAlim>' 
							ELSE 
								'' 
							END +
						'</retPgtoTot>' 
					END
			FROM tbMovimentoFolha a

			INNER JOIN tbItemMovimentoFolha b
			ON  b.CodigoEmpresa			= a.CodigoEmpresa
			AND b.CodigoLocal			= a.CodigoLocal
			AND b.TipoColaborador		= a.TipoColaborador
			AND	b.NumeroRegistro		= a.NumeroRegistro
			AND b.PeriodoCompetencia	= a.PeriodoCompetencia
			AND b.RotinaPagamento		= a.RotinaPagamento
			AND b.DataPagamento			= a.DataPagamento

			INNER JOIN tbEvento c
			ON  c.CodigoEmpresa			= b.CodigoEmpresa
			AND c.CodigoEvento			= b.CodigoEvento
			AND c.CodigoRubricaESocial	> 0
			AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
			AND (
						(@IndApuracao  = 6 AND c.BaseIrrfESocial IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- só leva estas incidencias
					OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- só leva estas incidencias
				)
			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoPagamento		= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
	END
	ELSE
	BEGIN
		IF @NomeArquivo = 'S-2299' OR @NomeArquivo = 'S-2399'
		BEGIN
			IF @TipoColaborador = 'T'
			BEGIN
				DECLARE curSaida CURSOR FOR
				SELECT	'<detVerbas>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							ELSE
								''
							END
						ELSE
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						END +		
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
								''
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
							END
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
						END +
 						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
							CASE WHEN c.RotinaCalculo = 100 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolhaTerc tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 100
																		  ),0))))),',','.') +
 								'</vrUnit>'
							ELSE
								CASE WHEN c.RotinaCalculo = 101 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolhaTerc tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 101 
																		  ),0))))),',','.') +
 									'</vrUnit>'
								ELSE
									''
								END
							END
 						ELSE
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento)
																				FROM  tbItemMovimentoFolhaTerc tmp
																				
																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento
																				
																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																		  ),0))))),',','.') +
 							'</vrUnit>'
 						END +
							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
						'</detVerbas>'
				FROM tbMovimentoFolhaTerc a

				INNER JOIN tbItemMovimentoFolhaTerc b
				ON  b.CodigoEmpresa			= a.CodigoEmpresa
				AND b.CodigoLocal			= a.CodigoLocal
				AND b.TipoColaborador		= a.TipoColaborador
				AND	b.NumeroRegistro		= a.NumeroRegistro
				AND b.PeriodoCompetencia	= a.PeriodoCompetencia
				AND b.RotinaPagamento		= a.RotinaPagamento
				AND b.DataPagamento			= a.DataPagamento

				INNER JOIN tbEvento c
				ON  c.CodigoEmpresa			= b.CodigoEmpresa
				AND c.CodigoEvento			= b.CodigoEvento
				AND c.CodigoRubricaESocial	> 0
				AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
				AND (
							(@IndApuracao  = 6 AND c.BaseIrrfESocial NOT IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- não leva estas incidencias
						OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial NOT IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- não leva estas incidencias
					)
				
				WHERE a.CodigoEmpresa			= @CodigoEmpresa
				AND a.CodigoLocal				= @CodigoLocal
				AND a.TipoColaborador			= @TipoColaborador
				AND a.NumeroRegistro			= @NumeroRegistro
				AND a.RotinaPagamento			= @IndApuracao
				AND a.PeriodoCompetencia		= @PerApuracao
				AND (
							(@IndApuracao  = 2 AND a.CondicaoColaboradorPagto	  IN (3,5))
						OR  (@IndApuracao <> 2 AND a.CondicaoColaboradorPagto NOT IN (3,5))
					)
				AND (
						@DataPagamento IS NULL
						OR (a.DataPagamento = @DataPagamento)
					)
			END
			ELSE -- Colaborador F ou E
			BEGIN
				DECLARE curSaida CURSOR FOR
				SELECT	'<detVerbas>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(b.CodigoEvento)),'') + '</codRubr>' +
							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.RotinaCalculo = 100 OR c.RotinaCalculo = 101 THEN
 								'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
							ELSE
								''
							END
						ELSE
 							'<qtdRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</qtdRubr>'
						END +		
						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN
							CASE WHEN c.CodigoRubricaESocial <> 9201 THEN
								''
							ELSE
 								'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),b.ReferenciaEvento)))),',','.') + '</fatorRubr>' 
							END
						ELSE
 							'<fatorRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(c.PercentualAcrescimoEvento/100))))),',','.') + '</fatorRubr>' 
						END +
 						CASE WHEN c.PercentualAcrescimoEvento = 0 THEN 
							CASE WHEN c.RotinaCalculo = 100 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT (ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END)
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 100 
																		  ),0))))),',','.') +
								'</vrUnit>'
							ELSE
								CASE WHEN c.RotinaCalculo = 101 THEN
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento) / CASE WHEN ABS(tmp.ReferenciaEvento) = 0 THEN 1 ELSE ABS(tmp.ReferenciaEvento) END
																				FROM  tbItemMovimentoFolha tmp

																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento

																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp.CodigoEvento		= b.CodigoEvento
																				AND tmp1.RotinaCalculo		= 101 
																		  ),0))))),',','.') +
									'</vrUnit>'
								ELSE
									''
								END
							END
 						ELSE
								'<vrUnit>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(
																			( 
																				SELECT ABS(tmp.ValorEvento)
																				FROM  tbItemMovimentoFolha tmp
																				
																				INNER JOIN tbEvento tmp1
																				ON	tmp1.CodigoEmpresa	= tmp.CodigoEmpresa
																				AND tmp1.CodigoEvento	= tmp.CodigoEvento
																				
																				WHERE tmp.CodigoEmpresa		= b.CodigoEmpresa
																				AND tmp.CodigoLocal			= b.CodigoLocal
																				AND tmp.TipoColaborador		= b.TipoColaborador
																				AND	tmp.NumeroRegistro		= b.NumeroRegistro
																				AND tmp.PeriodoCompetencia	= b.PeriodoCompetencia
																				AND tmp.RotinaPagamento		= b.RotinaPagamento
																				AND tmp.DataPagamento		= b.DataPagamento
																				AND tmp1.RotinaCalculo		= 901 -- Salario Hora
																		  ),0))))),',','.') +
 							'</vrUnit>'
 						END +
							'<vrRubr>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrRubr>' +
						'</detVerbas>'
				FROM tbMovimentoFolha a

				INNER JOIN tbItemMovimentoFolha b
				ON  b.CodigoEmpresa			= a.CodigoEmpresa
				AND b.CodigoLocal			= a.CodigoLocal
				AND b.TipoColaborador		= a.TipoColaborador
				AND	b.NumeroRegistro		= a.NumeroRegistro
				AND b.PeriodoCompetencia	= a.PeriodoCompetencia
				AND b.RotinaPagamento		= a.RotinaPagamento
				AND b.DataPagamento			= a.DataPagamento

				INNER JOIN tbEvento c
				ON  c.CodigoEmpresa			= b.CodigoEmpresa
				AND c.CodigoEvento			= b.CodigoEvento
				AND c.CodigoRubricaESocial	> 0
				AND c.TipoEvento			= ISNULL(@TipoRubrica,c.TipoEvento)
				AND (
							(@IndApuracao  = 6 AND c.BaseIrrfESocial NOT IN (0, 1, 13, 33, 43, 46, 53, 63, 75, 93))					-- não leva estas incidencias
						OR	(@IndApuracao <> 6 AND c.BaseIrrfESocial NOT IN (31, 32, 33, 34, 35, 51, 52, 53, 54, 55, 81, 82, 83))	-- não leva estas incidencias
					)
				
				WHERE a.CodigoEmpresa			= @CodigoEmpresa
				AND a.CodigoLocal				= @CodigoLocal
				AND a.TipoColaborador			= @TipoColaborador
				AND a.NumeroRegistro			= @NumeroRegistro
				AND a.RotinaPagamento			= @IndApuracao
				AND a.PeriodoCompetencia		= @PerApuracao
				AND (
							(@IndApuracao  = 2 AND a.CondicaoColaboradorPagto	  IN (3,5))
						OR  (@IndApuracao <> 2 AND a.CondicaoColaboradorPagto NOT IN (3,5))
					)
				AND (
						@DataPagamento IS NULL
						OR (a.DataPagamento = @DataPagamento)
					)
			END
		END
	END
	-- Retorno para todos os IFs
	OPEN curSaida

	FETCH NEXT FROM curSaida INTO @curLinha
	WHILE (@@fetch_status <> -1)
	BEGIN
		SELECT @Saida = @Saida + @curLinha 
		FETCH NEXT FROM curSaida INTO @curLinha
	END

	CLOSE curSaida
	DEALLOCATE curSaida

	RETURN @Saida

END

