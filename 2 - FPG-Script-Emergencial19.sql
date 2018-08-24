IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('fnESocialDependentes'))
	DROP FUNCTION dbo.fnESocialDependentes
GO
CREATE FUNCTION dbo.fnESocialDependentes
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

 ALTERACAO....: Edson Marson - 23/11/2017
 OBJETIVO.....: Correções para adequação a versão 2.4.01 divulgadas em 17/11/2017.
                Ticket 270012/2017

 ALTERACAO....: Edson Marson - 07/03/2018
 OBJETIVO.....: Correção na Tag cpfdep
  				Ticket 275285/2018

 ALTERACAO....: Edson Marson - 28/03/2018
 OBJETIVO.....: Correção no grupo da Tag <dependente>.
  				Ticket 275285/2018

 ALTERACAO....: Edson Marson - 18/05/2018
 OBJETIVO.....: Correções para o arquivo S-1200 com valores.
				Ticket 277565/2018 - Fase II

select dbo.fnESocialDependentes (1608, 0, 'F', 22, 'S-1210', '201407')
-------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC */
(
	@CodigoEmpresa		NUMERIC(4),
	@CodigoLocal		NUMERIC(4),
	@TipoColaborador	CHAR(1),
	@NumeroRegistro		NUMERIC(8),
	@NomeArquivo		CHAR(6),
	@PerApuracao		CHAR(6)
)

RETURNS VARCHAR(2000)

AS

BEGIN
	DECLARE @curLinha VARCHAR(2000)
	DECLARE @Saida    VARCHAR(2000)

	SELECT @Saida = ''

	IF @NomeArquivo = 'S-1210'
	BEGIN
		DECLARE @QtDep NUMERIC(1)

		SELECT TOP 1 @QtDep = NumeroDependentesIRRF FROM tbMovimentoFolha d
		WHERE d.CodigoEmpresa		= @CodigoEmpresa
		AND   d.CodigoLocal			= @CodigoLocal
		AND   d.TipoColaborador		= @TipoColaborador
		AND   d.NumeroRegistro		= @NumeroRegistro
		AND   d.PeriodoPagamento	= @PerApuracao
		AND   d.RotinaPagamento		IN (1,2,5,6,7) -- adto, mensal(rescisão), 13o Sal, férias, eventual
		--		
		SELECT @Saida = COALESCE((
									SELECT '<vrDedDep>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), (@QtDep * COALESCE(i.ValorDeducaoDependente,0)))))),',','.') + '</vrDedDep>' 
									FROM tbIRRF i
									WHERE i.PeriodoIRRF = @PerApuracao
								  ),'')
	END
	ELSE -- não é arq S-1210
	BEGIN
		DECLARE curSaida CURSOR FOR
		SELECT 	'<dependente>' +
					'<tpDep>' +  RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),GrauParentescoESocial),0)))),2) + '</tpDep>' +
					'<nmDep>' + COALESCE(RTRIM(LTRIM(NomeDependente)),'') + '</nmDep>' +
					'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,DataNascimentoDependente)),2,4),'') + '-' + 
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,DataNascimentoDependente)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,DataNascimentoDependente)),2,2),'') +  
					'</dtNascto>' +
					CASE WHEN COALESCE(RTRIM(LTRIM(CPFDependente)),'') = '' THEN
						''
					ELSE
						'<cpfDep>' + COALESCE(RTRIM(LTRIM(CPFDependente)),'') + '</cpfDep>' 
					END +
					'<depIRRF>' + CASE WHEN DependenteIRRF = 'V' THEN 'S' ELSE 'N' END + '</depIRRF>' +
					'<depSF>' + CASE WHEN DependenteSalarioFamilia = 'V' THEN 'S' ELSE 'N' END + '</depSF>' +
					'<incTrab>' + CASE WHEN DependenteInvalido = 'V' THEN 'S' ELSE 'N' END + '</incTrab>' +
				'</dependente>'
		FROM tbDependente
		WHERE CodigoEmpresa			= @CodigoEmpresa
		AND   CodigoLocal			= @CodigoLocal
		AND   TipoColaborador		= @TipoColaborador
		AND   NumeroRegistro		= @NumeroRegistro
		AND   GrauParentescoESocial > 0
		--
		OPEN curSaida

		FETCH NEXT FROM curSaida INTO @curLinha
		WHILE (@@fetch_status <> -1)
		BEGIN
			SELECT @Saida = @Saida + @curLinha 
			FETCH NEXT FROM curSaida INTO @curLinha
		END
			
		CLOSE curSaida
		DEALLOCATE curSaida
	END
	--
	RETURN @Saida
END

go

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

go

IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('fnESocialValorLiquido'))
	DROP FUNCTION dbo.fnESocialValorLiquido
GO
CREATE FUNCTION dbo.fnESocialValorLiquido
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

 ALTERACAO....: Edson Marson - 18/05/2018
 OBJETIVO.....: Correções para o arquivo S-1200 com valores.
				Ticket 277565/2018 - Fase II

 ALTERACAO....: Edson Marson - 05/06/2018
 OBJETIVO.....: Correções para os arquivos S-1295/S-1298/S-1299.
				Ticket 277565/2018 - Fase III - Ajustes

select dbo.fnESocialValorLiquido (1608, 0, 'F', 22, 2, '201206', '2012-06-30', null)
-------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC */
(
	@CodigoEmpresa		NUMERIC(4),
	@CodigoLocal		NUMERIC(4),
	@TipoColaborador	CHAR(1),
	@NumeroRegistro		NUMERIC(8),
	@IndApuracao		NUMERIC(1),
	@PerApuracao		CHAR(6),
	@DataPagamento		DATETIME,
	@NumeroRecibo		CHAR(40)	= NULL
)
RETURNS VARCHAR(2000)
AS
BEGIN
	DECLARE @curLinha VARCHAR(2000)
	DECLARE @Saida    VARCHAR(2000)

	SELECT @Saida = ''

	IF @IndApuracao = 6 -- férias
	BEGIN
		DECLARE curSaida CURSOR FOR
		SELECT	'<dtIniGoz>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataInicioGozoFeriasHist)),2,4),'0000') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataInicioGozoFeriasHist)),2,2),'00') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,d.DataInicioGozoFeriasHist)),2,2),'00') +
				'</dtIniGoz>' + 
				'<qtDias>' + CONVERT(VARCHAR(2),COALESCE(ABS(d.DiasGozadosFeriasHist),'00')) + '</qtDias>' +
				'<vrLiq>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrLiq>'

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
--		AND c.CodigoRubricaESocial	> 0
		AND c.RotinaCalculo			= 992 -- Valor Liquido
		
		INNER JOIN tbHistFerias d
		ON  d.CodigoEmpresa			= a.CodigoEmpresa
		AND d.CodigoLocal			= a.CodigoLocal
		AND d.TipoColaborador		= a.TipoColaborador
		AND	d.NumeroRegistro		= a.NumeroRegistro
		AND d.DataPagamentoFerias	= a.DataPagamento

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND a.CodigoLocal			= @CodigoLocal
		AND a.TipoColaborador		= @TipoColaborador
		AND a.NumeroRegistro		= @NumeroRegistro
		AND a.RotinaPagamento		= @IndApuracao
		AND a.PeriodoPagamento		= @PerApuracao
		AND a.DataPagamento			= @DataPagamento
	END
	ELSE -- demais tipos de pagamento
	BEGIN
		IF @TipoColaborador <> 'T' -- tipo colaborador = F ou E
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	CASE WHEN e.CondicaoColaborador IN (3,5) THEN
						'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@CodigoEmpresa)),'') + 
										COALESCE(RTRIM(LTRIM(@CodigoLocal)),'') +
										COALESCE(RTRIM(LTRIM(@TipoColaborador)),'') +
										COALESCE(RTRIM(LTRIM(@NumeroRegistro)),'') +
										COALESCE(RTRIM(LTRIM(a.PeriodoCompetencia)),'') +
										COALESCE(RTRIM(LTRIM(@IndApuracao)),'') +
										COALESCE(RTRIM(LTRIM(a.Dissidio)),'') +
						'</ideDmDev>' +
						'<indPgtoTt>' + 'S' + '</indPgtoTt>' +
						'<vrLiq>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrLiq>' +
						'<nrRecArq>' + RTRIM(LTRIM(@NumeroRecibo)) + '</nrRecArq>'
					ELSE
						'<perRef>' + CASE WHEN @IndApuracao = 5 THEN -- 13o Salario
										LEFT(a.PeriodoCompetencia,4)
									ELSE	
										LEFT(a.PeriodoCompetencia,4) + '-' + RIGHT(a.PeriodoCompetencia,2)
									END +
						'</perRef>' +
						'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@CodigoEmpresa)),'') + 
										COALESCE(RTRIM(LTRIM(@CodigoLocal)),'') +
										COALESCE(RTRIM(LTRIM(@TipoColaborador)),'') +
										COALESCE(RTRIM(LTRIM(@NumeroRegistro)),'') +
										COALESCE(RTRIM(LTRIM(a.PeriodoCompetencia)),'') +
										COALESCE(RTRIM(LTRIM(@IndApuracao)),'') +
										COALESCE(RTRIM(LTRIM(a.Dissidio)),'') +
						'</ideDmDev>' +
						'<indPgtoTt>' + 'S' + '</indPgtoTt>' +
						'<vrLiq>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrLiq>'
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
--			AND c.CodigoRubricaESocial	> 0
			AND c.RotinaCalculo			IN (570,992) -- Valor Liquido Rescisao e Valor Liquido mensal
			
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa			= a.CodigoEmpresa
			AND d.CodigoLocal			= a.CodigoLocal
			AND d.TipoColaborador		= a.TipoColaborador
			AND	d.NumeroRegistro		= a.NumeroRegistro

			INNER JOIN tbPessoal e
			ON  e.CodigoEmpresa			= a.CodigoEmpresa
			AND e.CodigoLocal			= a.CodigoLocal
			AND e.TipoColaborador		= a.TipoColaborador
			AND e.NumeroRegistro		= a.NumeroRegistro

			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoPagamento		= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
		ELSE -- tipo colaborador = T
		BEGIN
			DECLARE curSaida CURSOR FOR
			SELECT	CASE WHEN e.DataDemissao IS NOT NULL THEN
						'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@CodigoEmpresa)),'') + 
										COALESCE(RTRIM(LTRIM(@CodigoLocal)),'') +
										COALESCE(RTRIM(LTRIM(@TipoColaborador)),'') +
										COALESCE(RTRIM(LTRIM(@NumeroRegistro)),'') +
										COALESCE(RTRIM(LTRIM(a.PeriodoCompetencia)),'') +
										COALESCE(RTRIM(LTRIM(@IndApuracao)),'') +
										COALESCE(RTRIM(LTRIM(a.Dissidio)),'') +
						'</ideDmDev>' +
						'<indPgtoTt>' + 'S' + '</indPgtoTt>' +
						'<vrLiq>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrLiq>' +
						'<nrRecArq>' + RTRIM(LTRIM(@NumeroRecibo)) + '</nrRecArq>'
					ELSE
						'<perRef>' + CASE WHEN @IndApuracao = 5 THEN -- 13o Salario
										LEFT(a.PeriodoCompetencia,4)
									ELSE	
										LEFT(a.PeriodoCompetencia,4) + '-' + RIGHT(a.PeriodoCompetencia,2)
									END +
						'</perRef>' +
						'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@CodigoEmpresa)),'') + 
										COALESCE(RTRIM(LTRIM(@CodigoLocal)),'') +
										COALESCE(RTRIM(LTRIM(@TipoColaborador)),'') +
										COALESCE(RTRIM(LTRIM(@NumeroRegistro)),'') +
										COALESCE(RTRIM(LTRIM(a.PeriodoCompetencia)),'') +
										COALESCE(RTRIM(LTRIM(@IndApuracao)),'') +
										COALESCE(RTRIM(LTRIM(a.Dissidio)),'') +
						'</ideDmDev>' +
						'<indPgtoTt>' + 'S' + '</indPgtoTt>' +
						'<vrLiq>' + REPLACE(RTRIM(LTRIM(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),ABS(b.ValorEvento))))),',','.') + '</vrLiq>'
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
--			AND c.CodigoRubricaESocial	> 0
			AND c.RotinaCalculo			IN (570,992) -- Valor Liquido Rescisao e Valor Liquido mensal
			
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa			= a.CodigoEmpresa
			AND d.CodigoLocal			= a.CodigoLocal
			AND d.TipoColaborador		= a.TipoColaborador
			AND	d.NumeroRegistro		= a.NumeroRegistro

			INNER JOIN tbColaborador e
			ON  e.CodigoEmpresa			= a.CodigoEmpresa
			AND e.CodigoLocal			= a.CodigoLocal
			AND e.TipoColaborador		= a.TipoColaborador
			AND	e.NumeroRegistro		= a.NumeroRegistro

			WHERE a.CodigoEmpresa		= @CodigoEmpresa
			AND a.CodigoLocal			= @CodigoLocal
			AND a.TipoColaborador		= @TipoColaborador
			AND a.NumeroRegistro		= @NumeroRegistro
			AND a.RotinaPagamento		= @IndApuracao
			AND a.PeriodoPagamento		= @PerApuracao
			AND a.DataPagamento			= @DataPagamento
		END
	END
	--
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

go

IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whArquivosFPESocialXML'))
	DROP PROCEDURE whArquivosFPESocialXML
GO
CREATE PROCEDURE dbo.whArquivosFPESocialXML
/*INICIO_CABEC_PROC
------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: FP - Folha de Pagamento
 AUTOR........: Edson Marson
 DATA.........: 18/11/2013
 OBJETIVO.....: Retorno de dados para os arquivos do eSocial em XML. 
				Ticket 151764/2013 - FM 12435/2013
 ...
 
 ALTERACAO....: Edson Marson - 03/05/2018
 OBJETIVO.....: Adequações para a versão 2.4.02.(correções)
				Ticket 274673/2018

 ALTERACAO....: Edson Marson - 09/05/2018
 OBJETIVO.....: Correções para o arquivo S-2299 com valores.
				Ticket 277565/2018

 ALTERACAO....: Edson Marson - 18/05/2018
 OBJETIVO.....: Correções para o arquivo S-1200 com valores.
				Ticket 277565/2018 - Fase II

 ALTERACAO....: Edson Marson - 30/05/2018
 OBJETIVO.....: Correções para os arquivos S-1295/S-1298/S-1299.
				Ticket 277565/2018 - Fase III

 ALTERACAO....: Edson Marson - 05/06/2018
 OBJETIVO.....: Correções para os arquivos S-1295/S-1298/S-1299.
				Ticket 277565/2018 - Fase III - Ajustes

 ALTERACAO....: Edson Marson - 15/08/2018
 OBJETIVO.....: Varias correções efetuadas desde jun2018.
				Ticket XXXXXX/2018

whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = '0',@NomeArquivo = 'S-2300',@TipoColaborador = 'F',@NumeroRegistro = '78',
						@NroRecibo = '2312312313',@ESocialExcluido = 'S-2200',@IndApuracao = Null,@PerApuracao = Null,@Ambiente = 2
------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	@CodigoEmpresa		NUMERIC(4),
	@NomeArquivo		CHAR(6),
	@CodigoLocal		NUMERIC(4)	= NULL,
	@TipoRegistro		CHAR(1)		= NULL,
	@CargaInicial		CHAR(1)		= NULL,
	@TipoColaborador	CHAR(1)		= NULL,
	@NumeroRegistro		NUMERIC(8)  = NULL,
	@NroRecibo			CHAR(40)	= NULL,
	@NroReciboInfPre	CHAR(40)	= NULL,
	@NroReciboDemitido	CHAR(40)	= NULL,
	@ESocialExcluido	CHAR(6)		= NULL,
	@CodLocalMatriz		NUMERIC(4)  = NULL,
	@GeradoXML			CHAR(1)		= NULL,
	@IndApuracao		CHAR(1)		= NULL, -- 1-Mensal, 2-Anual(13.o Salário)
	@PerApuracao		CHAR(6)		= NULL,
	@Ferias				CHAR(1)		= NULL,
	@Ambiente			CHAR(1)		= NULL, -- 1-Produção, 2-Produção Restrita(Homologação)
	@Variavel			CHAR(21)	= NULL,
	@DataHoraArquivo	DATETIME	= NULL

AS

-- variaveis de ambiente
DECLARE @DataProcAMD			CHAR(8)
DECLARE @HoraProcHMS			CHAR(6)
DECLARE @DataHoraProc			CHAR(14)
DECLARE @VersaoLayout			CHAR(10)
DECLARE @VersaoSoftware			CHAR(20)
DECLARE @SequenciaArq			CHAR(5)
DECLARE @DataApuracao			DATETIME
DECLARE @DataInicioESocial		DATETIME
DECLARE @DataInicioESocialFase2	DATETIME
DECLARE @DataInicioESocialFase3	DATETIME
DECLARE @DataInicioESocialFase4	DATETIME
DECLARE @DataInicioESocialFase5	DATETIME

-- Encontra data processamento formato AAAAMMDD
SELECT @DataProcAMD = SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + 
				      SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) +
				      SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),1,2)

-- Encontra horario processamento formato 'HHMMSS' 
SELECT @HoraProcHMS = SUBSTRING(CONVERT(CHAR(8),GETDATE(),108),1,2) + 
				      SUBSTRING(CONVERT(CHAR(8),GETDATE(),108),4,2) + 
				      SUBSTRING(CONVERT(CHAR(8),GETDATE(),108),7,2) 

-- Agrupa data e hora formato 'AAAAMMDD HHMMSS'		-- compoe a tag <id>
SELECT @DataHoraProc = @DataProcAMD + @HoraProcHMS

-- Encontra a sequencia transmissao do arquivo XML	-- compoe a tag <id>
--Incrementar somente quando ocorrer geração de eventos na mesma data/hora, como usei o getdate() dificilmente terá nova sequencia.
SELECT @SequenciaArq = (SELECT SUBSTRING(CONVERT(VARCHAR(6), 100000 + (NumeroUltimaSequencia)),2,5) FROM tbArquivoSequenciaInterface WHERE CodigoTipoArquivo = @NomeArquivo) 

-- Encontra versao do layout
SELECT @VersaoLayout = 'v02_04_02'

-- Encontra versao setup
SELECT @VersaoSoftware = (SELECT RTRIM(LTRIM(SUBSTRING(MAX(VersaoSetup),1,20))) FROM tbControleVersaoSetup)

-- transforma o periodo apuracao em data
IF @IndApuracao = '1'
	IF @PerApuracao IS NOT NULL	SET @DataApuracao = CONVERT(DATETIME,LEFT(@PerApuracao,4) + '-' + RIGHT(@PerApuracao,2) + '-' + '01')
ELSE
	IF @PerApuracao IS NOT NULL	SET @DataApuracao = CONVERT(DATETIME,LEFT(@PerApuracao,4) + '-' + '12' + '-' + '01')

-- seta a data de inicio da empresa no eSocial
SELECT @DataInicioESocial		= (SELECT DataESocialIniciado FROM tbEmpresaFP WHERE CodigoEmpresa = @CodigoEmpresa )
SELECT @DataInicioESocialFase2	= (SELECT DataESocialIniciadoFase2 FROM tbEmpresaFP WHERE CodigoEmpresa = @CodigoEmpresa )
SELECT @DataInicioESocialFase3	= (SELECT DataESocialIniciadoFase3 FROM tbEmpresaFP WHERE CodigoEmpresa = @CodigoEmpresa )
SELECT @DataInicioESocialFase4	= (SELECT DataESocialIniciadoFase4 FROM tbEmpresaFP WHERE CodigoEmpresa = @CodigoEmpresa )
SELECT @DataInicioESocialFase5	= (SELECT DataESocialIniciadoFase5 FROM tbEmpresaFP WHERE CodigoEmpresa = @CodigoEmpresa )

-- variaveis das functions
DECLARE @SalarioFixo		VARCHAR(2000)
DECLARE @Dependentes		VARCHAR(2000)
DECLARE @Beneficiario		VARCHAR(2000)
DECLARE @Tomadores			VARCHAR(2000)
DECLARE @TomadoresDomic		VARCHAR(2000)
DECLARE @Transferencias		VARCHAR(2000)
DECLARE @TransferenciasCNPJ	VARCHAR(2000)
DECLARE @ASOs				VARCHAR(2000)
DECLARE @ValorRubricasV		VARCHAR(8000)
DECLARE @ValorRubricasD		VARCHAR(8000)
DECLARE @ValorRubricasB		VARCHAR(8000)
DECLARE @ValorPlanoSaudeTit	VARCHAR(2000)
DECLARE @ValorPlanoSaudeDep	VARCHAR(2000)
DECLARE @ValorPlanoSaudeOpe	VARCHAR(2000)
DECLARE @ValorBaseIRRF		VARCHAR(8000)
DECLARE @ValorLiquido		VARCHAR(2000)
DECLARE @PartesAtingidas	VARCHAR(2000)
DECLARE @AgentesCausadores	VARCHAR(2000)
DECLARE @MultiplosVinculos  VARCHAR(2000)
DECLARE @ProcessoAdmJudMes	VARCHAR(2000)
DECLARE @DissidioAcordoMes	VARCHAR(2000)
DECLARE @ContrSindPatronal	VARCHAR(2000)

-- variáveis do cursor Horario
DECLARE
	@curhorCodigoEmpresa	NUMERIC(4), 
	@curhorCodigoLocal		NUMERIC(4), 
	@curhorCodigoHorario	NUMERIC(4) 

-- variáveis do cursor Movimento Mensal
DECLARE
	@curDataESocialIniciado DATETIME,
	@curCodigoEmpresa		NUMERIC(4), 
	@curCodigoLocal			NUMERIC(4), 
	@curTipoColaborador		CHAR(1), 
	@curNumeroRegistro		NUMERIC(8), 
	@curPeriodoCompetencia	CHAR(6), 
	@curPeriodoPagamento	CHAR(6), 
	@curRotinaPagamento		NUMERIC(1), 
	@curDataPagamento		DATETIME,
	@curDissidio			CHAR(1), 
	@curCondicaoColaborador	NUMERIC(1),
	@curCodigoCliFor		NUMERIC(14),
	@curCategoriaESocial    NUMERIC(3),
	@curMatriculaESocial	VARCHAR(12),
	@curAgenteNocivoESocial	NUMERIC(1),
	@curResidenteBrasil		CHAR(1)	

-- variáveis plano saude
DECLARE	@curRegistroANS		NUMERIC(6),
		@curRegistroANSDep	NUMERIC(6),
		@curSeqDependente	NUMERIC(2)

-- temp a ser usada para todos os arquivos
DECLARE @xml TABLE 
	( 
		Linha	 VARCHAR(8000),
		Ordem	 VARCHAR(25),
		OrdemAux NUMERIC(4) 
	)

-- variaveis da temp
DECLARE @LinhaAux	VARCHAR(2000),
		@OrdemAux	NUMERIC(4),
		@SaudeColet CHAR(1)
SET @LinhaAux	= ''
SET @OrdemAux	= 0
SET @SaudeColet = 'F'

SET NOCOUNT ON

-- Eventos Iniciais e de Tabelas (12 arquivos, Tipo 'EI')
IF @NomeArquivo = 'S-1000' GOTO ARQ_S1000 -- Informações do Empregador-Contribuinte
IF @NomeArquivo = 'S-1005' GOTO ARQ_S1005 -- Tabela de Estabelecimentos e Obras de Construção Civil
IF @NomeArquivo = 'S-1010' GOTO ARQ_S1010 -- Tabela de Rubricas
IF @NomeArquivo = 'S-1020' GOTO ARQ_S1020 -- Tabela de Lotações Tributárias
IF @NomeArquivo = 'S-1030' GOTO ARQ_S1030 -- Tabela de Cargos-Empregos Públicos
--IF @NomeArquivo = 'S-1035' GOTO ARQ_S1035 -- Tabela de Carreiras Públicas  -------------------------------- ( não fazer no DealerPlus )
--IF @NomeArquivo = 'S-1040' GOTO ARQ_S1040 -- Tabela de Funções-Cargos em Comissão  ------------------------ ( não fazer no DealerPlus ) 
IF @NomeArquivo = 'S-1050' GOTO ARQ_S1050 -- Tabela de Horários-Turnos de Trabalho
IF @NomeArquivo = 'S-1060' GOTO ARQ_S1060 -- Tabela de Ambientes de Trabalho  
IF @NomeArquivo = 'S-1070' GOTO ARQ_S1070 -- Tabela de Processos Administrativos-Judiciais
--IF @NomeArquivo = 'S-1080' GOTO ARQ_S1080 -- Tabela de Operadores Portuários  ----------------------------- ( não fazer no DealerPlus )

-- Eventos Periódicos (11 arquivos, Tipo 'EP')
IF @NomeArquivo = 'S-1200' GOTO ARQ_S1200 -- Remuneração do Trabalhado
--IF @NomeArquivo = 'S-1202' GOTO ARQ_S1202 -- Remuneração de Trabalhado RPPS  ------------------------------ ( não fazer no DealerPlus )
--IF @NomeArquivo = 'S-1207' GOTO ARQ_S1207 -- Benefícios Previdenciários - RPPS  --------------------------- ( não fazer no DealerPlus )
IF @NomeArquivo = 'S-1210' GOTO ARQ_S1210 -- Pagamentos de Rendimentos do Trabalho 
--IF @NomeArquivo = 'S-1250' GOTO ARQ_S1250 -- Aquisição de Produção Rural  --------------------------------- ( não fazer no DealerPlus )
--IF @NomeArquivo = 'S-1260' GOTO ARQ_S1260 -- Comercialização da Produção Rural Pessoa Física  ------------- ( não fazer no DealerPlus )
--IF @NomeArquivo = 'S-1270' GOTO ARQ_S1270 -- Contratação de Trabalhadores Avulsos Não Portuários ---------- ( não fazer no DealerPlus )
--IF @NomeArquivo = 'S-1280' GOTO ARQ_S1280 -- Informações Complementares aos Eventos Periódicos  ----------- ( não fazer no DealerPlus )
IF @NomeArquivo = 'S-1295' GOTO ARQ_S1295 -- Solicitação de Totalização para Pagamento em Contingência 
IF @NomeArquivo = 'S-1298' GOTO ARQ_S1298 -- Reabertura dos Eventos Periódicos 
IF @NomeArquivo = 'S-1299' GOTO ARQ_S1299 -- Fechamento dos Eventos Periódicos
IF @NomeArquivo = 'S-1300' GOTO ARQ_S1300 -- Contribuição Sindical Patronal 

-- Eventos Não Periódicos (22 arquivos, Tipo 'EN')
IF @NomeArquivo = 'S-2190' GOTO ARQ_S2190 -- Admissão de Trabalhador - Registro Preliminar 
IF @NomeArquivo = 'S-2200' GOTO ARQ_S2200 -- Cadastramento Inicial do Vínculo e Admissão/Ingresso de Trabalhador
IF @NomeArquivo = 'S-2205' GOTO ARQ_S2205 -- Alteração de Dados Cadastrais do Trabalhador
IF @NomeArquivo = 'S-2206' GOTO ARQ_S2206 -- Alteração de Contrato de Trabalho
IF @NomeArquivo = 'S-2210' GOTO ARQ_S2210 -- Comunicação de Acidente de Trabalho
IF @NomeArquivo = 'S-2220' GOTO ARQ_S2220 -- Monitoramento da Saúde do Trabalhador
IF @NomeArquivo = 'S-2230' GOTO ARQ_S2230 -- Afastamento Temporário
IF @NomeArquivo = 'S-2240' GOTO ARQ_S2240 -- Condições Ambientais do Trabalho - Fatores de Risco 
IF @NomeArquivo = 'S-2241' GOTO ARQ_S2241 -- Insalubridade, Periculosidade e Aposentadoria Especial 
IF @NomeArquivo = 'S-2250' GOTO ARQ_S2250 -- Aviso Prévio
--IF @NomeArquivo = 'S-2260' GOTO ARQ_S2260 -- Convocação para Trabalho Intermitente ------------------------ ( não fazer no DealerPlus )
IF @NomeArquivo = 'S-2298' GOTO ARQ_S2298 -- Reintegração
IF @NomeArquivo = 'S-2299' GOTO ARQ_S2299 -- Desligamento 
IF @NomeArquivo = 'S-2300' GOTO ARQ_S2300 -- Trabalhador Sem Vínculo - Início
IF @NomeArquivo = 'S-2306' GOTO ARQ_S2306 -- Trabalhador Sem Vínculo - Alteração Contratual
IF @NomeArquivo = 'S-2399' GOTO ARQ_S2399 -- Trabalhador Sem Vínculo - Término
--IF @NomeArquivo = 'S-2400' GOTO ARQ_S2400 -- Cadastro de Benefícios Previdenciários - RPPS ---------------- ( não fazer no DealerPlus )
IF @NomeArquivo = 'S-3000' GOTO ARQ_S3000 -- Exclusão de Eventos
--IF @NomeArquivo = 'S-4000' GOTO ARQ_S4000 -- Solicitação de Totalização de Eventos, Bases e Contribuições 

-- Arquivos de retorno solicitados pelo S-4000 ( tratar na proc de retorno )
--IF @NomeArquivo = 'S-5001' GOTO ARQ_S5001 -- Totalização da Contribuição Previdenciária por Trabalhador
--IF @NomeArquivo = 'S-5002' GOTO ARQ_S5002 -- Totalização do IRRF por Trabalhador
--IF @NomeArquivo = 'S-5011' GOTO ARQ_S5011 -- Totalização da Contribuição Previdenciária por Empregador
--IF @NomeArquivo = 'S-5012' GOTO ARQ_S5012 -- Totalização do IRRF por Empregador
-- ( 45 Arquivos no Total ) 
GOTO ARQ_FIM	

-- Inicia XMLS
ARQ_S1000:
---- INICIO XML Empregador
BEGIN
--whArquivosFPESocialXML 1608, 'S-1000', 0, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N', '2'
	IF @CargaInicial = 'S'
	BEGIN
		-- dados cabeçalho
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtInfoEmpregador/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtInfoEmpregador Id="ID' +	
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoEmpregador>' +
					'<inclusao>' +
						'<idePeriodo>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</idePeriodo>' +
						'<infoCadastro>' +
							'<nmRazao>' + COALESCE(RTRIM(LTRIM(b.DescricaoLocal)),'') + '</nmRazao>' +
							'<classTrib>' + RIGHT(100 + COALESCE(RTRIM(LTRIM(a.ClassificacaoTributaria)),''),2) + '</classTrib>' +
							'<natJurid>' + COALESCE(RTRIM(LTRIM(a.NaturezaJuridica)),'') + '</natJurid>' +
							'<indCoop>' + COALESCE(RTRIM(LTRIM(a.CooperativaTrabalho)),'') + '</indCoop>' +
							'<indConstr>' + CASE WHEN COALESCE(RTRIM(LTRIM(a.Construtora)),'F') = 'F' THEN '0' ELSE '1' END + '</indConstr>' +
							'<indDesFolha>' + COALESCE(RTRIM(LTRIM(c.DesoneracaoFolha)),'') + '</indDesFolha>' +
							'<indOptRegEletron>' + COALESCE(RTRIM(LTRIM(c.PontoEletronico)),'') + '</indOptRegEletron>' +
							'<indEntEd>' + 'N' + '</indEntEd>' +
							'<indEtt>' + 'N' + '</indEtt>' +
							--'<nrRegEtt>' + '</nrRegEtt>' + -- preencher se indEtt = 'S'
						CASE WHEN a.SiglaCertifIsencao IS NULL OR RTRIM(LTRIM(a.SiglaCertifIsencao)) = '' THEN
							''
						ELSE
							'<dadosIsencao>' +
								'<ideMinLei>' + COALESCE(RTRIM(LTRIM(a.SiglaCertifIsencao)),'') + '</ideMinLei>' +
								'<nrCertif>' + COALESCE(RTRIM(LTRIM(a.NumeroCertifIsencao)),'') + '</nrCertif>' +
								'<dtEmisCertif>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataEmisCertifIsencao)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataEmisCertifIsencao)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataEmisCertifIsencao)),2,2),'') +
								'</dtEmisCertif>' + 
								'<dtVencCertif>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataVectoCertifIsencao)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataVectoCertifIsencao)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataVectoCertifIsencao)),2,2),'') +
								'</dtVencCertif>' + 
							CASE WHEN a.NumeroProtRenovIsencao IS NULL OR RTRIM(LTRIM(a.NumeroProtRenovIsencao)) = '' THEN
								''
							ELSE
								'<nrProtRenov>' + COALESCE(RTRIM(LTRIM(a.NumeroProtRenovIsencao)),'') + '</nrProtRenov>' +
								'<dtProtRenov>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataProtRenovIsencao)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataProtRenovIsencao)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataProtRenovIsencao)),2,2),'') +
								'</dtProtRenov>' + 
								'<dtDou>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataDOUIsencao)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataDOUIsencao)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataDOUIsencao)),2,2),'') +
								'</dtDou>' + 
								'<pagDou>' + COALESCE(RTRIM(LTRIM(a.PaginaDOUIsencao)),'') + '</pagDou>' 
							END +
							'</dadosIsencao>' 
						END +
							'<contato>' +
								'<nmCtt>' + COALESCE(RTRIM(LTRIM(c.NomeContatoESocial)),'') + '</nmCtt>' +
								'<cpfCtt>' + COALESCE(RTRIM(LTRIM(c.CPFContatoESocial)),'') + '</cpfCtt>' +
							CASE WHEN c.FoneFixoContatoESocial IS NULL OR RTRIM(LTRIM(c.FoneFixoContatoESocial)) = '' THEN	
								''
							ELSE
								'<foneFixo>' + c.FoneFixoContatoESocial + '</foneFixo>' 
							END +
							CASE WHEN c.FoneCelularContatoESocial IS NULL OR RTRIM(LTRIM(c.FoneCelularContatoESocial)) = '' THEN	
								''
							ELSE
								'<foneCel>' + c.FoneCelularContatoESocial + '</foneCel>' 
							END +
							CASE WHEN c.EmailContatoESocial IS NULL OR RTRIM(LTRIM(c.EmailContatoESocial)) = '' THEN	
								''
							ELSE
								'<email>' + c.EmailContatoESocial + '</email>' 
							END +
							'</contato>' +
							--Informações relativas a Órgãos Públicos
							--'<infoOP>' +
							--	'<nrSiafi>' + '</nrSiafi>' +
							--	'<infoEFR>' +
							--		'<ideEFR>' + '</ideEFR>' +
							--		'<cnpjEFR>' + '</cnpjEFR>' +
							--	'</infoEFR>' +
							--	'<infoEnte>' +
							--		'<nmEnte>' + '</nmEnte>' +
							--		'<uf>' + '</uf>' +
							--		'<codMunic>' + '</codMunic>' +
							--		'<indRPPS>' + '</indRPPS>' +
							--		'<subteto>' + '</subteto>' +
							--		'<vrSubteto>' + '</vrSubteto>' +
							--	'</infoEnte>' +
							--'</infoOP>' +
							--Informações exclusivas de organismos internacionais e outras instituições extraterritoriais
--							'<infoOrgInternacional>' +
--								'<indAcordoIsenMulta>' + '0' + '</indAcordoIsenMulta>' +
--							'</infoOrgInternacional>' +
							'<softwareHouse>' +
								'<cnpjSoftHouse>' + '04426565001591' + '</cnpjSoftHouse>' +
								'<nmRazao>' + 'T-SYSTEMS DO BRASIL LTDA' + '</nmRazao>' +
								'<nmCont>' + 'CENTRAL DE SUPORTE' + '</nmCont>' +
								'<telefone>' + '1121842500' + '</telefone>' +
								'<email>' + 'CENTRAL@T-SYSTEMS.COM.BR' + '</email>' +
							'</softwareHouse>' +
							'<infoComplementares>' +
								'<situacaoPJ>' +  
									'<indSitPJ>' + '0' + '</indSitPJ>' +
								'</situacaoPJ>' +
--								'<situacaoPF>' +  
--									'<indSitPF>' + '' + '</indSitPF>' +
--								'</situacaoPF>' +
							'</infoComplementares>' +
						'</infoCadastro>' +
					'</inclusao>' +
				'</infoEmpregador>' +
			'</evtInfoEmpregador>' +
		'</eSocial>',
		COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),14),'00000000000000'),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal
		
		INNER JOIN tbEmpresaFP c
		ON c.CodigoEmpresa = a.CodigoEmpresa

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   a.Matriz			= 'V'
	END
	ELSE--não é @CargaInicial
	BEGIN
		IF @TipoRegistro <> 'E'--não é exclusão de dados
		BEGIN
--execute whArquivosFPESocialXML @CodigoEmpresa = 1608,@NomeArquivo = 'S-1000',@TipoRegistro = 'A',@GeradoXML = 'F', @CodLocalMatriz = 0
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtInfoEmpregador/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtInfoEmpregador Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoEmpregador>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>' 
					ELSE
						'<alteracao>'
					END +
							'<idePeriodo>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
								'</iniValid>'  
							END +
							CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
								'</fimValid>' 
							ELSE
								''
							END +
							'</idePeriodo>' +
							'<infoCadastro>' +
								'<nmRazao>' + COALESCE(RTRIM(LTRIM(b.DescricaoLocal)),'') + '</nmRazao>' +
								'<classTrib>' + RIGHT( 100 + COALESCE(RTRIM(LTRIM(a.ClassificacaoTributaria)),''),2) + '</classTrib>' +
								'<natJurid>' + COALESCE(RTRIM(LTRIM(a.NaturezaJuridica)),'') + '</natJurid>' +
								'<indCoop>' + COALESCE(RTRIM(LTRIM(a.CooperativaTrabalho)),'') + '</indCoop>' +
								'<indConstr>' + CASE WHEN COALESCE(RTRIM(LTRIM(a.Construtora)),'F') = 'F' THEN '0' ELSE '1' END + '</indConstr>' +
								'<indDesFolha>' + COALESCE(RTRIM(LTRIM(c.DesoneracaoFolha)),'') + '</indDesFolha>' +
								'<indOptRegEletron>' + COALESCE(RTRIM(LTRIM(c.PontoEletronico)),'') + '</indOptRegEletron>' +
								'<indEntEd>' + 'N' + '</indEntEd>' +
								'<indEtt>' + 'N' + '</indEtt>' +
								--'<nrRegEtt>' + '</nrRegEtt>' + -- preencher se indEtt = 'S'
							CASE WHEN a.SiglaCertifIsencao IS NULL OR RTRIM(LTRIM(a.SiglaCertifIsencao)) = '' THEN
								''
							ELSE
								'<dadosIsencao>' +
									'<ideMinLei>' + COALESCE(RTRIM(LTRIM(a.SiglaCertifIsencao)),'') + '</ideMinLei>' +
									'<nrCertif>' + COALESCE(RTRIM(LTRIM(a.NumeroCertifIsencao)),'') + '</nrCertif>' +
									'<dtEmisCertif>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataEmisCertifIsencao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataEmisCertifIsencao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataEmisCertifIsencao)),2,2),'') +
									'</dtEmisCertif>' + 
									'<dtVencCertif>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataVectoCertifIsencao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataVectoCertifIsencao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataVectoCertifIsencao)),2,2),'') +
									'</dtVencCertif>' + 
								CASE WHEN a.NumeroProtRenovIsencao IS NULL OR RTRIM(LTRIM(a.NumeroProtRenovIsencao)) = '' THEN
									''
								ELSE
									'<nrProtRenov>' + COALESCE(RTRIM(LTRIM(a.NumeroProtRenovIsencao)),'') + '</nrProtRenov>' +
									'<dtProtRenov>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataProtRenovIsencao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataProtRenovIsencao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataProtRenovIsencao)),2,2),'') +
									'</dtProtRenov>' + 
									'<dtDou>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataDOUIsencao)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataDOUIsencao)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataDOUIsencao)),2,2),'') +
									'</dtDou>' + 
									'<pagDou>' + COALESCE(RTRIM(LTRIM(a.PaginaDOUIsencao)),'') + '</pagDou>' 
								END +
								'</dadosIsencao>' 
							END +
								'<contato>' +
									'<nmCtt>' + COALESCE(RTRIM(LTRIM(c.NomeContatoESocial)),'') + '</nmCtt>' +
									'<cpfCtt>' + COALESCE(RTRIM(LTRIM(c.CPFContatoESocial)),'') + '</cpfCtt>' +
								CASE WHEN c.FoneFixoContatoESocial IS NULL OR RTRIM(LTRIM(c.FoneFixoContatoESocial)) = '' THEN	
									''
								ELSE
									'<foneFixo>' + c.FoneFixoContatoESocial + '</foneFixo>' 
								END +
								CASE WHEN c.FoneCelularContatoESocial IS NULL OR RTRIM(LTRIM(c.FoneCelularContatoESocial)) = '' THEN	
									''
								ELSE
									'<foneCel>' + c.FoneCelularContatoESocial + '</foneCel>' 
								END +
								CASE WHEN c.EmailContatoESocial IS NULL OR RTRIM(LTRIM(c.EmailContatoESocial)) = '' THEN	
									''
								ELSE
									'<email>' + c.EmailContatoESocial + '</email>' 
								END +
								'</contato>' +
								--Informações relativas a Órgãos Públicos
								--'<infoOP>' +
								--	'<nrSiafi>' + '</nrSiafi>' +
								--	'<infoEFR>' +
								--		'<ideEFR>' + '</ideEFR>' +
								--		'<cnpjEFR>' + '</cnpjEFR>' +
								--	'</infoEFR>' +
								--	'<infoEnte>' +
								--		'<nmEnte>' + '</nmEnte>' +
								--		'<uf>' + '</uf>' +
								--		'<codMunic>' + '</codMunic>' +
								--		'<indRPPS>' + '</indRPPS>' +
								--		'<subteto>' + '</subteto>' +
								--		'<vrSubteto>' + '</vrSubteto>' +
								--	'</infoEnte>' +
								--'</infoOP>' +
								--Informações exclusivas de organismos internacionais e outras instituições extraterritoriais
--								'<infoOrgInternacional>' +
--									'<indAcordoIsenMulta>' + '0' + '</indAcordoIsenMulta>' +
--								'</infoOrgInternacional>' +
								'<softwareHouse>' +
									'<cnpjSoftHouse>' + '04426565001591' + '</cnpjSoftHouse>' +
									'<nmRazao>' + 'T-SYSTEMS DO BRASIL LTDA' + '</nmRazao>' +
									'<nmCont>' + 'CENTRAL DE SUPORTE' + '</nmCont>' +
									'<telefone>' + '1121842500' + '</telefone>' +
									'<email>' + 'CENTRAL@T-SYSTEMS.COM.BR' + '</email>' +
								'</softwareHouse>' +
								'<infoComplementares>' +
									'<situacaoPJ>' +  
										'<indSitPJ>' + '0' + '</indSitPJ>' +
									'</situacaoPJ>' +
--									'<situacaoPF>' +  
--										'<indSitPF>' + '' + '</indSitPF>' +
--									'</situacaoPF>' +
								'</infoComplementares>' +
							'</infoCadastro>' +
						CASE WHEN @TipoRegistro = 'I' THEN
							'</inclusao>'
						ELSE	
								'<novaValidade>' + 
									'<iniValid>' +	SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
													SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) + 
									'</iniValid>' + 
									--'<fimValid>' + '</fimValid>' + 
								'</novaValidade>' +								
							'</alteracao>' 
						END +
					'</infoEmpregador>' +
				'</evtInfoEmpregador>' +
			'</eSocial>',
			COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),14),'00000000000000'),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal
			
			INNER JOIN tbEmpresaFP c
			ON c.CodigoEmpresa = a.CodigoEmpresa

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal 	= @CodigoLocal
			AND   a.Matriz			= 'V'
		END
		IF @TipoRegistro = 'E'--é exclusão de dados
		BEGIN
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtInfoEmpregador/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtInfoEmpregador Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoEmpregador>' +
						'<exclusao>' + 
							'<idePeriodo>' + 
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
								'</iniValid>'  
							END +
							CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
								'</fimValid>' 
							ELSE
								''
							END +
							'</idePeriodo>' +
						'</exclusao>' +
					'</infoEmpregador>' +
				'</evtInfoEmpregador>' +
			'</eSocial>',
			0,
			@OrdemAux + 1
			FROM tbLocal b

			INNER JOIN tbLocalFP a
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON c.CodigoEmpresa = b.CodigoEmpresa

			WHERE b.CodigoEmpresa	= @CodigoEmpresa
			AND   b.CodigoLocal		= @CodigoLocal
			AND   a.Matriz			= 'V'
		END
	END
	---- FIM XML Empregador
END
GOTO ARQ_FIM

ARQ_S1005:
---- INICIO XML Estabelecimentos
BEGIN
--whArquivosFPESocialXML 1608, 'S-1005', 0, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N','3'
	IF @CargaInicial = 'S'
	BEGIN
		-- dados cabeçalho
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabEstab/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabEstab Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoEstab>' +
					'<inclusao>' +
						'<ideEstab>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
								'</iniValid>'  
							END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideEstab>' +
						'<dadosEstab>' +
							'<cnaePrep>' + COALESCE(RTRIM(LTRIM(a.CodigoAtividadeEconomica)),'') + 
											COALESCE(RTRIM(LTRIM(CONVERT(CHAR(2),a.ComplementoCNAE))),'') +							
							'</cnaePrep>' +
							'<aliqGilrat>' +
								'<aliqRat>' + COALESCE(RTRIM(LTRIM(LEFT(a.PercentualRATLocal,1))),'') + '</aliqRat>' +
								'<fap>' + COALESCE(RTRIM(LTRIM(a.PercentualFAPLocal)),'') + '</fap>' +
								'<aliqRatAjust>' + COALESCE(RTRIM(LTRIM(a.PercentualSATLocal)),'') + '</aliqRatAjust>' +
							CASE WHEN a.CodigoProcessoRAT IS NOT NULL THEN
								'<procAdmJudRat>' +
									'<tpProc>' + CASE WHEN RTRIM(LTRIM(a.CodigoProcessoRAT)) = 'A' THEN '1' ELSE '2' END + '</tpProc>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(a.NumeroProcessoRAT)),'') + '</nrProc>' +
									'<codSusp>' + '</codSusp>' +
								'</procAdmJudRat>' 
							ELSE
								''
							END +
							CASE WHEN a.CodigoProcessoFAP IS NOT NULL THEN
								'<procAdmJudFap>' +
									'<tpProc>' + CASE RTRIM(LTRIM(a.CodigoProcessoFAP)) 
													WHEN 'A' THEN '1'
													WHEN 'J' THEN '2'
													WHEN 'P' THEN '4'
												 ELSE
													''
												 END +
									'</tpProc>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(a.NumeroProcessoFAP)),'') + '</nrProc>' +
									'<codSusp>' + '</codSusp>' +
								'</procAdmJudFap>' 
							ELSE
								''
							END +
							'</aliqGilrat>' +
							--Informações relativas ao Cadastro da Atividade Econômica da Pessoa Física
							--'<infoCaepf>' +
							--	'<tpCaepf>' + '</tpCaepf>' +
							--'</infoCaepf>' +
							--Registro preenchido exclusivamente por empresa construtora
							CASE WHEN a.Construtora = 'V' THEN
								'<infoObra>' +
									'<indSubstPatrObra>' + '2' + '</indSubstPatrObra>' +
								'</infoObra>' 
							ELSE
								''
							END +
							'<infoTrab>' +
								'<regPt>' + COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.RegistroPonto))),'') + '</regPt>' +
								'<infoApr>' + 
									'<contApr>' + COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') + '</contApr>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') = 1 THEN
									'<nrProcJud>' + RTRIM(LTRIM(a.NumeroProcessoAprendiz)) + '</nrProcJud>' 
								ELSE
									''
								END +
									'<contEntEd>' + CASE WHEN RTRIM(LTRIM(a.EntidadeContrAprendiz)) = 'V' THEN 'S' ELSE 'N' END + '</contEntEd>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') <> 0 THEN
									'<infoEntEduc>' + 
										'<nrInsc>' + (	
														SELECT COALESCE(CONVERT(CHAR(14),MAX(RTRIM(LTRIM(CNPJInstEnsino)))),'') 
														FROM tbEstagio 
														WHERE AreaAtuacao = 'ESOCIAL'
														AND   CodigoEmpresa = a.CodigoEmpresa
														) + 
										'</nrInsc>' +
									'</infoEntEduc>' 
								ELSE
									''
								END +
								'</infoApr>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(a.Matriz)),'F') = 'V' THEN
								'<infoPCD>' + 
									'<contPCD>' + COALESCE(RTRIM(LTRIM(a.ContratacaoPCD)),'') + '</contPCD>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(a.ContratacaoPCD)),'') = 1 THEN
									'<nrProcJud>' + RTRIM(LTRIM(a.NumeroProcessoPCD)) + '</nrProcJud>' 
								ELSE
									''
								END +
								'</infoPCD>' 
							ELSE
								''
							END +
							'</infoTrab>' +
						'</dadosEstab>' +
					'</inclusao>' +
				'</infoEstab>' +
			'</evtTabEstab>' +
		'</eSocial>',
		COALESCE(RTRIM(LTRIM(b.CGCLocal)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP c
		ON c.CodigoEmpresa = b.CodigoEmpresa

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
	END
	ELSE -- não é @CargaInicial
	BEGIN
		IF @TipoRegistro <> 'E' -- não é exclusão de dados
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabEstab/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabEstab Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoEstab>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
							'<ideEstab>' +
								'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
								'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
									'</iniValid>'  
								END +
							CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
								'</fimValid>' 
							ELSE
								''
							END +
							'</ideEstab>' +
							'<dadosEstab>' +
								'<cnaePrep>' + COALESCE(RTRIM(LTRIM(a.CodigoAtividadeEconomica)),'') + 
												COALESCE(RTRIM(LTRIM(CONVERT(CHAR(2),a.ComplementoCNAE))),'') +							
								'</cnaePrep>' +
								'<aliqGilrat>' +
									'<aliqRat>' + COALESCE(RTRIM(LTRIM(LEFT(a.PercentualRATLocal,1))),'') + '</aliqRat>' +
									'<fap>' + COALESCE(RTRIM(LTRIM(a.PercentualFAPLocal)),'') + '</fap>' +
									'<aliqRatAjust>' + COALESCE(RTRIM(LTRIM(a.PercentualSATLocal)),'') + '</aliqRatAjust>' +
								CASE WHEN a.CodigoProcessoRAT IS NOT NULL THEN
									'<procAdmJudRat>' +
										'<tpProc>' + CASE WHEN RTRIM(LTRIM(a.CodigoProcessoRAT)) = 'A' THEN '1' ELSE '2' END + '</tpProc>' +
										'<nrProc>' + COALESCE(RTRIM(LTRIM(a.NumeroProcessoRAT)),'') + '</nrProc>' +
										'<codSusp>' + '</codSusp>' +
									'</procAdmJudRat>' 
								END +
								CASE WHEN a.CodigoProcessoFAP IS NOT NULL THEN
									'<procAdmJudFap>' +
										'<tpProc>' + CASE RTRIM(LTRIM(a.CodigoProcessoFAP)) 
														WHEN 'A' THEN '1'
														WHEN 'J' THEN '2'
														WHEN 'P' THEN '4'
													 ELSE
														''
													 END +
										'</tpProc>' +
										'<nrProc>' + COALESCE(RTRIM(LTRIM(a.NumeroProcessoFAP)),'') + '</nrProc>' +
										'<codSusp>' + '</codSusp>' +
									'</procAdmJudFap>' 
								END +
								'</aliqGilrat>' +
								--Informações relativas ao Cadastro da Atividade Econômica da Pessoa Física
								--'<infoCaepf>' +
								--	'<tpCaepf>' + '</tpCaepf>' +
								--'</infoCaepf>' +
								--Registro preenchido exclusivamente por empresa construtora
								CASE WHEN a.Construtora = 'V' THEN
									'<infoObra>' +
										'<indSubstPatrObra>' + '2' + '</indSubstPatrObra>' +
									'</infoObra>' 
								ELSE
									''
								END +
								'<infoTrab>' +
									'<regPt>' + COALESCE(RTRIM(LTRIM(a.RegistroPonto)),'') + '</regPt>' +
									'<infoApr>' + 
										'<contApr>' + COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') + '</contApr>' +
									CASE WHEN COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') = 1 THEN
										'<nrProcJud>' + RTRIM(LTRIM(a.NumeroProcessoAprendiz)) + '</nrProcJud>' 
									ELSE
										''
									END +
										'<contEntEd>' + CASE WHEN RTRIM(LTRIM(a.EntidadeContrAprendiz)) = 'V' THEN 'S' ELSE 'N' END + '</contEntEd>' +
									CASE WHEN COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),a.ContratacaoAprendiz))),'') <> 0 THEN
										'<infoEntEduc>' + 
											'<nrInsc>' + (	
															SELECT COALESCE(CONVERT(CHAR(14),MAX(RTRIM(LTRIM(CNPJInstEnsino)))),'') 
															FROM tbEstagio 
															WHERE AreaAtuacao = 'ESOCIAL'
															AND   CodigoEmpresa = a.CodigoEmpresa
															) + 
											'</nrInsc>' +
										'</infoEntEduc>' 
									END +
									'</infoApr>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(a.Matriz)),'F') = 'V' THEN
									'<infoPCD>' + 
										'<contPCD>' + COALESCE(RTRIM(LTRIM(a.ContratacaoPCD)),'') + '</contPCD>' +
									CASE WHEN COALESCE(RTRIM(LTRIM(a.ContratacaoPCD)),'') = 1 THEN
										'<nrProcJud>' + RTRIM(LTRIM(a.NumeroProcessoPCD)) + '</nrProcJud>' 
									ELSE
										''
									END +
									'</infoPCD>' 
								END +
								'</infoTrab>' +
							'</dadosEstab>' +
						CASE WHEN @TipoRegistro = 'A' THEN
							'<novaValidade>' +
								'<iniValid>' +	SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
												SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) + 
								'</iniValid>' + 
								--'<fimValid>' + '</fimValid>' + 
							'</novaValidade>' 
						ELSE
							''
						END +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>'
					ELSE
						'</alteracao>' 
					END +
					'</infoEstab>' +
				'</evtTabEstab>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(b.CGCLocal)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON c.CodigoEmpresa = b.CodigoEmpresa

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
		END
		IF @TipoRegistro = 'E' -- é exclusão de dados
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabEstab/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabEstab Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoEstab>' +
						'<exclusao>' +
							'<ideEstab>' +
								'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
								'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
									'</iniValid>'  
								END +
								'<fimValid>' +	SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
												SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) + 
								'</fimValid>' + 
							'</ideEstab>'+
						'</exclusao>' +
					'</infoEstab>' +
				'</evtTabEstab>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(b.CGCLocal)),''),
			@OrdemAux + 1
			FROM tbLocal b
						
			INNER JOIN tbLocalFP a
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON c.CodigoEmpresa = b.CodigoEmpresa

			WHERE b.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal			
		END
	END
	---- FIM XML Estabelecimentos
END
GOTO ARQ_FIM

ARQ_S1010:
---- INICIO XML Tabela de Rubricas
BEGIN
--whArquivosFPESocialXML 1608, 'S-1010', 0, 'I', 'S', null, null, null,null, null, null, null, null, 'N', '2'
	IF @CargaInicial = 'S'
	BEGIN
		-- dados rubricas
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabRubrica/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabRubrica Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoRubrica>' +
					'<inclusao>' +
						'<ideRubrica>' +
							'<codRubr>' + COALESCE(RTRIM(LTRIM(c.CodigoEvento)),'') + '</codRubr>' +
							'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') + 
								'</iniValid>'  
							END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideRubrica>' +
						'<dadosRubrica>' +
							'<dscRubr>' + COALESCE(RTRIM(LTRIM(c.DescricaoEvento)),'') + '</dscRubr>' +
							'<natRubr>' + COALESCE(RTRIM(LTRIM(c.CodigoRubricaESocial)),'') + '</natRubr>' +
							'<tpRubr>' + COALESCE(RTRIM(LTRIM(d.TipoRubrica)),'') + '</tpRubr>' +
							'<codIncCP>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseInssESocial),'')))),2) + '</codIncCP>' +
							'<codIncIRRF>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseIrrfESocial),'')))),2) + '</codIncIRRF>' +
							'<codIncFGTS>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseFgtsESocial),'')))),2) + '</codIncFGTS>' +
							'<codIncSIND>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseSindicalESocial),'')))),2) + '</codIncSIND>' +
--							'<repDSR>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideDSRESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repDSR>' +
--							'<rep13>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.Incide13SalESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</rep13>' +
--							'<repFerias>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideFeriasESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repFerias>' +
--							'<repAviso>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideAPrevioESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repAviso>' +
						CASE WHEN c.ObservacaoESocial IS NULL OR RTRIM(LTRIM(c.ObservacaoESocial)) = '' THEN	
							''
						ELSE
							'<observacao>' + c.ObservacaoESocial + '</observacao>' 
						END +
						CASE WHEN c.LocalProcessoInssESocial = @CodigoLocal THEN
						'<ideProcessoCP>' +
								'<tpProc>' + CASE WHEN COALESCE(RTRIM(LTRIM(inss.TipoProcesso)),'') = 'A' THEN '1' ELSE '2' END + '</tpProc>' +
								'<nrProc>' + COALESCE(RTRIM(LTRIM(inss.NumeroProcesso)),'') + '</nrProc>' +
								'<extDecisao>' + COALESCE(RTRIM(LTRIM(c.ExtensaoProcessoInssESocial)),'') + '</extDecisao>' + 
								'<codSusp>' + COALESCE(RTRIM(LTRIM(inss.CodigoSuspensao)),'') + '</codSusp>' + 
						'</ideProcessoCP>' 
						ELSE
							+ '' 
						END +
						CASE WHEN c.LocalProcessoIrrfESocial = @CodigoLocal THEN
						'<ideProcessoIRRF>' +
								'<nrProc>' + COALESCE(RTRIM(LTRIM(irrf.NumeroProcesso)),'') + '</nrProc>' +
								'<codSusp>' + COALESCE(RTRIM(LTRIM(irrf.CodigoSuspensao)),'') + '</codSusp>' + 
						'</ideProcessoIRRF>' 
						ELSE
							+ '' 
						END +
						CASE WHEN c.LocalProcessoFgtsESocial = @CodigoLocal THEN
						'<ideProcessoFGTS>' +
								'<nrProc>' + COALESCE(RTRIM(LTRIM(fgts.NumeroProcesso)),'') + '</nrProc>' +
--									'<codSusp>' + COALESCE(RTRIM(LTRIM(fgts.CodigoSuspensao)),'') + '</codSusp>' + 
						'</ideProcessoFGTS>' 
						ELSE
							+ '' 
						END +
						CASE WHEN c.LocalProcessoSindicalESocial = @CodigoLocal THEN
						'<ideProcessoSIND>' +
								'<nrProc>' + COALESCE(RTRIM(LTRIM(sind.NumeroProcesso)),'') + '</nrProc>' +
--									'<codSusp>' + COALESCE(RTRIM(LTRIM(sind.CodigoSuspensao)),'') + '</codSusp>' + 
						'</ideProcessoSIND>' 
						ELSE
							+ '' 
						END +
						'</dadosRubrica>' +
					'</inclusao>' +
				'</infoRubrica>' +
			'</evtTabRubrica>' +
		'</eSocial>' ,
		COALESCE(RTRIM(LTRIM(c.CodigoEvento)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = b.CodigoEmpresa

		INNER JOIN tbEvento c
		ON c.CodigoEmpresa = e.CodigoEmpresa
					
		INNER JOIN tbRubricaESocial d
		ON  c.CodigoEmpresa			= d.CodigoEmpresa
		AND c.CodigoRubricaESocial	= d.CodigoRubrica
		
		LEFT JOIN tbProcessoAdmJudicial inss
		ON  inss.CodigoEmpresa	= c.CodigoEmpresa
		AND inss.CodigoLocal	= c.LocalProcessoInssESocial
		AND inss.TipoProcesso	= c.CodigoProcessoInssESocial
		AND inss.NumeroProcesso	= c.NumeroProcessoInssESocial

		LEFT JOIN tbProcessoAdmJudicial irrf
		ON  irrf.CodigoEmpresa	= c.CodigoEmpresa
		AND irrf.CodigoLocal	= c.LocalProcessoIrrfESocial
		AND irrf.TipoProcesso	= c.CodigoProcessoIrrfESocial
		AND irrf.NumeroProcesso	= c.NumeroProcessoIrrfESocial

		LEFT JOIN tbProcessoAdmJudicial fgts
		ON  fgts.CodigoEmpresa	= c.CodigoEmpresa
		AND fgts.CodigoLocal	= c.LocalProcessoFgtsESocial
		AND fgts.TipoProcesso	= c.CodigoProcessoFgtsESocial
		AND fgts.NumeroProcesso	= c.NumeroProcessoFgtsESocial

		LEFT JOIN tbProcessoAdmJudicial sind
		ON  sind.CodigoEmpresa	= c.CodigoEmpresa
		AND sind.CodigoLocal	= c.LocalProcessoSindicalESocial
		AND sind.TipoProcesso	= c.CodigoProcessoSindicalESocial
		AND sind.NumeroProcesso	= c.NumeroProcessoSindicalESocial

		WHERE a.CodigoEmpresa			= @CodigoEmpresa
		AND   a.CodigoLocal				= @CodigoLocal
		AND   a.Matriz					= 'V'
		AND   c.CodigoEvento			= ISNULL(@Variavel,c.CodigoEvento)
		AND   c.CodigoRubricaESocial	<> 0
	END
	ELSE -- não é @CargaInicial
	BEGIN
--whArquivosFPESocialXML @CodigoEmpresa = 1608,@CodigoLocal = 0,@NomeArquivo = 'S-1010',@TipoRegistro = 'A',@CodLocalMatriz = 0,@GeradoXML = 'F',@Ambiente = 1
		IF @TipoRegistro <> 'E' -- não é exclusão de dados
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabRubrica/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabRubrica Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoRubrica>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
							'<ideRubrica>' +
								'<codRubr>' + COALESCE(RTRIM(LTRIM(c.CodigoEvento)),'') + '</codRubr>' +
								'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									CASE WHEN c.CodigoRubricaESocial IN (1603,1604,1650,2502,3525,9260) THEN
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciadoFase3)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciadoFase3)),2,2),'') + 
										'</iniValid>'  
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') + 
										'</iniValid>'  
									END 
								END +
							CASE WHEN c.CodigoRubricaESocial IN (1651,1652) THEN
									'<fimValid>' + '2018-04' + '</fimValid>' 
							ELSE
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END 
							END +
							'</ideRubrica>' +
							'<dadosRubrica>' +
								'<dscRubr>' + COALESCE(RTRIM(LTRIM(c.DescricaoEvento)),'') + '</dscRubr>' +
								'<natRubr>' + COALESCE(RTRIM(LTRIM(c.CodigoRubricaESocial)),'') + '</natRubr>' +
								'<tpRubr>' + COALESCE(RTRIM(LTRIM(d.TipoRubrica)),'') + '</tpRubr>' +
								'<codIncCP>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseInssESocial),'')))),2) + '</codIncCP>' +
								'<codIncIRRF>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseIrrfESocial),'')))),2) + '</codIncIRRF>' +
								'<codIncFGTS>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseFgtsESocial),'')))),2) + '</codIncFGTS>' +
								'<codIncSIND>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(3),100 + COALESCE(CONVERT(NUMERIC(2),c.BaseSindicalESocial),'')))),2) + '</codIncSIND>' +
--								'<repDSR>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideDSRESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repDSR>' +
--								'<rep13>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.Incide13SalESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</rep13>' +
--								'<repFerias>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideFeriasESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repFerias>' +
--								'<repAviso>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.IncideAPrevioESocial)),0) = 0 THEN 'N' ELSE 'S' END + '</repAviso>' +
							CASE WHEN c.ObservacaoESocial IS NULL OR RTRIM(LTRIM(c.ObservacaoESocial)) = '' THEN	
								''
							ELSE
								'<observacao>' + c.ObservacaoESocial + '</observacao>' 
							END +
							CASE WHEN c.LocalProcessoInssESocial = @CodigoLocal THEN
							'<ideProcessoCP>' +
									'<tpProc>' + CASE WHEN COALESCE(RTRIM(LTRIM(inss.TipoProcesso)),'') = 'A' THEN '1' ELSE '2' END + '</tpProc>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(inss.NumeroProcesso)),'') + '</nrProc>' +
									'<extDecisao>' + COALESCE(RTRIM(LTRIM(c.ExtensaoProcessoInssESocial)),'') + '</extDecisao>' + 
									'<codSusp>' + COALESCE(RTRIM(LTRIM(inss.CodigoSuspensao)),'') + '</codSusp>' + 
							'</ideProcessoCP>' 
							ELSE
								+ '' 
							END +
							CASE WHEN c.LocalProcessoIrrfESocial = @CodigoLocal THEN
							'<ideProcessoIRRF>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(irrf.NumeroProcesso)),'') + '</nrProc>' +
									'<codSusp>' + COALESCE(RTRIM(LTRIM(irrf.CodigoSuspensao)),'') + '</codSusp>' + 
							'</ideProcessoIRRF>' 
							ELSE
								+ '' 
							END +
							CASE WHEN c.LocalProcessoFgtsESocial = @CodigoLocal THEN
							'<ideProcessoFGTS>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(fgts.NumeroProcesso)),'') + '</nrProc>' +
--										'<codSusp>' + COALESCE(RTRIM(LTRIM(fgts.CodigoSuspensao)),'') + '</codSusp>' + 
							'</ideProcessoFGTS>' 
							ELSE
								+ '' 
							END +
							CASE WHEN c.LocalProcessoSindicalESocial = @CodigoLocal THEN
							'<ideProcessoSIND>' +
									'<nrProc>' + COALESCE(RTRIM(LTRIM(sind.NumeroProcesso)),'') + '</nrProc>' +
--										'<codSusp>' + COALESCE(RTRIM(LTRIM(sind.CodigoSuspensao)),'') + '</codSusp>' + 
							'</ideProcessoSIND>' 
							ELSE
								+ '' 
							END +
							'</dadosRubrica>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>'
					ELSE	
						'</alteracao>' 
					END +
					'</infoRubrica>' +
				'</evtTabRubrica>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.CodigoEvento)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEvento c
			ON c.CodigoEmpresa = a.CodigoEmpresa
						
			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= c.CodigoEmpresa
			AND l.CodigoEvento			= c.CodigoEvento
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			INNER JOIN tbRubricaESocial d
			ON  c.CodigoEmpresa = d.CodigoEmpresa
			AND c.CodigoRubricaESocial = d.CodigoRubrica

			LEFT JOIN tbProcessoAdmJudicial inss
			ON  inss.CodigoEmpresa	= c.CodigoEmpresa
			AND inss.CodigoLocal	= c.LocalProcessoInssESocial
			AND inss.TipoProcesso	= c.CodigoProcessoInssESocial
			AND inss.NumeroProcesso	= c.NumeroProcessoInssESocial

			LEFT JOIN tbProcessoAdmJudicial irrf
			ON  irrf.CodigoEmpresa	= c.CodigoEmpresa
			AND irrf.CodigoLocal	= c.LocalProcessoIrrfESocial
			AND irrf.TipoProcesso	= c.CodigoProcessoIrrfESocial
			AND irrf.NumeroProcesso	= c.NumeroProcessoIrrfESocial

			LEFT JOIN tbProcessoAdmJudicial fgts
			ON  fgts.CodigoEmpresa	= c.CodigoEmpresa
			AND fgts.CodigoLocal	= c.LocalProcessoFgtsESocial
			AND fgts.TipoProcesso	= c.CodigoProcessoFgtsESocial
			AND fgts.NumeroProcesso	= c.NumeroProcessoFgtsESocial

			LEFT JOIN tbProcessoAdmJudicial sind
			ON  sind.CodigoEmpresa	= c.CodigoEmpresa
			AND sind.CodigoLocal	= c.LocalProcessoSindicalESocial
			AND sind.TipoProcesso	= c.CodigoProcessoSindicalESocial
			AND sind.NumeroProcesso	= c.NumeroProcessoSindicalESocial

			WHERE a.CodigoEmpresa			= @CodigoEmpresa
			AND   a.CodigoLocal				= @CodigoLocal
			AND   a.Matriz					= 'V'
			AND   c.CodigoEvento			= ISNULL(@Variavel,c.CodigoEvento)
			AND   c.CodigoRubricaESocial	<> 0
		END
		IF @TipoRegistro = 'E' -- é exclusão de dados
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabRubrica/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabRubrica Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoRubrica>' +
						'<exclusao>' +
							'<ideRubrica>' +
								'<codRubr>' + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),'') + '</codRubr>' +
								'<ideTabRubr>' + 'tbEvento' + '</ideTabRubr>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE
									CASE WHEN d.CodigoRubricaESocial IN (1603,1604,1650,2502,3525,9260) THEN
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciadoFase3)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciadoFase3)),2,2),'') + 
										'</iniValid>'  
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') + 
										'</iniValid>'  
									END 
								END +
							CASE WHEN d.CodigoRubricaESocial IN (1651,1652) THEN
									'<fimValid>' + '2018-04' + '</fimValid>' 
							ELSE
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END 
							END +
							'</ideRubrica>' +
						'</exclusao>' +
					'</infoRubrica>' +
				'</evtTabRubrica>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON	c.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbEvento d
			ON d.CodigoEmpresa = c.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal
			AND   a.Matriz			= 'V'
		END
	END
	---- FIM XML Tabela de Rubricas
END
GOTO ARQ_FIM

ARQ_S1020:
---- INICIO XML Tabela de Lotações Tributárias
BEGIN
--whArquivosFPESocialXML 1608, 'S-1020', 1, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N'

	IF @CargaInicial = 'S'
	BEGIN
		-- dados do local ( Obrigatoriamente o empregador/contribuinte deve ter pelo menos 1 lotacao tributária, cadastrar inicialmente o codigo 01 da tabela 10, que será usada nos eventos de remuneração do trabalhador
		-- inclui todos os locais que empresa tiver
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabLotacao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabLotacao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoLotacao>' +
					'<inclusao>' +
						'<ideLotacao>' +
							'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') + 
								'</iniValid>'  
							END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideLotacao>' +
						'<dadosLotacao>' +
							'<tpLotacao>' + '01' + '</tpLotacao>' +
							'<tpInsc>' + '' + '</tpInsc>' +
							'<nrInsc>' + '' + '</nrInsc>' +
							'<fpasLotacao>' +
								'<fpas>' + COALESCE(RTRIM(LTRIM(a.CodigoFpasPrincipal)),'') + '</fpas>' + 
								'<codTercs>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTercs>' +
							CASE WHEN a.CodigoProcessoTerceiros IS NOT NULL THEN
								'<codTercsSusp>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTercsSusp>' +
								'<infoProcJudTerceiros>' +
									'<procJudTerceiro>' +
											'<codTerc>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTerc>' +
											'<nrProcJud>' + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),'') + '</nrProcJud>' +
											'<codSusp>' + COALESCE(RTRIM(LTRIM(c.CodigoSuspensao)),'') + '</codSusp>' + 
									'</procJudTerceiro>' +
								'</infoProcJudTerceiros>' 
							ELSE
									'' 
							END +
							'</fpasLotacao>' +
							--'<infoEmprParcial>' +
							--	'<tpInscContrat>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoContratante)),'') + '</tpInscContrat>' + 
							--	'<nrInscContrat>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoContratante)),'') + '</nrInscContrat>' + 
							--	'<tpInscProp>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoProprietario)),'') + '</tpInscProp>' + 
							--	'<nrInscProp>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoProprietario)),'') + '</nrInscProp>' + 
							--'</infoEmprParcial>' +
						'</dadosLotacao>' +
					'</inclusao>' +
				'</infoLotacao>' +
			'</evtTabLotacao>' +
		'</eSocial>',
		COALESCE(RTRIM(LTRIM(b.CGCLocal)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		LEFT JOIN tbProcessoAdmJudicial c
		ON  c.CodigoEmpresa		= a.CodigoEmpresa
		AND c.CodigoLocal		= a.CodigoLocal
		AND c.TipoProcesso		= a.CodigoProcessoTerceiros
		AND c.NumeroProcesso	= a.NumeroProcessoTerceiros

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= ISNULL(@CodigoLocal, a.CodigoLocal)
--		AND   a.Matriz			= 'V'

		-- dados gerais tomador
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabLotacao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabLotacao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoLotacao>' +
					'<inclusao>' +
						'<ideLotacao>' +
							'<codLotacao>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCliFor)),'') + '</codLotacao>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValidade)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN c.DataFimValidade IS NOT NULL THEN
							'<fimValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValidade)),2,2),'') + 
							'</fimValid>'  
						ELSE
							''
						END +
						'</ideLotacao>' +
						'<dadosLotacao>' +
							'<tpLotacao>' + COALESCE(RTRIM(LTRIM(RIGHT(100 + c.TipoLotacao,2))),'') + '</tpLotacao>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoESocial)),'') + '</tpInsc>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(c.TipoInscricaoESocial)),'') IN (1,10,21,24,90,91) THEN
								'<nrInsc>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoESocial)),'') + '</nrInsc>' 
							ELSE
								'<nrInsc>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoESocial)),'') + '</nrInsc>' 
							END +
							'<fpasLotacao>' +
								'<fpas>' + COALESCE(RTRIM(LTRIM(c.CodigoFpasESocial)),'') + '</fpas>' + 
								'<codTercs>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosESocial,4))),'') + '</codTercs>' +
								CASE WHEN c.TipoProcessoSindicalESocial IS NOT NULL THEN
								'<codTercsSusp>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosSuspESocial,4))),'') + '</codTercsSusp>' +
								'<infoProcJudTerceiros>' +
									'<procJudTerceiro>' +
											'<codTerc>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosSuspESocial,4))),'') + '</codTerc>' +
											'<nrProcJud>' + COALESCE(RTRIM(LTRIM(p.NumeroProcesso)),'') + '</nrProcJud>' +
											'<codSusp>' + COALESCE(RTRIM(LTRIM(p.CodigoSuspensao)),'') + '</codSusp>' + 
									'</procJudTerceiro>' +
								'</infoProcJudTerceiros>' 
								ELSE
									+ '' 
								END +
							'</fpasLotacao>' +
							'<infoEmprParcial>' +
								'<tpInscContrat>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoContratante)),'') + '</tpInscContrat>' + 
								'<nrInscContrat>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoContratante)),'') + '</nrInscContrat>' + 
								'<tpInscProp>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoProprietario)),'') + '</tpInscProp>' + 
								'<nrInscProp>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoProprietario)),'') + '</nrInscProp>' + 
							'</infoEmprParcial>' +
						'</dadosLotacao>' +
					'</inclusao>' +
				'</infoLotacao>' +
			'</evtTabLotacao>' +
		'</eSocial>',
		COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCliFor)),''),	
		@OrdemAux + 2
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbTomadorServico c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
								
		LEFT JOIN tbProcessoAdmJudicial p
		ON  p.CodigoEmpresa		= c.CodigoEmpresa
		AND p.CodigoLocal		= c.CodigoLocal
		AND p.TipoProcesso		= c.TipoProcessoSindicalESocial
		AND p.NumeroProcesso	= c.NumeroProcessoSindicalESocial

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= ISNULL(@CodigoLocal, a.CodigoLocal)
--		AND   a.Matriz			= 'V'
		AND   CONVERT(CHAR(14),c.CodigoCliFor)	= ISNULL(@Variavel,CONVERT(CHAR(14),c.CodigoCliFor))
		AND   (
					c.DataFimValidade IS NULL
				OR	c.DataFimValidade > ISNULL(@DataInicioESocial,ISNULL(@DataApuracao,a.DataInicioPeriodo))
			  )						  
	END
	ELSE -- não é @cargainicial
	BEGIN
		IF @TipoRegistro <> 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabLotacao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabLotacao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoLotacao>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
						'<ideLotacao>' +
							'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideLotacao>' +
						'<dadosLotacao>' +
							'<tpLotacao>' + '01' + '</tpLotacao>' +
							'<tpInsc>' + '' + '</tpInsc>' +
							'<nrInsc>' + '' + '</nrInsc>' +
							'<fpasLotacao>' +
								'<fpas>' + COALESCE(RTRIM(LTRIM(a.CodigoFpasPrincipal)),'') + '</fpas>' + 
								'<codTercs>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTercs>' +
								CASE WHEN a.CodigoProcessoTerceiros IS NOT NULL THEN
								'<codTercsSusp>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTercsSusp>' +
								'<infoProcJudTerceiros>' +
									'<procJudTerceiro>' +
											'<codTerc>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + a.CodigoTerceirosLocal,4))),'') + '</codTerc>' +
											'<nrProcJud>' + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),'') + '</nrProcJud>' +
											'<codSusp>' + COALESCE(RTRIM(LTRIM(c.CodigoSuspensao)),'') + '</codSusp>' + 
									'</procJudTerceiro>' +
								'</infoProcJudTerceiros>' 
								ELSE
									+ '' 
								END +
							'</fpasLotacao>' +
							--'<infoEmprParcial>' +
							--	'<tpInscContrat>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoContratante)),'') + '</tpInscContrat>' + 
							--	'<nrInscContrat>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoContratante)),'') + '</nrInscContrat>' + 
							--	'<tpInscProp>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoProprietario)),'') + '</tpInscProp>' + 
							--	'<nrInscProp>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoProprietario)),'') + '</nrInscProp>' + 
							--'</infoEmprParcial>' +
						'</dadosLotacao>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>'
					ELSE
						'</alteracao>' 
					END +
					'</infoLotacao>' +
				'</evtTabLotacao>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),	
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON	e.CodigoEmpresa = a.CodigoEmpresa

			LEFT JOIN tbProcessoAdmJudicial c
			ON  c.CodigoEmpresa		= a.CodigoEmpresa
			AND c.CodigoLocal		= a.CodigoLocal
			AND c.TipoProcesso		= a.CodigoProcessoTerceiros
			AND c.NumeroProcesso	= a.NumeroProcessoTerceiros

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= a.CodigoEmpresa
			AND l.CodigoLocal			= a.CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= ISNULL(@CodigoLocal, a.CodigoLocal)
--			AND   a.Matriz			= 'V'

			-- dados tomador
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabLotacao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabLotacao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoLotacao>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
					'<ideLotacao>' +
						'<codLotacao>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCliFor)),'') + '</codLotacao>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValidade)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN c.DataFimValidade IS NOT NULL THEN
							'<fimValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValidade)),2,2),'') + 
							'</fimValid>'  
						ELSE
							''
						END +
					'</ideLotacao>' +
					'<dadosLotacao>' +
						'<tpLotacao>' + COALESCE(RTRIM(LTRIM(RIGHT(100 + c.TipoLotacao,2))),'') + '</tpLotacao>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoESocial)),'') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoESocial)),'') + '</nrInsc>' +
						'<fpasLotacao>' +
							'<fpas>' + COALESCE(RTRIM(LTRIM(c.CodigoFpasESocial)),'') + '</fpas>' + 
							'<codTercs>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosESocial,4))),'') + '</codTercs>' +
							CASE WHEN c.TipoProcessoSindicalESocial IS NOT NULL THEN
							'<codTercsSusp>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosSuspESocial,4))),'') + '</codTercsSusp>' +
							'<infoProcJudTerceiros>' +
								'<procJudTerceiro>' +
										'<codTerc>' + COALESCE(RTRIM(LTRIM(RIGHT(10000 + c.CodigoTerceirosSuspESocial,4))),'') + '</codTerc>' +
										'<nrProcJud>' + COALESCE(RTRIM(LTRIM(p.NumeroProcesso)),'') + '</nrProcJud>' +
										'<codSusp>' + COALESCE(RTRIM(LTRIM(p.CodigoSuspensao)),'') + '</codSusp>' + 
								'</procJudTerceiro>' +
							'</infoProcJudTerceiros>' 
							ELSE
								+ '' 
							END +
						'</fpasLotacao>' +
						'<infoEmprParcial>' +
							'<tpInscContrat>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoContratante)),'') + '</tpInscContrat>' + 
							'<nrInscContrat>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoContratante)),'') + '</nrInscContrat>' + 
							'<tpInscProp>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoProprietario)),'') + '</tpInscProp>' + 
							'<nrInscProp>' + COALESCE(RTRIM(LTRIM(c.NumeroInscricaoProprietario)),'') + '</nrInscProp>' + 
						'</infoEmprParcial>' +
					'</dadosLotacao>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>'
					ELSE
						'</alteracao>' 
					END +
					'</infoLotacao>' +
				'</evtTabLotacao>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCliFor)),''),	
			@OrdemAux + 2
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbTomadorServico c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			INNER JOIN tbEmpresaFP e
			ON	e.CodigoEmpresa = a.CodigoEmpresa

			LEFT JOIN tbProcessoAdmJudicial p
			ON  p.CodigoEmpresa		= c.CodigoEmpresa
			AND p.CodigoLocal		= c.CodigoLocal
			AND p.TipoProcesso		= c.TipoProcessoSindicalESocial
			AND p.NumeroProcesso	= c.NumeroProcessoSindicalESocial

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= c.CodigoEmpresa
			AND l.CodigoLocal			= c.CodigoLocal
			AND LTRIM(RTRIM(l.CodigoEvento))	= CONVERT(CHAR(14),c.CodigoCliFor)
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = ISNULL(@CodigoLocal, a.CodigoLocal)
--			AND   a.Matriz			= 'V'
			AND   CONVERT(CHAR(14),c.CodigoCliFor)	= ISNULL(@Variavel,CONVERT(CHAR(14),c.CodigoCliFor))
		END
		IF @TipoRegistro = 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabLotacao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabLotacao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoLotacao>' +
						'<exclusao>' +
							'<ideLotacao>' +
								'<codLotacao>' + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),'') + '</codLotacao>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') +													 
								'</iniValid>'  
							END +
							CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
								'</fimValid>' 
							ELSE
								''
							END +
							'</ideLotacao>' +
						'</exclusao>' +
					'</infoLotacao>' +
				'</evtTabLotacao>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(a.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),	
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON	c.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa = @CodigoEmpresa
			AND   a.CodigoLocal   = ISNULL(@CodigoLocal, a.CodigoLocal)
--			AND   a.Matriz		  = 'V'
		END
	END
	---- FIM XML Tabela de Lotações Tributárias
END
GOTO ARQ_FIM

ARQ_S1030:
---- INICIO XML Tabela de Cargos-Empregos Públicos
BEGIN
--whArquivosFPESocialXML 1608, 'S-1030', 1, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N'
	IF @CargaInicial = 'S'
	BEGIN
		-- dados cargo
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabCargo/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabCargo Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoCargo>' +
					'<inclusao>' +
						'<ideCargo>' +
							'<codCargo>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCargo)),'') + '</codCargo>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
							'</iniValid>'  
						END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideCargo>' +
						'<dadosCargo>' +
							'<nmCargo>' + COALESCE(RTRIM(LTRIM(c.DescricaoCargo)),'') + '</nmCargo>' +
							'<codCBO>' + COALESCE(RTRIM(LTRIM(c.CBO)),'') + '</codCBO>' +
							----Detalhamento de informações exclusivas para Cargos e Empregos Públicos
							--'<cargoPublico>' +
							--	'<acumCargo>' + '' + '</acumCargo>' +
							--	'<contagemEsp>' + '' + '</contagemEsp>' +
							--	'<dedicExcl>' + '' + '</dedicExcl>' +
							--	'<leiCargo>' +
							--		'<nrLei>' + '' + '</nrLei>' +
							--		'<dtLei>' + '' + '</dtLei>' +
							--		'<sitCargo>' + '' + '</sitCargo>' +
							--	'</leiCargo>' +
							--'</cargoPublico>' +
						'</dadosCargo>' +
					'</inclusao>' +
				'</infoCargo>' +
			'</evtTabCargo>' +
		'</eSocial>' ,
		COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCargo)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbCargo c
		ON  c.CodigoEmpresa				= a.CodigoEmpresa
		AND c.CodigoLocal				= a.CodigoLocal
		AND c.CodigoCategoriaESocial	IS NOT NULL
								
		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   c.CodigoCargo	= ISNULL(@Variavel,c.CodigoCargo)
	END
	ELSE -- não é @cargainicial
	BEGIN
		IF @TipoRegistro <> 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabCargo/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabCargo Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoCargo>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
							'<ideCargo>' +
								'<codCargo>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCargo)),'') + '</codCargo>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
								'</iniValid>'  
							END +
							CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
								'</fimValid>' 
							ELSE
								''
							END +
							'</ideCargo>' +
							'<dadosCargo>' +
								'<nmCargo>' + COALESCE(RTRIM(LTRIM(c.DescricaoCargo)),'') + '</nmCargo>' +
								'<codCBO>' + COALESCE(RTRIM(LTRIM(c.CBO)),'') + '</codCBO>' +
								----Detalhamento de informações exclusivas para Cargos e Empregos Públicos
								--'<cargoPublico>' +
								--	'<acumCargo>' + '' + '</acumCargo>' +
								--	'<contagemEsp>' + '' + '</contagemEsp>' +
								--	'<dedicExcl>' + '' + '</dedicExcl>' +
								--	'<leiCargo>' +
								--		'<nrLei>' + '' + '</nrLei>' +
								--		'<dtLei>' + '' + '</dtLei>' +
								--		'<sitCargo>' + '' + '</sitCargo>' +
								--	'</leiCargo>' +
								--'</cargoPublico>' +
							'</dadosCargo>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>' 
					ELSE
						'</alteracao>' 
					END +
					'</infoCargo>' +
				'</evtTabCargo>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoCargo)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON	e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbCargo c
			ON  c.CodigoEmpresa				= a.CodigoEmpresa
			AND c.CodigoLocal				= a.CodigoLocal
			AND c.CodigoCategoriaESocial	IS NOT NULL
									
			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= c.CodigoEmpresa
			AND l.CodigoLocal			= c.CodigoLocal
			AND l.CodigoEvento			= c.CodigoCargo
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
			AND   c.CodigoCargo	= ISNULL(@Variavel,c.CodigoCargo)
		END
		IF @TipoRegistro = 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabCargo/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabCargo Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoCargo>' +
						'<exclusao>' +
							'<ideCargo>' +
								'<codCargo>' + COALESCE(RTRIM(LTRIM(l.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),'') + '</codCargo>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') +													 
								'</iniValid>'  
							END +
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,GETDATE())),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,GETDATE())),2,2),'') +													 
								'</fimValid>' + 
							'</ideCargo>' +
						'</exclusao>' +
					'</infoCargo>' +
				'</evtTabCargo>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(a.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON	c.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
		END
	END
	---- FIM XML Tabela de Cargos-Empregos Públicos
END
GOTO ARQ_FIM

ARQ_S1050:
---- INICIO XML Tabela de Horário/Turnos de Trabalho
BEGIN
--whArquivosFPESocialXML @CodigoEmpresa = '1608',@NomeArquivo = 'S-1050',@CodigoLocal = '0',@TipoRegistro = 'I',@CargaInicial = 'S',@Ambiente = 1,@Variavel = 1
	IF @CargaInicial = 'S'
	BEGIN
		SELECT c.CodigoEmpresa,
				c.CodigoLocal,
				c.CodigoHorario
				 
		INTO #tmpHorario

		FROM tbHorario c
								
		WHERE c.CodigoEmpresa	= @CodigoEmpresa
		AND   c.CodigoLocal		= @CodigoLocal
		AND   c.CodigoHorario	= ISNULL(@Variavel,c.CodigoHorario)

		WHILE EXISTS ( 
						SELECT 1 FROM #tmpHorario
					  )
		BEGIN
			SELECT TOP 1 
				@curhorCodigoEmpresa	= CodigoEmpresa,
				@curhorCodigoLocal		= CodigoLocal,
				@curhorCodigoHorario	= CodigoHorario
			FROM #tmpHorario
			ORDER BY CodigoEmpresa, CodigoLocal, CodigoHorario
			-- dados horario -- SEGUNDA
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt01ESocial IS NOT NULL THEN -- SEGUNDA
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia01ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt01ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai01ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt01ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt01ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt01ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- TERÇA
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt02ESocial IS NOT NULL THEN -- TERÇA
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia02ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt02ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai02ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt02ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt02ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt02ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- QUARTA
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt03ESocial IS NOT NULL THEN -- QUARTA
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia03ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt03ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai03ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt03ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt03ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt03ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- QUINTA
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt04ESocial IS NOT NULL THEN -- QUINTA
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia04ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt04ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai04ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt04ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt04ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt04ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- SEXTA
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt05ESocial IS NOT NULL THEN -- SEXTA
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia05ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt05ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai05ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt05ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt05ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt05ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- SABADO
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt06ESocial IS NOT NULL THEN -- SABADO
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia06ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt06ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai06ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt06ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt06ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt06ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- DOMINGO
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt07ESocial IS NOT NULL THEN -- DOMINGO
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia07ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt07ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai07ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt07ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt07ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt07ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- dados horario -- DIA VARIAVEL
			INSERT @xml
			SELECT DISTINCT
			CASE WHEN c.HoraEnt08ESocial IS NOT NULL THEN -- DIA VARIAVEL
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtTabHorTur Id="ID' + 
													COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
													COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
													@DataHoraProc +
													@SequenciaArq + '">' +
						'<ideEvento>' + 
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<infoHorContratual>' +
							'<inclusao>' +
								'<ideHorContratual>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + COALESCE(RTRIM(LTRIM(c.Dia08ESocial)),'') + '</codHorContrat>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
									CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
										CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
												  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
											'<iniValid>' +	'2016-01' + '</iniValid>'
										ELSE
											'<iniValid>' +	'2017-01' + '</iniValid>'  
										END
									ELSE
										'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
										'</iniValid>'  
									END 
								ELSE							
									'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
									'</iniValid>'  
								END +
								CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
									'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
									'</fimValid>' 
								ELSE
									''
								END +
								'</ideHorContratual>' +
								'<dadosHorContratual>' +
									'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt08ESocial,'.','')),0)))),4) + '</hrEntr>' +
									'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai08ESocial,'.','')),0)))),4) + '</hrSaida>' +
									'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0))) = 4 THEN 
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2)),4)
													 ELSE
														RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2)),4)
													 END + 
									'</durJornada>' +
									'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
								CASE WHEN c.HoraEntInt08ESocial IS NOT NULL THEN
									'<horarioIntervalo>' +
										'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
										'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0))) = 4 THEN 
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2)),3)
														 ELSE
															RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2)),3)
														 END + 
										'</durInterv>' +
									CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
										'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt08ESocial,'.','')),0)))),4) + '</iniInterv>' +
										'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt08ESocial,'.','')),0)))),4) + '</termInterv>' 
									ELSE
										''
									END +
									'</horarioIntervalo>'
								ELSE
									''
								END +
								'</dadosHorContratual>' +
							'</inclusao>' +
						'</infoHorContratual>' +
					'</evtTabHorTur>' +
				'</eSocial>' 
			END,
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			WHERE a.CodigoEmpresa	= @curhorCodigoEmpresa
			AND   a.CodigoLocal		= @curhorCodigoLocal
			AND   c.CodigoHorario	= @curhorCodigoHorario
			-- deleta registro atual
			DELETE #tmpHorario
			WHERE CodigoEmpresa = @curhorCodigoEmpresa
			AND CodigoLocal		= @curhorCodigoLocal
			AND CodigoHorario	= @curhorCodigoHorario	
			-- incrementa variavel
			SET @OrdemAux = @OrdemAux + 1
		END			
		DROP TABLE #tmpHorario
	END
	ELSE -- não é @cargainicial
	BEGIN
--whArquivosFPESocialXML @CodigoEmpresa = 1608,@CodigoLocal = 0,@NomeArquivo = 'S-1050',@TipoRegistro = 'I',@CodLocalMatriz = 10,@GeradoXML = 'F',@Ambiente = 1,@Variavel = '010QUA',@DataHoraArquivo = '2018-06-15 18:39:18'
		IF @TipoRegistro <> 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabHorTur Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoHorContratual>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
						'<ideHorContratual>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),'') + RIGHT(RTRIM(LTRIM(@Variavel)),3) + '</codHorContrat>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') +													 
							'</iniValid>'  
						END +
						CASE WHEN b.DataEncerramentoAtividade IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataEncerramentoAtividade)),2,4),'') + '-' + 
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataEncerramentoAtividade)),2,2),'') + 
							'</fimValid>' 
						ELSE
							''
						END +
						'</ideHorContratual>' +
						'<dadosHorContratual>' +
						CASE RIGHT(LTRIM(RTRIM(@Variavel)),3)
						WHEN 'SEG' THEN --SEGUNDA
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt01ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai01ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai01ESocial,0) - COALESCE(c.HoraEnt01ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt01ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt01ESocial,0) - COALESCE(c.HoraEntInt01ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt01ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt01ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>' 
						ELSE
							''
						END 
						WHEN 'TER' THEN --TERÇA
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt02ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai02ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai02ESocial,0) - COALESCE(c.HoraEnt02ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt02ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt02ESocial,0) - COALESCE(c.HoraEntInt02ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt02ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt02ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>' 
						ELSE
							''
						END
						WHEN 'QUA' THEN --QUARTA
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt03ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai03ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai03ESocial,0) - COALESCE(c.HoraEnt03ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt03ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt03ESocial,0) - COALESCE(c.HoraEntInt03ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt03ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt03ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>' 
						ELSE
							''
						END
						WHEN 'QUI' THEN --QUINTA
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt04ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai04ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai04ESocial,0) - COALESCE(c.HoraEnt04ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt04ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt04ESocial,0) - COALESCE(c.HoraEntInt04ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt04ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt04ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>' 
						ELSE
							''
						END 
						WHEN 'SEX' THEN --SEXTA
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt05ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai05ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai05ESocial,0) - COALESCE(c.HoraEnt05ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt05ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt05ESocial,0) - COALESCE(c.HoraEntInt05ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt05ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt05ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>'
						ELSE
							''
						END 
						WHEN 'SAB' THEN --SABADO
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt06ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai06ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai06ESocial,0) - COALESCE(c.HoraEnt06ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt06ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt06ESocial,0) - COALESCE(c.HoraEntInt06ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt06ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt06ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>'
						ELSE
							''
						END 
						WHEN 'DOM' THEN --DOMINGO
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt07ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai07ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai07ESocial,0) - COALESCE(c.HoraEnt07ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt07ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt07ESocial,0) - COALESCE(c.HoraEntInt07ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt07ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt07ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>'
						ELSE
							''
						END  
						WHEN 'VAR' THEN --DIA VARIAVEL
							'<hrEntr>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEnt08ESocial,'.','')),0)))),4) + '</hrEntr>' +
							'<hrSaida>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSai08ESocial,'.','')),0)))),4) + '</hrSaida>' +
							'<durJornada>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0))) = 4 THEN 
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2)),4)
											 ELSE
												RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSai08ESocial,0) - COALESCE(c.HoraEnt08ESocial,0)),2)),4)
											 END + 
							'</durJornada>' +
							'<perHorFlexivel>' + CASE WHEN c.JornadaPadraoESocial = 'V' THEN 'N' ELSE 'S' END + '</perHorFlexivel>' +
						CASE WHEN c.HoraEntInt08ESocial IS NOT NULL THEN
							'<horarioIntervalo>' +
								'<tpInterv>' + CONVERT(CHAR(1),COALESCE(c.CodigoTurnoESocial,'1')) + '</tpInterv>' +
								'<durInterv>' + CASE WHEN LEN(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0))) = 4 THEN 
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),1) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2)),3)
												 ELSE
													RIGHT(CONVERT(VARCHAR(5), 10000 + LEFT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2) * 60 + RIGHT(ABS(COALESCE(c.HoraSaiInt08ESocial,0) - COALESCE(c.HoraEntInt08ESocial,0)),2)),3)
												 END + 
								'</durInterv>' +
							CASE WHEN COALESCE(c.CodigoTurnoESocial,'1') = 1 THEN	
								'<iniInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraEntInt08ESocial,'.','')),0)))),4) + '</iniInterv>' +
								'<termInterv>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(5),10000 + COALESCE(CONVERT(NUMERIC(4),REPLACE(c.HoraSaiInt08ESocial,'.','')),0)))),4) + '</termInterv>' 
							ELSE
								''
							END +
							'</horarioIntervalo>'
						ELSE
							''
						END 
						ELSE
							''
						END +
							'</dadosHorContratual>' +
						CASE WHEN @TipoRegistro = 'A' THEN
							'<novaValidade>' +
								'<iniValid>' + SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
												SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) +													 
								'</iniValid>' + 
								--'<fimValid>' + '</fimValid>' + 
							'</novaValidade>' 
						ELSE
							''
						END +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>' 
					ELSE
						'</alteracao>' 
					END +
					'</infoHorContratual>' +
				'</evtTabHorTur>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.CodigoHorario)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON	e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbHorario c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
			AND c.CodigoHorario	= ISNULL(@CodLocalMatriz,c.CodigoHorario)
									
			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
		END
		IF @TipoRegistro = 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabHorTur/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabHorTur Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoHorContratual>' +
						'<exclusao>' +
							'<ideHorContratual>' +
								'<codHorContrat>' + COALESCE(RTRIM(LTRIM(l.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoLocalMatriz)),'') + RIGHT(COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),3) + '</codHorContrat>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataESocialIniciado)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataESocialIniciado)),2,2),'') +													 
								'</iniValid>'  
							END +
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,GETDATE())),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,GETDATE())),2,2),'') +													 
								'</fimValid>' + 
							'</ideHorContratual>' +
						'</exclusao>' +
					'</infoHorContratual>' +
				'</evtTabHorTur>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(a.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(l.CodigoLocalMatriz)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP c
			ON	c.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'
									
			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
		END
	END
	---- FIM XML Tabela de Horário/Turnos de Trabalho
END
GOTO ARQ_FIM

ARQ_S1060:
---- INICIO XML Ambientes de Trabalho
BEGIN
--whArquivosFPESocialXML 1608, 'S-1060', 0, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N', '1', 100
	IF @CargaInicial = 'S'
	BEGIN
		-- dados ambientes
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabAmbiente/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabAmbiente Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoAmbiente>' +
					'<inclusao>' +
						'<ideAmbiente>' +
							'<codAmb>' + COALESCE(RTRIM(LTRIM(c.CodigoAmbiente)),'') + '</codAmb>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValAmbiente)),2,2),'') +													 
							'</iniValid>'  
						END +
						CASE WHEN c.DataFimValAmbiente IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValAmbiente)),2,2),'') +												 
							'</fimValid>'  
						ELSE
							''
						END +
						'</ideAmbiente>' +
						'<dadosAmbiente>' +
							'<dscAmb>' + COALESCE(RTRIM(LTRIM(c.DescricaoAmbiente)),'') + '</dscAmb>' +
							'<localAmb>' + COALESCE(RTRIM(LTRIM(c.CodigoLocalAmbiente)),'') + '</localAmb>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(c.TipoInscricaoAmbiente)),'') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(RTRIM(LTRIM(c.CodInscricaoAmbiente)),'') + '</nrInsc>' +
							'<fatorRisco>' +
								'<codFatRis>' + COALESCE(RTRIM(LTRIM(c.FatorRiscoAmbiente)),'') + '</codFatRis>' +
							'</fatorRisco>' +
						'</dadosAmbiente>' +
					'</inclusao>' +
				'</infoAmbiente>' +
			'</evtTabAmbiente>' +
		'</eSocial>',
		COALESCE(RTRIM(LTRIM(c.CodigoAmbiente)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbCentroCusto c
		ON  c.CodigoEmpresa = a.CodigoEmpresa

		WHERE b.CodigoEmpresa		= @CodigoEmpresa
		AND   b.CodigoLocal			= @CodigoLocal
		AND   c.CodigoAmbiente		IS NOT NULL
		AND   c.CentroCusto			= ISNULL(@Variavel,c.CentroCusto)
		AND   c.BloqueiaCentroCusto = 'F'
	END
	ELSE -- não é @cargainicial
	BEGIN
		IF @TipoRegistro <> 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabAmbiente/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabAmbiente Id="ID' + 
											COALESCE(RTRIM(LTRIM(b.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(c.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(b.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(c.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoAmbiente>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
						'<ideAmbiente>' +
							'<codAmb>' + COALESCE(RTRIM(LTRIM(a.CodigoAmbiente)),'') + '</codAmb>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(c.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataIniValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataIniValAmbiente)),2,2),'') +													 
							'</iniValid>'  
						END +
						CASE WHEN a.DataFimValAmbiente IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataFimValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataFimValAmbiente)),2,2),'') +												 
							'</fimValid>'  
						ELSE
							''
						END +
						'</ideAmbiente>' +
						'<dadosAmbiente>' +
							'<dscAmb>' + COALESCE(RTRIM(LTRIM(a.DescricaoAmbiente)),'') + '</dscAmb>' +
							'<localAmb>' + COALESCE(RTRIM(LTRIM(a.CodigoLocalAmbiente)),'') + '</localAmb>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoAmbiente)),'') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(RTRIM(LTRIM(a.CodInscricaoAmbiente)),'') + '</nrInsc>' +
							'<fatorRisco>' +
								'<codFatRis>' + COALESCE(RTRIM(LTRIM(a.FatorRiscoAmbiente)),'') + '</codFatRis>' +
							'</fatorRisco>' +
						'</dadosAmbiente>' +
					CASE WHEN @TipoRegistro = 'A' THEN
						'<novaValidade>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(c.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataIniValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataIniValAmbiente)),2,2),'') +													 
							'</iniValid>'  
						END +
						CASE WHEN a.DataFimValAmbiente IS NOT NULL THEN
							'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataFimValAmbiente)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataFimValAmbiente)),2,2),'') +												 
							'</fimValid>'  
						ELSE
							''
						END +
						'</novaValidade>' 
					ELSE
						''
					END +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>' 
					ELSE
						'</alteracao>' 
					END +
					'</infoAmbiente>' +
				'</evtTabAmbiente>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),
			@OrdemAux + 1
			FROM tbCentroCusto a

			INNER JOIN tbLocalFP b
			ON b.CodigoEmpresa = a.CodigoEmpresa
			
			INNER JOIN tbLocal c
			ON	c.CodigoEmpresa = b.CodigoEmpresa
			AND c.CodigoLocal   = b.CodigoLocal
									
			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= b.CodigoEmpresa
			AND l.CodigoLocal			= b.CodigoLocal
			AND l.CodigoEvento			= a.CentroCusto
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE b.CodigoEmpresa		= @CodigoEmpresa
			AND   b.CodigoLocal			= @CodigoLocal
			AND   a.CodigoAmbiente		IS NOT NULL
			AND   a.CentroCusto			= ISNULL(@Variavel,a.CentroCusto)
			AND   a.BloqueiaCentroCusto = 'F'
		END
		IF @TipoRegistro = 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabAmbiente/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabAmbiente Id="ID' + 
											COALESCE(RTRIM(LTRIM(b.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(c.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(b.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(c.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoAmbiente>' +
						'<exclusao>' +
							'<ideAmbiente>' +
								'<codAmb>' + COALESCE(RTRIM(LTRIM(a.CodigoAmbiente)),'') + '</codAmb>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(c.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataIniValAmbiente)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataIniValAmbiente)),2,2),'') +													 
								'</iniValid>'  
							END +
							CASE WHEN a.DataFimValAmbiente IS NOT NULL THEN
								'<fimValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataFimValAmbiente)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataFimValAmbiente)),2,2),'') +												 
								'</fimValid>'  
							ELSE
								''
							END +
							'</ideAmbiente>' +
						'</exclusao>' +
					'</infoAmbiente>' +
				'</evtTabAmbiente>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(l.CodigoEvento)),''),
			@OrdemAux + 1
			FROM tbCentroCusto a

			INNER JOIN tbLocalFP b
			ON b.CodigoEmpresa = a.CodigoEmpresa
			
			INNER JOIN tbLocal c
			ON	c.CodigoEmpresa = b.CodigoEmpresa
			AND c.CodigoLocal   = b.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoEvento			= a.CentroCusto
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'
									
			WHERE b.CodigoEmpresa	= @CodigoEmpresa
			AND   b.CodigoLocal     = @CodigoLocal
		END
	END
	---- FIM XML Ambientes de Trabalho
END
GOTO ARQ_FIM

ARQ_S1070:
---- INICIO XML Processos Administrativos/Judiciais
BEGIN
--whArquivosFPESocialXML 1608, 'S-1070', 0, 'I', 'S', null, null, null,null, null, 'N', '2', '201407', 'N','1','A1'
	IF @CargaInicial = 'S'
	BEGIN
		-- dados processos
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabProcesso/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTabProcesso Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoProcesso>' +
					'<inclusao>' +
						'<ideProcesso>' +
							'<tpProc>' + CASE RTRIM(LTRIM(c.TipoProcesso)) 
											WHEN 'A' THEN '1' 
											WHEN 'J' THEN '2' 
											WHEN 'N' THEN '3'
											WHEN 'P' THEN '4'
										 ELSE ''
										 END + 
							'</tpProc>' +
							'<nrProc>' + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),'') + '</nrProc>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValidade)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN c.DataFimValidade IS NOT NULL THEN
							'<fimValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValidade)),2,2),'') + 
							'</fimValid>'  
						ELSE
							''
						END +
						'</ideProcesso>' +
						'<dadosProc>' +
							'<indAutoria>' + COALESCE(RTRIM(LTRIM(c.Autoria)),'1') + '</indAutoria>' + 
							'<indMatProc>' + COALESCE(RTRIM(LTRIM(c.Materia)),'99') + '</indMatProc>' + 
							-- não criei o campo observacao na tabela
							--'<observacao>' + '' + '</observacao>' +
							'<dadosProcJud>' +
								'<ufVara>' + COALESCE(RTRIM(LTRIM(c.UFVara)),'') + '</ufVara>' + 
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioVara),0)))),7) + '</codMunic>' + 
								'<idVara>' + COALESCE(RTRIM(LTRIM(c.CodigoVara)),'') + '</idVara>' + 
								'<infoSusp>' +
									'<codSusp>' + COALESCE(RTRIM(LTRIM(c.CodigoSuspensao)),'') + '</codSusp>' + 
									'<indSusp>' + COALESCE(RTRIM(LTRIM(c.Decisao)),'92') + '</indSusp>' + 
									'<dtDecisao>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataDecisao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataDecisao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataDecisao)),2,2),'') +
									'</dtDecisao>' + 
									'<indDeposito>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.Deposito)),'F') = 'V' THEN 'S' ELSE 'N' END + '</indDeposito>' +
								'</infoSusp>' +
							'</dadosProcJud>' +
						'</dadosProc>' +
					'</inclusao>' +
				'</infoProcesso>' +
			'</evtTabProcesso>' +
		'</eSocial>',
		COALESCE(RTRIM(LTRIM(c.TipoProcesso)),'') + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),''),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbProcessoAdmJudicial c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
								
		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   ( 
				(RTRIM(LTRIM(c.TipoProcesso)) + RTRIM(LTRIM(c.NumeroProcesso)))	= ISNULL(@Variavel,(RTRIM(LTRIM(c.TipoProcesso)) + RTRIM(LTRIM(c.NumeroProcesso))))
			   )
	END
	ELSE -- não é @cargainicial
	BEGIN
		IF @TipoRegistro <> 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabProcesso/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabProcesso Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoProcesso>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'<inclusao>'
					ELSE
						'<alteracao>' 
					END +
						'<ideProcesso>' +
							'<tpProc>' + CASE RTRIM(LTRIM(c.TipoProcesso)) 
											WHEN 'A' THEN '1' 
											WHEN 'J' THEN '2' 
											WHEN 'N' THEN '3'
											WHEN 'P' THEN '4'
										 ELSE ''
										 END + 
							'</tpProc>' +
							'<nrProc>' + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),'') + '</nrProc>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
							CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
								CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
										  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
									'<iniValid>' +	'2016-01' + '</iniValid>'
								ELSE
									'<iniValid>' +	'2017-01' + '</iniValid>'  
								END
							ELSE
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
								'</iniValid>'  
							END 
						ELSE							
							'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValidade)),2,2),'') + 
							'</iniValid>'  
						END +
						CASE WHEN c.DataFimValidade IS NOT NULL THEN
							'<fimValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValidade)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValidade)),2,2),'') + 
							'</fimValid>'  
						ELSE
							''
						END +
						'</ideProcesso>' +
						'<dadosProc>' +
							'<indAutoria>' + COALESCE(RTRIM(LTRIM(c.Autoria)),'1') + '</indAutoria>' + 
							'<indMatProc>' + COALESCE(RTRIM(LTRIM(c.Materia)),'99') + '</indMatProc>' + 
							-- não criei o campo observacao na tabela
							--'<observacao>' + '' + '</observacao>' +
							'<dadosProcJud>' +
								'<ufVara>' + COALESCE(RTRIM(LTRIM(c.UFVara)),'') + '</ufVara>' + 
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioVara),0)))),7) + '</codMunic>' + 
								'<idVara>' + COALESCE(RTRIM(LTRIM(c.CodigoVara)),'') + '</idVara>' + 
								'<infoSusp>' +
									'<codSusp>' + COALESCE(RTRIM(LTRIM(c.CodigoSuspensao)),'') + '</codSusp>' + 
									'<indSusp>' + COALESCE(RTRIM(LTRIM(c.Decisao)),'92') + '</indSusp>' + 
									'<dtDecisao>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataDecisao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataDecisao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataDecisao)),2,2),'') +
									'</dtDecisao>' + 
									'<indDeposito>' + CASE WHEN COALESCE(RTRIM(LTRIM(c.Deposito)),'F') = 'V' THEN 'S' ELSE 'N' END + '</indDeposito>' +
								'</infoSusp>' +
							'</dadosProcJud>' +
						'</dadosProc>' +
					CASE WHEN @TipoRegistro = 'I' THEN
						'</inclusao>'
					ELSE
						'</alteracao>' 
					END +
					'</infoProcesso>' +
				'</evtTabProcesso>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.TipoProcesso)),'') + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbProcessoAdmJudicial c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
									
			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= c.CodigoEmpresa
			AND l.CodigoLocal			= c.CodigoLocal
			AND l.CodigoEvento          = c.TipoProcesso + c.NumeroProcesso
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
			AND   ( 
					(RTRIM(LTRIM(c.TipoProcesso)) + RTRIM(LTRIM(c.NumeroProcesso)))	= ISNULL(@Variavel,(RTRIM(LTRIM(c.TipoProcesso)) + RTRIM(LTRIM(c.NumeroProcesso))))
				   )
		END
		IF @TipoRegistro = 'E'
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTabProcesso/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtTabProcesso Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<infoProcesso>' +
						'<exclusao>' +
							'<ideProcesso>' +
								'<tpProc>' + CASE RTRIM(LTRIM(c.TipoProcesso)) 
												WHEN 'A' THEN '1' 
												WHEN 'J' THEN '2' 
												WHEN 'N' THEN '3'
												WHEN 'P' THEN '4'
											 ELSE ''
											 END + 
								'</tpProc>' +
								'<nrProc>' + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),'') + '</nrProc>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) = 2 THEN
								CASE WHEN COALESCE(b.DataRegistroJuntaLocal,'2016-01-01') <= '2016-01-01' THEN
									CASE WHEN COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataESocialIniciado)),2,4),'') + '-' + 
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataESocialIniciado)),2,2),'') = '2018-01' THEN
										'<iniValid>' +	'2016-01' + '</iniValid>'
									ELSE
										'<iniValid>' +	'2017-01' + '</iniValid>'  
									END
								ELSE
									'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,b.DataRegistroJuntaLocal)),2,4),'') + '-' + 
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,b.DataRegistroJuntaLocal)),2,2),'') + 
									'</iniValid>'  
								END 
							ELSE							
								'<iniValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataIniValidade)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataIniValidade)),2,2),'') + 
								'</iniValid>'  
							END +
							CASE WHEN c.DataFimValidade IS NOT NULL THEN
								'<fimValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimValidade)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimValidade)),2,2),'') + 
								'</fimValid>'  
							ELSE
								''
							END +
							'</ideProcesso>' +
						'</exclusao>' +
					'</infoProcesso>' +
				'</evtTabProcesso>' +
			'</eSocial>',
			COALESCE(RTRIM(LTRIM(c.TipoProcesso)),'') + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroProcesso)),''),
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbProcessoAdmJudicial c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP e
			ON e.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbLogCargaInicialESocial l
			ON  l.CodigoEmpresa			= @CodigoEmpresa
			AND l.CodigoLocal			= @CodigoLocal
			AND l.CodigoArquivo			= @NomeArquivo
			AND l.TipoOperacaoArquivo	= @TipoRegistro
			AND REPLACE(CONVERT(CHAR(10),l.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),l.DataHoraArquivo,108)	= @DataHoraArquivo
			AND l.GeradoXML				= @GeradoXML
			AND l.ExcluidoLog			= 'F'

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal     = @CodigoLocal
		END
	END
	---- FIM XML Processos Administrativos/Judiciais
END
GOTO ARQ_FIM

ARQ_S1200:
---- INICIO XML Evento Remuneração de trabalhador vinculado ao Regime Geral de Previd. Social
BEGIN
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, null, null,'N', 0, 'N', 2, '201407', 'N', 1, null, null
	-- cria temp com valores mensais
	SELECT DISTINCT
		CodigoEmpresa, 
		CodigoLocal, 
		TipoColaborador, 
		NumeroRegistro, 
		PeriodoCompetencia,
		RotinaPagamento,
		DataPagamento,
		Dissidio
	INTO #tmpPagamentos1200
	FROM tbMovimentoFolha
	WHERE 1 = 2
	--
	IF @TipoColaborador <> 'T' -- Tipo Colaborador = E ou F
	BEGIN
		-- popula temp com valores mensais
		INSERT INTO #tmpPagamentos1200
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia,
			RotinaPagamento		= a.RotinaPagamento,
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio 

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
		
		INNER JOIN tbEmpresaFP d
		ON	d.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbPessoal e
		ON  e.CodigoEmpresa			= a.CodigoEmpresa
		AND e.CodigoLocal			= a.CodigoLocal
		AND e.TipoColaborador		= a.TipoColaborador
		AND	e.NumeroRegistro		= a.NumeroRegistro

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND	  (
				a.PeriodoCompetencia	= @PerApuracao
				OR(
					a.PeriodoCompetencia = @PerApuracao -1 
					AND
					a.PeriodoCompetencia = (COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataESocialIniciadoFase3)),2,4),'') +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataESocialIniciadoFase3)),2,2),'')) -1
					AND
					a.PeriodoPagamento   = COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataESocialIniciadoFase3)),2,4),'') +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataESocialIniciadoFase3)),2,2),'')
				   )	
			   )
		AND   e.CondicaoColaborador	NOT IN (3,4,5) -- não demitidos
		AND   (
					(@IndApuracao = 1 AND a.RotinaPagamento	IN (1,2,7)) -- adto, mensal, eventual
				OR	(@IndApuracao = 2 AND a.RotinaPagamento	IN (4,5))	-- 13o salario	
		  	  )
		GROUP BY a.CodigoEmpresa, 
				a.CodigoLocal, 
				a.TipoColaborador, 
				a.NumeroRegistro, 
				a.PeriodoCompetencia, 
				a.RotinaPagamento,
				a.DataPagamento,
				a.Dissidio 
	END
	ELSE -- TipoColaborador = T
	BEGIN
		INSERT INTO #tmpPagamentos1200
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia, 
			RotinaPagamento		= a.RotinaPagamento,
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio 

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

		INNER JOIN tbEmpresaFP d
		ON	d.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbColaborador e
		ON  e.CodigoEmpresa			= a.CodigoEmpresa
		AND e.CodigoLocal			= a.CodigoLocal
		AND e.TipoColaborador		= a.TipoColaborador
		AND	e.NumeroRegistro		= a.NumeroRegistro

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND	  (
				a.PeriodoCompetencia	= @PerApuracao
				OR(
					a.PeriodoCompetencia = @PerApuracao -1 
					AND
					a.PeriodoCompetencia = (COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataESocialIniciadoFase3)),2,4),'') +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataESocialIniciadoFase3)),2,2),'')) -1
					AND
					a.PeriodoPagamento   = COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,d.DataESocialIniciadoFase3)),2,4),'') +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,d.DataESocialIniciadoFase3)),2,2),'')
				   )	
			   )
		AND   e.DataDemissao		IS NULL -- não demitidos
		AND   (
					(@IndApuracao = 1 AND a.RotinaPagamento	IN (1,2,7)) -- adto, mensal, eventual
				OR	(@IndApuracao = 2 AND a.RotinaPagamento	IN (5))		-- 13o salario	
		  	  )
		GROUP BY a.CodigoEmpresa, 
				a.CodigoLocal, 
				a.TipoColaborador, 
				a.NumeroRegistro, 
				a.PeriodoCompetencia, 
				a.RotinaPagamento,
				a.DataPagamento,
				a.Dissidio 
	END	
	-- se existir valores mensais!!
	IF EXISTS(
				SELECT 1 FROM #tmpPagamentos1200		
			  )
	BEGIN
		SELECT @MultiplosVinculos	= ''
--		SELECT @Transferencias		= ''
		SELECT @ProcessoAdmJudMes	= ''
		
		SELECT @MultiplosVinculos	= (SELECT dbo.fnESocialRemuneracaoOutraEmpresa (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @IndApuracao, @PerApuracao))
--		SELECT @Transferencias		= (SELECT dbo.fnESocialTransferencias (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))
		SELECT @ProcessoAdmJudMes	= (SELECT dbo.fnESocialProcessosAdmJud (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @IndApuracao, @PerApuracao))
		-- dados empresa/vinculo
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtRemun/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtRemun Id="ID' + 
												COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
												COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
												@DataHoraProc +
												@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				CASE WHEN @IndApuracao = '1' THEN
					'<indApuracao>' + '1' + '</indApuracao>' +
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
				ELSE
					'<indApuracao>' + '2' + '</indApuracao>' +
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<ideTrabalhador>' +
					'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
					'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				CASE WHEN @MultiplosVinculos <> '' THEN
					'<infoMV>' + @MultiplosVinculos + '</infoMV>'
				ELSE
					''
				END +
--				CASE WHEN @Transferencias <> '' THEN
--					@Transferencias 
--				ELSE
--					''
--				END +
				CASE WHEN @ProcessoAdmJudMes <> '' THEN
					@ProcessoAdmJudMes
				ELSE
					''
				END +
					-- nao fiz
					--'<infoInterm>' + 
					--	'<qtdDiasInterm>' + '</qtdDiasInterm>' +
					--'</infoInterm>' +
				'</ideTrabalhador>',
		d.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaboradorGeral d
		ON  d.CodigoEmpresa		= c.CodigoEmpresa
		AND d.CodigoLocal		= c.CodigoLocal
		AND d.TipoColaborador	= c.TipoColaborador
		AND d.NumeroRegistro	= c.NumeroRegistro

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   c.CodigoEmpresa		= @CodigoEmpresa
		AND   c.CodigoLocal			= @CodigoLocal
		AND   c.TipoColaborador		= @TipoColaborador
		AND   c.NumeroRegistro		= @NumeroRegistro
		-- inicia tag demonstrativos
		-- cria cursor com os tipos de pagamentos encontrados
		-- dados verbas
		WHILE EXISTS ( SELECT 1 FROM #tmpPagamentos1200 )
		BEGIN
			-- tag abertura remuneracao
			SET @LinhaAux = '<dmDev>' 
			INSERT @xml SELECT @LinhaAux, @OrdemAux, @OrdemAux + 2
			SET @LinhaAux = ''
			-- pagamentos 
			SELECT TOP 1 			
				@curCodigoEmpresa		= a.CodigoEmpresa, 
				@curCodigoLocal			= a.CodigoLocal, 
				@curTipoColaborador		= a.TipoColaborador, 
				@curNumeroRegistro		= a.NumeroRegistro, 
				@curPeriodoCompetencia	= a.PeriodoCompetencia, 
				@curRotinaPagamento		= a.RotinaPagamento,
				@curDataPagamento		= a.DataPagamento,
				@curDissidio			= a.Dissidio,
				@curCategoriaESocial	= e.CodigoCategoriaESocial,
				@curMatriculaESocial	= CASE WHEN c.TipoColaborador = 'F' and f.CondicaoINSS = 'N' THEN
												d.MatriculaESocial
										  ELSE
											''
										  END,
				@curAgenteNocivoESocial	= CASE WHEN c.TipoColaborador = 'F' and f.CondicaoINSS = 'N' THEN 
												c.CodigoAgenteNocivoESocial
										  ELSE
											0
										  END
			FROM #tmpPagamentos1200 a

			INNER JOIN tbColaborador c
			ON  c.CodigoEmpresa		= a.CodigoEmpresa
			AND c.CodigoLocal		= a.CodigoLocal
			AND c.TipoColaborador	= a.TipoColaborador
			AND c.NumeroRegistro	= a.NumeroRegistro
		
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa		= c.CodigoEmpresa
			AND d.CodigoLocal		= c.CodigoLocal
			AND d.TipoColaborador	= c.TipoColaborador
			AND d.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbCargo e
			ON  e.CodigoEmpresa	= c.CodigoEmpresa
			AND e.CodigoLocal   = c.CodigoLocal
			AND e.CodigoCargo   = c.CodigoCargo
		
			LEFT JOIN tbPessoal f
			ON  f.CodigoEmpresa		= c.CodigoEmpresa
			AND f.CodigoLocal		= c.CodigoLocal
			AND f.TipoColaborador	= c.TipoColaborador
			AND f.NumeroRegistro	= c.NumeroRegistro

			-- 1.o registro da temp
			IF @curDissidio = 'F' -- não é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, null,'', 0, 'N', '1', '201103', 'N'
			BEGIN
				-- tag abertura
				SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) +	'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@curCodigoEmpresa)),'') + 
																			COALESCE(RTRIM(LTRIM(@curCodigoLocal)),'') +
																			COALESCE(RTRIM(LTRIM(@curTipoColaborador)),'') +
																			COALESCE(RTRIM(LTRIM(@curNumeroRegistro)),'') +
																			COALESCE(RTRIM(LTRIM(@curPeriodoCompetencia)),'') +
																			COALESCE(RTRIM(LTRIM(@curRotinaPagamento)),'') +
																			COALESCE(RTRIM(LTRIM(@curDissidio)),'') +
															'</ideDmDev>' +
															'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(@curCategoriaESocial,0)))),3) + '</codCateg>' +
															'<infoPerApur>' 
				-- insere na temp original
				IF RTRIM(LTRIM(@LinhaAux)) <> ''
					INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 3
				SELECT @LinhaAux = ''
				-- cria temp tomadores
				SELECT TOP 1 @curCodigoCliFor = coalesce(c.CodigoCliFor,0)
			
				FROM tbTomadorFunc a,
					 tbTomadorServico b,
					 tbCliFor c
			
				WHERE a.CodigoEmpresa		= b.CodigoEmpresa
				AND   a.CodigoLocal			= b.CodigoLocal
				AND   a.CodigoCliFor		= b.CodigoCliFor
				AND   b.CodigoEmpresa       = c.CodigoEmpresa
				AND   b.CodigoCliFor        = c.CodigoCliFor
				AND   a.CodigoEmpresa		= @curCodigoEmpresa
				AND   a.CodigoLocal			= @curCodigoLocal
				AND   a.TipoColaborador		= @curTipoColaborador
				AND   a.NumeroRegistro		= @curNumeroRegistro
				AND   (
						(b.DataIniValidade <= @DataApuracao AND b.DataFimValidade IS NULL)
						OR (@DataApuracao BETWEEN b.DataIniValidade AND b.DataFimValidade)
					  )
				IF @curCodigoCliFor > 0 -- tem tomadores e não é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, null, '', 0, 'N', '1', '201103', 'N'
				BEGIN
					SELECT @Tomadores	= ''
					SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, @curCodigoCliFor))
					INSERT @xml SELECT '<ideEstabLot>' + RTRIM(LTRIM(@Tomadores)), @OrdemAux, @OrdemAux + 4
					-- detalhes verbas
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
					-- insere na temp original
					IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
						INSERT @xml SELECT '<remunPerApur>' + CASE WHEN @curMatriculaESocial <> '' THEN
																	'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
															  ELSE
																''
														      END + RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 5 
					IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 6 
					IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 7 
					-- detalhes plano saude	
					-- cria temp operadora
					SELECT RegistroANS
					INTO #tmpPlanoSaudeOperTom
					FROM tbAssistMedica
					WHERE 1 = 2
					--
					-- popula temp operadora
					IF @TipoColaborador <> 'T'
					BEGIN
						INSERT INTO #tmpPlanoSaudeOperTom
						SELECT 
								d.RegistroANS
						
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
						AND c.CodigoRubricaESocial	= 9219
						
						INNER JOIN tbAssistMedica d
						ON  d.CodigoEmpresa			= b.CodigoEmpresa
						AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

						WHERE a.CodigoEmpresa			= @curCodigoEmpresa
						AND   a.CodigoLocal				= @curCodigoLocal
						AND   a.TipoColaborador			= @curTipoColaborador
						AND   a.NumeroRegistro			= @curNumeroRegistro
						AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
						AND   a.DataPagamento			= @curDataPagamento
						AND   a.RotinaPagamento			= @curRotinaPagamento
						AND   b.TipoAssistenciaMedica	> 0

						GROUP BY d.RegistroANS

						ORDER BY d.RegistroANS
					END
					ELSE
					BEGIN
						INSERT INTO #tmpPlanoSaudeOperTom
						SELECT 
								d.RegistroANS

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
						AND c.CodigoRubricaESocial	= 9219
						
						INNER JOIN tbAssistMedica d
						ON  d.CodigoEmpresa			= b.CodigoEmpresa
						AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

						WHERE a.CodigoEmpresa			= @curCodigoEmpresa
						AND   a.CodigoLocal				= @curCodigoLocal
						AND   a.TipoColaborador			= @curTipoColaborador
						AND   a.NumeroRegistro			= @curNumeroRegistro
						AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
						AND   a.DataPagamento			= @curDataPagamento
						AND   a.RotinaPagamento			= @curRotinaPagamento
						AND   b.TipoAssistenciaMedica	> 0

						GROUP BY d.RegistroANS

						ORDER BY d.RegistroANS
					END
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201207', 'N'
					IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperTom )
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 8
						SELECT @LinhaAux = ''
						SET @SaudeColet = 'V'
					END
					WHILE EXISTS (
									SELECT 1 FROM #tmpPlanoSaudeOperTom
								  )
					BEGIN
						-- operadora
						SELECT TOP 1 			
							@curRegistroANS = RegistroANS 
						FROM #tmpPlanoSaudeOperTom
						GROUP BY RegistroANS
						--inclui operadora
						SELECT @ValorPlanoSaudeOpe	= ''
						SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
						IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
							INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 9
						-- valor titular
						SELECT @ValorPlanoSaudeTit	= ''
						SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
						IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 10
						ELSE
						BEGIN
							SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
							INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 11
						END
						-- valor dependentes
						-- cria temp
						SELECT 	RegistroANS,
								TipoAssistenciaMedica AS SequenciaDependente									
						INTO #tmpPlanoSaudeDepTom
						FROM tbAssistMedica
						WHERE 1 = 2
						-- 
						-- popula temp
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeDepTom
							SELECT 
									d.RegistroANS,
									b.SequenciaDependente									
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
							AND d.RegistroANS			= @curRegistroANS

							INNER JOIN tbDependente e
							ON  e.CodigoEmpresa			= b.CodigoEmpresa
							AND e.CodigoLocal			= b.CodigoLocal
							AND e.TipoColaborador		= b.TipoColaborador
							AND e.NumeroRegistro		= b.NumeroRegistro
							AND e.SequenciaDependente	= b.SequenciaDependente

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento

							GROUP BY d.RegistroANS,
									b.SequenciaDependente,
									e.CPFDependente

							ORDER BY d.RegistroANS,
									e.CPFDependente
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeDepTom
							SELECT 
									d.RegistroANS,
									b.SequenciaDependente

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
							AND d.RegistroANS			= @curRegistroANS

							INNER JOIN tbDependente e
							ON  e.CodigoEmpresa			= b.CodigoEmpresa
							AND e.CodigoLocal			= b.CodigoLocal
							AND e.TipoColaborador		= b.TipoColaborador
							AND e.NumeroRegistro		= b.NumeroRegistro
							AND e.SequenciaDependente	= b.SequenciaDependente

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento

							GROUP BY d.RegistroANS,
									b.SequenciaDependente,
									e.CPFDependente

							ORDER BY d.RegistroANS,
									e.CPFDependente
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeDepTom
									 )
						BEGIN
							SELECT TOP 1 			
								@curRegistroANSDep	= RegistroANS,
								@curSeqDependente	= SequenciaDependente 
							FROM #tmpPlanoSaudeDepTom
							GROUP BY RegistroANS,
									SequenciaDependente
							-- inclui		
							SELECT @ValorPlanoSaudeDep	= ''
							SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
							IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 10
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeDepTom 
							WHERE RegistroANS			= @curRegistroANSDep
							AND   SequenciaDependente	= @curSeqDependente
							-- incrementa contador
							SET @OrdemAux = @OrdemAux + 12
						END
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeDepTom
						-- deleta 1.o registro
						DELETE #tmpPlanoSaudeOperTom 
						WHERE RegistroANS = @curRegistroANS
						-- fecha operadora
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 13
						SELECT @LinhaAux = ''
						-- incrementa contador
						SET @OrdemAux = @OrdemAux + 14
					END -- fim temp
					-- elimina a tabela ao fim do processamento
					DROP TABLE #tmpPlanoSaudeOperTom 
					IF @SaudeColet = 'V'
					BEGIN
						-- fecha tag plano saude
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 15
						SELECT @LinhaAux = ''
						SET @SaudeColet = 'F'
					END
					-- agente nocivo e codigo simples
					IF @curAgenteNocivoESocial <> 0 
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoAgNocivo>' +
																	'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  '</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerApur>' 
					END
					ELSE
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + --'<infoAgNocivo>' +
																	--'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  --'</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerApur>' 
					END
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
					SELECT @LinhaAux = ''
					-- incrementa contador
					SET @OrdemAux = @OrdemAux + 17
					-- fecha remuneracao
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</ideEstabLot>' + '</infoPerApur>'
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 18
					SELECT @LinhaAux = ''
				END
				ELSE -- nao tem tomadores não é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201207', 'N'
				BEGIN
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																SELECT DISTINCT '<ideEstabLot>' +
																	'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
																	'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
																	'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>'  
																	--'<qtdDiasAv>' + '0' + '</qtdDiasAv>' 
																FROM tbLocalFP a
																	
																INNER JOIN tbLocal b
																ON  b.CodigoEmpresa = a.CodigoEmpresa
																AND b.CodigoLocal   = a.CodigoLocal

																INNER JOIN tbColaborador c
																ON  c.CodigoEmpresa = b.CodigoEmpresa
																AND c.CodigoLocal   = b.CodigoLocal
																
																WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																AND   c.CodigoLocal		= @curCodigoLocal
																AND   c.TipoColaborador = @curTipoColaborador
																AND   c.NumeroRegistro  = @curNumeroRegistro
															)
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 3
					SELECT @LinhaAux = ''
					-- detalhes verbas
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
					-- insere na temp original
					IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
						INSERT @xml SELECT '<remunPerApur>' + CASE WHEN @curMatriculaESocial <> '' THEN
																'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
															  ELSE
																''
															  END + RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 4 
					IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 5
					IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 6
					-- detalhes plano saude	
					-- cria temp operadora
						SELECT RegistroANS
						INTO #tmpPlanoSaudeOperNTom
						FROM tbAssistMedica
						WHERE 1 = 2
					--
					-- popula temp operadora
					IF @TipoColaborador <> 'T'
					BEGIN
						INSERT INTO #tmpPlanoSaudeOperNTom
						SELECT 
								d.RegistroANS
						
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
						AND c.CodigoRubricaESocial	= 9219
						
						INNER JOIN tbAssistMedica d
						ON  d.CodigoEmpresa			= b.CodigoEmpresa
						AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

						WHERE a.CodigoEmpresa			= @curCodigoEmpresa
						AND   a.CodigoLocal				= @curCodigoLocal
						AND   a.TipoColaborador			= @curTipoColaborador
						AND   a.NumeroRegistro			= @curNumeroRegistro
						AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
						AND   a.DataPagamento			= @curDataPagamento
						AND   a.RotinaPagamento			= @curRotinaPagamento
						AND   b.TipoAssistenciaMedica	> 0

						GROUP BY d.RegistroANS

						ORDER BY d.RegistroANS
					END
					ELSE
					BEGIN
						INSERT INTO #tmpPlanoSaudeOperNTom
						SELECT 
								d.RegistroANS

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
						AND c.CodigoRubricaESocial	= 9219
						
						INNER JOIN tbAssistMedica d
						ON  d.CodigoEmpresa			= b.CodigoEmpresa
						AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

						WHERE a.CodigoEmpresa			= @curCodigoEmpresa
						AND   a.CodigoLocal				= @curCodigoLocal
						AND   a.TipoColaborador			= @curTipoColaborador
						AND   a.NumeroRegistro			= @curNumeroRegistro
						AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
						AND   a.DataPagamento			= @curDataPagamento
						AND   a.RotinaPagamento			= @curRotinaPagamento
						AND   b.TipoAssistenciaMedica	> 0

						GROUP BY d.RegistroANS

						ORDER BY d.RegistroANS
					END
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201207', 'N'
					IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperNTom )
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 7
						SELECT @LinhaAux = ''
						SET @SaudeColet = 'V'
					END
					WHILE EXISTS (
									SELECT 1 FROM #tmpPlanoSaudeOperNTom
								  )
					BEGIN
						-- operadora
						SELECT TOP 1 			
							@curRegistroANS = RegistroANS 
						FROM #tmpPlanoSaudeOperNTom
						GROUP BY RegistroANS
						-- inclui operadora
						SELECT @ValorPlanoSaudeOpe	= ''
						SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
						IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
							INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 8
						-- valores
						-- valor titular
						SELECT @ValorPlanoSaudeTit	= ''
						SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
						IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 9
						ELSE
						BEGIN
							SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
							INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 10
						END
						-- cria temp dep
							SELECT RegistroANS,
									TipoAssistenciaMedica AS SequenciaDependente									
							INTO #tmpPlanoSaudeDepNTom
							FROM tbAssistMedica
							WHERE 1 = 2
						--
						-- popula tem dep
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeDepNTom
							SELECT 
									d.RegistroANS,
									b.SequenciaDependente									
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
							AND d.RegistroANS			= @curRegistroANS

							INNER JOIN tbDependente e
							ON  e.CodigoEmpresa			= b.CodigoEmpresa
							AND e.CodigoLocal			= b.CodigoLocal
							AND e.TipoColaborador		= b.TipoColaborador
							AND e.NumeroRegistro		= b.NumeroRegistro
							AND e.SequenciaDependente	= b.SequenciaDependente

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento

							GROUP BY d.RegistroANS,
									b.SequenciaDependente,
									e.CPFDependente

							ORDER BY d.RegistroANS,
									e.CPFDependente
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeDepNTom
							SELECT 
									d.RegistroANS,
									b.SequenciaDependente

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
							ANd d.RegistroANS			= @curRegistroANS

							INNER JOIN tbDependente e
							ON  e.CodigoEmpresa			= b.CodigoEmpresa
							AND e.CodigoLocal			= b.CodigoLocal
							AND e.TipoColaborador		= b.TipoColaborador
							AND e.NumeroRegistro		= b.NumeroRegistro
							AND e.SequenciaDependente	= b.SequenciaDependente

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento

							GROUP BY d.RegistroANS,
									b.SequenciaDependente,
									e.CPFDependente

							ORDER BY d.RegistroANS,
									e.CPFDependente
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeDepNTom
									 )
						BEGIN
							SELECT TOP 1 			
								@curRegistroANSDep	= RegistroANS,
								@curSeqDependente	= SequenciaDependente 
							FROM #tmpPlanoSaudeDepNTom
							GROUP BY RegistroANS,
									SequenciaDependente
							-- valor dependente		
							SELECT @ValorPlanoSaudeDep	= ''
							SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
							IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 11
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeDepNTom 
							WHERE RegistroANS			= @curRegistroANSDep
							AND   SequenciaDependente	= @curSeqDependente
							-- incrementa contadores
							SET @OrdemAux = @OrdemAux + 12
						END
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeDepNTom
						-- deleta 1.o registro
						DELETE #tmpPlanoSaudeOperNTom 
						WHERE RegistroANS = @curRegistroANS
						-- fecha operadora
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 13
						SELECT @LinhaAux = ''
						-- incrementa contador
						SET @OrdemAux = @OrdemAux + 14
					END -- fim temp
					-- elimina a tabela ao fim do processamento
					DROP TABLE #tmpPlanoSaudeOperNTom 
					IF @SaudeColet = 'V'
					BEGIN
						-- fecha tag plano saude
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 15
						SELECT @LinhaAux = ''
						SET @SaudeColet = 'F'
					END
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, null, '', 0, 'N', '1', '201103', 'N'
					IF @curAgenteNocivoESocial <> 0 
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoAgNocivo>' +
																	'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  '</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerApur>'
					END
					ELSE
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + --'<infoAgNocivo>' +
																	--'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  --'</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerApur>'
					END
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
					SELECT @LinhaAux = ''
					-- incrementa contador
					SET @OrdemAux = @OrdemAux + 17
					-- fecha remuneracao
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</ideEstabLot>' + '</infoPerApur>'
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 18
					SELECT @LinhaAux = ''
				END -- fim tomadores não dissidio
			END
			ELSE -- é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, '', 0, 'N', '1', '201103', 'N'
			BEGIN
				-- tag abertura
				SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) +	'<ideDmDev>' + COALESCE(RTRIM(LTRIM(@curCodigoEmpresa)),'') + 
																			COALESCE(RTRIM(LTRIM(@curCodigoLocal)),'') +
																			COALESCE(RTRIM(LTRIM(@curTipoColaborador)),'') +
																			COALESCE(RTRIM(LTRIM(@curNumeroRegistro)),'') +
																			COALESCE(RTRIM(LTRIM(@curPeriodoCompetencia)),'') +
																			COALESCE(RTRIM(LTRIM(@curRotinaPagamento)),'') +
																			COALESCE(RTRIM(LTRIM(@curDissidio)),'') +
															'</ideDmDev>' +
															'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(@curCategoriaESocial,0)))),3) + '</codCateg>' +
															'<infoPerAnt>' +
															'<ideADC>'
				-- insere na temp original
				IF RTRIM(LTRIM(@LinhaAux)) <> ''
					INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 3
				SELECT @LinhaAux = ''
				-- estabelecimento/lotacao
				SELECT @DissidioAcordoMes = ''
				SELECT @DissidioAcordoMes = (SELECT dbo.fnESocialDissidioAcordo (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, NULL, @curPeriodoCompetencia, NULL, @curDissidio))
				-- insere na temp original
				IF RTRIM(LTRIM(@DissidioAcordoMes)) <> ''
					INSERT @xml SELECT RTRIM(LTRIM(@DissidioAcordoMes)), @OrdemAux, @OrdemAux + 4
				-- cria temp tomadores
				SELECT TOP 1 @curCodigoCliFor = coalesce(c.CodigoCliFor,0)
			
				FROM tbTomadorFunc a,
					 tbTomadorServico b,
					 tbCliFor c
			
				WHERE a.CodigoEmpresa		= b.CodigoEmpresa
				AND   a.CodigoLocal			= b.CodigoLocal
				AND   a.CodigoCliFor		= b.CodigoCliFor
				AND   b.CodigoEmpresa       = c.CodigoEmpresa
				AND   b.CodigoCliFor        = c.CodigoCliFor
				AND   a.CodigoEmpresa		= @curCodigoEmpresa
				AND   a.CodigoLocal			= @curCodigoLocal
				AND   a.TipoColaborador		= @curTipoColaborador
				AND   a.NumeroRegistro		= @curNumeroRegistro
				AND   (
						(b.DataIniValidade <= @DataApuracao AND b.DataFimValidade IS NULL)
						OR (@DataApuracao BETWEEN b.DataIniValidade AND b.DataFimValidade)
					  )
				IF @curCodigoCliFor > 0 -- tem tomadores é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, '', 0, 'N', '1', '201103', 'N'
				BEGIN
					-- pega o 1.o
					SELECT TOP 1 @curCodigoCliFor = CodigoCliFor FROM #tmpTomadores1200
					SELECT @Tomadores	= ''
					SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, @curCodigoCliFor))
					INSERT @xml SELECT '<ideEstabLot>' + RTRIM(LTRIM(@Tomadores)), @OrdemAux, @OrdemAux + 5
					-- detalhes verbas
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
					-- insere na temp original
					IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
						INSERT @xml SELECT '<remunPerAnt>' + CASE WHEN @curMatriculaESocial <> '' THEN
																'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
															 ELSE
																''
															 END + RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 6 
					IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 7 
					IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 8 
					-- agente nocivo e codigo simples
					IF @curAgenteNocivoESocial <> 0 
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoAgNocivo>' +
																	'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  '</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerAnt>' 
					END
					ELSE
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + --'<infoAgNocivo>' +
																	--'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  --'</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerAnt>' 
					END
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 9
					SELECT @LinhaAux = ''
					-- incrementa contador
					SET @OrdemAux = @OrdemAux + 10
					-- fecha remuneracao
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</ideEstabLot>' + '</idePeriodo>' + '</ideADC>' + '</infoPerAnt>'
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 10
					SELECT @LinhaAux = ''
				END
				ELSE -- nao tem tomadores é dissidio
--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 59, 121324, null,'', 0, 'N', '1', '201103', 'N'
				BEGIN
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																SELECT DISTINCT '<ideEstabLot>' +
																	'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
																	'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
																	'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>'
																FROM tbLocalFP a
																	
																INNER JOIN tbLocal b
																ON  b.CodigoEmpresa = a.CodigoEmpresa
																AND b.CodigoLocal   = a.CodigoLocal

																INNER JOIN tbColaborador c
																ON  c.CodigoEmpresa = b.CodigoEmpresa
																AND c.CodigoLocal   = b.CodigoLocal
																
																WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																AND   c.CodigoLocal		= @curCodigoLocal
																AND   c.TipoColaborador = @curTipoColaborador
																AND   c.NumeroRegistro  = @curNumeroRegistro
															)
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 11
					SELECT @LinhaAux = ''
					-- detalhes verbas
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
					-- insere na temp original
					IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
						INSERT @xml SELECT '<remunPerAnt>' + CASE WHEN @curMatriculaESocial <> '' THEN
																'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
															 ELSE
																''
															 END + RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 12 
					IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 13
					IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 14
					-- fim rubricas
					IF @curAgenteNocivoESocial <> 0
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoAgNocivo>' +
																	'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  '</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerAnt>'
					END
					ELSE
					BEGIN
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + --'<infoAgNocivo>' +
																	--'<grauExp>' + COALESCE(RTRIM(LTRIM(@curAgenteNocivoESocial)),'') + '</grauExp>' +
																  --'</infoAgNocivo>' + 
																--'<infoTrabInterm>' +
																--	'<codConv>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</codConv>' +
																--'</infoTrabInterm>' +
																'</remunPerAnt>'
					END
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 15
					SELECT @LinhaAux = ''
					-- incrementa contador
					SET @OrdemAux = @OrdemAux + 10
					-- fecha remuneracao
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</ideEstabLot>' + '</idePeriodo>' + '</ideADC>' + '</infoPerAnt>'
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
					SELECT @LinhaAux = ''
				END -- fim não tomadores é dissidio
			END
--			-- insere na temp original
			INSERT @xml SELECT '</dmDev>', @OrdemAux, @OrdemAux + 18
--			-- acumula variaveis
			SET @OrdemAux = @OrdemAux + 100
--			-- deleta 1.o registro
			DELETE #tmpPagamentos1200 
			WHERE CodigoEmpresa			= @curCodigoEmpresa
			AND   CodigoLocal			= @curCodigoLocal
			AND   TipoColaborador		= @curTipoColaborador
			AND   NumeroRegistro		= @curNumeroRegistro
			AND   PeriodoCompetencia	= @curPeriodoCompetencia
			AND   RotinaPagamento		= @curRotinaPagamento
			AND   DataPagamento			= @curDataPagamento
			AND   Dissidio				= @curDissidio
		END -- fim temp pagamentos
		-- elimina a tabela ao fim do processamento
		DROP TABLE #tmpPagamentos1200 

		-- fecha Tags
		INSERT @xml
		SELECT DISTINCT
			'</evtRemun>' +
		'</eSocial>',
		@OrdemAux,
		@OrdemAux + 20
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		WHERE a.CodigoEmpresa = @CodigoEmpresa
		AND   a.CodigoLocal	  = @CodigoLocal
	END	
	---- FIM XML Evento Remuneração de trabalhador vinculado ao Regime Geral de Previd. Social
END
GOTO ARQ_FIM

ARQ_S1210:
---- INICIO XML Pagamentos de Rendimentos do Trabalho
BEGIN
	-- cria temp com valores mensais
	SELECT DISTINCT
		CodigoEmpresa, 
		CodigoLocal, 
		TipoColaborador, 
		NumeroRegistro, 
		PeriodoCompetencia, 
		PeriodoPagamento,
		RotinaPagamento, 
		DataPagamento,
		Dissidio,
		1 AS CondicaoColaborador,
		'            ' AS MatriculaESocial,
		DataDissidioESocial AS DataESocialIniciado,
		999 AS CategoriaESocial,
		' ' AS ResidenteBrasil
	INTO #tmpPagamentos1210
	FROM tbMovimentoFolha
	WHERE 1 = 2
	--
	IF @TipoColaborador <> 'T' -- Tipo Colaborador = E ou F
	BEGIN
		-- popula temp com valores mensais
		INSERT INTO #tmpPagamentos1210
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia, 
			PeriodoPagamento	= a.PeriodoPagamento,
			RotinaPagamento		= a.RotinaPagamento, 
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio,
			CondicaoColaborador = i.CondicaoColaborador,
			MatriculaESocial	= CASE WHEN d.TipoColaborador = 'F' AND i.CondicaoINSS = 'N' THEN e.MatriculaESocial ELSE '' END,
			DataESocialIniciado = f.DataESocialIniciadoFase3,
			CategoriaESocial	= g.CodigoCategoriaESocial,
			ResidenteBrasil		= CASE WHEN COALESCE(h.CodigoPaisResidencia,1058) = 1058 THEN 'S' ELSE 'N' END -- 1058 = Brasi

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

		INNER JOIN tbColaborador d
		ON  d.CodigoEmpresa		= a.CodigoEmpresa
		AND d.CodigoLocal		= a.CodigoLocal
		AND d.TipoColaborador	= a.TipoColaborador
		AND d.NumeroRegistro	= a.NumeroRegistro

		INNER JOIN tbColaboradorGeral e
		ON  e.CodigoEmpresa		= d.CodigoEmpresa
		AND e.CodigoLocal		= d.CodigoLocal
		AND e.TipoColaborador	= d.TipoColaborador
		AND e.NumeroRegistro	= d.NumeroRegistro

		INNER JOIN tbEmpresaFP f
		ON  f.CodigoEmpresa	= a.CodigoEmpresa

		INNER JOIN tbCargo g
		ON  g.CodigoEmpresa	= d.CodigoEmpresa
		AND g.CodigoLocal	= d.CodigoLocal
		AND g.CodigoCargo	= d.CodigoCargo

		INNER JOIN tbColaboradorEndereco h
		ON  h.CodigoEmpresa		= d.CodigoEmpresa
		AND h.CodigoLocal		= d.CodigoLocal
		AND h.TipoColaborador	= d.TipoColaborador
		AND h.NumeroRegistro	= d.NumeroRegistro

		INNER JOIN tbPessoal i
		ON  i.CodigoEmpresa		= d.CodigoEmpresa
		AND i.CodigoLocal		= d.CodigoLocal
		AND i.TipoColaborador	= d.TipoColaborador
		AND i.NumeroRegistro	= d.NumeroRegistro

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND   a.PeriodoPagamento	= @PerApuracao
		AND   a.RotinaPagamento		IN (1,2,5,6,7) -- adto, mensal(rescisão), 13o Sal, férias, eventual
		
		ORDER BY a.CodigoEmpresa,
				a.CodigoLocal,
				a.TipoColaborador,
				a.NumeroRegistro,
				a.PeriodoPagamento,
				a.DataPagamento
	END
	ELSE -- TipoColaborador = T
	BEGIN
		INSERT INTO #tmpPagamentos1210
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia, 
			PeriodoPagamento	= a.PeriodoPagamento,
			RotinaPagamento		= a.RotinaPagamento, 
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio,
			CondicaoColaborador = CASE WHEN d.DataDemissao IS NOT NULL THEN 3 ELSE 1 END,
			MatriculaESocial	= '',--e.MatriculaESocial,
			DataESocialIniciado = f.DataESocialIniciadoFase3,
			CategoriaESocial	= g.CodigoCategoriaESocial,
			ResidenteBrasil		= CASE WHEN COALESCE(h.CodigoPaisResidencia,1058) = 1058 THEN 'S' ELSE 'N' END -- 1058 = Brasi

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

		INNER JOIN tbColaborador d
		ON  d.CodigoEmpresa		= a.CodigoEmpresa
		AND d.CodigoLocal		= a.CodigoLocal
		AND d.TipoColaborador	= a.TipoColaborador
		AND d.NumeroRegistro	= a.NumeroRegistro

		INNER JOIN tbColaboradorGeral e
		ON  e.CodigoEmpresa		= d.CodigoEmpresa
		AND e.CodigoLocal		= d.CodigoLocal
		AND e.TipoColaborador	= d.TipoColaborador
		AND e.NumeroRegistro	= d.NumeroRegistro

		INNER JOIN tbEmpresaFP f
		ON  f.CodigoEmpresa	= a.CodigoEmpresa

		INNER JOIN tbCargo g
		ON  g.CodigoEmpresa	= d.CodigoEmpresa
		AND g.CodigoLocal	= d.CodigoLocal
		AND g.CodigoCargo	= d.CodigoCargo

		INNER JOIN tbColaboradorEndereco h
		ON  h.CodigoEmpresa		= d.CodigoEmpresa
		AND h.CodigoLocal		= d.CodigoLocal
		AND h.TipoColaborador	= d.TipoColaborador
		AND h.NumeroRegistro	= d.NumeroRegistro

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND   a.PeriodoPagamento	= @PerApuracao
		AND   a.RotinaPagamento		IN (1,2,5,6,7) -- adto, mensal(rescisão), 13o Sal, férias, eventual
		
		ORDER BY a.CodigoEmpresa,
				a.CodigoLocal,
				a.TipoColaborador,
				a.NumeroRegistro,
				a.PeriodoPagamento,
				a.DataPagamento
	END	
	-- se existir valores mensais!!
	IF EXISTS(
				SELECT 1 FROM #tmpPagamentos1210
			  )
	BEGIN
--whArquivosFPESocialXML 1608, 'S-1210', 0, 'I', 'N', 'F', 22, 121324, null,'', 0, 'N', '1', '201407', 'N'
		SELECT @Dependentes	= ''

		SELECT @Dependentes	= (SELECT dbo.fnESocialDependentes (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @PerApuracao))

		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtPgtos/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtPgtos Id="ID' + 
												COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
												COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
												@DataHoraProc +
												@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				CASE WHEN @IndApuracao = '1' THEN
					'<indApuracao>' + '1' + '</indApuracao>' +
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
				ELSE
					'<indApuracao>' + '2' + '</indApuracao>' +
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<ideBenef>' +
					'<cpfBenef>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfBenef>' +
				CASE WHEN @Dependentes <> '' THEN
					'<deps>' + @Dependentes + '</deps>' 
				ELSE
					''
				END,
		d.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal
					
		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaboradorGeral d
		ON  d.CodigoEmpresa		= c.CodigoEmpresa
		AND d.CodigoLocal		= c.CodigoLocal
		AND d.TipoColaborador	= c.TipoColaborador
		AND d.NumeroRegistro	= c.NumeroRegistro

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   c.CodigoEmpresa		= @CodigoEmpresa
		AND   c.CodigoLocal			= @CodigoLocal
		AND   c.TipoColaborador		= @TipoColaborador
		AND   c.NumeroRegistro		= @NumeroRegistro

		-- dados verbas
		WHILE EXISTS ( 
						SELECT 1 FROM #tmpPagamentos1210 
					 )
		BEGIN
			-- tag abertura
			SET @LinhaAux = '<infoPgto>'
			IF RTRIM(LTRIM(@LinhaAux)) <> ''
				INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 2
			SELECT @LinhaAux = ''
			-- pagamentos 
			SELECT TOP 1 			
				@curCodigoEmpresa		= a.CodigoEmpresa, 
				@curCodigoLocal			= a.CodigoLocal, 
				@curTipoColaborador		= a.TipoColaborador, 
				@curNumeroRegistro		= a.NumeroRegistro, 
				@curPeriodoCompetencia	= a.PeriodoCompetencia, 
				@curPeriodoPagamento	= a.PeriodoPagamento, 
				@curRotinaPagamento		= a.RotinaPagamento, 
				@curDataPagamento		= a.DataPagamento,
				@curDissidio			= a.Dissidio,
				@curCondicaoColaborador	= a.CondicaoColaborador,
				@curMatriculaESocial	= a.MatriculaESocial,
				@curCategoriaESocial	= a.CategoriaESocial,
				@curDataESocialIniciado = a.DataESocialIniciado,
				@curResidenteBrasil		= a.ResidenteBrasil

			FROM #tmpPagamentos1210 a
			--
			SET @LinhaAux = @LinhaAux + 
							'<dtPgto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,@curDataPagamento)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,@curDataPagamento)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,@curDataPagamento)),2,2),'') +
							'</dtPgto>'  
			-- pagamento anterior à obrigatoriedade do esocial
			IF @curPeriodoCompetencia < COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,@curDataESocialIniciado)),2,4),'') +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,@curDataESocialIniciado)),2,2),'') 
			BEGIN
				SELECT @ValorBaseIRRF	= ''
				SELECT @ValorBaseIRRF	= (SELECT dbo.fnESocialValorBaseIRRF (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento))
				IF RTRIM(LTRIM(@ValorBaseIRRF)) <> '' 
				BEGIN
					SET @LinhaAux = @LinhaAux +
									'<tpPgto>' + '9' + '</tpPgto>' +
									'<indResBr>' + RTRIM(LTRIM(@curResidenteBrasil)) + '</indResBr>' +
									'<detPgtoAnt>' +
										'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(@curCategoriaESocial,0)))),3) + '</codCateg>'
					-- insere a linha apurada
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 3
					SELECT @LinhaAux = ''
					INSERT @xml SELECT RTRIM(LTRIM(@ValorBaseIRRF)) + '</detPgtoAnt>', @OrdemAux, @OrdemAux + 4
				END
			END
			ELSE -- não é pagamento anterior à obrigatoriedade do esocial
			BEGIN			
				-- é pagamento férias
				IF @curRotinaPagamento = 6 
				BEGIN
					SELECT @ValorLiquido	= ''
					SELECT @ValorLiquido	= (SELECT dbo.fnESocialValorLiquido (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, NULL))
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'B'))
					-- carrega linha 
					IF RTRIM(LTRIM(@ValorLiquido)) <> ''
					BEGIN
						IF @curMatriculaESocial <> ''
						BEGIN
							SET @LinhaAux = @LinhaAux +
											'<tpPgto>' + '7' + '</tpPgto>' +
											'<indResBr>' + RTRIM(LTRIM(@curResidenteBrasil)) + '</indResBr>' + 
											'<detPgtoFer>' +
												'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(@curCategoriaESocial,0)))),3) + '</codCateg>' +
												'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
						END
						ELSE
						BEGIN
							SET @LinhaAux = @LinhaAux +
											'<tpPgto>' + '7' + '</tpPgto>' +
											'<indResBr>' + RTRIM(LTRIM(@curResidenteBrasil)) + '</indResBr>' + 
											'<detPgtoFer>' +
												'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(@curCategoriaESocial,0)))),3) + '</codCateg>' 
												--'<matricula>' + COALESCE(RTRIM(LTRIM(@curMatriculaESocial)),'') + '</matricula>' 
						END
						-- insere a linha apurada
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 5
						SELECT @LinhaAux = ''
						-- valor liquido
						INSERT @xml SELECT RTRIM(LTRIM(@ValorLiquido)), @OrdemAux, @OrdemAux + 6
						-- valor rubricas 
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 7
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 8
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 9
						-- fecha ferias
						SET @LinhaAux = @LinhaAux + '</detPgtoFer>'
						-- insere a linha apurada
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 10
						SELECT @LinhaAux = ''
					END
				END
				ELSE -- não é pagamento férias
				BEGIN
					--Seria mais um grupo dentro da tag InfoPgto, porém, não temos Identificador atribuído pelo Órgão Público ou Instituto de Previdência (S-1207)		
					--'<detPgtoBenPr>' + 
					--	@ValorLiquido + 
					--	'<retPgtoTot>' +
					--		@ValorRubricas +
					--	'</retPgtoTot>' +
					--	'<infoPgtoParc>' +
					--		'<matricula>' + '</matricula>' +
					--		@ValorRubricas +
					--	'</infoPgtoParc>' +
					--'</detPgtoBenPr>' +

					-- demais pagamentos (adto, mensal(rescisão), 13o Sal, eventual)
					SELECT @ValorLiquido	= ''
					SELECT @ValorLiquido	= (SELECT dbo.fnESocialValorLiquido (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, @NroReciboDemitido))
					SELECT @ValorRubricasV	= ''
					SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'V'))
					SELECT @ValorRubricasD	= ''
					SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'D'))
					SELECT @ValorRubricasB	= ''
					SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoPagamento, @curDataPagamento, 'B'))
					IF RTRIM(LTRIM(@ValorLiquido)) <> ''
					BEGIN					
						-- carrega linha 
						SET @LinhaAux = @LinhaAux + '<tpPgto>' + CASE WHEN @curCondicaoColaborador IN (3,5) THEN 
																	CASE WHEN @curTipoColaborador = 'F' THEN '2' ELSE '3' END
																 ELSE '1' END + '</tpPgto>' +
													'<indResBr>' + RTRIM(LTRIM(@curResidenteBrasil)) + '</indResBr>' +
													'<detPgtoFl>'
						-- insere a linha apurada
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 11
						SELECT @LinhaAux = ''
						-- valor liquido
						INSERT @xml SELECT RTRIM(LTRIM(@ValorLiquido)), @OrdemAux, @OrdemAux + 12
						-- valor rubricas 
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 13
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 14
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 15
						-- assumimos todos os pagtos como total, não há parcial
						--'<infoPgtoParc>' + 
						--	'<matricula>' + '</matricula>' +
						--	@ValorRubricas + 
						--'</infoPgtoParc>' +
						-- fecha pagamentos
						SET @LinhaAux = @LinhaAux + '</detPgtoFl>'
						-- insere a linha apurada
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
						SELECT @LinhaAux = ''
					END
				END 			
			END
			-- pagamento a beneficiário residente fiscal no exterior
			IF RTRIM(LTRIM(@curResidenteBrasil)) = 'N'
			BEGIN
				INSERT @xml
				SELECT DISTINCT
					'<idePgtoExt>' + 
						'<idePais>' + 
							'<codPais>' + LEFT(CONVERT(CHAR(4),COALESCE(d.CodigoPaisResidencia,'')),3) + '</codPais>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') > '' THEN 
								'<indNIF>' + '1' + '</indNIF>' +
								'<nifBenef>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nifBenef>' 
							ELSE
								'<indNIF>' + '2' + '</indNIF>' 
							END +
						'</idePais>' +
						'<endExt>' + 
							'<dscLograd>' + COALESCE(RTRIM(LTRIM(d.RuaColaborador)),'') + '</dscLograd>' +
							'<nrLograd>' + COALESCE(RTRIM(LTRIM(d.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(d.ComplementoEndColaborador)),'') = '' THEN
								''
							ELSE
								'<complem>' + COALESCE(RTRIM(LTRIM(d.ComplementoEndColaborador)),'') + '</complem>' 
							END +
							'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(d.BairroColaborador,60))),'') + '</bairro>' +
							'<nmCid>' + COALESCE(RTRIM(LTRIM(d.MunicipioColaborador)),'') + '</nmCid>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(d.CodigoPostal)),'') = '' THEN
								''
							ELSE
								'<codPostal>' + COALESCE(RTRIM(LTRIM(d.CodigoPostal)),'') + '</codPostal>' 
							END +
						'</endExt>' +
					'</idePgtoExt>',
				@OrdemAux,
				@OrdemAux + 17
				FROM tbLocalFP a
				
				INNER JOIN tbLocal b
				ON	b.CodigoEmpresa = a.CodigoEmpresa
				AND b.CodigoLocal   = a.CodigoLocal

				INNER JOIN tbColaborador c
				ON  c.CodigoEmpresa = a.CodigoEmpresa
				AND c.CodigoLocal   = a.CodigoLocal

				INNER JOIN tbColaboradorEndereco d
				ON  d.CodigoEmpresa		= c.CodigoEmpresa
				AND d.CodigoLocal		= c.CodigoLocal
				AND d.TipoColaborador	= c.TipoColaborador
				AND d.NumeroRegistro	= c.NumeroRegistro

				INNER JOIN tbColaboradorGeral e
				ON  e.CodigoEmpresa		= c.CodigoEmpresa
				AND e.CodigoLocal		= c.CodigoLocal
				AND e.TipoColaborador	= c.TipoColaborador
				AND e.NumeroRegistro	= c.NumeroRegistro

				WHERE a.CodigoEmpresa		= @CodigoEmpresa
				AND   a.CodigoLocal			= @CodigoLocal
				AND   c.CodigoEmpresa		= @CodigoEmpresa
				AND   c.CodigoLocal			= @CodigoLocal
				AND   c.TipoColaborador		= @TipoColaborador
				AND   c.NumeroRegistro		= @NumeroRegistro
			END
			-- posiciona proximo registro
			DELETE #tmpPagamentos1210
			WHERE CodigoEmpresa			= @curCodigoEmpresa 
			AND	  CodigoLocal			= @curCodigoLocal
			AND	  TipoColaborador		= @curTipoColaborador
			AND	  NumeroRegistro		= @curNumeroRegistro
			AND	  PeriodoPagamento		= @curPeriodoPagamento
			AND	  RotinaPagamento		= @curRotinaPagamento
			AND	  DataPagamento			= @curDataPagamento
			-- tag fechamento
			SET @LinhaAux = '</infoPgto>'
			IF RTRIM(LTRIM(@LinhaAux)) <> ''
				INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 18
			SELECT @LinhaAux = ''
			-- incrementa variavel
			SET @OrdemAux = @OrdemAux + 100
		END
		DROP TABLE #tmpPagamentos1210

		-- fecha Tags
		INSERT @xml
		SELECT DISTINCT 
				'</ideBenef>' +
			'</evtPgtos>' +
		'</eSocial>',
		@OrdemAux,
		@OrdemAux + 33
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		WHERE a.CodigoEmpresa = @CodigoEmpresa
		AND   a.CodigoLocal	  = @CodigoLocal
		---- FIM XML Pagamentos de Rendimentos do Trabalho
	END
END
GOTO ARQ_FIM

ARQ_S1295:
---- INICIO XML Evento Solicitação de Totalização para Pagamento em Contingência
BEGIN
--whArquivosFPESocialXML 1608, 'S-1295', 0, 'I', 'N', 'F', 22, null, 'N', 0, 'N', 2, '201507', 'N', 1, null, null
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTotConting/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtTotConting Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @IndApuracao = '1' THEN
				'<indApuracao>' + '1' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
			ELSE
				'<indApuracao>' + '2' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
			END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideRespInf>' +
				'<nmResp>' + COALESCE(LEFT(RTRIM(LTRIM(c.NomeContatoESocial)),70),'') + '</nmResp>' +
				'<cpfResp>' + COALESCE(LEFT(RTRIM(LTRIM(c.CPFContatoESocial)),11),'') + '</cpfResp>' +
				'<telefone>' + COALESCE(LEFT(RTRIM(LTRIM(c.FoneFixoContatoESocial)),13),'') + '</telefone>' +
				'<email>' + COALESCE(RTRIM(LTRIM(c.EmailContatoESocial)),'')  + '</email>' +
			'</ideRespInf>' +
		'</evtTotConting>' +
	'</eSocial>',
	0,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal
	
	INNER JOIN tbEmpresaFP c
	ON c.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	---- FIM XML Evento Solicitação de Totalização para Pagamento em Contingência
END
GOTO ARQ_FIM

ARQ_S1298:
---- INICIO XML Evento Reabertura dos Eventos Periódicos
BEGIN
--whArquivosFPESocialXML 1608, 'S-1298', 0, 'I', 'N', 'F', 22, null, 'N', 0, 'N', 2, '201507', 'N', 1, null, null
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtReabreEvPer/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtReabreEvPer Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @IndApuracao = '1' THEN
				'<indApuracao>' + '1' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
			ELSE
				'<indApuracao>' + '2' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
			END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
		'</evtReabreEvPer>' +
	'</eSocial>',
	0,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal
	
	INNER JOIN tbEmpresaFP c
	ON c.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	---- FIM XML Evento Reabertura dos Eventos Periódicos
END
GOTO ARQ_FIM

ARQ_S1299:
---- INICIO XML Evento Fechamento dos Eventos Periódicos
BEGIN
	INSERT @xml 
--whArquivosFPESocialXML 1608, 'S-1299', 0, 'I', 'N', 'F', 22, null, 'N', null,0, 'N', 2, '201507', 'N', 1, null, null
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtFechaEvPer/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtFechaEvPer Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @IndApuracao = '1' THEN
				'<indApuracao>' + '1' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
			ELSE
				'<indApuracao>' + '2' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
			END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideRespInf>' +
				'<nmResp>' + COALESCE(LEFT(RTRIM(LTRIM(c.NomeContatoESocial)),70),'') + '</nmResp>' +
				'<cpfResp>' + COALESCE(LEFT(RTRIM(LTRIM(c.CPFContatoESocial)),11),'') + '</cpfResp>' +
				'<telefone>' + COALESCE(LEFT(RTRIM(LTRIM(c.FoneFixoContatoESocial)),13),'') + '</telefone>' +
				'<email>' + COALESCE(RTRIM(LTRIM(c.EmailContatoESocial)),'')  + '</email>' +
			'</ideRespInf>' +
			'<infoFech>' +
			CASE WHEN (
						(
							SELECT COUNT(*) 
							FROM tbLogFolhaMensalESocial a
							WHERE a.CodigoEmpresa		= @CodigoEmpresa
							AND   a.CodigoLocal			= @CodigoLocal
							AND   a.CodigoArquivo		IN ('S-1200','S-2299','S-2399')
							AND   a.TipoOperacaoArquivo = 'O'
							AND   a.PeriodoCompetencia	= @PerApuracao
							AND   a.GeradoXML			= 'V'
							AND   a.ExcluidoLog			= 'F'
							AND   (
									(@Ambiente = 1 AND a.Producao = 'V')
									OR
									(@Ambiente = 2 AND a.Producao = 'F')
								   )
						 ) > 0
 				       ) THEN
				'<evtRemun>' + 'S' + '</evtRemun>' -- evento S-1200, S-2299 ou S-2399
			ELSE
				'<evtRemun>' + 'N' + '</evtRemun>' 		
			END +
			CASE WHEN (
						(
							SELECT COUNT(*) 
							FROM tbLogFolhaMensalESocial a
							WHERE a.CodigoEmpresa		= @CodigoEmpresa
							AND   a.CodigoLocal			= @CodigoLocal
							AND   a.CodigoArquivo		= 'S-1210'
							AND   a.TipoOperacaoArquivo = 'O'
							AND   a.PeriodoCompetencia	= @PerApuracao
							AND   a.GeradoXML			= 'V'
							AND   a.ExcluidoLog			= 'F'
							AND   (
									(@Ambiente = 1 AND a.Producao = 'V')
									OR
									(@Ambiente = 2 AND a.Producao = 'F')
								   )
						 ) > 0
 				       ) THEN
				'<evtPgtos>' + 'S' + '</evtPgtos>' -- eventos S-1210	
			ELSE
				'<evtPgtos>' + 'N' + '</evtPgtos>' 	
			END +
				'<evtAqProd>' + 'N' + '</evtAqProd>' +				-- evento S-1250 - nao fizemos 
				'<evtComProd>' + 'N' + '</evtComProd>' +			-- evento S-1260 - nao fizemos 
				'<evtContratAvNP>' + 'N' + '</evtContratAvNP>' +	-- evento S-1270 - nao fizemos 
				'<evtInfoComplPer>' + 'N' + '</evtInfoComplPer>' +	-- evento S-1280 - nao fizemos 
			CASE WHEN (
						(
							SELECT COUNT(*) 
							FROM tbLogFolhaMensalESocial a
							WHERE a.CodigoEmpresa		= @CodigoEmpresa
							AND   a.CodigoLocal			= @CodigoLocal
							AND   a.CodigoArquivo		IN ('S-1200','S-1210','S-2299','S-2399')
							AND   a.TipoOperacaoArquivo = 'O'
							AND   a.PeriodoCompetencia	= @PerApuracao
							AND   a.GeradoXML			= 'V'
							AND   a.ExcluidoLog			= 'F'
							AND   (
									(@Ambiente = 1 AND a.Producao = 'V')
									OR
									(@Ambiente = 2 AND a.Producao = 'F')
								   )
						 ) = 0
 				       ) THEN
				'<compSemMovto>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</compSemMovto>' -- obrigatório se os campos acima forem todos 'N'
			ELSE
				'' 
			END +
			'</infoFech>' +
		'</evtFechaEvPer>' +
	'</eSocial>',
	0,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal
	
	INNER JOIN tbEmpresaFP c
	ON c.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	---- FIM XML Evento Fechamento dos Eventos Periódicos
END
GOTO ARQ_FIM

ARQ_S1300:
---- INICIO XML Evento Contribuição Sindical Patronal
BEGIN
	SELECT @ContrSindPatronal	= ''

	SELECT @ContrSindPatronal	= (SELECT dbo.fnESocialContrSindPatronal (@CodigoEmpresa, @CodigoLocal, @NomeArquivo, @PerApuracao))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtContrSindPatr/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtContrSindPatr Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			CASE WHEN @IndApuracao = '1' THEN
				'<indApuracao>' + '1' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
			ELSE
				'<indApuracao>' + '2' + '</indApuracao>' +
				'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
		CASE WHEN @ContrSindPatronal <> '' THEN
			@ContrSindPatronal 
		ELSE
			''
		END +
		'</evtContrSindPatr>' +
	'</eSocial>',
	0,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP c
	ON c.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa = @CodigoEmpresa
	AND   a.Matriz        = 'V'
	---- FIM XML Evento Contribuição Sindical Patronal
END
GOTO ARQ_FIM

ARQ_S2190:
---- INICIO XML Evento Admissão de Trabalhador - Registro Preliminar
BEGIN
		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAdmPrelim/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtAdmPrelim Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
					'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
					'<procEmi>' + '1' + '</procEmi>' +
					'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<infoRegPrelim>' +
					'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
					'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
					'</dtNascto>' + 
					'<dtAdm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao)),2,4),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao)),2,2),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao)),2,2),'') +
					'</dtAdm>' + 
				'</infoRegPrelim>' +			
			'</evtAdmPrelim>' +
		'</eSocial>',
		e.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
							
		INNER JOIN tbEmpresaFP d
		ON d.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbColaboradorGeral e
		ON  e.CodigoEmpresa		= c.CodigoEmpresa
		AND e.CodigoLocal		= c.CodigoLocal
		AND e.TipoColaborador	= c.TipoColaborador
		AND e.NumeroRegistro	= c.NumeroRegistro

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   c.CodigoEmpresa	= @CodigoEmpresa
		AND   c.CodigoLocal		= @CodigoLocal
		AND   c.TipoColaborador = @TipoColaborador
		AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Admissão de Trabalhador - Registro Preliminar
END
GOTO ARQ_FIM

ARQ_S2200: 
---- INICIO XML Evento Cadastramento Inicial do Vínculo e Admissão/Ingresso de Trabalhador
BEGIN
--whArquivosFPESocialXML 1608, 'S-2200', 0, 'O', 'S', 'F', 22, null, null, null, null, null, null, null
		SELECT @Dependentes		= ''
		SELECT @Tomadores		= ''
		SELECT @SalarioFixo     = ''
		SELECT @TomadoresDomic	= ''
		SELECT @Transferencias	= ''
		SELECT @TransferenciasCNPJ	= ''
		SELECT @ASOs			= ''

		SELECT @Dependentes		= (SELECT dbo.fnESocialDependentes (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, NULL))
		SELECT @Tomadores		= (SELECT dbo.fnESocialTomadorServico (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, NULL, NULL))
		SELECT @SalarioFixo		= (SELECT dbo.fnESocialSalarioAtual (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))
		SELECT @TomadoresDomic	= (SELECT dbo.fnESocialTomadorServicoEndereco (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))
		SELECT @Transferencias	= (SELECT dbo.fnESocialTransferencias (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))
		SELECT @TransferenciasCNPJ	= (SELECT dbo.fnESocialTransferencias (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, 'S2200C'))
		SELECT @ASOs			= (SELECT dbo.fnESocialASO (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))

		IF @CargaInicial = 'S'
		BEGIN
--whArquivosFPESocialXML @CodigoEmpresa = '1608',@NomeArquivo = 'S-2200',@CodigoLocal = '1',@TipoRegistro = 'O',@CargaInicial = 'S',@TipoColaborador = 'F',@NumeroRegistro = '1',@NroRecibo = 0
			-- dados vinculo
			INSERT @xml
			SELECT DISTINCT
				'<?xml version="1.0" encoding="utf-8"?>' +
				'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAdmissao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
					'<evtAdmissao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
						'<ideEvento>' + 
						CASE WHEN @TipoRegistro = 'O' THEN
							'<indRetif>' + '1' + '</indRetif>' 
						ELSE
							'<indRetif>' + '2' + '</indRetif>' +
							'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
						END +
							'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(t.TipoAmbiente)),'2')) + '</tpAmb>' +
							'<procEmi>' + '1' + '</procEmi>' +
							'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
						'</ideEvento>' +
						'<ideEmpregador>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
						'</ideEmpregador>' +
						'<trabalhador>' +
							'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
							'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
							'<nmTrab>' + COALESCE(RTRIM(LTRIM(d.NomePessoal)),'') + '</nmTrab>' +
							'<sexo>' + COALESCE(RTRIM(LTRIM(c.SexoColaborador)),'') + '</sexo>' +
							'<racaCor>' + COALESCE(RTRIM(LTRIM(e.RacaCorESocial)),'') + '</racaCor>' +
							'<estCiv>' + COALESCE(RTRIM(LTRIM(f.CodigoESocial)),'') + '</estCiv>' +
							'<grauInstr>' + COALESCE(RTRIM(LTRIM(RIGHT(CONVERT(CHAR(3), 100 + g.GrauInstrucaoESocial),2))),'') + '</grauInstr>' +
							'<indPriEmpr>' + CASE WHEN l.PrimeiroEmpregoESocial = 'V' THEN 'S' ELSE 'N' END + '</indPriEmpr>' +
							--Nome social para travesti ou transexual ( usei o nomeusual ja existente no Dealer )
							CASE WHEN COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') = '' THEN
								''
							ELSE
								'<nmSoc>' + COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') + '</nmSoc>' 
							END +
							'<nascimento>' +
								'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
								'</dtNascto>' + 
								CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioNascto),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(c.UFNascimentoColaborador)),'') + '</uf>' 
								ELSE
									''
								END +
								'<paisNascto>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNascto,3))),'') + '</paisNascto>' +
								'<paisNac>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNacionalidade,3))),'') + '</paisNac>' +
								'<nmMae>' + COALESCE(RTRIM(LTRIM(c.NomeMae)),'') + '</nmMae>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(c.NomePai)),'') = '' THEN
									''
								ELSE
									'<nmPai>' + COALESCE(RTRIM(LTRIM(c.NomePai)),'') + '</nmPai>' 
								END +
							'</nascimento>' +
							'<documentos>' +
							CASE WHEN c.NumeroCTPS IS NOT NULL THEN
								'<CTPS>' +
									'<nrCtps>' + RIGHT(CONVERT(VARCHAR(9), 100000000 + COALESCE(RTRIM(LTRIM(c.NumeroCTPS)),'00000000')),8) + '</nrCtps>' +
									'<serieCtps>' + RIGHT(COALESCE(RTRIM(LTRIM(c.SerieCTPS)),'00000'),5) + '</serieCtps>' +
									'<ufCtps>' + COALESCE(RTRIM(LTRIM(c.UFCTPS)),'') + '</ufCtps>' +
								'</CTPS>' 
							ELSE 
								'' 
							END +
			-- não temos no Dealer
			--					'<RIC>' +
			--						'<nrRic>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrRic>' +
			--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
			--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
			--					'</RIC>' +
							CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
								'<RG>' +
									'<nrRg>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRg>' +
									'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
									'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
									'</dtExped>' + 
								'</RG>' 
							ELSE
								'<RNE>' +
									'<nrRne>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRne>' +
									'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
									'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
									'</dtExped>' + 
								'</RNE>' 
							END +
		-- não temos no Dealer
		--					'<OC>' +
		--						'<nrOc>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrOc>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--						'<dtValid>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtValid>' +
		--					'</OC>' +
							CASE WHEN c.NumeroCarteiraHabilitacao IS NOT NULL THEN
								'<CNH>' +
									'<nrRegCnh>' + COALESCE(RTRIM(LTRIM(c.NumeroCarteiraHabilitacao)),'') + '</nrRegCnh>' +
									'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ExpedicaoHabilitacao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ExpedicaoHabilitacao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ExpedicaoHabilitacao)),2,2),'') +
									'</dtExped>' + 
									CASE WHEN c.UFEmissorCNH IS NULL OR c.UFEmissorCNH = '' THEN
										''
									ELSE
										'<ufCnh>' + COALESCE(RTRIM(LTRIM(c.UFEmissorCNH)),'') + '</ufCnh>'
									END +
									'<dtValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ValidadeHabilitacao)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ValidadeHabilitacao)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ValidadeHabilitacao)),2,2),'') +
									'</dtValid>' + 
		--nao tem no Dealer			'<dtPriHab>' + '' + '</dtPriHab>' +
									'<categoriaCnh>' + COALESCE(RTRIM(LTRIM(c.CategoriaHabilitacao)),'') + '</categoriaCnh>' +
								'</CNH>' 
							ELSE
								''
							END +
							'</documentos>' +
							'<endereco>' +
							CASE WHEN j.SiglaPais = 'BR' THEN
								'<brasil>' +
									'<tpLograd>' + COALESCE(RTRIM(LTRIM(i.TipoLogradouro)),'') + '</tpLograd>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
									CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
										''
									ELSE
										'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
									END +
									'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
									'<cep>' + COALESCE(RTRIM(LTRIM(i.CEPColaborador)),'') + '</cep>' +
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),i.CodigoMunicipio),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(i.UFColaborador)),'') + '</uf>' +
								'</brasil>' 
							ELSE
								'<exterior>' +
									'<paisResid>' + COALESCE(RTRIM(LTRIM(LEFT(i.CodigoPaisResidencia,3))),'') + '</paisResid>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
									CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
										''
									ELSE
										'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
									END +
									'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
									'<nmCid>' + COALESCE(RTRIM(LTRIM(i.MunicipioColaborador)),'') + '</nmCid>' +
									CASE WHEN COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') = '' THEN
										''
									ELSE
										'<codPostal>' + COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') + '</codPostal>' 
									END +
								'</exterior>' 
							END +
							'</endereco>' +
							CASE WHEN h.NacionalidadeBrasileira = 'F' THEN
							'<trabEstrangeiro>' +
								'<dtChegada>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataChegada)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataChegada)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataChegada)),2,2),'') +
								'</dtChegada>' + 
								'<classTrabEstrang>' + COALESCE(RTRIM(LTRIM(c.ClassTrabEstrangeiro)),'') + '</classTrabEstrang>' +
								'<casadoBr>' + CASE WHEN c.CasadoComBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</casadoBr>' +
								'<filhosBr>' + CASE WHEN c.FilhoBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</filhosBr>' +
							'</trabEstrangeiro>' 
							ELSE
								''
							END + 
							CASE WHEN c.DeficienteFisico = 'V' THEN
							'<infoDeficiencia>' +
								'<defFisica>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 1 THEN 'S' ELSE 'N' END + '</defFisica>' +
								'<defVisual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 3 THEN 'S' ELSE 'N' END + '</defVisual>' +
								'<defAuditiva>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 2 THEN 'S' ELSE 'N' END + '</defAuditiva>' +
								'<defMental>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 4 THEN 'S' ELSE 'N' END + '</defMental>' +
								'<defIntelectual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 5 THEN 'S' ELSE 'N' END + '</defIntelectual>' +
								'<reabReadap>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 6 THEN 'S' ELSE 'N' END + '</reabReadap>' +
								'<infoCota>' + CASE WHEN LEFT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 7 THEN 'S' ELSE 'N' END + '</infoCota>' +
								-- não criei este campo
								--'<observacao>' + '' + '</observacao>' +
							'</infoDeficiencia>' 
							ELSE
								''
							END +
							CASE WHEN @Dependentes <> '' THEN
								@Dependentes 
							ELSE
								''
							END +
							CASE WHEN k.CondicaoINSS = 'A' THEN
								'<aposentadoria>' +
									'<trabAposent>' + 'S' + '</trabAposent>' +
								'</aposentadoria>' 
							ELSE
								''
							END +
							'<contato>' +
								CASE WHEN i.TelefoneColaborador IS NULL OR i.TelefoneColaborador = '' THEN
									''
								ELSE
									'<fonePrinc>' + COALESCE(RTRIM(LTRIM(i.DDDColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneColaborador)),'') + '</fonePrinc>'
								END +
								CASE WHEN i.TelefoneCelularColaborador IS NULL OR i.TelefoneCelularColaborador = '' THEN
									''
								ELSE
									'<foneAlternat>' + COALESCE(RTRIM(LTRIM(i.DDDTelefoneCelularColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneCelularColaborador)),'') + '</foneAlternat>'
								END +
								CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
									''
								ELSE
									'<emailPrinc>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailPrinc>'
								END +
								CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
									''
								ELSE
									'<emailAlternat>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailAlternat>'
								END +
							'</contato>' +
						'</trabalhador>' +
						'<vinculo>' +
							'<matricula>' + COALESCE(RTRIM(LTRIM(d.MatriculaESocial)),'') + '</matricula>' +
--							'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
							--1 - CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas; 2 - Estatutário.
							'<tpRegTrab>' + COALESCE(RTRIM(LTRIM(l.TipoRegimeTrabalhistaESocial)),'1') + '</tpRegTrab>' +
							'<tpRegPrev>' + COALESCE(RTRIM(LTRIM(l.TipoRegimePrevidenciarioESocial)),'1') + '</tpRegPrev>' +
							-- NÃO FOI FEITO PARA CARGA INICIAL
							--'<nrRecInfPrelim>' + COALESCE(RTRIM(LTRIM(@NroReciboInfPre)),'') + '</nrRecInfPrelim>' 
							--CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(t.TipoAmbiente)),'2')) = 2 THEN
							--	CASE WHEN COALESCE(c.DataAdmissao,'2016-01-01') >= '2016-01-01' AND
							--				COALESCE(c.DataAdmissao,'2016-01-01') <= COALESCE(t.DataESocialIniciadoFase2,'2016-01-01') THEN
							--		'<cadIni>' + 'N' + '</cadIni>' 
							--	ELSE
							--		'<cadIni>' + 'S' + '</cadIni>' 
							--	END 
							--ELSE							
							--	'<cadIni>' + 'S' + '</cadIni>' 
							--END +
							'<cadIni>' + 'S' + '</cadIni>' + 
							'<infoRegimeTrab>' + 
								'<infoCeletista>' + --1 - CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas; 
									'<dtAdm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao)),2,2),'') +
									'</dtAdm>' + 
									'<tpAdmissao>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'1') + '</tpAdmissao>' +
									'<indAdmissao>' + COALESCE(RTRIM(LTRIM(l.IndicadorAdmissaoESocial)),'1') + '</indAdmissao>' +
									'<tpRegJor>' + '1' + '</tpRegJor>' + -- fixei 1 - Submetidos a Horário de Trabalho (Cap. II da CLT);
									CASE WHEN @TipoColaborador <> 'E' THEN
										'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>'
									ELSE
										''
									END +
									'<dtBase>' + COALESCE(RTRIM(LTRIM(a.MesBaseDissidio)),'') + '</dtBase>' +
									'<cnpjSindCategProf>' + COALESCE(RTRIM(LTRIM(s.CNPJSindicato)),'1') + '</cnpjSindCategProf>' +
									'<FGTS>' +
									CASE WHEN n.DataOpcaoFGTS IS NOT NULL THEN
										'<opcFGTS>' + '1' + '</opcFGTS>' +
										'<dtOpcFGTS>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataOpcaoFGTS)),2,4),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataOpcaoFGTS)),2,2),'') + '-' +
														COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataOpcaoFGTS)),2,2),'') +
										'</dtOpcFGTS>'  
									ELSE
										'<opcFGTS>' + '2' + '</opcFGTS>' 
									END +
									'</FGTS>' +
								CASE WHEN @Tomadores <> '' THEN
									'<trabTemporario>' + -- no caso do Dealer considero temporário os tomadores de serviços
										'<hipLeg>' + '2' + '</hipLeg>' +
										'<justContr>' + 'Acréscimo extraordinário de serviços' + '</justContr>' +
										'<tpInclContr>' + '3' + '</tpInclContr>' +
										'<ideTomadorServ>' + @Tomadores + '</ideTomadorServ>' + 
										--'<ideTrabSubstituido>' + -- nao fiz
										--	'<cpfTrabSubst>' + '' + '</cpfTrabSubst>' +
										--'</ideTrabSubstituido>' +
									'</trabTemporario>' 
								ELSE
									'' 
								END +
								CASE WHEN COALESCE(RTRIM(LTRIM(a.ContratacaoAprendiz)),'') > 0 THEN
									CASE WHEN COALESCE(RTRIM(LTRIM(l.MenorAprendiz)),'F') = 'F' THEN
										''
									ELSE
										'<aprend>' + 
											'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
											CASE WHEN @Transferencias <> '' THEN
												@TransferenciasCNPJ 
											ELSE
												'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' 
											END +
										'</aprend>' 
									END 
								ELSE
									''
								END +
								'</infoCeletista>' +
		--						'<infoEstatutario>' + --2 - Estatutário. ( não foi feito, nao temos clientes com contratação em regime estatutário-Governos )
		--							'<indProvim>' + '</indProvim>' +
		--							'<tpProv>' + '</tpProv>' +
		--							'<dtNomeacao>' + '</dtNomeacao>' +
		--							'<dtPosse>' + '</dtPosse>' +
		--							'<dtExercicio>' + '</dtExercicio>' +
		--							'<tpPlanRP>' + '</tpPlanRP>' +
		--							'<infoDecJud>' 
		--								'<nrProcJud>' + '</nrProcJud>' +
		--							'</infoDecJud>' +
		--						'</infoEstatutario>' +
							'</infoRegimeTrab>' +
							'<infoContrato>' +
								'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
								--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
								'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
								-- não fizemos o S-1035
								--'<codCarreira>' + COALESCE(RTRIM(LTRIM(m.CodigoCategoriaESocial)),'') + '</codCarreira>' +
								--'<dtIngrCarr>' + '' + '</dtIngrCarr>' +
							CASE WHEN @TipoColaborador <> 'E' THEN
								CASE WHEN @SalarioFixo <> '' THEN
									'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
								ELSE
									'' 
								END 
							ELSE
								''
							END +
								'<duracao>' +
									CASE WHEN @TipoColaborador <> 'T' THEN
										CASE WHEN l.CondicaoPrazoDeterminado = 'F' THEN
											'<tpContr>' + '1' + '</tpContr>' 
										ELSE
											'<tpContr>' + '2' + '</tpContr>' +
											CASE @TipoColaborador 
												WHEN 'F' THEN
													'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataFimContratoDeterminado)),2,4),'') + '-' +
																 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataFimContratoDeterminado)),2,2),'') + '-' +
																 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataFimContratoDeterminado)),2,2),'') +
													'</dtTerm>' +
													'<clauAssec>' + CASE WHEN COALESCE(RTRIM(LTRIM(l.ClausulaAssecuratoria)),'F') = 'F' THEN 'N' ELSE 'S' END + '</clauAssec>'
												WHEN 'E' THEN
													'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimContratoEstagio)),2,4),'') + '-' +
																 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimContratoEstagio)),2,2),'') + '-' +
																 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataFimContratoEstagio)),2,2),'') +
													'</dtTerm>'  +
													'<clauAssec>' + CASE WHEN COALESCE(RTRIM(LTRIM(l.ClausulaAssecuratoria)),'F') = 'F' THEN 'N' ELSE 'S' END + '</clauAssec>'
											END
										END 
									ELSE 
										'<tpContr>' + '1' + '</tpContr>' 
									END +
								'</duracao>' +
								'<localTrabalho>' +
									'<localTrabGeral>' +
										'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
										'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' + 
										--'<descComp>' + '' + '</descComp>' +  -- nao fizemos esta campo
									'</localTrabGeral>' +
								CASE WHEN @TomadoresDomic <> '' THEN
									'<localTrabDom>' + @TomadoresDomic + '</localTrabDom>'  
								ELSE
									'' 
								END +
								'</localTrabalho>' +
								'<horContratual>' +
									'<qtdHrsSem>' + COALESCE(RTRIM(LTRIM(r.HorasSemana)),'') + '</qtdHrsSem>' +
									CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaPadraoESocial)),'') = 'V' THEN
										'<tpJornada>' + '1' + '</tpJornada>'  
									ELSE  
										CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaEspecialESocial,''))) = 'V' THEN
											'<tpJornada>' + '2' + '</tpJornada>'  
										ELSE
											CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaTurnoFixoESocial)),'') = 'V' THEN 
												'<tpJornada>' + '3' + '</tpJornada>'  
											ELSE
												CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaTurnoFlexESocial,''))) = 'V' THEN
													'<tpJornada>' + '9' + '</tpJornada>' + 
													'<dscTpJorn>' + RTRIM(LTRIM(COALESCE(r.DescrTipoJornESocial,''))) + '</dscTpJorn>' 
												ELSE
													''
												END
											END
										END
									END	+
									'<tmpParc>' + RTRIM(LTRIM(COALESCE(r.CodigoTipoEscalaESocial,''))) + '</tmpParc>' + 
								CASE WHEN r.HoraEnt01ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Segunda-Feira
										'<dia>' + '1' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia01ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt02ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Terça-Feira
										'<dia>' + '2' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia02ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt03ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Quarta-Feira
										'<dia>' + '3' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia03ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt04ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Quinta-Feira
										'<dia>' + '4' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia04ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt05ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Sexta-Feira
										'<dia>' + '5' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia05ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt06ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Sabádo
										'<dia>' + '6' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia06ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt07ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Domingo
										'<dia>' + '7' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia07ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								CASE WHEN r.HoraEnt08ESocial IS NOT NULL THEN
									'<horario>' + 
										-- Dia Variável
										'<dia>' + '8' + '</dia>' +
										'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia08ESocial)) + '</codHorContrat>' +						
									'</horario>' 
								ELSE
									''
								END +
								'</horContratual>' +
							CASE WHEN k.SindicatoMensalidadeSindical IS NOT NULL THEN
								'<filiacaoSindical>' +
									'<cnpjSindTrab>' + COALESCE(RTRIM(LTRIM(s.CNPJSindicato)),'') + '</cnpjSindTrab>' +
								'</filiacaoSindical>' 
							ELSE
								''
							END +
							CASE WHEN c.AlvaraJuridico = 'V' THEN
								'<alvaraJudicial>' +
									'<nrProcJud>' + COALESCE(RTRIM(LTRIM(c.NumeroProcessoMenor16ESocial)),'') + '</nrProcJud>' +
								'</alvaraJudicial>' 
							ELSE
								''
							END +
							'</infoContrato>' +
						CASE WHEN @Transferencias <> '' THEN
							@Transferencias 
						ELSE
							''
						END +
						CASE WHEN @ASOs <> '' THEN
							'<afastamento>' + @ASOs + '</afastamento>' 
						ELSE
							'' 
						END +
						CASE WHEN c.DataDemissao IS NOT NULL AND c.DataDemissao > DATEADD(MM,-1,a.DataInicioPeriodo) THEN
							'<desligamento>' + 
								'<dtDeslig>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataDemissao)),2,4),'') + '-' +
											 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataDemissao)),2,2),'') + '-' +
											 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataDemissao)),2,2),'') +
								'</dtDeslig>' + 
							'</desligamento>' 
						ELSE
							'' 
						END +					
						'</vinculo>' +			
					'</evtAdmissao>' +
				'</eSocial>',
			d.MatriculaESocial,
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbEmpresaFP t
			ON t.CodigoEmpresa = a.CodigoEmpresa

			INNER JOIN tbColaborador c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
						
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa		= c.CodigoEmpresa
			AND d.CodigoLocal		= c.CodigoLocal
			AND d.TipoColaborador	= c.TipoColaborador
			AND d.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbRacaCor e
			ON  e.CodigoRacaCor	= c.CodigoRacaCor

			LEFT JOIN tbEstadoCivil f
			ON  f.CodigoEstadoCivil	= c.CodigoEstadoCivil
			
			LEFT JOIN tbGrauInstrucao g
			ON  g.CodigoGrauInstrucao = c.CodigoGrauInstrucao

			LEFT JOIN tbNacionalidade h
			ON  h.CodigoNacionalidade = c.CodigoNacionalidade

			INNER JOIN tbColaboradorEndereco i
			ON  i.CodigoEmpresa		= c.CodigoEmpresa
			AND i.CodigoLocal		= c.CodigoLocal
			AND i.TipoColaborador	= c.TipoColaborador
			AND i.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbPais j
			ON j.IdPais = i.CodigoPaisResidencia
			
			INNER JOIN tbPessoal k
			ON  k.CodigoEmpresa		= c.CodigoEmpresa
			AND k.CodigoLocal		= c.CodigoLocal
			AND k.TipoColaborador	= c.TipoColaborador
			AND k.NumeroRegistro	= c.NumeroRegistro
			AND k.CondicaoINSS		<> 'P'

			LEFT JOIN tbTipoMovimentacaoFolha l 
			ON  l.CodigoEmpresa				= k.CodigoEmpresa 
			AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
			AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

			LEFT JOIN tbCargo m
			ON  m.CodigoEmpresa	= c.CodigoEmpresa
			AND m.CodigoLocal   = c.CodigoLocal
			AND m.CodigoCargo   = c.CodigoCargo
			
			LEFT JOIN tbFuncionario n
			ON  n.CodigoEmpresa		= c.CodigoEmpresa
			AND n.CodigoLocal		= c.CodigoLocal
			AND n.TipoColaborador	= c.TipoColaborador
			AND n.NumeroRegistro	= c.NumeroRegistro
			
			INNER JOIN tbColaboradorCentroCusto o
			ON  o.CodigoEmpresa		= c.CodigoEmpresa
			AND o.CodigoLocal		= c.CodigoLocal
			AND o.TipoColaborador	= c.TipoColaborador
			AND o.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbCentroCusto p
			ON  p.CodigoEmpresa	= o.CodigoEmpresa
			AND p.CentroCusto 	= o.CentroCusto

			INNER JOIN tbPessoalHorario q
			ON  q.CodigoEmpresa		= c.CodigoEmpresa
			AND q.CodigoLocal		= c.CodigoLocal
			AND q.TipoColaborador	= c.TipoColaborador
			AND q.NumeroRegistro	= c.NumeroRegistro
			
			LEFT JOIN tbHorario r
			ON  r.CodigoEmpresa	= q.CodigoEmpresa
			AND r.CodigoLocal	= q.CodigoLocal
			AND r.CodigoHorario	= q.CodigoHorario

			LEFT JOIN tbSindicato s
			ON  s.CodigoEmpresa		= k.CodigoEmpresa
			AND s.CodigoSindicato	= k.SindicatoTaxaAssistencial
			
			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal
			AND   c.CodigoEmpresa	= @CodigoEmpresa
			AND   c.CodigoLocal		= @CodigoLocal
			AND   c.TipoColaborador = @TipoColaborador
			AND   c.NumeroRegistro  = @NumeroRegistro
			AND   c.TipoColaborador	= 'F'
		END
		ELSE -- não é @cargainicial
		BEGIN
			-- dados empresa
			INSERT @xml
			SELECT DISTINCT
			'<?xml version="1.0" encoding="utf-8"?>' +
			'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAdmissao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
				'<evtAdmissao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
					'<ideEvento>' + 
					CASE WHEN @TipoRegistro = 'O' THEN
						'<indRetif>' + '1' + '</indRetif>' 
					ELSE
						'<indRetif>' + '2' + '</indRetif>' +
						'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
					END +
						'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(t.TipoAmbiente)),'2')) + '</tpAmb>' +
						'<procEmi>' + '1' + '</procEmi>' +
						'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
					'</ideEvento>' +
					'<ideEmpregador>' +
						'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
						'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
					'</ideEmpregador>' +
					'<trabalhador>' +
						'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
						'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
						'<nmTrab>' + COALESCE(RTRIM(LTRIM(d.NomePessoal)),'') + '</nmTrab>' +
						'<sexo>' + COALESCE(RTRIM(LTRIM(c.SexoColaborador)),'') + '</sexo>' +
						'<racaCor>' + COALESCE(RTRIM(LTRIM(e.RacaCorESocial)),'') + '</racaCor>' +
						'<estCiv>' + COALESCE(RTRIM(LTRIM(f.CodigoESocial)),'') + '</estCiv>' +
						'<grauInstr>' + COALESCE(RTRIM(LTRIM(RIGHT(CONVERT(CHAR(3), 100 + g.GrauInstrucaoESocial),2))),'') + '</grauInstr>' +
						'<indPriEmpr>' + CASE WHEN l.PrimeiroEmpregoESocial = 'V' THEN 'S' ELSE 'N' END + '</indPriEmpr>' +
						--Nome social para travesti ou transexual ( usei o nomeusual ja existente no Dealer )
						CASE WHEN COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') = '' THEN
							''
						ELSE
							'<nmSoc>' + COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') + '</nmSoc>' 
						END +
						'<nascimento>' +
							'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
							'</dtNascto>' + 
							CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioNascto),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(c.UFNascimentoColaborador)),'') + '</uf>' 
							ELSE
								''
							END +
							'<paisNascto>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNascto,3))),'') + '</paisNascto>' +
							'<paisNac>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNacionalidade,3))),'') + '</paisNac>' +
							'<nmMae>' + COALESCE(RTRIM(LTRIM(c.NomeMae)),'') + '</nmMae>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(c.NomePai)),'') = '' THEN
								''
							ELSE
								'<nmPai>' + COALESCE(RTRIM(LTRIM(c.NomePai)),'') + '</nmPai>' 
							END +
						'</nascimento>' +
						'<documentos>' +
						CASE WHEN c.NumeroCTPS IS NOT NULL THEN
							'<CTPS>' +
								'<nrCtps>' + RIGHT(CONVERT(VARCHAR(9), 100000000 + COALESCE(RTRIM(LTRIM(c.NumeroCTPS)),'00000000')),8) + '</nrCtps>' +
								'<serieCtps>' + RIGHT(COALESCE(RTRIM(LTRIM(c.SerieCTPS)),'00000'),5) + '</serieCtps>' +
								'<ufCtps>' + COALESCE(RTRIM(LTRIM(c.UFCTPS)),'') + '</ufCtps>' +
							'</CTPS>' 
						ELSE 
							'' 
						END +
		-- não temos no Dealer
		--					'<RIC>' +
		--						'<nrRic>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrRic>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--					'</RIC>' +
						CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
							'<RG>' +
								'<nrRg>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRg>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RG>' 
						ELSE
							'<RNE>' +
								'<nrRne>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRne>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RNE>' 
						END +
	-- não temos no Dealer
	--					'<OC>' +
	--						'<nrOc>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrOc>' +
	--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
	--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
	--						'<dtValid>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtValid>' +
	--					'</OC>' +
						CASE WHEN c.NumeroCarteiraHabilitacao IS NOT NULL THEN
							'<CNH>' +
								'<nrRegCnh>' + COALESCE(RTRIM(LTRIM(c.NumeroCarteiraHabilitacao)),'') + '</nrRegCnh>' +
								'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ExpedicaoHabilitacao)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ExpedicaoHabilitacao)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ExpedicaoHabilitacao)),2,2),'') +
								'</dtExped>' + 
								CASE WHEN c.UFEmissorCNH IS NULL OR c.UFEmissorCNH = '' THEN
									''
								ELSE
									'<ufCnh>' + COALESCE(RTRIM(LTRIM(c.UFEmissorCNH)),'') + '</ufCnh>'
								END +
								'<dtValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ValidadeHabilitacao)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ValidadeHabilitacao)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ValidadeHabilitacao)),2,2),'') +
								'</dtValid>' + 
	--nao tem no Dealer			'<dtPriHab>' + '' + '</dtPriHab>' +
								'<categoriaCnh>' + COALESCE(RTRIM(LTRIM(c.CategoriaHabilitacao)),'') + '</categoriaCnh>' +
							'</CNH>' 
						ELSE
							''
						END +
						'</documentos>' +
						'<endereco>' +
						CASE WHEN j.SiglaPais = 'BR' THEN
							'<brasil>' +
								'<tpLograd>' + COALESCE(RTRIM(LTRIM(i.TipoLogradouro)),'') + '</tpLograd>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<cep>' + COALESCE(RTRIM(LTRIM(i.CEPColaborador)),'') + '</cep>' +
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),i.CodigoMunicipio),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(i.UFColaborador)),'') + '</uf>' +
							'</brasil>' 
						ELSE
							'<exterior>' +
								'<paisResid>' + COALESCE(RTRIM(LTRIM(LEFT(i.CodigoPaisResidencia,3))),'') + '</paisResid>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<nmCid>' + COALESCE(RTRIM(LTRIM(i.MunicipioColaborador)),'') + '</nmCid>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') = '' THEN
									''
								ELSE
									'<codPostal>' + COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') + '</codPostal>' 
								END +
							'</exterior>' 
						END +
						'</endereco>' +
						CASE WHEN h.NacionalidadeBrasileira = 'F' THEN
						'<trabEstrangeiro>' +
							'<dtChegada>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataChegada)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataChegada)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataChegada)),2,2),'') +
							'</dtChegada>' + 
							'<classTrabEstrang>' + COALESCE(RTRIM(LTRIM(c.ClassTrabEstrangeiro)),'') + '</classTrabEstrang>' +
							'<casadoBr>' + CASE WHEN c.CasadoComBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</casadoBr>' +
							'<filhosBr>' + CASE WHEN c.FilhoBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</filhosBr>' +
						'</trabEstrangeiro>' 
						ELSE
							''
						END + 
						CASE WHEN c.DeficienteFisico = 'V' THEN
						'<infoDeficiencia>' +
							'<defFisica>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 1 THEN 'S' ELSE 'N' END + '</defFisica>' +
							'<defVisual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 3 THEN 'S' ELSE 'N' END + '</defVisual>' +
							'<defAuditiva>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 2 THEN 'S' ELSE 'N' END + '</defAuditiva>' +
							'<defMental>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 4 THEN 'S' ELSE 'N' END + '</defMental>' +
							'<defIntelectual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 5 THEN 'S' ELSE 'N' END + '</defIntelectual>' +
							'<reabReadap>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 6 THEN 'S' ELSE 'N' END + '</reabReadap>' +
							'<infoCota>' + CASE WHEN LEFT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 7 THEN 'S' ELSE 'N' END + '</infoCota>' +
							-- não criei este campo
							--'<observacao>' + '' + '</observacao>' +
						'</infoDeficiencia>' 
						ELSE
							''
						END +
						CASE WHEN @Dependentes <> '' THEN
							@Dependentes 
						ELSE
							''
						END +
						CASE WHEN k.CondicaoINSS = 'A' THEN
							'<aposentadoria>' +
								'<trabAposent>' + 'S' + '</trabAposent>' +
							'</aposentadoria>' 
						ELSE
							''
						END +
						'<contato>' +
							CASE WHEN i.TelefoneColaborador IS NULL OR i.TelefoneColaborador = '' THEN
								''
							ELSE
								'<fonePrinc>' + COALESCE(RTRIM(LTRIM(i.DDDColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneColaborador)),'') + '</fonePrinc>'
							END +
							CASE WHEN i.TelefoneCelularColaborador IS NULL OR i.TelefoneCelularColaborador = '' THEN
								''
							ELSE
								'<foneAlternat>' + COALESCE(RTRIM(LTRIM(i.DDDTelefoneCelularColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneCelularColaborador)),'') + '</foneAlternat>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailPrinc>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailPrinc>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailAlternat>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailAlternat>'
							END +
						'</contato>' +
					'</trabalhador>' +
					'<vinculo>' +
						'<matricula>' + COALESCE(RTRIM(LTRIM(d.MatriculaESocial)),'') + '</matricula>' +
--						'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
						--1 - CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas; 2 - Estatutário.
						'<tpRegTrab>' + COALESCE(RTRIM(LTRIM(l.TipoRegimeTrabalhistaESocial)),'1') + '</tpRegTrab>' +
						'<tpRegPrev>' + COALESCE(RTRIM(LTRIM(l.TipoRegimePrevidenciarioESocial)),'1') + '</tpRegPrev>' +
					CASE WHEN @NroReciboInfPre IS NOT NULL AND @NroReciboInfPre <> '' THEN
						'<nrRecInfPrelim>' + COALESCE(RTRIM(LTRIM(@NroReciboInfPre)),'') + '</nrRecInfPrelim>' 
					ELSE
						''
					END +
						--CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(t.TipoAmbiente)),'2')) = 2 THEN
						--	CASE WHEN COALESCE(c.DataAdmissao,'2016-01-01') >= '2016-01-01' AND
						--				COALESCE(c.DataAdmissao,'2016-01-01') <= COALESCE(t.DataESocialIniciadoFase2,'2016-01-01') THEN
						--		'<cadIni>' + 'N' + '</cadIni>' 
						--	ELSE
						--		'<cadIni>' + 'S' + '</cadIni>' 
						--	END 
						--ELSE							
						--	'<cadIni>' + 'N' + '</cadIni>' 
						--END +
						'<cadIni>' + 'N' + '</cadIni>' +
						'<infoRegimeTrab>' + 
							'<infoCeletista>' + --1 - CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas; 
								'<dtAdm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao)),2,2),'') +
								'</dtAdm>' + 
								'<tpAdmissao>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'1') + '</tpAdmissao>' +
								'<indAdmissao>' + COALESCE(RTRIM(LTRIM(l.IndicadorAdmissaoESocial)),'1') + '</indAdmissao>' +
								'<tpRegJor>' + '1' + '</tpRegJor>' + -- fixei 1 - Submetidos a Horário de Trabalho (Cap. II da CLT);0
								CASE WHEN @TipoColaborador <> 'E' THEN
									'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>'
								ELSE
									''
								END +
								'<dtBase>' + COALESCE(RTRIM(LTRIM(a.MesBaseDissidio)),'') + '</dtBase>' +
								'<cnpjSindCategProf>' + COALESCE(RTRIM(LTRIM(s.CNPJSindicato)),'1') + '</cnpjSindCategProf>' +
								'<FGTS>' +
								CASE WHEN n.DataOpcaoFGTS IS NOT NULL THEN
									'<opcFGTS>' + '1' + '</opcFGTS>' +
									'<dtOpcFGTS>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataOpcaoFGTS)),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataOpcaoFGTS)),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataOpcaoFGTS)),2,2),'') +
									'</dtOpcFGTS>'  
								ELSE
									'<opcFGTS>' + '2' + '</opcFGTS>' 
								END +
								'</FGTS>' +
							CASE WHEN @Tomadores <> '' THEN
								'<trabTemporario>' + -- no caso do Dealer considero temporário os tomadores de serviços
									'<hipLeg>' + '2' + '</hipLeg>' +
									'<justContr>' + 'Acréscimo extraordinário de serviços' + '</justContr>' +
									'<tpInclContr>' + '3' + '</tpInclContr>' +
									'<ideTomadorServ>' + @Tomadores + '</ideTomadorServ>' + 
									--'<ideTrabSubstituido>' + -- nao fiz
									--	'<cpfTrabSubst>' + '' + '</cpfTrabSubst>' +
									--'</ideTrabSubstituido>' +
								'</trabTemporario>' 
							ELSE
								'' 
							END +
								CASE WHEN COALESCE(RTRIM(LTRIM(a.ContratacaoAprendiz)),'') > 0 THEN
									CASE WHEN COALESCE(RTRIM(LTRIM(l.MenorAprendiz)),'F') = 'F' THEN
										''
									ELSE
										'<aprend>' + 
											'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
											CASE WHEN @Transferencias <> '' THEN
												@TransferenciasCNPJ 
											ELSE
												'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' 
											END +
										'</aprend>' 
									END 
								ELSE
									''
								END +
							'</infoCeletista>' +
	--						'<infoEstatutario>' + --2 - Estatutário. ( não foi feito, nao temos clientes com contratação em regime estatutário-Governos )
	--							'<indProvim>' + '</indProvim>' +
	--							'<tpProv>' + '</tpProv>' +
	--							'<dtNomeacao>' + '</dtNomeacao>' +
	--							'<dtPosse>' + '</dtPosse>' +
	--							'<dtExercicio>' + '</dtExercicio>' +
	--							'<tpPlanRP>' + '</tpPlanRP>' +
	--							'<infoDecJud>' 
	--								'<nrProcJud>' + '</nrProcJud>' +
	--							'</infoDecJud>' +
	--						'</infoEstatutario>' +
						'</infoRegimeTrab>' +
						'<infoContrato>' +
							'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
							--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
							'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
							-- não fizemos o S-1035
							--'<codCarreira>' + COALESCE(RTRIM(LTRIM(m.CodigoCategoriaESocial)),'') + '</codCarreira>' +
							--'<dtIngrCarr>' + '' + '</dtIngrCarr>' +
						CASE WHEN @TipoColaborador <> 'E' THEN
							CASE WHEN @SalarioFixo <> '' THEN
								'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
							ELSE
								'' 
							END 
						ELSE
							''
						END +
							'<duracao>' +
								CASE WHEN @TipoColaborador <> 'T' THEN
									CASE WHEN l.CondicaoPrazoDeterminado = 'F' THEN
										'<tpContr>' + '1' + '</tpContr>' 
									ELSE
										'<tpContr>' + '2' + '</tpContr>' +
										CASE @TipoColaborador 
											WHEN 'F' THEN
												'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataFimContratoDeterminado)),2,4),'') + '-' +
															 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataFimContratoDeterminado)),2,2),'') + '-' +
															 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataFimContratoDeterminado)),2,2),'') +
												'</dtTerm>' +
												'<clauAssec>' + CASE WHEN COALESCE(RTRIM(LTRIM(l.ClausulaAssecuratoria)),'F') = 'F' THEN 'N' ELSE 'S' END + '</clauAssec>'
											WHEN 'E' THEN
												'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimContratoEstagio)),2,4),'') + '-' +
															 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimContratoEstagio)),2,2),'') + '-' +
															 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataFimContratoEstagio)),2,2),'') +
												'</dtTerm>'  +
												'<clauAssec>' + CASE WHEN COALESCE(RTRIM(LTRIM(l.ClausulaAssecuratoria)),'F') = 'F' THEN 'N' ELSE 'S' END + '</clauAssec>'
										END
									END 
								ELSE 
									'<tpContr>' + '1' + '</tpContr>' 
								END +
							'</duracao>' +
							'<localTrabalho>' +
								'<localTrabGeral>' +
									'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
									'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' + 
									--'<descComp>' + '' + '</descComp>' +  -- nao fizemos esta campo
								'</localTrabGeral>' +
							CASE WHEN @TomadoresDomic <> '' THEN
								'<localTrabDom>' + @TomadoresDomic + '</localTrabDom>'  
							ELSE
								'' 
							END +
							'</localTrabalho>' +
							'<horContratual>' +
								'<qtdHrsSem>' + COALESCE(RTRIM(LTRIM(r.HorasSemana)),'') + '</qtdHrsSem>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaPadraoESocial)),'') = 'V' THEN
								'<tpJornada>' + '1' + '</tpJornada>'  
							ELSE  
								CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaEspecialESocial,''))) = 'V' THEN
									'<tpJornada>' + '2' + '</tpJornada>'  
								ELSE
									CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaTurnoFixoESocial)),'') = 'V' THEN 
										'<tpJornada>' + '3' + '</tpJornada>'  
									ELSE
										CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaTurnoFlexESocial,''))) = 'V' THEN
											'<tpJornada>' + '9' + '</tpJornada>' + 
											'<dscTpJorn>' + RTRIM(LTRIM(COALESCE(r.DescrTipoJornESocial,''))) + '</dscTpJorn>' 
										ELSE
											''
										END
									END
								END
							END	+
								'<tmpParc>' + RTRIM(LTRIM(COALESCE(r.CodigoTipoEscalaESocial,''))) + '</tmpParc>' + 
							CASE WHEN r.HoraEnt01ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Segunda-Feira
									'<dia>' + '1' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia01ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt02ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Terça-Feira
									'<dia>' + '2' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia02ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt03ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Quarta-Feira
									'<dia>' + '3' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia03ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt04ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Quinta-Feira
									'<dia>' + '4' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia04ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt05ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Sexta-Feira
									'<dia>' + '5' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia05ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt06ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Sabádo
									'<dia>' + '6' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia06ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt07ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Domingo
									'<dia>' + '7' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia07ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							CASE WHEN r.HoraEnt08ESocial IS NOT NULL THEN
								'<horario>' + 
									-- Dia Variável
									'<dia>' + '8' + '</dia>' +
									'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia08ESocial)) + '</codHorContrat>' +						
								'</horario>' 
							ELSE
								''
							END +
							'</horContratual>' +
						CASE WHEN k.SindicatoMensalidadeSindical IS NOT NULL THEN
							'<filiacaoSindical>' +
								'<cnpjSindTrab>' + COALESCE(RTRIM(LTRIM(s.CNPJSindicato)),'') + '</cnpjSindTrab>' +
							'</filiacaoSindical>' 
						ELSE
							''
						END +
						CASE WHEN c.AlvaraJuridico = 'V' THEN
							'<alvaraJudicial>' +
								'<nrProcJud>' + COALESCE(RTRIM(LTRIM(c.NumeroProcessoMenor16ESocial)),'') + '</nrProcJud>' +
							'</alvaraJudicial>' 
						ELSE
							''
						END +
						'</infoContrato>' +
					CASE WHEN @Transferencias <> '' THEN
						@Transferencias
					ELSE
						''
					END +
					CASE WHEN @ASOs <> '' THEN
						'<afastamento>' + @ASOs + '</afastamento>' 
					ELSE
						'' 
					END +
					'</vinculo>' +
				'</evtAdmissao>' +
			'</eSocial>',
			d.MatriculaESocial,
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal
						
			INNER JOIN tbColaborador c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
						
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa		= c.CodigoEmpresa
			AND d.CodigoLocal		= c.CodigoLocal
			AND d.TipoColaborador	= c.TipoColaborador
			AND d.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbRacaCor e
			ON  e.CodigoRacaCor	= c.CodigoRacaCor

			LEFT JOIN tbEstadoCivil f
			ON  f.CodigoEstadoCivil	= c.CodigoEstadoCivil
			
			LEFT JOIN tbGrauInstrucao g
			ON  g.CodigoGrauInstrucao = c.CodigoGrauInstrucao

			LEFT JOIN tbNacionalidade h
			ON  h.CodigoNacionalidade = c.CodigoNacionalidade

			INNER JOIN tbColaboradorEndereco i
			ON  i.CodigoEmpresa		= c.CodigoEmpresa
			AND i.CodigoLocal		= c.CodigoLocal
			AND i.TipoColaborador	= c.TipoColaborador
			AND i.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbPais j
			ON j.IdPais = i.CodigoPaisResidencia
			
			INNER JOIN tbPessoal k
			ON  k.CodigoEmpresa		= c.CodigoEmpresa
			AND k.CodigoLocal		= c.CodigoLocal
			AND k.TipoColaborador	= c.TipoColaborador
			AND k.NumeroRegistro	= c.NumeroRegistro
			AND k.CondicaoINSS		<> 'P'

			LEFT JOIN tbTipoMovimentacaoFolha l 
			ON  l.CodigoEmpresa				= k.CodigoEmpresa 
			AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
			AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

			LEFT JOIN tbCargo m
			ON  m.CodigoEmpresa	= c.CodigoEmpresa
			AND m.CodigoLocal   = c.CodigoLocal
			AND m.CodigoCargo   = c.CodigoCargo
			
			LEFT JOIN tbFuncionario n
			ON  n.CodigoEmpresa		= c.CodigoEmpresa
			AND n.CodigoLocal		= c.CodigoLocal
			AND n.TipoColaborador	= c.TipoColaborador
			AND n.NumeroRegistro	= c.NumeroRegistro
			
			INNER JOIN tbColaboradorCentroCusto o
			ON  o.CodigoEmpresa		= c.CodigoEmpresa
			AND o.CodigoLocal		= c.CodigoLocal
			AND o.TipoColaborador	= c.TipoColaborador
			AND o.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbCentroCusto p
			ON  p.CodigoEmpresa	= o.CodigoEmpresa
			AND p.CentroCusto 	= o.CentroCusto

			INNER JOIN tbPessoalHorario q
			ON  q.CodigoEmpresa		= c.CodigoEmpresa
			AND q.CodigoLocal		= c.CodigoLocal
			AND q.TipoColaborador	= c.TipoColaborador
			AND q.NumeroRegistro	= c.NumeroRegistro
			
			LEFT JOIN tbHorario r
			ON  r.CodigoEmpresa	= q.CodigoEmpresa
			AND r.CodigoLocal	= q.CodigoLocal
			AND r.CodigoHorario	= q.CodigoHorario

			LEFT JOIN tbSindicato s
			ON  s.CodigoEmpresa		= k.CodigoEmpresa
			AND s.CodigoSindicato	= k.SindicatoTaxaAssistencial
			
			INNER JOIN tbEmpresaFP t
			ON c.CodigoEmpresa = a.CodigoEmpresa

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal
			AND   c.CodigoEmpresa	= @CodigoEmpresa
			AND   c.CodigoLocal		= @CodigoLocal
			AND   c.TipoColaborador = @TipoColaborador
			AND   c.NumeroRegistro  = @NumeroRegistro
			AND   c.TipoColaborador = 'F'
		END
	---- FIM XML Evento Cadastramento Inicial do Vínculo e Admissão/Ingresso de Trabalhador
END
GOTO ARQ_FIM

ARQ_S2205: 
---- INICIO XML Evento Alteração de Dados Cadastrais do Trabalhador
BEGIN
	SELECT @Dependentes	= ''

	SELECT @Dependentes		= (SELECT dbo.fnESocialDependentes (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @PerApuracao))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAltCadastral/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtAltCadastral Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(l.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideTrabalhador>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
			'</ideTrabalhador>' +
			'<alteracao>' +
				'<dtAlteracao>' + SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
									SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) + '-' +
									SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),1,2) +	 
				'</dtAlteracao>' +
				'<dadosTrabalhador>' +
					'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
					'<nmTrab>' + COALESCE(RTRIM(LTRIM(d.NomePessoal)),'') + '</nmTrab>' +
					'<sexo>' + COALESCE(RTRIM(LTRIM(c.SexoColaborador)),'') + '</sexo>' +
					'<racaCor>' + COALESCE(RTRIM(LTRIM(e.RacaCorESocial)),'') + '</racaCor>' +
					'<estCiv>' + COALESCE(RTRIM(LTRIM(f.CodigoESocial)),'') + '</estCiv>' +
					'<grauInstr>' + COALESCE(RTRIM(LTRIM(RIGHT(CONVERT(CHAR(3), 100 + g.GrauInstrucaoESocial),2))),'') + '</grauInstr>' +
					--Nome social para travesti ou transexual ( usei o nomeusual ja existente no Dealer )
					CASE WHEN COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') = '' THEN
						''
					ELSE
						'<nmSoc>' + COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') + '</nmSoc>' 
					END +
					'<nascimento>' +
						'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
						'</dtNascto>' + 
						CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
							'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioNascto),0)))),7) + '</codMunic>' +
							'<uf>' + COALESCE(RTRIM(LTRIM(c.UFNascimentoColaborador)),'') + '</uf>' 
						ELSE
							''
						END +
						'<paisNascto>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNascto,3))),'') + '</paisNascto>' +
						'<paisNac>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNacionalidade,3))),'') + '</paisNac>' +
						'<nmMae>' + COALESCE(RTRIM(LTRIM(c.NomeMae)),'') + '</nmMae>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(c.NomePai)),'') = '' THEN
							''
						ELSE
							'<nmPai>' + COALESCE(RTRIM(LTRIM(c.NomePai)),'') + '</nmPai>' 
						END +
					'</nascimento>' +
					'<documentos>' +
					CASE WHEN c.NumeroCTPS IS NOT NULL THEN
						'<CTPS>' +
							'<nrCtps>' + RIGHT(CONVERT(VARCHAR(9), 100000000 + COALESCE(RTRIM(LTRIM(c.NumeroCTPS)),'00000000')),8) + '</nrCtps>' +
							'<serieCtps>' + RIGHT(COALESCE(RTRIM(LTRIM(c.SerieCTPS)),'00000'),5) + '</serieCtps>' +
							'<ufCtps>' + COALESCE(RTRIM(LTRIM(c.UFCTPS)),'') + '</ufCtps>' +
						'</CTPS>' 
					ELSE 
						'' 
					END +
	-- não temos no Dealer
	--					'<RIC>' +
	--						'<nrRic>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrRic>' +
	--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
	--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
	--					'</RIC>' +
					CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
						'<RG>' +
							'<nrRg>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRg>' +
							'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
							'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
							'</dtExped>' + 
						'</RG>' 
					ELSE
						'<RNE>' +
							'<nrRne>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRne>' +
							'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
							'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
							'</dtExped>' + 
						'</RNE>' 
					END +
	-- não temos no Dealer
	--					'<OC>' +
	--						'<nrOc>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrOc>' +
	--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
	--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
	--						'<dtValid>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtValid>' +
	--					'</OC>' +
					CASE WHEN c.NumeroCarteiraHabilitacao IS NOT NULL THEN
						'<CNH>' +
							'<nrRegCnh>' + COALESCE(RTRIM(LTRIM(c.NumeroCarteiraHabilitacao)),'') + '</nrRegCnh>' +
							'<dtExped>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ExpedicaoHabilitacao)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ExpedicaoHabilitacao)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ExpedicaoHabilitacao)),2,2),'') +
							'</dtExped>' + 
							CASE WHEN c.UFEmissorCNH IS NULL OR c.UFEmissorCNH = '' THEN
								''
							ELSE
								'<ufCnh>' + COALESCE(RTRIM(LTRIM(c.UFEmissorCNH)),'') + '</ufCnh>'
							END +
							'<dtValid>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ValidadeHabilitacao)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ValidadeHabilitacao)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ValidadeHabilitacao)),2,2),'') +
							'</dtValid>' + 
--nao tem no Dealer			'<dtPriHab>' + '' + '</dtPriHab>' +
							'<categoriaCnh>' + COALESCE(RTRIM(LTRIM(c.CategoriaHabilitacao)),'') + '</categoriaCnh>' +
						'</CNH>' 
					ELSE
						''
					END +
					'</documentos>' +
					'<endereco>' +
					CASE WHEN j.SiglaPais = 'BR' THEN
						'<brasil>' +
							'<tpLograd>' + COALESCE(RTRIM(LTRIM(i.TipoLogradouro)),'') + '</tpLograd>' +
							'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
							'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
							CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
								''
							ELSE
								'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
							END +
							'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
							'<cep>' + COALESCE(RTRIM(LTRIM(i.CEPColaborador)),'') + '</cep>' +
							'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),i.CodigoMunicipio),0)))),7) + '</codMunic>' +
							'<uf>' + COALESCE(RTRIM(LTRIM(i.UFColaborador)),'') + '</uf>' +
						'</brasil>' 
					ELSE
						'<exterior>' +
							'<paisResid>' + COALESCE(RTRIM(LTRIM(LEFT(i.CodigoPaisResidencia,3))),'') + '</paisResid>' +
							'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
							'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
							CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
								''
							ELSE
								'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
							END +
							'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
							'<nmCid>' + COALESCE(RTRIM(LTRIM(i.MunicipioColaborador)),'') + '</nmCid>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') = '' THEN
								''
							ELSE
								'<codPostal>' + COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') + '</codPostal>' 
							END +
						'</exterior>' 
					END +
					'</endereco>' +
					CASE WHEN h.NacionalidadeBrasileira = 'F' THEN
					'<trabEstrangeiro>' +
						'<dtChegada>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataChegada)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataChegada)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataChegada)),2,2),'') +
						'</dtChegada>' + 
						'<classTrabEstrang>' + COALESCE(RTRIM(LTRIM(c.ClassTrabEstrangeiro)),'') + '</classTrabEstrang>' +
						'<casadoBr>' + CASE WHEN c.CasadoComBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</casadoBr>' +
						'<filhosBr>' + CASE WHEN c.FilhoBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</filhosBr>' +
					'</trabEstrangeiro>' 
					ELSE
						''
					END + 
					CASE WHEN c.DeficienteFisico = 'V' THEN
					'<infoDeficiencia>' +
						'<defFisica>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 1 THEN 'S' ELSE 'N' END + '</defFisica>' +
						'<defVisual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 3 THEN 'S' ELSE 'N' END + '</defVisual>' +
						'<defAuditiva>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 2 THEN 'S' ELSE 'N' END + '</defAuditiva>' +
						'<defMental>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 4 THEN 'S' ELSE 'N' END + '</defMental>' +
						'<defIntelectual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 5 THEN 'S' ELSE 'N' END + '</defIntelectual>' +
						'<reabReadap>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 6 THEN 'S' ELSE 'N' END + '</reabReadap>' +
						'<infoCota>' + CASE WHEN LEFT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 7 THEN 'S' ELSE 'N' END + '</infoCota>' +
						-- não criei este campo
						--'<observacao>' + '' + '</observacao>' +
					'</infoDeficiencia>' 
					ELSE
						''
					END +
					CASE WHEN @Dependentes <> '' THEN
						@Dependentes 
					ELSE
						''
					END +
					CASE WHEN k.CondicaoINSS = 'A' THEN
						'<aposentadoria>' +
							'<trabAposent>' + 'S' + '</trabAposent>' +
						'</aposentadoria>' 
					ELSE
						''
					END +
					'<contato>' +
						CASE WHEN i.TelefoneColaborador IS NULL OR i.TelefoneColaborador = '' THEN
							''
						ELSE
							'<fonePrinc>' + COALESCE(RTRIM(LTRIM(i.DDDColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneColaborador)),'') + '</fonePrinc>'
						END +
						CASE WHEN i.TelefoneCelularColaborador IS NULL OR i.TelefoneCelularColaborador = '' THEN
							''
						ELSE
							'<foneAlternat>' + COALESCE(RTRIM(LTRIM(i.DDDTelefoneCelularColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneCelularColaborador)),'') + '</foneAlternat>'
						END +
						CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
							''
						ELSE
							'<emailPrinc>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailPrinc>'
						END +
						CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
							''
						ELSE
							'<emailAlternat>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailAlternat>'
						END +
					'</contato>' +
				'</dadosTrabalhador>' +
			'</alteracao>' +		
		'</evtAltCadastral>' +
	'</eSocial>',
	d.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbColaboradorGeral d
	ON  d.CodigoEmpresa		= c.CodigoEmpresa
	AND d.CodigoLocal		= c.CodigoLocal
	AND d.TipoColaborador	= c.TipoColaborador
	AND d.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbRacaCor e
	ON  e.CodigoRacaCor	= c.CodigoRacaCor

	LEFT JOIN tbEstadoCivil f
	ON  f.CodigoEstadoCivil	= c.CodigoEstadoCivil
	
	LEFT JOIN tbGrauInstrucao g
	ON  g.CodigoGrauInstrucao = c.CodigoGrauInstrucao

	LEFT JOIN tbNacionalidade h
	ON  h.CodigoNacionalidade = c.CodigoNacionalidade

	INNER JOIN tbColaboradorEndereco i
	ON  i.CodigoEmpresa		= c.CodigoEmpresa
	AND i.CodigoLocal		= c.CodigoLocal
	AND i.TipoColaborador	= c.TipoColaborador
	AND i.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbPais j
	ON j.IdPais = i.CodigoPaisResidencia

	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	INNER JOIN tbEmpresaFP l
	ON l.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Alteração de Dados Cadastrais do Trabalhador
END
GOTO ARQ_FIM

ARQ_S2206: 
---- INICIO XML Evento Alteração de Contrato de Trabalho
BEGIN
	SELECT @Tomadores		= ''
	SELECT @SalarioFixo     = ''
	SELECT @TomadoresDomic		= ''
	SELECT @Transferencias		= ''
	SELECT @TransferenciasCNPJ	= ''

	SELECT @Tomadores		= (SELECT dbo.fnESocialTomadorServico (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, NULL, NULL))
	SELECT @SalarioFixo		= (SELECT dbo.fnESocialSalarioAtual (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))
	SELECT @TomadoresDomic	= (SELECT dbo.fnESocialTomadorServicoEndereco (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))
	SELECT @Transferencias	= (SELECT dbo.fnESocialTransferencias (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))
	SELECT @TransferenciasCNPJ	= (SELECT dbo.fnESocialTransferencias (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, 'S2200C'))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAltContratual/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtAltContratual Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(t.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(d.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			'<altContratual>' +
				'<dtAlteracao>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,a.DataInicioPeriodo)),2,4),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,a.DataInicioPeriodo)),2,2),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,a.DataInicioPeriodo)),2,2),'') +
				'</dtAlteracao>' + 
				--'<dtEf>' + '' + '</dtEf>' +
				--'<dscAlt>' + '' + '</dscAlt>' +
				'<vinculo>' +
--					'<tpRegimeTrab>' + COALESCE(RTRIM(LTRIM(l.TipoRegimeTrabalhistaESocial)),'3') + '</tpRegimeTrab>' +
					'<tpRegPrev>' + COALESCE(RTRIM(LTRIM(l.TipoRegimePrevidenciarioESocial)),'2') + '</tpRegPrev>' +
				'</vinculo>' +			
				'<infoRegimeTrab>' + 
					'<infoCeletista>' + --1 - CLT - Consolidação das Leis de Trabalho e legislações trabalhistas específicas; 
						'<tpRegJor>' + '1' + '</tpRegJor>' + -- fixei 1 - Submetidos a Horário de Trabalho (Cap. II da CLT);
						CASE WHEN @TipoColaborador <> 'E' THEN
							'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>'
						ELSE
							''
						END +
						'<dtBase>' + COALESCE(RTRIM(LTRIM(a.MesBaseDissidio)),'') + '</dtBase>' +
						'<cnpjSindCategProf>' + COALESCE(RTRIM(LTRIM(u.CNPJSindicato)),'1') + '</cnpjSindCategProf>' +
					CASE WHEN @Tomadores <> '' THEN
						'<trabTemp>' + -- no caso do Dealer considero temporário os tomadores de serviços
							'<justProrr>' + 'Acréscimo extraordinário de serviços' + '</justProrr>' +
						'</trabTemp>' 
					ELSE
						'' 
					END +
					CASE WHEN COALESCE(RTRIM(LTRIM(a.ContratacaoAprendiz)),'') > 0 THEN
						CASE WHEN COALESCE(RTRIM(LTRIM(l.MenorAprendiz)),'F') = 'F' THEN
							''
						ELSE
							'<aprend>' + 
								'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
								CASE WHEN @Transferencias <> '' THEN
									@TransferenciasCNPJ 
								ELSE
									'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' 
								END +
							'</aprend>' 
						END 
					ELSE
						''
					END +
					'</infoCeletista>' +
--						'<infoEstatutario>' + --2 - Estatutário. ( não foi feito, nao temos clientes com contratação em regime estatutário-Governos )
--							'<tpPlanRP>' + '</tpPlanRP>' +
--						'</infoEstatutario>' +
				'</infoRegimeTrab>' +
				'<infoContrato>' +
					'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
					--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
					'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
					-- não fizemos o S-1035
					--'<codCarreira>' + COALESCE(RTRIM(LTRIM(m.CodigoCategoriaESocial)),'') + '</codCarreira>' +
					--'<dtIngrCarr>' + '' + '</dtIngrCarr>' +
				CASE WHEN @TipoColaborador <> 'E' THEN
					CASE WHEN @SalarioFixo <> '' THEN
						'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
					ELSE
						'' 
					END 
				ELSE
					''
				END +
					'<duracao>' +
						CASE WHEN @TipoColaborador <> 'T' THEN
							CASE WHEN l.CondicaoPrazoDeterminado = 'F' THEN
								'<tpContr>' + '1' + '</tpContr>' 
							ELSE
								'<tpContr>' + '2' + '</tpContr>' +
								CASE @TipoColaborador 
									WHEN 'F' THEN
										'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataFimContratoDeterminado)),2,4),'') + '-' +
													 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataFimContratoDeterminado)),2,2),'') + '-' +
													 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataFimContratoDeterminado)),2,2),'') +
										'</dtTerm>'  
									WHEN 'E' THEN
										'<dtTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataFimContratoEstagio)),2,4),'') + '-' +
													 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataFimContratoEstagio)),2,2),'') + '-' +
													 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataFimContratoEstagio)),2,2),'') +
										'</dtTerm>'  
								END
							END 
						ELSE 
							'<tpContr>' + '1' + '</tpContr>' 
						END +
					'</duracao>' +
					'<localTrabalho>' +
						'<localTrabGeral>' +
							'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
							'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' + 
							--'<descComp>' + '' + '</descComp>' +  -- nao fizemos esta campo
						'</localTrabGeral>' +
					CASE WHEN @TomadoresDomic <> '' THEN
						'<localTrabDom>' + @TomadoresDomic + '</localTrabDom>'  
					ELSE
						'' 
					END +
					'</localTrabalho>' +
					'<horContratual>' +
						'<qtdHrsSem>' + COALESCE(RTRIM(LTRIM(r.HorasSemana)),'') + '</qtdHrsSem>' +
					CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaPadraoESocial)),'') = 'V' THEN
						'<tpJornada>' + '1' + '</tpJornada>'  
					ELSE  
						CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaEspecialESocial,''))) = 'V' THEN
							'<tpJornada>' + '2' + '</tpJornada>'  
						ELSE
							CASE WHEN COALESCE(RTRIM(LTRIM(r.JornadaTurnoFixoESocial)),'') = 'V' THEN 
								'<tpJornada>' + '3' + '</tpJornada>'  
							ELSE
								CASE WHEN RTRIM(LTRIM(COALESCE(r.JornadaTurnoFlexESocial,''))) = 'V' THEN
									'<tpJornada>' + '9' + '</tpJornada>' + 
									'<dscTpJorn>' + RTRIM(LTRIM(COALESCE(r.DescrTipoJornESocial,''))) + '</dscTpJorn>' 
								ELSE
									''
								END
							END
						END
					END	+
						'<tmpParc>' + RTRIM(LTRIM(COALESCE(r.CodigoTipoEscalaESocial,''))) + '</tmpParc>' + 
					CASE WHEN r.HoraEnt01ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Segunda-Feira
							'<dia>' + '1' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia01ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt02ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Terça-Feira
							'<dia>' + '2' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia02ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt03ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Quarta-Feira
							'<dia>' + '3' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia03ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt04ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Quinta-Feira
							'<dia>' + '4' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia04ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt05ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Sexta-Feira
							'<dia>' + '5' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia05ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt06ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Sabádo
							'<dia>' + '6' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia06ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt07ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Domingo
							'<dia>' + '7' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia07ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					CASE WHEN r.HoraEnt08ESocial IS NOT NULL THEN
						'<horario>' + 
							-- Dia Variável
							'<dia>' + '8' + '</dia>' +
							'<codHorContrat>' + COALESCE(RTRIM(LTRIM(r.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(r.CodigoHorario)),'') + RTRIM(LTRIM(r.Dia08ESocial)) + '</codHorContrat>' +						
						'</horario>' 
					ELSE
						''
					END +
					'</horContratual>' +
				CASE WHEN k.SindicatoMensalidadeSindical IS NOT NULL THEN
					'<filiacaoSindical>' +
						'<cnpjSindTrab>' + COALESCE(RTRIM(LTRIM(s.CNPJSindicato)),'') + '</cnpjSindTrab>' +
					'</filiacaoSindical>' 
				ELSE
					''
				END +
				CASE WHEN c.AlvaraJuridico = 'V' THEN
					'<alvaraJudicial>' +
						'<nrProcJud>' + COALESCE(RTRIM(LTRIM(c.NumeroProcessoMenor16ESocial)),'') + '</nrProcJud>' +
					'</alvaraJudicial>' 
				ELSE
					''
				END +
					--'<servPubl>' +
					--	'<mtvAlter>' + '' + '</mtvAlter>' +
					--'</servPubl>' +
				'</infoContrato>' +
			'</altContratual>' +
		'</evtAltContratual>' +
	'</eSocial>',
	d.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbColaboradorGeral d
	ON	d.CodigoEmpresa		= c.CodigoEmpresa
	AND d.CodigoLocal		= c.CodigoLocal
	AND d.TipoColaborador	= c.TipoColaborador
	AND d.NumeroRegistro	= c.NumeroRegistro
	
	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

	LEFT JOIN tbCargo m
	ON  m.CodigoEmpresa	= c.CodigoEmpresa
	AND m.CodigoLocal   = c.CodigoLocal
	AND m.CodigoCargo   = c.CodigoCargo
	
	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	INNER JOIN tbColaboradorCentroCusto o
	ON  o.CodigoEmpresa		= c.CodigoEmpresa
	AND o.CodigoLocal		= c.CodigoLocal
	AND o.TipoColaborador	= c.TipoColaborador
	AND o.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbCentroCusto p
	ON  p.CodigoEmpresa	= o.CodigoEmpresa
	AND p.CentroCusto 	= o.CentroCusto

	INNER JOIN tbPessoalHorario q
	ON  q.CodigoEmpresa		= c.CodigoEmpresa
	AND q.CodigoLocal		= c.CodigoLocal
	AND q.TipoColaborador	= c.TipoColaborador
	AND q.NumeroRegistro	= c.NumeroRegistro
	
	LEFT JOIN tbHorario r
	ON  r.CodigoEmpresa	= q.CodigoEmpresa
	AND r.CodigoLocal	= q.CodigoLocal
	AND r.CodigoHorario	= q.CodigoHorario

	LEFT JOIN tbSindicato s
	ON  s.CodigoEmpresa		= k.CodigoEmpresa
	AND s.CodigoSindicato	= k.SindicatoMensalidadeSindical
	
	INNER JOIN tbEmpresaFP t
	ON t.CodigoEmpresa = a.CodigoEmpresa

	LEFT JOIN tbSindicato u
	ON  u.CodigoEmpresa		= k.CodigoEmpresa
	AND u.CodigoSindicato	= k.SindicatoTaxaAssistencial

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Alteração de Contrato de Trabalho
END
GOTO ARQ_FIM

ARQ_S2210: 
---- INICIO XML Evento de Comunicação de Acidente de Trabalho
BEGIN
	SELECT @PartesAtingidas		= ''
	SELECT @AgentesCausadores	= ''

	SELECT @PartesAtingidas		= (SELECT dbo.fnESocialCATParteAtingida (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))
	SELECT @AgentesCausadores	= (SELECT dbo.fnESocialCATAgenteCausador (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtCAT/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtCAT Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(n.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideRegistrador>' +
				'<tpRegistrador>' + '1' + '</tpRegistrador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideRegistrador>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideTrabalhador>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
			'</ideTrabalhador>' +
			'<cat>' + 
				'<dtAcid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataAcidente)),2,4),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataAcidente)),2,2),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,e.DataAcidente)),2,2),'') +
				'</dtAcid>' + 
				'<tpAcid>' + COALESCE(RTRIM(LTRIM(e.CodigoAcidente)),'') + '</tpAcid>' +
				'<hrAcid>' + REPLACE(COALESCE(RTRIM(LTRIM(e.HoraAcidente)),''),'.','') + '</hrAcid>' +
				'<hrsTrabAntesAcid>' + REPLACE(COALESCE(RTRIM(LTRIM(e.QtdeHorasAntesAcidente)),''),'.','') + '</hrsTrabAntesAcid>' +
				'<tpCat>' + COALESCE(RTRIM(LTRIM(e.TipoCAT)),'') + '</tpCat>' +
--				'<indCatParcial>' + CASE WHEN COALESCE(RTRIM(LTRIM(e.CATParcial)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indCatParcial>' +
				'<indCatObito>' + CASE WHEN COALESCE(RTRIM(LTRIM(e.CATObito)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indCatObito>' +
				'<dtObito>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataObito)),2,4),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataObito)),2,2),'') + '-' +
							 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,e.DataObito)),2,2),'') +
				'</dtObito>' + 
				'<indComunicPolicia>' + CASE WHEN COALESCE(RTRIM(LTRIM(e.CATPolicia)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indComunicPolicia>' +
				'<codSitGeradora>' + COALESCE(RTRIM(LTRIM(e.CodSituacaoGeradora)),'') + '</codSitGeradora>' +
				'<iniciatCAT>' + '1' + '</iniciatCAT>' +
				--'<observacao>' + '') + '</observacao>' + -- não criei este campo
				'<localAcidente>' +
					'<tpLocal>' + COALESCE(RTRIM(LTRIM(e.TipoLocalAcidente)),'') + '</tpLocal>' +
					'<dscLocal>' + COALESCE(RTRIM(LTRIM(e.DescrLocalAcidente)),'') + '</dscLocal>' +
					'<dscLograd>' + COALESCE(RTRIM(LTRIM(e.DescrLogradAcidente)),'') + '</dscLograd>' +
					'<nrLograd>' + COALESCE(RTRIM(LTRIM(e.NumeroLogradAcidente)),'') + '</nrLograd>' +
					'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),e.CodMunLogradAcidente),0)))),7) + '</codMunic>' +
					'<uf>' + COALESCE(RTRIM(LTRIM(e.UFLogradAcidente)),'') + '</uf>' +
				CASE WHEN COALESCE(RTRIM(LTRIM(e.CNPJLocalAcidente)),'') = '' THEN
					''
				ELSE
					'<cnpjLocalAcid>' + COALESCE(RTRIM(LTRIM(e.CNPJLocalAcidente)),'') + '</cnpjLocalAcid>' 
				END +				
					-- nao criei estes campos = 2 - Estabelecimento do empregador no Exterior
					--'<pais>' + '' + '</pais>' +
					--'<codPostal>' + '' + '</codPostal>' +
				'</localAcidente>' +
			CASE WHEN @PartesAtingidas <> '' THEN
				@PartesAtingidas
			ELSE
				''
			END +
			CASE WHEN @AgentesCausadores <> '' THEN
				@AgentesCausadores
			ELSE
				''
			END +
				'<atestado>' +
					'<codCNES>' + COALESCE(RTRIM(LTRIM(e.CodCNES)),'') + '</codCNES>' +
					'<dtAtendimento>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataAtendimento)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataAtendimento)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,e.DataAtendimento)),2,2),'') +
					'</dtAtendimento>' + 
					'<hrAtendimento>' + REPLACE(COALESCE(RTRIM(LTRIM(e.HoraAtendimento)),''),'.','') + '</hrAtendimento>' +
					'<indInternacao>' + CASE WHEN COALESCE(RTRIM(LTRIM(e.Internado)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indInternacao>' +
					'<durTrat>' + COALESCE(RTRIM(LTRIM(e.DiasDuraTratamento)),'') + '</durTrat>' +
					'<indAfast>' + CASE WHEN COALESCE(RTRIM(LTRIM(e.Afastado)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indAfast>' +
					'<dscLesao>' + COALESCE(RTRIM(LTRIM(e.DescricaoLesao)),'') + '</dscLesao>' +
					--'<dscCompLesao>' + '' + '</dscCompLesao>' + -- nao fiz
					'<diagProvavel>' + COALESCE(RTRIM(LTRIM(e.DiagnosticoProvavel)),'') + '</diagProvavel>' +
					CASE WHEN COALESCE(RTRIM(LTRIM(e.CodCID)),'') = '' THEN
						''
					ELSE
						'<codCID>' + COALESCE(RTRIM(LTRIM(e.CodCID)),'') + '</codCID>' 
					END +
					CASE WHEN COALESCE(RTRIM(LTRIM(e.Observacao)),'') = '' THEN
						''
					ELSE
						'<observacao>' + COALESCE(RTRIM(LTRIM(e.Observacao)),'') + '</observacao>'
					END +
					CASE WHEN COALESCE(RTRIM(LTRIM(e.NomeMedico)),'') = '' THEN
						''
					ELSE
						'<emitente>' + 
							'<nmEmit>' + COALESCE(RTRIM(LTRIM(e.NomeMedico)),'') + '</nmEmit>' +
							'<ideOC>' + COALESCE(RTRIM(LTRIM(e.TipoOrgaoClasse)),'1') + '</ideOC>' +
							'<nrOc>' + COALESCE(RTRIM(LTRIM(e.NumeroCRM)),'') + '</nrOc>' +
							'<ufOC>' + COALESCE(RTRIM(LTRIM(e.UFCRM)),'') + '</ufOC>' +
						'</emitente>' 					
					END +
				'</atestado>' +
			CASE WHEN e.NumeroCATOrigem IS NOT NULL THEN	
				'<catOrigem>' +
					'<dtCatOrig>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,e.DataCATOrigem)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,e.DataCATOrigem)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,e.DataCATOrigem)),2,2),'') +
					'</dtCatOrig>' + 
					'<nrCatOrig>' + COALESCE(RTRIM(LTRIM(e.NumeroCATOrigem)),'') + '</nrCatOrig>' +
				'</catOrigem>' 
			ELSE
				''
			END +
			'</cat>' +
		'</evtCAT>' +
	'</eSocial>',
	d.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbColaboradorGeral d
	ON  d.CodigoEmpresa		= c.CodigoEmpresa
	AND d.CodigoLocal		= c.CodigoLocal
	AND d.TipoColaborador	= c.TipoColaborador
	AND d.NumeroRegistro	= c.NumeroRegistro

	INNER JOIN tbHistCAT e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro
	AND e.NumeroCAT			= (SELECT MAX(NumeroCAT) FROM tbHistCAT cat
							   WHERE cat.CodigoEmpresa		= @CodigoEmpresa
							   AND   cat.CodigoLocal		= @CodigoLocal
							   AND   cat.TipoColaborador	= @TipoColaborador
							   AND   cat.NumeroRegistro		= @NumeroRegistro
							   AND   cat.DataCAT			= (SELECT MAX(DataCAT) FROM tbHistCAT dat
															   WHERE dat.CodigoEmpresa		= @CodigoEmpresa
															   AND   dat.CodigoLocal		= @CodigoLocal
															   AND   dat.TipoColaborador	= @TipoColaborador
															   AND   dat.NumeroRegistro		= @NumeroRegistro))
	LEFT JOIN tbCargo m
	ON  m.CodigoEmpresa	= c.CodigoEmpresa
	AND m.CodigoLocal   = c.CodigoLocal
	AND m.CodigoCargo   = c.CodigoCargo
	
	INNER JOIN tbEmpresaFP n
	ON n.CodigoEmpresa = a.CodigoEmpresa

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Comunicação de Acidente de Trabalho
END
GOTO ARQ_FIM

ARQ_S2220: 
---- INICIO XML Evento Monitoramento da Saúde do Trabalhador
BEGIN
	SELECT @ASOs	= ''

	SELECT @ASOs	= (SELECT dbo.fnESocialASO (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtMonit/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtMonit Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			CASE WHEN @ASOs <> '' THEN
				@ASOs
			ELSE
				''
			END +
		'</evtMonit>' +
	'</eSocial>',
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Monitoramento da Saúde do Trabalhador
END
GOTO ARQ_FIM

ARQ_S2230: 
---- INICIO XML Evento Afastamento temporario
BEGIN
	IF @Ferias = 'V'
	BEGIN
		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAfastTemp/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtAfastTemp Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<ideVinculo>' +
					'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
					'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
					'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--					'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
				'</ideVinculo>' +
				'<infoAfastamento>' +
					'<iniAfastamento>' +
						'<dtIniAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataInicioGozoFeriasHist)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataInicioGozoFeriasHist)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataInicioGozoFeriasHist)),2,2),'') +
						'</dtIniAfast>' + 
						'<codMotAfast>' + '15' + '</codMotAfast>' +
						'<infoMesmoMtv>' + 'N' + '</infoMesmoMtv>' +
						--'<tpAcidTransito>' + '' + '</tpAcidTransito>' +
						CASE WHEN COALESCE(RTRIM(LTRIM(f.Observacao)),'') = '' THEN
							''
						ELSE
							'<observacao>' + COALESCE(RTRIM(LTRIM(f.Observacao)),'') + '</observacao>' 
						END +
						-- Ferias, nao preenchi
						--'<infoAtestado>' +
						--	'<codCID>' + '' + '</codCID>' +
						--	'<qtdDiasAfast>' + '' + '</qtdDiasAfast>' +
						--	'<emitente>' +
						--		'<nmEmit>' + '' + '</nmEmit>' +
						--		'<ideOC>' + '' + '</ideOC>' +
						--		'<nrOc>' + '' + '</nrOc>' +
						--		'<ufOC>' + '' + '</ufOC>' +
						--	'</emitente>' +							
						--'</infoAtestado>' +
					-- Férias, nao preenchi
					--CASE WHEN h.CNPJCessionario IS NOT NULL THEN
					--	'<infoCessao>' +
					--		'<cnpjCess>' + '' + '</cnpjCess>' +
					--		'<infOnus>' + '' + '</infOnus>' +
					--	'</infoCessao>' 
					--ELSE
					--	''
					--END +
					-- Férias, não preenchi
					--CASE WHEN h.CNPJSindicato IS NOT NULL THEN
					--	'<infoMandSind>' +
					--		'<cnpjSind>' + '' + '</cnpjSind>' +
					--		'<infOnusRemun>' + '' + '</infOnusRemun>' +
					--	'</infoMandSind>' 
					--ELSE
					--	''
					--END +
					--Férias, não preenchi
					'</iniAfastamento>' +
					-- Férias, não preenchi
					--'<infoRetif>' +
					--	'<origRetif>' +  + '</origRetif>' +
					--	'<tpProc>' + + '</tpProc>' +
					--	'<nrProc>' + + '</nrProc>' +
					--'</infoRetif>' +
					'<fimAfastamento>' +
						'<dtTermAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataFinalGozoFeriasHist)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataFinalGozoFeriasHist)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataFinalGozoFeriasHist)),2,2),'') +
						'</dtTermAfast>' + 
					'</fimAfastamento>' +
				'</infoAfastamento>' +
			'</evtAfastTemp>' +
		'</eSocial>',
		e.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
					
		INNER JOIN tbEmpresaFP d
		ON d.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbColaboradorGeral e
		ON  e.CodigoEmpresa		= c.CodigoEmpresa
		AND e.CodigoLocal		= c.CodigoLocal
		AND e.TipoColaborador	= c.TipoColaborador
		AND e.NumeroRegistro	= c.NumeroRegistro

		INNER JOIN tbHistFerias h
		ON  h.CodigoEmpresa		= c.CodigoEmpresa
		AND h.CodigoLocal		= c.CodigoLocal
		AND h.TipoColaborador	= c.TipoColaborador
		AND h.NumeroRegistro	= c.NumeroRegistro

		LEFT JOIN tbFerias f
		ON  f.CodigoEmpresa				= h.CodigoEmpresa
		AND f.CodigoLocal				= h.CodigoLocal
		AND f.TipoColaborador			= h.TipoColaborador
		AND f.NumeroRegistro			= h.NumeroRegistro
		AND f.InicioPeriodoAquisitivo	= h.DataInicioPerAquisitivoHist
		AND f.InicioFerias				= h.DataInicioGozoFeriasHist
		
		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   c.CodigoEmpresa	= @CodigoEmpresa
		AND   c.CodigoLocal		= @CodigoLocal
		AND   c.TipoColaborador = @TipoColaborador
		AND   c.NumeroRegistro  = @NumeroRegistro
		AND EXISTS (
					SELECT 1 
					FROM tbLogEventoTrabalhistaESocial e
					WHERE e.CodigoEmpresa		= h.CodigoEmpresa
					AND e.CodigoLocal			= h.CodigoLocal
					AND e.TipoColaborador		= h.TipoColaborador
					AND e.NumeroRegistro		= h.NumeroRegistro
					AND e.CodigoLocalMatriz		= h.SequenciaHistFerias
					AND e.CodigoArquivo			= @NomeArquivo
					AND e.TipoOperacaoArquivo	= @TipoRegistro
					AND REPLACE(CONVERT(CHAR(10),e.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),e.DataHoraArquivo,108)	= @DataHoraArquivo
					AND e.ExcluidoLog			= 'F'
					AND e.CodigoEvento			= 'FERIAS'
				   )
	END
	ELSE -- não é férias
	BEGIN
--whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = '0',@NomeArquivo = 'S-2230',@TipoColaborador = 'F',@NumeroRegistro = '22',@NroRecibo = '2312312313',@ESocialExcluido = 'S-2200',@IndApuracao = Null,@PerApuracao = Null,@Ambiente = 2, @Ferias = 'F'
		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAfastTemp/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtAfastTemp Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
				'<ideVinculo>' +
					'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
					'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
					'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--					'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
				'</ideVinculo>' +
				'<infoAfastamento>' +
				CASE WHEN @Variavel <> 'R' THEN	
					'<iniAfastamento>' +
						'<dtIniAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataInicioAfastamentoHist)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataInicioAfastamentoHist)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataInicioAfastamentoHist)),2,2),'') +
						'</dtIniAfast>' + 
						'<codMotAfast>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'') + '</codMotAfast>' +
						'<infoMesmoMtv>' + CASE WHEN l.CodigoRE = 'P2' THEN 'S' ELSE 'N' END + '</infoMesmoMtv>' +
					CASE WHEN COALESCE(RTRIM(LTRIM(h.TipoAcidenteTransito)),'') = '' OR COALESCE(RTRIM(LTRIM(h.TipoAcidenteTransito)),'') = 0 THEN
						''
					ELSE
						'<tpAcidTransito>' + COALESCE(RTRIM(LTRIM(h.TipoAcidenteTransito)),'') + '</tpAcidTransito>' 
					END +
					CASE WHEN COALESCE(RTRIM(LTRIM(h.Observacao)),'') = '' THEN
						''
					ELSE
						'<observacao>' + COALESCE(RTRIM(LTRIM(h.Observacao)),'') + '</observacao>' 
					END +
					CASE WHEN COALESCE(RTRIM(LTRIM(h.CodigoCID)),'') <> '' AND COALESCE(RTRIM(LTRIM(h.NomeMedico)),'') <> '' THEN
						'<infoAtestado>' +
							'<codCID>' + COALESCE(RTRIM(LTRIM(h.CodigoCID)),'') + '</codCID>' + 
							'<qtdDiasAfast>' + COALESCE(RTRIM(LTRIM(h.DiasAfastamento)),'') + '</qtdDiasAfast>' +
							'<emitente>' +
								'<nmEmit>' + COALESCE(RTRIM(LTRIM(h.NomeMedico)),'') + '</nmEmit>' +
								'<ideOC>' + COALESCE(RTRIM(LTRIM(h.TipoOrgaoClasse)),'') + '</ideOC>' +
								'<nrOc>' + COALESCE(RTRIM(LTRIM(h.CRMMedico)),'') + '</nrOc>' +
								'<ufOC>' + COALESCE(RTRIM(LTRIM(h.UFCRMMedico)),'') + '</ufOC>' +
							'</emitente>' +
						'</infoAtestado>' 
					ELSE
						CASE WHEN COALESCE(RTRIM(LTRIM(h.CodigoCID)),'') <> '' AND COALESCE(RTRIM(LTRIM(h.NomeMedico)),'') = '' THEN
							'<infoAtestado>' +
								'<codCID>' + COALESCE(RTRIM(LTRIM(h.CodigoCID)),'') + '</codCID>' +
								'<qtdDiasAfast>' + COALESCE(RTRIM(LTRIM(h.DiasAfastamento)),'') + '</qtdDiasAfast>' +
							'</infoAtestado>' 
						ELSE
							CASE WHEN COALESCE(RTRIM(LTRIM(h.CodigoCID)),'') = '' AND COALESCE(RTRIM(LTRIM(h.NomeMedico)),'') <> '' THEN
								'<infoAtestado>' +
									'<qtdDiasAfast>' + COALESCE(RTRIM(LTRIM(h.DiasAfastamento)),'') + '</qtdDiasAfast>' +
									'<emitente>' +
										'<nmEmit>' + COALESCE(RTRIM(LTRIM(h.NomeMedico)),'') + '</nmEmit>' +
										'<ideOC>' + COALESCE(RTRIM(LTRIM(h.TipoOrgaoClasse)),'') + '</ideOC>' +
										'<nrOc>' + COALESCE(RTRIM(LTRIM(h.CRMMedico)),'') + '</nrOc>' +
										'<ufOC>' + COALESCE(RTRIM(LTRIM(h.UFCRMMedico)),'') + '</ufOC>' +
									'</emitente>' +
								'</infoAtestado>' 
							ELSE
								''
							END 
						END 
					END +
					CASE WHEN h.CNPJCessionario IS NOT NULL THEN
						'<infoCessao>' +
							'<cnpjCess>' + COALESCE(RTRIM(LTRIM(h.CNPJCessionario)),'') + '</cnpjCess>' +
							'<infOnus>' + CASE COALESCE(RTRIM(LTRIM(h.OnusCessionario)),'F') WHEN 'V' THEN '1' WHEN 'F' THEN '2' WHEN 'D' THEN '3' END + '</infOnus>' +
						'</infoCessao>' 
					ELSE
						''
					END +
					CASE WHEN h.CNPJSindicato IS NOT NULL THEN
						'<infoMandSind>' +
							'<cnpjSind>' + COALESCE(RTRIM(LTRIM(h.CNPJSindicato)),'') + '</cnpjSind>' +
							'<infOnusRemun>' + CASE COALESCE(RTRIM(LTRIM(h.OnusSindicato)),'F') WHEN 'V' THEN '1' WHEN 'F' THEN '2' WHEN 'D' THEN '3' END + '</infOnusRemun>' +
						'</infoMandSind>' 
					ELSE
						''
					END +
					'</iniAfastamento>' 
				ELSE
					''
				END +
					-- deve ser indicado no hist afastamento, nao fiz ainda
					--'<infoRetif>' +
					--	'<origRetif>' + + '</origRetif>' +
					--	'<tpProc>' + + '</tpProc>' +
					--	'<nrProc>' + + '</nrProc>' +
					--'</infoRetif>' +
					CASE WHEN COALESCE(RTRIM(LTRIM(h.DataTerminoAfastamentoHist)),'') = '' THEN
						''
					ELSE
						'<fimAfastamento>' +
							'<dtTermAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataTerminoAfastamentoHist)),2,4),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataTerminoAfastamentoHist)),2,2),'') + '-' +
												COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataTerminoAfastamentoHist)),2,2),'') +
							'</dtTermAfast>' + 
						'</fimAfastamento>' 
					END +
				'</infoAfastamento>' +
			'</evtAfastTemp>' +
		'</eSocial>',
		e.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
					
		INNER JOIN tbEmpresaFP d
		ON d.CodigoEmpresa = a.CodigoEmpresa

		INNER JOIN tbColaboradorGeral e
		ON  e.CodigoEmpresa		= c.CodigoEmpresa
		AND e.CodigoLocal		= c.CodigoLocal
		AND e.TipoColaborador	= c.TipoColaborador
		AND e.NumeroRegistro	= c.NumeroRegistro

		INNER JOIN tbHistAfastamento h
		ON  h.CodigoEmpresa				= c.CodigoEmpresa
		AND h.CodigoLocal				= c.CodigoLocal
		AND h.TipoColaborador			= c.TipoColaborador
		AND h.NumeroRegistro			= c.NumeroRegistro
		AND h.SequenciaHistAfastamento  = (
											SELECT CodigoEvento 
											FROM tbLogEventoTrabalhistaESocial e
											WHERE e.CodigoEmpresa		= h.CodigoEmpresa
											AND e.CodigoLocal			= h.CodigoLocal
											AND e.TipoColaborador		= h.TipoColaborador
											AND e.NumeroRegistro		= h.NumeroRegistro
											AND e.CodigoArquivo			= @NomeArquivo
											AND e.TipoOperacaoArquivo	= @TipoRegistro
											AND REPLACE(CONVERT(CHAR(10),e.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),e.DataHoraArquivo,108)	= @DataHoraArquivo
											AND e.ExcluidoLog			= 'F'
											AND e.CodigoEvento			<> 'FERIAS'
										   )

		INNER JOIN tbTipoMovimentacaoFolha l 
		ON  l.CodigoEmpresa				= h.CodigoEmpresa 
		AND	l.TipoMovimentacaoColab		= h.TipoMovimentacaoColab 
		AND	l.CodigoMovimentacaoColab	= h.CodigoMovimentacaoColab

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   c.CodigoEmpresa	= @CodigoEmpresa
		AND   c.CodigoLocal		= @CodigoLocal
		AND   c.TipoColaborador = @TipoColaborador
		AND   c.NumeroRegistro  = @NumeroRegistro
	END
	---- FIM XML Evento Afastamento Temporario
END
GOTO ARQ_FIM

ARQ_S2240:
---- INICIO XML Evento Condições Ambientais do Trabalho - Fatores de Risco
BEGIN
	SELECT @ASOs	= ''

	SELECT @ASOs	= (SELECT dbo.fnESocialASO (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtExpRisco/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtExpRisco Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(f.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			CASE WHEN @ASOs <> '' THEN
				@ASOs
			ELSE
				''
			END +
		'</evtExpRisco>' +
	'</eSocial>',
	f.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbLogEventoTrabalhistaESocial e
	ON  e.CodigoEmpresa			= c.CodigoEmpresa
	AND e.CodigoLocal			= c.CodigoLocal
	AND e.TipoColaborador		= c.TipoColaborador
	AND e.NumeroRegistro		= c.NumeroRegistro
	AND e.CodigoArquivo			= @NomeArquivo
	AND e.TipoOperacaoArquivo	= @TipoRegistro
	AND REPLACE(CONVERT(CHAR(10),e.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),e.DataHoraArquivo,108)	= @DataHoraArquivo
	AND e.ExcluidoLog			= 'F'

	INNER JOIN tbColaboradorGeral f
	ON  f.CodigoEmpresa		= c.CodigoEmpresa
	AND f.CodigoLocal		= c.CodigoLocal
	AND f.TipoColaborador	= c.TipoColaborador
	AND f.NumeroRegistro	= c.NumeroRegistro

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Condições Ambientais do Trabalho - Fatores de Risco 
END
GOTO ARQ_FIM

ARQ_S2241:
---- INICIO XML inslubridade, periculosidade e Aposentadoria especial
BEGIN
	SELECT @ASOs	= ''

	SELECT @ASOs	= (SELECT dbo.fnESocialASO (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtInsApo/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtInsApo Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(f.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			CASE WHEN @ASOs <> '' THEN
				@ASOs
			ELSE
				''
			END +
		'</evtInsApo>' +
	'</eSocial>',
	f.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbLogEventoTrabalhistaESocial e
	ON  e.CodigoEmpresa			= c.CodigoEmpresa
	AND e.CodigoLocal			= c.CodigoLocal
	AND e.TipoColaborador		= c.TipoColaborador
	AND e.NumeroRegistro		= c.NumeroRegistro
	AND e.CodigoArquivo			= @NomeArquivo
	AND e.TipoOperacaoArquivo	= @TipoRegistro
	AND REPLACE(CONVERT(CHAR(10),e.DataHoraArquivo,102),'.','-') + ' ' + CONVERT(CHAR(8),e.DataHoraArquivo,108)	= @DataHoraArquivo
	AND e.ExcluidoLog			= 'F'

	INNER JOIN tbColaboradorGeral f
	ON  f.CodigoEmpresa		= c.CodigoEmpresa
	AND f.CodigoLocal		= c.CodigoLocal
	AND f.TipoColaborador	= c.TipoColaborador
	AND f.NumeroRegistro	= c.NumeroRegistro

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML inslubridade, periculosidade e Aposentadoria especial
END
GOTO ARQ_FIM

ARQ_S2250: 
---- INICIO XML Evento Indicacao Aviso Previo
BEGIN
	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtAvPrevio/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtAvPrevio Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			'<infoAvPrevio>' +
				'<detAvPrevio>' +
					'<dtAvPrv>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataAvisoPrevio)),2,4),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataAvisoPrevio)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataAvisoPrevio)),2,2),'') +
					'</dtAvPrv>' + 
					'<dtPrevDeslig>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataProjetada)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataProjetada)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataProjetada)),2,2),'') +
					'</dtPrevDeslig>' + 
					'<tpAvPrevio>' + COALESCE(RTRIM(LTRIM(h.TipoAvisoPrevio)),'') + '</tpAvPrevio>' +
				CASE WHEN COALESCE(RTRIM(LTRIM(h.Observacao)),'') = '' THEN
					''
				ELSE
					'<observacao>' + COALESCE(RTRIM(LTRIM(h.Observacao)),'') + '</observacao>' 
				END +
				'</detAvPrevio>' +
			CASE WHEN h.Cancelado = 'V' THEN
				'<cancAvPrevio>' +
					'<dtCancAvPrv>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataCancelado)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataCancelado)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataCancelado)),2,2),'') +
					'</dtCancAvPrv>' + 
				CASE WHEN COALESCE(RTRIM(LTRIM(h.ObsCancelado)),'') = '' THEN
					''
				ELSE
					'<observacao>' + COALESCE(RTRIM(LTRIM(h.ObsCancelado)),'') + '</observacao>' 
				END +
					'<mtvCancAvPrevio>' + COALESCE(RTRIM(LTRIM(h.MotivoCancelado)),'') + '</mtvCancAvPrevio>' +
				'</cancAvPrevio>'
			ELSE
				''
			END +
			'</infoAvPrevio>' +
		'</evtAvPrevio>' +
	'</eSocial>',
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

	INNER JOIN tbIndicaAvisoPrevio h
	ON  h.CodigoEmpresa		= c.CodigoEmpresa
	AND h.CodigoLocal		= c.CodigoLocal
	AND h.TipoColaborador	= c.TipoColaborador
	AND h.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Indicacao Aviso Previo
END
GOTO ARQ_FIM

ARQ_S2298: 
---- INICIO XML Evento Reintegracao
BEGIN
	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtReintegr/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtReintegr Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			'<infoReintegr>' +
				'<tpReint>' + COALESCE(RTRIM(LTRIM(n.TipoReintegracao)),'') + '</tpReint>' +
				'<nrProcJud>' + COALESCE(RTRIM(LTRIM(n.NumeroProcJudicial)),'') + '</nrProcJud>' +
				'<nrLeiAnistia>' + COALESCE(RTRIM(LTRIM(n.NumeroLeiAnistia)),'') + '</nrLeiAnistia>' +
				'<dtEfetRetorno>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataReintegracao)),2,4),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataReintegracao)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataReintegracao)),2,2),'') +
				'</dtEfetRetorno>' + 
				'<dtEfeito>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataRetorno)),2,4),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataRetorno)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataRetorno)),2,2),'') +
				'</dtEfeito>' + 
				'<indPagtoJuizo>' + CASE WHEN COALESCE(RTRIM(LTRIM(n.PagamentoJuizo)),'F') = 'F' THEN 'N' ELSE 'S' END + '</indPagtoJuizo>' +
			'</infoReintegr>' +
		'</evtReintegr>' +
	'</eSocial>',
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	---- FIM XML Evento Reintegracao
END
GOTO ARQ_FIM

ARQ_S2299: 
---- INICIO XML Evento Desligamento
BEGIN
	SELECT @Beneficiario		= ''
	SELECT @ProcessoAdmJudMes	= ''
	SELECT @MultiplosVinculos	= ''
	SELECT @ValorRubricasV		= ''
	SELECT @ValorRubricasD		= ''
	SELECT @ValorRubricasB		= ''
	
	SELECT @Beneficiario		= (SELECT dbo.fnESocialPensaoAlimenticia (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @IndApuracao, @PerApuracao, NULL))
	SELECT @ProcessoAdmJudMes	= (SELECT dbo.fnESocialProcessosAdmJud (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao))
	SELECT @MultiplosVinculos	= (SELECT dbo.fnESocialRemuneracaoOutraEmpresa (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao))
	IF @DataInicioESocialFase3 <= GETDATE()
	BEGIN
		SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'V'))
		SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'D'))
		SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'B'))
	END
	-- dados vinculo
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtDeslig/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtDeslig Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<matricula>' + COALESCE(RTRIM(LTRIM(e.MatriculaESocial)),'') + '</matricula>' +
--				'<matricula>' + COALESCE(RTRIM(LTRIM(c.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(c.NumeroRegistro)),'') + '</matricula>' +
			'</ideVinculo>' +
			'<infoDeslig>' +
				'<mtvDeslig>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'') + '</mtvDeslig>' +
				'<dtDeslig>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataDemissao)),2,4),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataDemissao)),2,2),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataDemissao)),2,2),'') +
				'</dtDeslig>' + 
			CASE WHEN l.CondicaoAvisoPrevio = 'I' THEN
				'<indPagtoAPI>' + 'S' + '</indPagtoAPI>' +
				'<dtProjFimAPI>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataAvisoPrevio)),2,4),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataAvisoPrevio)),2,2),'') + '-' +
									COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataAvisoPrevio)),2,2),'') +
				'</dtProjFimAPI>' 
			ELSE
				'<indPagtoAPI>' + 'N' + '</indPagtoAPI>'	
			END +
			CASE WHEN RTRIM(LTRIM(@Beneficiario)) <> '' THEN
				RTRIM(LTRIM(@Beneficiario))
			ELSE
				'<pensAlim>' +  '0' + '</pensAlim>' 
			END +				
			CASE WHEN COALESCE(RTRIM(LTRIM(n.NumeroAtestadoObito)),'') = '' THEN
				''
			ELSE
				'<nrCertObito>' + COALESCE(RTRIM(LTRIM(n.NumeroAtestadoObito)),'') + '</nrCertObito>' 
			END +
			CASE WHEN COALESCE(RTRIM(LTRIM(n.NumeroProcTrabalhista)),'') = '' THEN
				''
			ELSE
				'<nrProcTrab>' + COALESCE(RTRIM(LTRIM(n.NumeroProcTrabalhista)),'') + '</nrProcTrab>' 
			END +
			CASE WHEN l.CondicaoAvisoPrevio = 'I' THEN
				'<indCumprParc>' + '4' + '</indCumprParc>'  -- nao criei campo novo
			ELSE
				'<indCumprParc>' + '0' + '</indCumprParc>'  -- nao criei campo novo
			END +
			-- obrigatório para categoria de trabalhador = 111-trabalho intermitente, nao geramos este arquivo 2260.
			--'<qtdDiasInterm>' '' '</qtdDiasInterm>'
			CASE WHEN COALESCE(RTRIM(LTRIM(n.ObservacaoESocial)),'') = '' THEN
				''
			ELSE
				'<observacoes>' +
					'<observacao>' + COALESCE(RTRIM(LTRIM(n.ObservacaoESocial)),'') + '</observacao>' +
				'</observacoes>' 
			END +
			CASE WHEN COALESCE(RTRIM(LTRIM(n.CNPJSucessora)),'') = '' THEN
				'' 				
			ELSE
				'<sucessaoVinc>' +
					'<cnpjSucessora>' + COALESCE(RTRIM(LTRIM(n.CNPJSucessora)),'') + '</cnpjSucessora>' +
				'</sucessaoVinc>' 
			END ,
				-- nao fiz transfTit
				--'<transfTit>' +
				--	'<cpfSubstituto>' + '</cpfSubstituto>' +
				--	'<dtNascto>' +	'</dtNascto>' 
				--'</transfTit>' +
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

 	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoDemissao
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoDemissao

	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro

	-- dados verbas
--whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = '0',@NomeArquivo = 'S-2299',@TipoColaborador = 'F',@NumeroRegistro = '22',@IndApuracao = '1',@PerApuracao = '201407',@Ambiente = 1
	-- inicia tag Verbas
	IF @ValorRubricasV <> '' -- tem movimento quitacao
	BEGIN
		SET @LinhaAux = '<verbasResc>'
		-- cria cursor com os tipos de pagamentos encontrados
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia, 
			PeriodoPagamento	= a.PeriodoPagamento,
			RotinaPagamento		= a.RotinaPagamento, 
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio, 
			TipoDissidioESocial	= a.TipoDissidioESocial, 
			DataDissidioESocial	= a.DataDissidioESocial

		INTO #tmpPagamentos2299

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

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND   a.PeriodoCompetencia	= @PerApuracao
		AND   (
					(@IndApuracao = 1 AND a.RotinaPagamento	IN (1,2,7)) -- adto, mensal, eventual
				OR	(@IndApuracao = 2 AND a.RotinaPagamento	IN (4,5))	-- 13o salario	
		  	  )
		
		WHILE EXISTS ( SELECT 1 FROM #tmpPagamentos2299 )
		BEGIN
			-- tag abertura
			SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<dmDev>'
			-- pagamentos quitacao
			SELECT TOP 1 			
				@curCodigoEmpresa		= a.CodigoEmpresa, 
				@curCodigoLocal			= a.CodigoLocal, 
				@curTipoColaborador		= a.TipoColaborador, 
				@curNumeroRegistro		= a.NumeroRegistro, 
				@curPeriodoCompetencia	= a.PeriodoCompetencia,
				@curRotinaPagamento		= a.RotinaPagamento, 
				@curDataPagamento		= a.DataPagamento,
				@curDissidio			= a.Dissidio 

			FROM #tmpPagamentos2299 a

			IF @curDissidio = 'F' -- não é dissidio
			BEGIN
				-- tag abertura
				SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<ideDmDev>' + COALESCE(RTRIM(LTRIM(@curCodigoEmpresa)),'') + 
																		COALESCE(RTRIM(LTRIM(@curCodigoLocal)),'') +
																		COALESCE(RTRIM(LTRIM(@curTipoColaborador)),'') +
																		COALESCE(RTRIM(LTRIM(@curNumeroRegistro)),'') +
																		COALESCE(RTRIM(LTRIM(@curPeriodoCompetencia)),'') +
																		COALESCE(RTRIM(LTRIM(@curRotinaPagamento)),'') +
																		COALESCE(RTRIM(LTRIM(@curDissidio)),'') +
											'</ideDmDev>' +
											'<infoPerApur>' + 
												'<ideEstabLot>' 
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 2
					SELECT @LinhaAux = ''
					-- estabelecimento/lotacao
					SELECT @Tomadores	= ''
					SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, NULL))
					IF @Tomadores <> '' -- tem tomadores não dissidio
					BEGIN
						-- cria temp tomadores
						SELECT	CodigoClifor = c.CodigoCliFor
						
						INTO #tmpTomadores2299
						
						FROM tbTomadorFunc a,
							 tbTomadorServico b,
							 tbCliFor c
						
						WHERE a.CodigoEmpresa		= b.CodigoEmpresa
						AND   a.CodigoLocal			= b.CodigoLocal
						AND   a.CodigoCliFor		= b.CodigoCliFor
						AND   b.CodigoEmpresa       = c.CodigoEmpresa
						AND   b.CodigoCliFor        = c.CodigoCliFor
						AND   a.CodigoEmpresa		= @curCodigoEmpresa
						AND   a.CodigoLocal			= @curCodigoLocal
						AND   a.TipoColaborador		= @curTipoColaborador
						AND   a.NumeroRegistro		= @curNumeroRegistro
						AND   (
								(b.DataIniValidade <= @DataApuracao AND b.DataFimValidade IS NULL)
								OR (@DataApuracao BETWEEN b.DataIniValidade AND b.DataFimValidade)
							  )

						WHILE EXISTS ( SELECT 1 FROM #tmpTomadores2299 )
						BEGIN
							-- pega o 1.o
							SELECT TOP 1 @curCodigoCliFor = CodigoCliFor FROM #tmpTomadores2299
							SELECT @Tomadores = ''
							SELECT @Tomadores = (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, @curCodigoCliFor))
							-- insere na temp original
							IF RTRIM(LTRIM(@Tomadores)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@Tomadores)), @OrdemAux, @OrdemAux + 3 
							-- limpa variaveis
							SET @OrdemAux = @OrdemAux + 4
							-- deleta 1.o registro
							DELETE #tmpTomadores2299 WHERE CodigoCliFor = @curCodigoCliFor
						END
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpTomadores2299 
						-- detalhes verbas
						SELECT @ValorRubricasV = ''
						SELECT @ValorRubricasV = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD = ''
						SELECT @ValorRubricasD = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB = ''
						SELECT @ValorRubricasB = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 5 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 6 
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 7 
						-- detalhes plano saude	
						-- cria temp operadora
						SELECT RegistroANS
						INTO #tmpPlanoSaudeOperTom2299
						FROM tbAssistMedica
						WHERE 1 = 2
						--
						-- popula temp operadora
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperTom2299
							SELECT 
									d.RegistroANS
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperTom2299
							SELECT 
									d.RegistroANS

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
	--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201206', 'N'
						IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperTom2299 )
						BEGIN
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 8
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'V'
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeOperTom2299
									  )
						BEGIN
							-- operadora
							SELECT TOP 1 			
								@curRegistroANS = RegistroANS 
							FROM #tmpPlanoSaudeOperTom2299
							GROUP BY RegistroANS
							--inclui operadora
							SELECT @ValorPlanoSaudeOpe	= ''
							SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
							IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
								INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 9
							-- valor titular
							SELECT @ValorPlanoSaudeTit	= ''
							SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
							IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 10
							ELSE
							BEGIN
								SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 11
							END
							-- valor dependentes
							-- cria temp
							SELECT RegistroANS,
									TipoAssistenciaMedica AS SequenciaDependente									
							INTO #tmpPlanoSaudeDepTom2299
							FROM tbAssistMedica
							WHERE 1 = 2
							--
							-- popula temp							
							IF @TipoColaborador <> 'T'
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepTom2299
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente									
								
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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								AND d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							ELSE
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepTom2299
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente

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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								AND d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							WHILE EXISTS (
											SELECT 1 FROM #tmpPlanoSaudeDepTom2299
										 )
							BEGIN
								SELECT TOP 1 			
									@curRegistroANSDep	= RegistroANS,
									@curSeqDependente	= SequenciaDependente 
								FROM #tmpPlanoSaudeDepTom2299
								GROUP BY RegistroANS,
										SequenciaDependente
								-- inclui		
								SELECT @ValorPlanoSaudeDep	= ''
								SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
								IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
									INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 12
								-- deleta 1.o registro
								DELETE #tmpPlanoSaudeDepTom2299 
								WHERE RegistroANS			= @curRegistroANSDep
								AND   SequenciaDependente	= @curSeqDependente
								-- incrementa contador
								SET @OrdemAux = @OrdemAux + 13
							END
							-- elimina a tabela ao fim do processamento
							DROP TABLE #tmpPlanoSaudeDepTom2299
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeOperTom2299 
							WHERE RegistroANS = @curRegistroANS
							-- fecha operadora
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 14
							SELECT @LinhaAux = ''
							-- incrementa contador
							SET @OrdemAux = @OrdemAux + 15
						END -- fim temp
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeOperTom2299 
						IF @SaudeColet = 'V'
						BEGIN
							-- fecha tag plano saude
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'F'
						END
						-- agente nocivo e codigo simples
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT TOP 1
																		'<infoAgNocivo>' +
																			'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																		'</infoAgNocivo>' + 
																		--'<infoSimples>' +
																		--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																		--'</infoSimples>' +
																		'</ideEstabLot>' + 
																		'</infoPerApur>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = a.CodigoEmpresa
																	AND c.CodigoLocal   = a.CodigoLocal
																						
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																  )
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 17
						SELECT @LinhaAux = ''
					END
					ELSE -- nao tem tomadores não dissidio
					BEGIN
						-- codigo lotacao
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT DISTINCT '<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
																		'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
																		'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbLocal b
																	ON  b.CodigoEmpresa = a.CodigoEmpresa
																	AND b.CodigoLocal   = a.CodigoLocal

																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = b.CodigoEmpresa
																	AND c.CodigoLocal   = b.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																)
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 18
						SELECT @LinhaAux = ''
						-- detalhes verbas
						SELECT @ValorRubricasV	= ''
						SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD	= ''
						SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB	= ''
						SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 19 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 20
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 21
						-- detalhes plano saude	
						-- cria temp operadora
						SELECT RegistroANS
						INTO #tmpPlanoSaudeOperNTom2299
						FROM tbAssistMedica
						WHERE 1 = 2
						--
						-- popula temp operadora
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperNTom2299
							SELECT 
									d.RegistroANS
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperNTom2299
							SELECT 
									d.RegistroANS

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
	--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201206', 'N'
						IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperNTom2299 )
						BEGIN
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 22
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'V'
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeOperNTom2299
									  )
						BEGIN
							-- operadora
							SELECT TOP 1 			
								@curRegistroANS = RegistroANS
							FROM #tmpPlanoSaudeOperNTom2299
							GROUP BY RegistroANS
							--inclui operadora
							SELECT @ValorPlanoSaudeOpe	= ''
							SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
							IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
								INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 23
							-- valor titular
							SELECT @ValorPlanoSaudeTit	= ''
							SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
							IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 24
							ELSE
							BEGIN
								SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 25
							END
							-- valor dependentes
							-- cria temp
							SELECT RegistroANS,
									TipoAssistenciaMedica AS SequenciaDependente									
							INTO #tmpPlanoSaudeDepNTom2299
							FROM tbAssistMedica
							WHERE 1 = 2
							--
							-- popula temp
							IF @TipoColaborador <> 'T'
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepNTom2299
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente									
								
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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							ELSE
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepNTom2299
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente

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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							WHILE EXISTS (
											SELECT 1 FROM #tmpPlanoSaudeDepNTom2299
										 )
							BEGIN
								SELECT TOP 1 			
									@curRegistroANSDep	= RegistroANS,
									@curSeqDependente	= SequenciaDependente 
								FROM #tmpPlanoSaudeDepNTom2299
								GROUP BY RegistroANS,
										SequenciaDependente
								-- inclui		
								SELECT @ValorPlanoSaudeDep	= ''
								SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
								IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
									INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 26
								-- deleta 1.o registro
								DELETE #tmpPlanoSaudeDepNTom2299 
								WHERE RegistroANS			= @curRegistroANSDep
								AND   SequenciaDependente	= @curSeqDependente
								-- incrementa contador
								SET @OrdemAux = @OrdemAux + 27
							END
							-- elimina a tabela ao fim do processamento
							DROP TABLE #tmpPlanoSaudeDepNTom2299
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeOperNTom2299 
							WHERE RegistroANS = @curRegistroANS
							-- fecha operadora
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 28
							SELECT @LinhaAux = ''
							-- incrementa contador
							SET @OrdemAux = @OrdemAux + 29
						END -- fim temp
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeOperNTom2299 
						IF @SaudeColet = 'V' 
						BEGIN
							-- fecha tag plano saude
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 30
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'F'
						END
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, '', 0, 'N', '2', '201407', 'N'
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT TOP 1
																		'<infoAgNocivo>' +
																			'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																		'</infoAgNocivo>' + 
																		--'<infoSimples>' +
																		--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																		--'</infoSimples>' +
																	'</ideEstabLot>' + 
																'</infoPerApur>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = a.CodigoEmpresa
																	AND c.CodigoLocal   = a.CodigoLocal
																						
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																  )
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 31
						SELECT @LinhaAux = ''
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 59, 121324, '', 0, 'N', '2', '201407', 'N'
						SET @OrdemAux = @OrdemAux + 32
					END -- fim tomadores não dissidio
			END
			ELSE -- é dissidio
			BEGIN
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, '', 0, 'N', '2', '201407', 'N'
				-- tag abertura
				SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoPerAnt>' 
				-- tipo de dissidio
				SELECT @DissidioAcordoMes	= ''
				SELECT @DissidioAcordoMes	= (SELECT dbo.fnESocialDissidioAcordo (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, NULL))
				IF RTRIM(LTRIM(@DissidioAcordoMes)) <> '' -- tem lote de dissidio
				BEGIN
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<ideADC>' + '<ideEstabLot>'
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 33
					SELECT @LinhaAux = ''
					-- insere na temp original
					IF RTRIM(LTRIM(@DissidioAcordoMes)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@DissidioAcordoMes)), @OrdemAux, @OrdemAux + 34
					-- estabelecimento/lotacao
					SELECT @Tomadores	= ''
					SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, NULL))
					IF RTRIM(LTRIM(@Tomadores)) <> '' -- tem tomadores
					BEGIN
						-- cria temp tomadores
						SELECT	CodigoClifor = c.CodigoCliFor
						INTO #tmpTomadoresDissidio2299
						FROM tbTomadorFunc a,
							 tbTomadorServico b,
							 tbCliFor c
						WHERE a.CodigoEmpresa		= b.CodigoEmpresa
						AND   a.CodigoLocal			= b.CodigoLocal
						AND   a.CodigoCliFor		= b.CodigoCliFor
						AND   b.CodigoEmpresa       = c.CodigoEmpresa
						AND   b.CodigoCliFor        = c.CodigoCliFor
						AND   a.CodigoEmpresa		= @curCodigoEmpresa
						AND   a.CodigoLocal			= @curCodigoLocal
						AND   a.TipoColaborador		= @curTipoColaborador
						AND   a.NumeroRegistro		= @curNumeroRegistro
						AND   (
								(b.DataIniValidade <= @DataApuracao AND b.DataFimValidade IS NULL)
								OR (@DataApuracao BETWEEN b.DataIniValidade AND b.DataFimValidade)
							  )

						WHILE EXISTS ( SELECT 1 FROM #tmpTomadoresDissidio2299 )
						BEGIN
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, '', 0, 'N', '2', '201407', 'N'
							-- pega o 1.o
							SELECT TOP 1 @curCodigoCliFor = CodigoCliFor FROM #tmpTomadoresDissidio2299
							SELECT @Tomadores	= ''
							SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, @curCodigoCliFor))
							-- insere na temp original
							IF RTRIM(LTRIM(@Tomadores)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@Tomadores)), @OrdemAux, @OrdemAux + 35
							-- limpa variaveis
							SET @OrdemAux = @OrdemAux + 36
							-- deleta 1.o registro
							DELETE #tmpTomadoresDissidio2299 WHERE CodigoCliFor = @curCodigoCliFor
						END
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpTomadoresDissidio2299 
						-- detalhes verbas
						SELECT @ValorRubricasV = ''
						SELECT @ValorRubricasV = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD = ''
						SELECT @ValorRubricasD = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB = ''
						SELECT @ValorRubricasB = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 37 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 38
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 39
						-- agente nocivo e codigo simples
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (
																	SELECT TOP 1
																		'<infoAgNocivo>' +
																			'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																		'</infoAgNocivo>' + 
																		--'<infoSimples>' +
																		--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																		--'</infoSimples>' +
																	'</ideEstabLot>' + 
																'</idePeriodo>' +
															'</ideADC>' +
														'</infoPerAnt>'  
																	FROM tbLocalFP a
																	
																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = a.CodigoEmpresa
																	AND c.CodigoLocal   = a.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																  )
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 40
						SELECT @LinhaAux = ''
					END
					ELSE -- nao tem tomadores
					BEGIN
						-- codigo lotacao
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT DISTINCT '<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
																		'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
																		'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbLocal b
																	ON  b.CodigoEmpresa = a.CodigoEmpresa
																	AND b.CodigoLocal   = a.CodigoLocal

																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = b.CodigoEmpresa
																	AND c.CodigoLocal   = b.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																)
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 41
						SELECT @LinhaAux = ''
						-- detalhes verbas
						SELECT @ValorRubricasV	= ''
						SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD	= ''
						SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB	= ''
						SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 42 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 43
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 44
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, '', 0, 'N', '2', '201407', 'N'
						-- agente nocivo e codigo simples
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT TOP 1 '<infoAgNocivo>' +
																					'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																				'</infoAgNocivo>' + 
																				--'<infoSimples>' +
																				--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																				--'</infoSimples>' +
																			'</ideEstabLot>' + 
																		'</idePeriodo>' + 
																	'</ideADC>' +
																'</infoPerAnt>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbLocal b
																	ON  b.CodigoEmpresa = a.CodigoEmpresa
																	AND b.CodigoLocal   = a.CodigoLocal

																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = b.CodigoEmpresa
																	AND c.CodigoLocal   = b.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																)
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 45
						SELECT @LinhaAux = ''
						-- limpa variaveis
						SET @OrdemAux = @OrdemAux + 46
					END -- fim tomadores
				END
				ELSE -- não tem lote de dissidio
				BEGIN
					SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoPerAnt>' 
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 47
					SELECT @LinhaAux = ''
				END
			END
			-- insere na temp original
			INSERT @xml SELECT '</dmDev>', @OrdemAux, @OrdemAux + 48
			-- limpa variaveis
			SET @OrdemAux = @OrdemAux + 49
			-- deleta 1.o registro
			DELETE #tmpPagamentos2299 
			WHERE CodigoEmpresa			= @curCodigoEmpresa
			AND   CodigoLocal			= @curCodigoLocal
			AND   TipoColaborador		= @curTipoColaborador
			AND   NumeroRegistro		= @curNumeroRegistro
			AND   PeriodoCompetencia	= @curPeriodoCompetencia
			AND   RotinaPagamento		= @curRotinaPagamento
			AND   DataPagamento			= @curDataPagamento			
		END -- fim temp pagamentos
		-- elimina a tabela ao fim do processamento
		DROP TABLE #tmpPagamentos2299 
		IF @ProcessoAdmJudMes <> '' AND @MultiplosVinculos <> '' 
		BEGIN
			INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)), @OrdemAux, @OrdemAux + 50
			INSERT @xml SELECT '<infoMV>' + 
									RTRIM(LTRIM(@MultiplosVinculos)) + 
								'</infoMV>' +
								--'<procCS>' + 
								--	'<nrProcJud>' + '</nrProcJud>' +
								--'</procCS>' +
								'</verbasResc>', 
								@OrdemAux,
								@OrdemAux + 51
		END
		ELSE
		BEGIN
			IF @ProcessoAdmJudMes = '' AND @MultiplosVinculos = '' 
			BEGIN
				INSERT @xml SELECT '</verbasResc>', @OrdemAux, @OrdemAux + 52			
			END
			ELSE
			BEGIN
				IF @ProcessoAdmJudMes <> '' INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)) + '</verbasResc>', @OrdemAux, @OrdemAux + 53
				IF @MultiplosVinculos <> '' INSERT @xml SELECT '<infoMV>' + RTRIM(LTRIM(@MultiplosVinculos)) + '</infoMV>' + '</verbasResc>', @OrdemAux, @OrdemAux + 54
			END
		END
	END
	ELSE -- não tem movimento quitacao
	BEGIN
--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, null,'', 0, 'N', '2', '201407', 'N'
		IF @ProcessoAdmJudMes <> '' AND @MultiplosVinculos <> '' 
		BEGIN
			INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)), @OrdemAux, @OrdemAux + 55
			INSERT @xml SELECT '<infoMV>' + 
									RTRIM(LTRIM(@MultiplosVinculos)) + 
								'</infoMV>' +
								--'<procCS>' + 
								--	'<nrProcJud>' + '</nrProcJud>' +
								--'</procCS>' +
								'</verbasResc>',
								@OrdemAux, 
								@OrdemAux + 56
		END
		ELSE
		BEGIN
			IF @ProcessoAdmJudMes <> '' INSERT @xml SELECT '<verbasResc>' + RTRIM(LTRIM(@ProcessoAdmJudMes)) + '</verbasResc>', @OrdemAux, @OrdemAux + 57
			IF @MultiplosVinculos <> '' INSERT @xml SELECT '<verbasResc>' + '<infoMV>' + RTRIM(LTRIM(@MultiplosVinculos)) + '</infoMV>' + '</verbasResc>', @OrdemAux, @OrdemAux + 58		
		END
	END
	-- fecha as tags
	INSERT @xml
	SELECT DISTINCT
				-- nao fiz quarentena
				--'<quarentena>' +
				--	'<dtFimQuar>' + '' + '</dtFimQuar>'
				--'</quarentena>' +
				-- nao fiz consigFGTS
				--'<consigFGTS>' +
				--	'<insConsig>' + '' + '</insConsig>' +
				--	'<nrContr>' + '' + '</nrContr>' +
				--'</consigFGTS>' +				
			'</infoDeslig>' +
		'</evtDeslig>' +
	'</eSocial>',

--whArquivosFPESocialXML 1608, 'S-2299', 0, 'I', 'N', 'F', 22, 121324, '', 0, 'N', '2', '201407', 'N'

	@OrdemAux,
	@OrdemAux + 58
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

 	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoDemissao
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoDemissao

	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
END
GOTO ARQ_FIM

ARQ_S2300: 
---- INICIO XML Evento Trabalhador Sem Vínculo de Emprego/Estatutário - Início
BEGIN
	SELECT @Dependentes		= ''
	SELECT @SalarioFixo		= ''

	SELECT @Dependentes		= (SELECT dbo.fnESocialDependentes (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, @PerApuracao))
	SELECT @SalarioFixo		= (SELECT dbo.fnESocialSalarioAtual (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))

	IF @CargaInicial = 'S'
	BEGIN
		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTSVInicio/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTSVInicio Id="ID' + 
												COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
												COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
												@DataHoraProc +
												@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(o.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
					'<trabalhador>' +
						'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
						'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
						'<nmTrab>' + COALESCE(RTRIM(LTRIM(d.NomePessoal)),'') + '</nmTrab>' +
						'<sexo>' + COALESCE(RTRIM(LTRIM(c.SexoColaborador)),'') + '</sexo>' +
						'<racaCor>' + COALESCE(RTRIM(LTRIM(e.RacaCorESocial)),'') + '</racaCor>' +
						'<estCiv>' + COALESCE(RTRIM(LTRIM(f.CodigoESocial)),'') + '</estCiv>' +
						'<grauInstr>' + COALESCE(RTRIM(LTRIM(RIGHT(CONVERT(CHAR(3), 100 + g.GrauInstrucaoESocial),2))),'') + '</grauInstr>' +
						--Nome social para travesti ou transexual ( usei o nomeusual ja existente no Dealer )
						CASE WHEN COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') = '' THEN
							''
						ELSE
							'<nmSoc>' + COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') + '</nmSoc>' 
						END +
						'<nascimento>' +
							'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
							'</dtNascto>' + 
							CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioNascto),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(c.UFNascimentoColaborador)),'') + '</uf>'
							ELSE
								''
							END +
							'<paisNascto>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNascto,3))),'') + '</paisNascto>' +
							'<paisNac>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNacionalidade,3))),'') + '</paisNac>' +
							'<nmMae>' + COALESCE(RTRIM(LTRIM(c.NomeMae)),'') + '</nmMae>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(c.NomePai)),'') = '' THEN
								''
							ELSE
								'<nmPai>' + COALESCE(RTRIM(LTRIM(c.NomePai)),'') + '</nmPai>' 
							END +
						'</nascimento>' +
						'<documentos>' +
						CASE WHEN c.NumeroCTPS IS NOT NULL THEN
							'<CTPS>' +
								'<nrCtps>' + RIGHT(CONVERT(VARCHAR(9), 100000000 + COALESCE(RTRIM(LTRIM(c.NumeroCTPS)),'00000000')),8) + '</nrCtps>' +
								'<serieCtps>' + RIGHT(COALESCE(RTRIM(LTRIM(c.SerieCTPS)),'00000'),5) + '</serieCtps>' +
								'<ufCtps>' + COALESCE(RTRIM(LTRIM(c.UFCTPS)),'') + '</ufCtps>' +
							'</CTPS>' 
						ELSE 
							'' 
						END +
		-- não temos no Dealer
		--					'<RIC>' +
		--						'<nrRic>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrRic>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--					'</RIC>' +
						CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
							'<RG>' +
								'<nrRg>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRg>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RG>' 
						ELSE
							'<RNE>' +
								'<nrRne>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRne>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RNE>' 
						END +
		-- não temos no Dealer
		--					'<OC>' +
		--						'<nrOc>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrOc>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--						'<dtValid>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtValid>' +
		--					'</OC>' +
						CASE WHEN c.NumeroCarteiraHabilitacao IS NOT NULL THEN
							'<CNH>' +
								'<nrRegCnh>' + COALESCE(RTRIM(LTRIM(c.NumeroCarteiraHabilitacao)),'') + '</nrRegCnh>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ExpedicaoHabilitacao)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ExpedicaoHabilitacao)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ExpedicaoHabilitacao)),2,2),'') +
								'</dtExped>' + 
								CASE WHEN c.UFEmissorCNH IS NULL OR c.UFEmissorCNH = '' THEN
									''
								ELSE
									'<ufCnh>' + COALESCE(RTRIM(LTRIM(c.UFEmissorCNH)),'') + '</ufCnh>'
								END +
								'<dtValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ValidadeHabilitacao)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ValidadeHabilitacao)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ValidadeHabilitacao)),2,2),'') +
								'</dtValid>' + 
		--nao tem no Dealer			'<dtPriHab>' + '' + '</dtPriHab>' +
								'<categoriaCnh>' + COALESCE(RTRIM(LTRIM(c.CategoriaHabilitacao)),'') + '</categoriaCnh>' +
							'</CNH>' 
						ELSE
							''
						END +
						'</documentos>' +
						'<endereco>' +
						CASE WHEN j.SiglaPais = 'BR' THEN
							'<brasil>' +
								'<tpLograd>' + COALESCE(RTRIM(LTRIM(i.TipoLogradouro)),'') + '</tpLograd>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<cep>' + COALESCE(RTRIM(LTRIM(i.CEPColaborador)),'') + '</cep>' +
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),i.CodigoMunicipio),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(i.UFColaborador)),'') + '</uf>' +
							'</brasil>' 
						ELSE
							'<exterior>' +
								'<paisResid>' + COALESCE(RTRIM(LTRIM(LEFT(i.CodigoPaisResidencia,3))),'') + '</paisResid>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<nmCid>' + COALESCE(RTRIM(LTRIM(i.MunicipioColaborador)),'') + '</nmCid>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') = '' THEN
									''
								ELSE
									'<codPostal>' + COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') + '</codPostal>' 
								END +
							'</exterior>' 
						END +
						'</endereco>' +
						CASE WHEN h.NacionalidadeBrasileira = 'F' THEN
						'<trabEstrangeiro>' +
							'<dtChegada>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataChegada)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataChegada)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataChegada)),2,2),'') +
							'</dtChegada>' + 
							'<classTrabEstrang>' + COALESCE(RTRIM(LTRIM(c.ClassTrabEstrangeiro)),'') + '</classTrabEstrang>' +
							'<casadoBr>' + CASE WHEN c.CasadoComBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</casadoBr>' +
							'<filhosBr>' + CASE WHEN c.FilhoBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</filhosBr>' +
						'</trabEstrangeiro>' 
						ELSE
							''
						END + 
						CASE WHEN c.DeficienteFisico = 'V' THEN
						'<infoDeficiencia>' +
							'<defFisica>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 1 THEN 'S' ELSE 'N' END + '</defFisica>' +
							'<defVisual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 3 THEN 'S' ELSE 'N' END + '</defVisual>' +
							'<defAuditiva>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 2 THEN 'S' ELSE 'N' END + '</defAuditiva>' +
							'<defMental>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 4 THEN 'S' ELSE 'N' END + '</defMental>' +
							'<defIntelectual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 5 THEN 'S' ELSE 'N' END + '</defIntelectual>' +
							'<reabReadap>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 6 THEN 'S' ELSE 'N' END + '</reabReadap>' +
							-- não criei este campo
							--'<observacao>' + '' + '</observacao>' +
						'</infoDeficiencia>' 
						ELSE
							''
						END +
						CASE WHEN @Dependentes <> '' THEN
							@Dependentes 
						ELSE
							''
						END +
						'<contato>' +
							CASE WHEN i.TelefoneColaborador IS NULL OR i.TelefoneColaborador = '' THEN
								''
							ELSE
								'<fonePrinc>' + COALESCE(RTRIM(LTRIM(i.DDDColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneColaborador)),'') + '</fonePrinc>'
							END +
							CASE WHEN i.TelefoneCelularColaborador IS NULL OR i.TelefoneCelularColaborador = '' THEN
								''
							ELSE
								'<foneAlternat>' + COALESCE(RTRIM(LTRIM(i.DDDTelefoneCelularColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneCelularColaborador)),'') + '</foneAlternat>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailPrinc>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailPrinc>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailAlternat>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailAlternat>'
							END +
						'</contato>' +
					'</trabalhador>' +
					'<infoTSVInicio>' +
						--CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(o.TipoAmbiente)),'2')) = 2 THEN
						--	CASE WHEN COALESCE(c.DataAdmissao,'2016-01-01') >= '2016-01-01' AND
						--				COALESCE(c.DataAdmissao,'2016-01-01') <= COALESCE(o.DataESocialIniciadoFase2,'2016-01-01') THEN
						--		'<cadIni>' + 'N' + '</cadIni>' 
						--	ELSE
						--		'<cadIni>' + 'S' + '</cadIni>' 
						--	END 
						--ELSE							
						--	'<cadIni>' + 'S' + '</cadIni>' 
						--END +
						'<cadIni>' + 'S' + '</cadIni>' +
						'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
						'<dtInicio>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao)),2,2),'') +
						'</dtInicio>' + 
						--'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>' 
						'<infoComplementares>' + 
						CASE WHEN RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) IN (721,722) THEN
							'<cargoFuncao>' + 
								'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
								--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
							'</cargoFuncao>' 
						ELSE
							''
						END +
						CASE WHEN @SalarioFixo <> '' THEN
							'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
						ELSE
							'' 
						END +
							--'<fgts>' +
								--'<opcFGTS>' + '1' + '</opcFGTS>' +
									--'<dtOpcFGTS>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataOpcaoFGTS)),2,4),'') + '-' +
									--					COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataOpcaoFGTS)),2,2),'') + '-' +
									--					COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataOpcaoFGTS)),2,2),'') +
								--'</dtOpcFGTS>'  
							--'</fgts>' 
							-- dirigente sindical -- nao fiz
							--'<infoDirigenteSindical>' +
							--	'<categOrig>' + '' + '</categOrig>' +
							--	'<cnpjOrigem>' + '' + '</cnpjOrigem>' +
							--	'<dtAdmOrig>' + '' + '</dtAdmOrig>' +
							--	'<matricOrig>' + '' + '</matricOrig>' +
							--'</infoDirigenteSindical>' 
							-- trabalhador cediro -- nao fiz
							--'<infoTrabCedido>' +
							--	'<categOrig>' + '' + '</categOrig>' +
							--	'<cnpjCednt>' + '' + '</cnpjCednt>' +
							--	'<matricCed>' + '' + '</matricCed>' +
							--	'<dtAdmCed>' + '' + '</dtAdmCed>' +
							--	'<tpRegTrab>' + '' + '</tpRegTrab>' +
							--	'<tpRegPrev>' + '' + '</tpRegPrev>' +
							--	'<infOnus>' + '' + '</infOnus>' +
							--'</infoTrabCedido>' 
						CASE WHEN @TipoColaborador = 'E' THEN -- todos os estagiarios
							'<infoEstagiario>' +
							CASE WHEN t.Obrigatorio = 'V' THEN
								'<natEstagio>' + 'O' + '</natEstagio>' 
							ELSE
								'<natEstagio>' + 'N' + '</natEstagio>' 
							END +
								'<nivEstagio>' + COALESCE(RTRIM(LTRIM(t.Nivel)),'') + '</nivEstagio>' +
								'<areaAtuacao>' + COALESCE(RTRIM(LTRIM(t.AreaAtuacao)),'') + '</areaAtuacao>' +
								'<nrApol>' + COALESCE(RTRIM(LTRIM(t.NumeroApolice)),'') + '</nrApol>' +
								'<vlrBolsa>' + COALESCE(REPLACE(CONVERT(VARCHAR(16),@SalarioFixo),',','.'),'0,00') + '</vlrBolsa>' +
								'<dtPrevTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao + (t.MesesDuracao * 30))),2,4),'') + '-' +
												 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') + '-' +
												 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') +
								'</dtPrevTerm>' + 
								'<instEnsino>' + 
									'<cnpjInstEnsino>' + COALESCE(RTRIM(LTRIM(t.CNPJInstEnsino)),'') + '</cnpjInstEnsino>' +
									'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeInstEnsino)),'') + '</nmRazao>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrInstEnsino)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrInstEnsino)),'') + '</nrLograd>' +
									'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroInstEnsino)),'') + '</bairro>' +
									'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPInstEnsino)),'') + '</cep>' +
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicInstEnsino),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(t.UFInstEnsino)),'') + '</uf>' +
								'</instEnsino>' +
								'<ageIntegracao>' + 
									'<cnpjAgntInteg>' + COALESCE(RTRIM(LTRIM(t.CNPJAgtIntegracao)),'') + '</cnpjAgntInteg>' +
									'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeAgtIntegracao)),'') + '</nmRazao>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrAgtIntegracao)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrAgtIntegracao)),'') + '</nrLograd>' +
									'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroAgtIntegracao)),'') + '</bairro>' +
									'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPAgtIntegracao)),'') + '</cep>' +
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicAgtIntegracao),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(t.UFAgtIntegracao)),'') + '</uf>' +
								'</ageIntegracao>' + 
								'<supervisorEstagio>' + 
									'<cpfSupervisor>' + COALESCE(RTRIM(LTRIM(t.CPFCoordenador)),'') + '</cpfSupervisor>' +
									'<nmSuperv>' + COALESCE(RTRIM(LTRIM(t.NomeCoordenador)),'') + '</nmSuperv>' +
								'</supervisorEstagio>' +
							'</infoEstagiario>' 
						ELSE
							''
						END +
						'</infoComplementares>' +
						-- terceiros nao tem afastamento no Dealer
	--					'<afastamento>' +
	--						'<dtIniAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataInicioAfastamentoHist)),2,4),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataInicioAfastamentoHist)),2,2),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataInicioAfastamentoHist)),2,2),'') +
	--						'</dtIniAfast>' + 
	--						'<codMotAfast>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'') + '</codMotAfast>' +
	--					'</afastamento>' +
	--					'<termino>' +
	--						'<dtTerm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataTerminoAfastamentoHist)),2,4),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataTerminoAfastamentoHist)),2,2),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataTerminoAfastamentoHist)),2,2),'') +
	--						'</dtTerm>' + 					
					'</infoTSVInicio>' +
				'</evtTSVInicio>' +
			'</eSocial>',
			d.MatriculaESocial,
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbColaborador c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
						
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa		= c.CodigoEmpresa
			AND d.CodigoLocal		= c.CodigoLocal
			AND d.TipoColaborador	= c.TipoColaborador
			AND d.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbRacaCor e
			ON  e.CodigoRacaCor	= c.CodigoRacaCor

			LEFT JOIN tbEstadoCivil f
			ON  f.CodigoEstadoCivil	= c.CodigoEstadoCivil
			
			LEFT JOIN tbGrauInstrucao g
			ON  g.CodigoGrauInstrucao = c.CodigoGrauInstrucao

			LEFT JOIN tbNacionalidade h
			ON  h.CodigoNacionalidade = c.CodigoNacionalidade

			INNER JOIN tbColaboradorEndereco i
			ON  i.CodigoEmpresa		= c.CodigoEmpresa
			AND i.CodigoLocal		= c.CodigoLocal
			AND i.TipoColaborador	= c.TipoColaborador
			AND i.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbPais j
			ON j.IdPais = i.CodigoPaisResidencia
			
			LEFT JOIN tbPessoal k
			ON  k.CodigoEmpresa		= c.CodigoEmpresa
			AND k.CodigoLocal		= c.CodigoLocal
			AND k.TipoColaborador	= c.TipoColaborador
			AND k.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbTipoMovimentacaoFolha l 
			ON  l.CodigoEmpresa				= k.CodigoEmpresa 
			AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
			AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

			LEFT JOIN tbCargo m
			ON  m.CodigoEmpresa	= c.CodigoEmpresa
			AND m.CodigoLocal   = c.CodigoLocal
			AND m.CodigoCargo   = c.CodigoCargo
			
			LEFT JOIN tbFuncionario n
			ON  n.CodigoEmpresa		= c.CodigoEmpresa
			AND n.CodigoLocal		= c.CodigoLocal
			AND n.TipoColaborador	= c.TipoColaborador
			AND n.NumeroRegistro	= c.NumeroRegistro
					
			INNER JOIN tbEmpresaFP o
			ON o.CodigoEmpresa = a.CodigoEmpresa

			LEFT JOIN tbEstagio t
			ON	t.CodigoEmpresa		= c.CodigoEmpresa
			AND	t.CodigoEstagio		= c.CodigoEstagio

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal
			AND   c.CodigoEmpresa	= @CodigoEmpresa
			AND   c.CodigoLocal		= @CodigoLocal
			AND   c.TipoColaborador = @TipoColaborador
			AND   c.NumeroRegistro  = @NumeroRegistro
			AND   (
					c.TipoColaborador IN ('E','T')
					OR (
						c.TipoColaborador = 'F' AND k.CondicaoINSS = 'P'
						)
					)
	END
	ELSE -- não é carga inicial
	BEGIN
		-- dados empresa
		INSERT @xml
		SELECT DISTINCT
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTSVInicio/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
			'<evtTSVInicio Id="ID' + 
												COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
												COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
												@DataHoraProc +
												@SequenciaArq + '">' +
				'<ideEvento>' + 
				CASE WHEN @TipoRegistro = 'O' THEN
					'<indRetif>' + '1' + '</indRetif>' 
				ELSE
					'<indRetif>' + '2' + '</indRetif>' +
					'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
				END +
				'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(o.TipoAmbiente)),'2')) + '</tpAmb>' +
				'<procEmi>' + '1' + '</procEmi>' +
				'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
				'</ideEvento>' +
				'<ideEmpregador>' +
					'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
					'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
				'</ideEmpregador>' +
					'<trabalhador>' +
						'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
						'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
						'<nmTrab>' + COALESCE(RTRIM(LTRIM(d.NomePessoal)),'') + '</nmTrab>' +
						'<sexo>' + COALESCE(RTRIM(LTRIM(c.SexoColaborador)),'') + '</sexo>' +
						'<racaCor>' + COALESCE(RTRIM(LTRIM(e.RacaCorESocial)),'') + '</racaCor>' +
						'<estCiv>' + COALESCE(RTRIM(LTRIM(f.CodigoESocial)),'') + '</estCiv>' +
						'<grauInstr>' + COALESCE(RTRIM(LTRIM(RIGHT(CONVERT(CHAR(3), 100 + g.GrauInstrucaoESocial),2))),'') + '</grauInstr>' +
						--Nome social para travesti ou transexual ( usei o nomeusual ja existente no Dealer )
						CASE WHEN COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') = '' THEN
							''
						ELSE
							'<nmSoc>' + COALESCE(RTRIM(LTRIM(d.NomeUsualColaborador)),'') + '</nmSoc>' 
						END +
						'<nascimento>' +
							'<dtNascto>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataNascimentoColaborador)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataNascimentoColaborador)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataNascimentoColaborador)),2,2),'') +
							'</dtNascto>' + 
							CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),c.CodigoMunicipioNascto),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(c.UFNascimentoColaborador)),'') + '</uf>' 
							ELSE
								''
							END +			
							'<paisNascto>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNascto,3))),'') + '</paisNascto>' +
							'<paisNac>' + COALESCE(RTRIM(LTRIM(LEFT(c.CodigoPaisNacionalidade,3))),'') + '</paisNac>' +
							'<nmMae>' + COALESCE(RTRIM(LTRIM(c.NomeMae)),'') + '</nmMae>' +
							CASE WHEN COALESCE(RTRIM(LTRIM(c.NomePai)),'') = '' THEN
								''
							ELSE
								'<nmPai>' + COALESCE(RTRIM(LTRIM(c.NomePai)),'') + '</nmPai>' 
							END +
						'</nascimento>' +
						'<documentos>' +
						CASE WHEN c.NumeroCTPS IS NOT NULL THEN
							'<CTPS>' +
								'<nrCtps>' + RIGHT(CONVERT(VARCHAR(9), 100000000 + COALESCE(RTRIM(LTRIM(c.NumeroCTPS)),'00000000')),8) + '</nrCtps>' +
								'<serieCtps>' + RIGHT(COALESCE(RTRIM(LTRIM(c.SerieCTPS)),'00000'),5) + '</serieCtps>' +
								'<ufCtps>' + COALESCE(RTRIM(LTRIM(c.UFCTPS)),'') + '</ufCtps>' +
							'</CTPS>' 
						ELSE 
							'' 
						END +
		-- não temos no Dealer
		--					'<RIC>' +
		--						'<nrRic>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrRic>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--					'</RIC>' +
						CASE WHEN h.NacionalidadeBrasileira = 'V' THEN
							'<RG>' +
								'<nrRg>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRg>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RG>' 
						ELSE
							'<RNE>' +
								'<nrRne>' + COALESCE(RTRIM(LTRIM(c.NumeroRGColaborador)),'') + '</nrRne>' +
								'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.OrgaoExpedicaoRGColaborador)),'') + COALESCE(RTRIM(LTRIM(c.UFExpedicaoRGColaborador)),'') +'</orgaoEmissor>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataExpedicaoRGColaborador)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataExpedicaoRGColaborador)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataExpedicaoRGColaborador)),2,2),'') +
								'</dtExped>' + 
							'</RNE>' 
						END +
		-- não temos no Dealer
		--					'<OC>' +
		--						'<nrOc>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</nrOc>' +
		--						'<orgaoEmissor>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</orgaoEmissor>' +
		--						'<dtExped>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtExped>' +
		--						'<dtValid>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</dtValid>' +
		--					'</OC>' +
						CASE WHEN c.NumeroCarteiraHabilitacao IS NOT NULL THEN
							'<CNH>' +
								'<nrRegCnh>' + COALESCE(RTRIM(LTRIM(c.NumeroCarteiraHabilitacao)),'') + '</nrRegCnh>' +
								'<dtExped>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ExpedicaoHabilitacao)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ExpedicaoHabilitacao)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ExpedicaoHabilitacao)),2,2),'') +
								'</dtExped>' + 
								CASE WHEN c.UFEmissorCNH IS NULL OR c.UFEmissorCNH = '' THEN
									''
								ELSE
									'<ufCnh>' + COALESCE(RTRIM(LTRIM(c.UFEmissorCNH)),'') + '</ufCnh>'
								END +
								'<dtValid>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.ValidadeHabilitacao)),2,4),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.ValidadeHabilitacao)),2,2),'') + '-' +
											  COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.ValidadeHabilitacao)),2,2),'') +
								'</dtValid>' + 
		--nao tem no Dealer			'<dtPriHab>' + '' + '</dtPriHab>' +
								'<categoriaCnh>' + COALESCE(RTRIM(LTRIM(c.CategoriaHabilitacao)),'') + '</categoriaCnh>' +
							'</CNH>' 
						ELSE
							''
						END +
						'</documentos>' +
						'<endereco>' +
						CASE WHEN j.SiglaPais = 'BR' THEN
							'<brasil>' +
								'<tpLograd>' + COALESCE(RTRIM(LTRIM(i.TipoLogradouro)),'') + '</tpLograd>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<cep>' + COALESCE(RTRIM(LTRIM(i.CEPColaborador)),'') + '</cep>' +
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),i.CodigoMunicipio),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(i.UFColaborador)),'') + '</uf>' +
							'</brasil>' 
						ELSE
							'<exterior>' +
								'<paisResid>' + COALESCE(RTRIM(LTRIM(LEFT(i.CodigoPaisResidencia,3))),'') + '</paisResid>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(i.RuaColaborador)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(i.NumeroEndColaborador)),'S/N') + '</nrLograd>' +
								CASE WHEN i.ComplementoEndColaborador IS NULL OR i.ComplementoEndColaborador = '' THEN
									''
								ELSE
									'<complemento>' + COALESCE(RTRIM(LTRIM(i.ComplementoEndColaborador)),'') + '</complemento>'
								END +
								'<bairro>' + COALESCE(RTRIM(LTRIM(LEFT(i.BairroColaborador,60))),'') + '</bairro>' +
								'<nmCid>' + COALESCE(RTRIM(LTRIM(i.MunicipioColaborador)),'') + '</nmCid>' +
								CASE WHEN COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') = '' THEN
									''
								ELSE
									'<codPostal>' + COALESCE(RTRIM(LTRIM(i.CodigoPostal)),'') + '</codPostal>' 
								END +
							'</exterior>' 
						END +
						'</endereco>' +
						CASE WHEN h.NacionalidadeBrasileira = 'F' THEN
						'<trabEstrangeiro>' +
							'<dtChegada>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataChegada)),2,4),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataChegada)),2,2),'') + '-' +
											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataChegada)),2,2),'') +
							'</dtChegada>' + 
							'<classTrabEstrang>' + COALESCE(RTRIM(LTRIM(c.ClassTrabEstrangeiro)),'') + '</classTrabEstrang>' +
							'<casadoBr>' + CASE WHEN c.CasadoComBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</casadoBr>' +
							'<filhosBr>' + CASE WHEN c.FilhoBrasileiro = 'F' THEN 'N' ELSE 'S' END + '</filhosBr>' +
						'</trabEstrangeiro>' 
						ELSE
							''
						END + 
						CASE WHEN c.DeficienteFisico = 'V' THEN
						'<infoDeficiencia>' +
							'<defFisica>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 1 THEN 'S' ELSE 'N' END + '</defFisica>' +
							'<defVisual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 3 THEN 'S' ELSE 'N' END + '</defVisual>' +
							'<defAuditiva>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 2 THEN 'S' ELSE 'N' END + '</defAuditiva>' +
							'<defMental>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 4 THEN 'S' ELSE 'N' END + '</defMental>' +
							'<defIntelectual>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 5 THEN 'S' ELSE 'N' END + '</defIntelectual>' +
							'<reabReadap>' + CASE WHEN RIGHT(LTRIM(RTRIM(c.TipoDeficiencia)),1) = 6 THEN 'S' ELSE 'N' END + '</reabReadap>' +
							-- não criei este campo
							--'<observacao>' + '' + '</observacao>' +
						'</infoDeficiencia>' 
						ELSE
							''
						END +
						CASE WHEN @Dependentes <> '' THEN
							@Dependentes 
						ELSE
							''
						END +
						'<contato>' +
							CASE WHEN i.TelefoneColaborador IS NULL OR i.TelefoneColaborador = '' THEN
								''
							ELSE
								'<fonePrinc>' + COALESCE(RTRIM(LTRIM(i.DDDColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneColaborador)),'') + '</fonePrinc>'
							END +
							CASE WHEN i.TelefoneCelularColaborador IS NULL OR i.TelefoneCelularColaborador = '' THEN
								''
							ELSE
								'<foneAlternat>' + COALESCE(RTRIM(LTRIM(i.DDDTelefoneCelularColaborador)),'') + COALESCE(RTRIM(LTRIM(i.TelefoneCelularColaborador)),'') + '</foneAlternat>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailPrinc>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailPrinc>'
							END +
							CASE WHEN i.EMailColaborador IS NULL OR i.EMailColaborador = '' THEN
								''
							ELSE
								'<emailAlternat>' + COALESCE(RTRIM(LTRIM(i.EMailColaborador)),'') + '</emailAlternat>'
							END +
						'</contato>' +
					'</trabalhador>' +
					'<infoTSVInicio>' +
						--CASE WHEN COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(o.TipoAmbiente)),'2')) = 2 THEN
						--	CASE WHEN COALESCE(c.DataAdmissao,'2016-01-01') >= '2016-01-01' AND
						--				COALESCE(c.DataAdmissao,'2016-01-01') <= COALESCE(o.DataESocialIniciadoFase2,'2016-01-01') THEN
						--		'<cadIni>' + 'N' + '</cadIni>' 
						--	ELSE
						--		'<cadIni>' + 'S' + '</cadIni>' 
						--	END 
						--ELSE							
						--	'<cadIni>' + 'N' + '</cadIni>' 
						--END +
						'<cadIni>' + 'N' + '</cadIni>' +
						'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
						'<dtInicio>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao)),2,4),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao)),2,2),'') + '-' +
										COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao)),2,2),'') +
						'</dtInicio>' + 
						--'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>' 
						'<infoComplementares>' + 
						CASE WHEN RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) IN (721,722) THEN
							'<cargoFuncao>' + 
								'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
								--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
							'</cargoFuncao>' 
						ELSE
							''
						END +
						CASE WHEN @SalarioFixo <> '' THEN
							'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
						ELSE
							'' 
						END +
							--'<fgts>' +
								--'<opcFGTS>' + '1' + '</opcFGTS>' +
									--'<dtOpcFGTS>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,n.DataOpcaoFGTS)),2,4),'') + '-' +
									--					COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,n.DataOpcaoFGTS)),2,2),'') + '-' +
									--					COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,n.DataOpcaoFGTS)),2,2),'') +
									--'</dtOpcFGTS>'  
								--'<opcFGTS>' + '2' + '</opcFGTS>' 
							--'</fgts>' 
							-- dirigente sindical -- nao fiz
							--'<infoDirigenteSindical>' +
							--	'<categOrig>' + '' + '</categOrig>' +
							--	'<cnpjOrigem>' + '' + '</cnpjOrigem>' +
							--	'<dtAdmOrig>' + '' + '</dtAdmOrig>' +
							--	'<matricOrig>' + '' + '</matricOrig>' +
							--'</infoDirigenteSindical>' 
							-- trabalhador cediro -- nao fiz
							--'<infoTrabCedido>' +
							--	'<categOrig>' + '' + '</categOrig>' +
							--	'<cnpjCednt>' + '' + '</cnpjCednt>' +
							--	'<matricCed>' + '' + '</matricCed>' +
							--	'<dtAdmCed>' + '' + '</dtAdmCed>' +
							--	'<tpRegTrab>' + '' + '</tpRegTrab>' +
							--	'<tpRegPrev>' + '' + '</tpRegPrev>' +
							--	'<infOnus>' + '' + '</infOnus>' +
							--'</infoTrabCedido>' 
						CASE WHEN @TipoColaborador = 'E' THEN -- todos os estagiarios
							'<infoEstagiario>' +
							CASE WHEN t.Obrigatorio = 'V' THEN
								'<natEstagio>' + 'O' + '</natEstagio>' 
							ELSE
								'<natEstagio>' + 'N' + '</natEstagio>' 
							END +
								'<nivEstagio>' + COALESCE(RTRIM(LTRIM(t.Nivel)),'') + '</nivEstagio>' +
								'<areaAtuacao>' + COALESCE(RTRIM(LTRIM(t.AreaAtuacao)),'') + '</areaAtuacao>' +
								'<nrApol>' + COALESCE(RTRIM(LTRIM(t.NumeroApolice)),'') + '</nrApol>' +
								'<vlrBolsa>' + COALESCE(REPLACE(CONVERT(VARCHAR(16),@SalarioFixo),',','.'),'0,00') + '</vlrBolsa>' +
								'<dtPrevTerm>' + COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao + (t.MesesDuracao * 30))),2,4),'') + '-' +
												 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') + '-' +
												 COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') +
								'</dtPrevTerm>' + 
								'<instEnsino>' + 
									'<cnpjInstEnsino>' + COALESCE(RTRIM(LTRIM(t.CNPJInstEnsino)),'') + '</cnpjInstEnsino>' +
									'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeInstEnsino)),'') + '</nmRazao>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrInstEnsino)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrInstEnsino)),'') + '</nrLograd>' +
									'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroInstEnsino)),'') + '</bairro>' +
									'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPInstEnsino)),'') + '</cep>' +
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicInstEnsino),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(t.UFInstEnsino)),'') + '</uf>' +
								'</instEnsino>' +
								'<ageIntegracao>' + 
									'<cnpjAgntInteg>' + COALESCE(RTRIM(LTRIM(t.CNPJAgtIntegracao)),'') + '</cnpjAgntInteg>' +
									'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeAgtIntegracao)),'') + '</nmRazao>' +
									'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrAgtIntegracao)),'') + '</dscLograd>' +
									'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrAgtIntegracao)),'') + '</nrLograd>' +
									'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroAgtIntegracao)),'') + '</bairro>' +
									'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPAgtIntegracao)),'') + '</cep>' +
									'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicAgtIntegracao),0)))),7) + '</codMunic>' +
									'<uf>' + COALESCE(RTRIM(LTRIM(t.UFAgtIntegracao)),'') + '</uf>' +
								'</ageIntegracao>' + 
								'<supervisorEstagio>' + 
									'<cpfSupervisor>' + COALESCE(RTRIM(LTRIM(t.CPFCoordenador)),'') + '</cpfSupervisor>' +
									'<nmSuperv>' + COALESCE(RTRIM(LTRIM(t.NomeCoordenador)),'') + '</nmSuperv>' +
								'</supervisorEstagio>' +
							'</infoEstagiario>' 
						ELSE
							''
						END +
						'</infoComplementares>' +
						-- terceiros nao tem afastamento no Dealer
	--					'<afastamento>' +
	--						'<dtIniAfast>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataInicioAfastamentoHist)),2,4),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataInicioAfastamentoHist)),2,2),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataInicioAfastamentoHist)),2,2),'') +
	--						'</dtIniAfast>' + 
	--						'<codMotAfast>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'') + '</codMotAfast>' +
	--					'</afastamento>' +
	--					'<termino>' +
	--						'<dtTerm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,h.DataTerminoAfastamentoHist)),2,4),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,h.DataTerminoAfastamentoHist)),2,2),'') + '-' +
	--											COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,h.DataTerminoAfastamentoHist)),2,2),'') +
	--						'</dtTerm>' + 					
					'</infoTSVInicio>' +
				'</evtTSVInicio>' +
			'</eSocial>',
			d.MatriculaESocial,
			@OrdemAux + 1
			FROM tbLocalFP a
			
			INNER JOIN tbLocal b
			ON	b.CodigoEmpresa = a.CodigoEmpresa
			AND b.CodigoLocal   = a.CodigoLocal

			INNER JOIN tbColaborador c
			ON  c.CodigoEmpresa = a.CodigoEmpresa
			AND c.CodigoLocal   = a.CodigoLocal
						
			INNER JOIN tbColaboradorGeral d
			ON  d.CodigoEmpresa		= c.CodigoEmpresa
			AND d.CodigoLocal		= c.CodigoLocal
			AND d.TipoColaborador	= c.TipoColaborador
			AND d.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbRacaCor e
			ON  e.CodigoRacaCor	= c.CodigoRacaCor

			LEFT JOIN tbEstadoCivil f
			ON  f.CodigoEstadoCivil	= c.CodigoEstadoCivil
			
			LEFT JOIN tbGrauInstrucao g
			ON  g.CodigoGrauInstrucao = c.CodigoGrauInstrucao

			LEFT JOIN tbNacionalidade h
			ON  h.CodigoNacionalidade = c.CodigoNacionalidade

			INNER JOIN tbColaboradorEndereco i
			ON  i.CodigoEmpresa		= c.CodigoEmpresa
			AND i.CodigoLocal		= c.CodigoLocal
			AND i.TipoColaborador	= c.TipoColaborador
			AND i.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbPais j
			ON j.IdPais = i.CodigoPaisResidencia
			
			LEFT JOIN tbPessoal k
			ON  k.CodigoEmpresa		= c.CodigoEmpresa
			AND k.CodigoLocal		= c.CodigoLocal
			AND k.TipoColaborador	= c.TipoColaborador
			AND k.NumeroRegistro	= c.NumeroRegistro

			LEFT JOIN tbTipoMovimentacaoFolha l 
			ON  l.CodigoEmpresa				= k.CodigoEmpresa 
			AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
			AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

			LEFT JOIN tbCargo m
			ON  m.CodigoEmpresa	= c.CodigoEmpresa
			AND m.CodigoLocal   = c.CodigoLocal
			AND m.CodigoCargo   = c.CodigoCargo
			
			LEFT JOIN tbFuncionario n
			ON  n.CodigoEmpresa		= c.CodigoEmpresa
			AND n.CodigoLocal		= c.CodigoLocal
			AND n.TipoColaborador	= c.TipoColaborador
			AND n.NumeroRegistro	= c.NumeroRegistro
					
			INNER JOIN tbEmpresaFP o
			ON o.CodigoEmpresa = a.CodigoEmpresa

			LEFT JOIN tbEstagio t
			ON	t.CodigoEmpresa		= c.CodigoEmpresa
			AND	t.CodigoEstagio		= c.CodigoEstagio

			WHERE a.CodigoEmpresa	= @CodigoEmpresa
			AND   a.CodigoLocal		= @CodigoLocal
			AND   c.CodigoEmpresa	= @CodigoEmpresa
			AND   c.CodigoLocal		= @CodigoLocal
			AND   c.TipoColaborador = @TipoColaborador
			AND   c.NumeroRegistro  = @NumeroRegistro
			AND   (
					c.TipoColaborador IN ('E','T')
					OR (
						c.TipoColaborador = 'F' AND k.CondicaoINSS = 'P'
						)
					)
	END
	---- FIM XML Evento Trabalhador Sem Vínculo de Emprego/Estatutário - Início
END
GOTO ARQ_FIM

ARQ_S2306: 
---- INICIO XML Evento Trabalhador Sem Vínculo de Emprego/Estatutário - Alteração Contratual
BEGIN
	SELECT @SalarioFixo		= ''

	SELECT @SalarioFixo		= (SELECT dbo.fnESocialSalarioAtual (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro))

	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTSVAltContr/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtTSVAltContr Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideTrabSemVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
				'<infoTSVAlteracao>' +
					'<dtAlteracao>' + SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),7,4) + '-' +
										SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),4,2) + '-' +
										SUBSTRING(CONVERT(CHAR(10),GETDATE(),103),1,2) +	 
					'</dtAlteracao>' +
					--'<natAtividade>' + COALESCE(RTRIM(LTRIM(l.TipoVinculoTrabalhistaESocial)),'1') + '</natAtividade>'
					'<infoComplementares>' + 
					CASE WHEN RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) IN (721,722) THEN
						'<cargoFuncao>' + 
							'<codCargo>' + COALESCE(RTRIM(LTRIM(m.CodigoLocal)),'') + COALESCE(RTRIM(LTRIM(m.CodigoCargo)),'') + '</codCargo>' +
							--'<codFuncao>' + '' + '</codFuncao>' -- não fizemos o S-1040
						'</cargoFuncao>' 
					ELSE
						''
					END +
					CASE WHEN @SalarioFixo <> '' THEN
						'<remuneracao>' + @SalarioFixo + '</remuneracao>'  
					ELSE
						'' 
					END +
					CASE WHEN @TipoColaborador = 'E' THEN -- todos os estagiarios
						'<infoEstagiario>' +
						CASE WHEN t.Obrigatorio = 'V' THEN
							'<natEstagio>' + 'O' + '</natEstagio>' 
						ELSE
							'<natEstagio>' + 'N' + '</natEstagio>' 
						END +
							'<nivEstagio>' + COALESCE(RTRIM(LTRIM(t.Nivel)),'') + '</nivEstagio>' +
							'<areaAtuacao>' + COALESCE(RTRIM(LTRIM(t.AreaAtuacao)),'') + '</areaAtuacao>' +
							'<nrApol>' + COALESCE(RTRIM(LTRIM(t.NumeroApolice)),'') + '</nrApol>' +
							'<vlrBolsa>' + COALESCE(REPLACE(CONVERT(VARCHAR(16),@SalarioFixo),',','.'),'0,00') + '</vlrBolsa>' +
							'<dtPrevTerm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataAdmissao + (t.MesesDuracao * 30))),2,4),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') + '-' +
													COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataAdmissao + (t.MesesDuracao * 30))),2,2),'') +
							'</dtPrevTerm>' + 
							'<instEnsino>' + 
								'<cnpjInstEnsino>' + COALESCE(RTRIM(LTRIM(t.CNPJInstEnsino)),'') + '</cnpjInstEnsino>' +
								'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeInstEnsino)),'') + '</nmRazao>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrInstEnsino)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrInstEnsino)),'') + '</nrLograd>' +
								'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroInstEnsino)),'') + '</bairro>' +
								'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPInstEnsino)),'') + '</cep>' +
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicInstEnsino),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(t.UFInstEnsino)),'') + '</uf>' +
							'</instEnsino>' +
							'<ageIntegracao>' + 
								'<cnpjAgntInteg>' + COALESCE(RTRIM(LTRIM(t.CNPJAgtIntegracao)),'') + '</cnpjAgntInteg>' +
								'<nmRazao>' + COALESCE(RTRIM(LTRIM(t.NomeAgtIntegracao)),'') + '</nmRazao>' +
								'<dscLograd>' + COALESCE(RTRIM(LTRIM(t.DescrLogrAgtIntegracao)),'') + '</dscLograd>' +
								'<nrLograd>' + COALESCE(RTRIM(LTRIM(t.NroLogrAgtIntegracao)),'') + '</nrLograd>' +
								'<bairro>' + COALESCE(RTRIM(LTRIM(t.BairroAgtIntegracao)),'') + '</bairro>' +
								'<cep>' + COALESCE(RTRIM(LTRIM(t.CEPAgtIntegracao)),'') + '</cep>' +
								'<codMunic>' + RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),10000000 + COALESCE(CONVERT(NUMERIC(7),t.CodMunicAgtIntegracao),0)))),7) + '</codMunic>' +
								'<uf>' + COALESCE(RTRIM(LTRIM(t.UFAgtIntegracao)),'') + '</uf>' +
							'</ageIntegracao>' + 
							'<supervisorEstagio>' + 
								'<cpfSupervisor>' + COALESCE(RTRIM(LTRIM(t.CPFCoordenador)),'') + '</cpfSupervisor>' +
								'<nmSuperv>' + COALESCE(RTRIM(LTRIM(t.NomeCoordenador)),'') + '</nmSuperv>' +
							'</supervisorEstagio>' +
						'</infoEstagiario>' 
					ELSE
						''
					END +
					'</infoComplementares>' +
				'</infoTSVAlteracao>' + 
			'</ideTrabSemVinculo>' +
		'</evtTSVAltContr>' +
	'</eSocial>',
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbCargo m
	ON  m.CodigoEmpresa	= c.CodigoEmpresa
	AND m.CodigoLocal   = c.CodigoLocal
	AND m.CodigoCargo   = c.CodigoCargo
	
	LEFT JOIN tbEstagio t
	ON	t.CodigoEmpresa		= c.CodigoEmpresa
	AND	t.CodigoEstagio		= c.CodigoEstagio
	
	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoAdmissao 
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoAdmissao

	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
	AND   (
			c.TipoColaborador IN ('E','T')
			OR (
				c.TipoColaborador = 'F' AND k.CondicaoINSS = 'P'
				)
			)
	---- FIM XML Evento Trabalhador Sem Vínculo de Emprego/Estatutário - Alteração Contratual
END
GOTO ARQ_FIM

ARQ_S2399: 
---- INICIO XML Termino Trabalhador sem Vinculo
BEGIN
	SELECT @ProcessoAdmJudMes	= ''
	SELECT @MultiplosVinculos	= ''
	SELECT @ValorRubricasV		= ''
	SELECT @ValorRubricasD		= ''
	SELECT @ValorRubricasB		= ''
	
	SELECT @ProcessoAdmJudMes	= (SELECT dbo.fnESocialProcessosAdmJud (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao))
	SELECT @MultiplosVinculos	= (SELECT dbo.fnESocialRemuneracaoOutraEmpresa (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao))
	IF @DataInicioESocialFase3 <= GETDATE()
	BEGIN
		SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'V'))
		SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'D'))
		SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@CodigoEmpresa, @CodigoLocal, @TipoColaborador, @NumeroRegistro, @NomeArquivo, 2, @PerApuracao, NULL, 'B'))
	END
	-- dados vinculo
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtTSVTermino/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtTSVTermino Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			CASE WHEN @TipoRegistro = 'O' THEN
				'<indRetif>' + '1' + '</indRetif>' 
			ELSE
				'<indRetif>' + '2' + '</indRetif>' +
				'<nrRecibo>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecibo>' 
			END +
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(d.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<ideTrabSemVinculo>' +
				'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
				'<nisTrab>' + COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') + '</nisTrab>' +
				'<codCateg>' + RIGHT(RTRIM(LTRIM(CONVERT(CHAR(4),1000 + COALESCE(m.CodigoCategoriaESocial,0)))),3) + '</codCateg>' +
			'</ideTrabSemVinculo>' +
			'<infoTSVTermino>' +
				'<dtTerm>' +	COALESCE(SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,c.DataDemissao)),2,4),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,c.DataDemissao)),2,2),'') + '-' +
								COALESCE(SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,c.DataDemissao)),2,2),'') +
				'</dtTerm>' + 
				'<mtvDesligTSV>' + COALESCE(RTRIM(LTRIM(l.CodAdmAfastDesligESocial)),'') + '</mtvDesligTSV>',
	e.MatriculaESocial,
	@OrdemAux + 1
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbCargo m
	ON  m.CodigoEmpresa	= c.CodigoEmpresa
	AND m.CodigoLocal   = c.CodigoLocal
	AND m.CodigoCargo   = c.CodigoCargo

	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoDemissao
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoDemissao

	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro

	-- dados verbas
	-- inicia tag Verbas
	IF @ValorRubricasV <> '' -- tem movimento quitacao
	BEGIN
		SET @LinhaAux = '<verbasResc>'
		-- cria cursor com os tipos de pagamentos encontrados
		SELECT DISTINCT
			CodigoEmpresa		= a.CodigoEmpresa, 
			CodigoLocal			= a.CodigoLocal, 
			TipoColaborador		= a.TipoColaborador, 
			NumeroRegistro		= a.NumeroRegistro, 
			PeriodoCompetencia	= a.PeriodoCompetencia, 
			PeriodoPagamento	= a.PeriodoPagamento,
			RotinaPagamento		= a.RotinaPagamento, 
			DataPagamento		= a.DataPagamento,
			Dissidio			= a.Dissidio, 
			TipoDissidioESocial	= a.TipoDissidioESocial, 
			DataDissidioESocial	= a.DataDissidioESocial

		INTO #tmpPagamentos2399

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

		WHERE a.CodigoEmpresa		= @CodigoEmpresa
		AND   a.CodigoLocal			= @CodigoLocal
		AND   a.TipoColaborador		= @TipoColaborador
		AND   a.NumeroRegistro		= @NumeroRegistro
		AND   a.PeriodoCompetencia	= @PerApuracao
		AND   (
					(@IndApuracao = 1 AND a.RotinaPagamento	IN (1,2,7)) -- adto, mensal, eventual
				OR	(@IndApuracao = 2 AND a.RotinaPagamento	IN (4,5))	-- 13o salario	
		  	  )
		
		WHILE EXISTS ( SELECT 1 FROM #tmpPagamentos2399 )
		BEGIN
			-- tag abertura
			SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<dmDev>'
			-- pagamentos quitacao
			SELECT TOP 1 			
				@curCodigoEmpresa		= a.CodigoEmpresa, 
				@curCodigoLocal			= a.CodigoLocal, 
				@curTipoColaborador		= a.TipoColaborador, 
				@curNumeroRegistro		= a.NumeroRegistro, 
				@curPeriodoCompetencia	= a.PeriodoCompetencia,
				@curRotinaPagamento		= a.RotinaPagamento, 
				@curDataPagamento		= a.DataPagamento,
				@curDissidio			= a.Dissidio 

			FROM #tmpPagamentos2399 a

			IF @curDissidio = 'F' -- não é dissidio
			BEGIN
				-- tag abertura
				SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<ideDmDev>' + COALESCE(RTRIM(LTRIM(@curCodigoEmpresa)),'') + 
																		COALESCE(RTRIM(LTRIM(@curCodigoLocal)),'') +
																		COALESCE(RTRIM(LTRIM(@curTipoColaborador)),'') +
																		COALESCE(RTRIM(LTRIM(@curNumeroRegistro)),'') +
																		COALESCE(RTRIM(LTRIM(@curPeriodoCompetencia)),'') +
																		COALESCE(RTRIM(LTRIM(@curRotinaPagamento)),'') +
																		COALESCE(RTRIM(LTRIM(@curDissidio)),'') +
														  '</ideDmDev>' +
														'<ideEstabLot>' 
					-- insere na temp original
					IF RTRIM(LTRIM(@LinhaAux)) <> ''
						INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 2
					SELECT @LinhaAux = ''
					-- estabelecimento/lotacao
					SELECT @Tomadores	= ''
					SELECT @Tomadores	= (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, NULL))
					IF @Tomadores <> '' -- tem tomadores não dissidio
					BEGIN
						-- cria temp tomadores
						SELECT	CodigoClifor = c.CodigoCliFor
						
						INTO #tmpTomadores2399
						
						FROM tbTomadorFunc a,
							 tbTomadorServico b,
							 tbCliFor c
						
						WHERE a.CodigoEmpresa		= b.CodigoEmpresa
						AND   a.CodigoLocal			= b.CodigoLocal
						AND   a.CodigoCliFor		= b.CodigoCliFor
						AND   b.CodigoEmpresa       = c.CodigoEmpresa
						AND   b.CodigoCliFor        = c.CodigoCliFor
						AND   a.CodigoEmpresa		= @curCodigoEmpresa
						AND   a.CodigoLocal			= @curCodigoLocal
						AND   a.TipoColaborador		= @curTipoColaborador
						AND   a.NumeroRegistro		= @curNumeroRegistro
						AND   (
								(b.DataIniValidade <= @DataApuracao AND b.DataFimValidade IS NULL)
								OR (@DataApuracao BETWEEN b.DataIniValidade AND b.DataFimValidade)
							  )

						WHILE EXISTS ( SELECT 1 FROM #tmpTomadores2399 )
						BEGIN
							-- pega o 1.o
							SELECT TOP 1 @curCodigoCliFor = CodigoCliFor FROM #tmpTomadores2399
							SELECT @Tomadores = ''
							SELECT @Tomadores = (SELECT dbo.fnESocialTomadorServico (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @DataApuracao, @curCodigoCliFor))
							-- insere na temp original
							IF RTRIM(LTRIM(@Tomadores)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@Tomadores)), @OrdemAux, @OrdemAux + 3 
							-- limpa variaveis
							SET @OrdemAux = @OrdemAux + 4
							-- deleta 1.o registro
							DELETE #tmpTomadores2399 WHERE CodigoCliFor = @curCodigoCliFor
						END
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpTomadores2399 
						-- detalhes verbas
						SELECT @ValorRubricasV = ''
						SELECT @ValorRubricasV = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD = ''
						SELECT @ValorRubricasD = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB = ''
						SELECT @ValorRubricasB = (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 5 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 6 
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 7 
						-- detalhes plano saude	
						-- cria temp operadora
						SELECT RegistroANS
						INTO #tmpPlanoSaudeOperTom2399
						FROM tbAssistMedica
						WHERE 1 = 2
						--
						-- popula temp operadora
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperTom2399
							SELECT 
									d.RegistroANS
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperTom2399
							SELECT 
									d.RegistroANS

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
	--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201206', 'N'
						IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperTom2399 )
						BEGIN
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 8
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'V'
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeOperTom2399
									  )
						BEGIN
							-- operadora
							SELECT TOP 1 			
								@curRegistroANS = RegistroANS 
							FROM #tmpPlanoSaudeOperTom2399
							GROUP BY RegistroANS
							--inclui operadora
							SELECT @ValorPlanoSaudeOpe	= ''
							SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
							IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
								INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 9
							-- valor titular
							SELECT @ValorPlanoSaudeTit	= ''
							SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
							IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 10
							ELSE
							BEGIN
								SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 11
							END
							-- valor dependentes
							-- cria temp
							SELECT RegistroANS,
									TipoAssistenciaMedica AS SequenciaDependente									
							INTO #tmpPlanoSaudeDepTom2399
							FROM tbAssistMedica
							WHERE 1 = 2
							--
							-- popula temp							
							IF @TipoColaborador <> 'T'
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepTom2399
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente									
								
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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							ELSE
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepTom2399
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente

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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							WHILE EXISTS (
											SELECT 1 FROM #tmpPlanoSaudeDepTom2399
										 )
							BEGIN
								SELECT TOP 1 			
									@curRegistroANSDep	= RegistroANS,
									@curSeqDependente	= SequenciaDependente 
								FROM #tmpPlanoSaudeDepTom2399
								GROUP BY RegistroANS,
										SequenciaDependente
								-- inclui		
								SELECT @ValorPlanoSaudeDep	= ''
								SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
								IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
									INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 12
								-- deleta 1.o registro
								DELETE #tmpPlanoSaudeDepTom2399 
								WHERE RegistroANS			= @curRegistroANSDep
								AND   SequenciaDependente	= @curSeqDependente
								-- incrementa contador
								SET @OrdemAux = @OrdemAux + 13
							END
							-- elimina a tabela ao fim do processamento
							DROP TABLE #tmpPlanoSaudeDepTom2399
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeOperTom2399 
							WHERE RegistroANS = @curRegistroANS
							-- fecha operadora
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 14
							SELECT @LinhaAux = ''
							-- incrementa contador
							SET @OrdemAux = @OrdemAux + 15
						END -- fim temp
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeOperTom2399 
						IF @SaudeColet = 'V'
						BEGIN
							-- fecha tag plano saude
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 16
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'F'
						END
--whArquivosFPESocialXML 1608, 'S-2399', 0, 'I', 'N', 'F', 22, 121324, null,'', 0, 'N', '2', '201407', 'N'
						-- agente nocivo e codigo simples
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT TOP 1
																	CASE WHEN c.TipoColaborador = 'E' THEN	
																		''
																	ELSE
																		'<infoAgNocivo>' +
																			'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																		'</infoAgNocivo>'  
																	END +
																		--'<infoSimples>' +
																		--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																		--'</infoSimples>' +
																	'</ideEstabLot>'  
																	FROM tbLocalFP a
																	
																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = a.CodigoEmpresa
																	AND c.CodigoLocal   = a.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																  )
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 17
						SELECT @LinhaAux = ''
					END
					ELSE -- nao tem tomadores não dissidio
					BEGIN
						-- codigo lotacao
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT DISTINCT '<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'') + '</tpInsc>' +
																		'<nrInsc>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</nrInsc>' +
																		'<codLotacao>' + COALESCE(RTRIM(LTRIM(b.CGCLocal)),'') + '</codLotacao>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbLocal b
																	ON  b.CodigoEmpresa = a.CodigoEmpresa
																	AND b.CodigoLocal   = a.CodigoLocal

																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = b.CodigoEmpresa
																	AND c.CodigoLocal   = b.CodigoLocal
																	
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																)
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 18
						SELECT @LinhaAux = ''
						-- detalhes verbas
						SELECT @ValorRubricasV	= ''
						SELECT @ValorRubricasV	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'V'))
						SELECT @ValorRubricasD	= ''
						SELECT @ValorRubricasD	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'D'))
						SELECT @ValorRubricasB	= ''
						SELECT @ValorRubricasB	= (SELECT dbo.fnESocialValoresRubricas (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, 'B'))
						-- insere na temp original
						IF RTRIM(LTRIM(@ValorRubricasV)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasV)), @OrdemAux, @OrdemAux + 19 
						IF RTRIM(LTRIM(@ValorRubricasD)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasD)), @OrdemAux, @OrdemAux + 20
						IF RTRIM(LTRIM(@ValorRubricasB)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@ValorRubricasB)), @OrdemAux, @OrdemAux + 21
						-- detalhes plano saude	
						-- cria temp operadora
						SELECT RegistroANS
						INTO #tmpPlanoSaudeOperNTom2399
						FROM tbAssistMedica
						WHERE 1 = 2
						--
						-- popula temp operadora						
						IF @TipoColaborador <> 'T'
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperNTom2399
							SELECT 
									d.RegistroANS
							
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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
						ELSE
						BEGIN
							INSERT INTO #tmpPlanoSaudeOperNTom2399
							SELECT 
									d.RegistroANS

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
							AND c.CodigoRubricaESocial	= 9219
							
							INNER JOIN tbAssistMedica d
							ON  d.CodigoEmpresa			= b.CodigoEmpresa
							AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica

							WHERE a.CodigoEmpresa			= @curCodigoEmpresa
							AND   a.CodigoLocal				= @curCodigoLocal
							AND   a.TipoColaborador			= @curTipoColaborador
							AND   a.NumeroRegistro			= @curNumeroRegistro
							AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
							AND   a.DataPagamento			= @curDataPagamento
							AND   a.RotinaPagamento			= @curRotinaPagamento
							AND   b.TipoAssistenciaMedica	> 0

							GROUP BY d.RegistroANS

							ORDER BY d.RegistroANS
						END
	--whArquivosFPESocialXML 1608, 'S-1200', 0, 'I', 'N', 'F', 22, 121324, null, '', 0, 'N', '1', '201206', 'N'
						IF EXISTS ( SELECT 1 FROM #tmpPlanoSaudeOperNTom2399 )
						BEGIN
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '<infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 22
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'V'
						END
						WHILE EXISTS (
										SELECT 1 FROM #tmpPlanoSaudeOperNTom2399
									  )
						BEGIN
							-- operadora
							SELECT TOP 1 			
								@curRegistroANS = RegistroANS 
							FROM #tmpPlanoSaudeOperNTom2399
							GROUP BY RegistroANS
							--inclui operadora
							SELECT @ValorPlanoSaudeOpe	= ''
							SELECT @ValorPlanoSaudeOpe	= (SELECT dbo.fnESocialPlanoSaudeOper (@curCodigoEmpresa, @curRegistroANS))
							IF RTRIM(LTRIM(@ValorPlanoSaudeOpe)) <> ''
								INSERT @xml SELECT '<detOper>' + RTRIM(LTRIM(@ValorPlanoSaudeOpe)), @OrdemAux, @OrdemAux + 23
							-- valor titular
							SELECT @ValorPlanoSaudeTit	= ''
							SELECT @ValorPlanoSaudeTit	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANS, 0))
							IF RTRIM(LTRIM(@ValorPlanoSaudeTit)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 24
							ELSE
							BEGIN
								SET @ValorPlanoSaudeTit = '<vrPgTit>0.00</vrPgTit>'
								INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeTit)), @OrdemAux, @OrdemAux + 25
							END
							-- valor dependentes
							-- cria temp
							SELECT RegistroANS,
									TipoAssistenciaMedica AS SequenciaDependente									
							INTO #tmpPlanoSaudeDepNTom2399
							FROM tbAssistMedica
							WHERE 1 = 2
							--
							-- popula temp
							IF @TipoColaborador <> 'T'
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepNTom2399
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente									
								
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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							ELSE
							BEGIN
								INSERT INTO #tmpPlanoSaudeDepNTom2399
								SELECT 
										d.RegistroANS,
										b.SequenciaDependente

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
								AND c.CodigoRubricaESocial	= 9219
								
								INNER JOIN tbAssistMedica d
								ON  d.CodigoEmpresa			= b.CodigoEmpresa
								AND d.TipoAssistenciaMedica = b.TipoAssistenciaMedica
								ANd d.RegistroANS			= @curRegistroANS

								INNER JOIN tbDependente e
								ON  e.CodigoEmpresa			= b.CodigoEmpresa
								AND e.CodigoLocal			= b.CodigoLocal
								AND e.TipoColaborador		= b.TipoColaborador
								AND e.NumeroRegistro		= b.NumeroRegistro
								AND e.SequenciaDependente	= b.SequenciaDependente

								WHERE a.CodigoEmpresa			= @curCodigoEmpresa
								AND   a.CodigoLocal				= @curCodigoLocal
								AND   a.TipoColaborador			= @curTipoColaborador
								AND   a.NumeroRegistro			= @curNumeroRegistro
								AND   a.PeriodoCompetencia		= @curPeriodoCompetencia
								AND   a.DataPagamento			= @curDataPagamento
								AND   a.RotinaPagamento			= @curRotinaPagamento

								GROUP BY d.RegistroANS,
										b.SequenciaDependente,
										e.CPFDependente

								ORDER BY d.RegistroANS,
										e.CPFDependente
							END
							WHILE EXISTS (
											SELECT 1 FROM #tmpPlanoSaudeDepNTom2399
										 )
							BEGIN
								SELECT TOP 1 			
									@curRegistroANSDep	= RegistroANS,
									@curSeqDependente	= SequenciaDependente 
								FROM #tmpPlanoSaudeDepNTom2399
								GROUP BY RegistroANS,
										SequenciaDependente
								-- inclui		
								SELECT @ValorPlanoSaudeDep	= ''
								SELECT @ValorPlanoSaudeDep	= (SELECT dbo.fnESocialPlanoSaude (@curCodigoEmpresa, @curCodigoLocal, @curTipoColaborador, @curNumeroRegistro, @NomeArquivo, @curRotinaPagamento, @curPeriodoCompetencia, @curDataPagamento, @curRegistroANSDep, @curSeqDependente))
								IF RTRIM(LTRIM(@ValorPlanoSaudeDep)) <> ''
									INSERT @xml SELECT RTRIM(LTRIM(@ValorPlanoSaudeDep)), @OrdemAux, @OrdemAux + 26
								-- deleta 1.o registro
								DELETE #tmpPlanoSaudeDepNTom2399 
								WHERE RegistroANS			= @curRegistroANSDep
								AND   SequenciaDependente	= @curSeqDependente
								-- incrementa contador
								SET @OrdemAux = @OrdemAux + 27
							END
							-- elimina a tabela ao fim do processamento
							DROP TABLE #tmpPlanoSaudeDepNTom2399
							-- deleta 1.o registro
							DELETE #tmpPlanoSaudeOperNTom2399 
							WHERE RegistroANS = @curRegistroANS
							-- fecha operadora
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</detOper>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 28
							SELECT @LinhaAux = ''
							-- incrementa contador
							SET @OrdemAux = @OrdemAux + 29
						END -- fim temp
						-- elimina a tabela ao fim do processamento
						DROP TABLE #tmpPlanoSaudeOperNTom2399 
						IF @SaudeColet = 'V'
						BEGIN
							-- fecha tag plano saude
							SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + '</infoSaudeColet>'
							-- insere na temp original
							IF RTRIM(LTRIM(@LinhaAux)) <> ''
								INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 30
							SELECT @LinhaAux = ''
							SET @SaudeColet = 'F'
						END
--whArquivosFPESocialXML 1608, 'S-2399', 0, 'I', 'N', 'F', 22, 121324, null,'', 0, 'N', '2', '201407', 'N'
						-- agente nocivo e codigo simples
						SET @LinhaAux = RTRIM(LTRIM(@LinhaAux)) + (	
																	SELECT TOP 1
																	CASE WHEN c.TipoColaborador = 'E' THEN	
																		''
																	ELSE
																		'<infoAgNocivo>' +
																			'<grauExp>' + COALESCE(RTRIM(LTRIM(c.CodigoAgenteNocivoESocial)),'') + '</grauExp>' +
																		'</infoAgNocivo>'  
																	END +
																		--'<infoSimples>' +
																		--	'<indSimples>' + COALESCE(RTRIM(LTRIM(a.CodigoSIMPLES)),'') + '</indSimples>' +
																		--'</infoSimples>' +
																	'</ideEstabLot>'  
																	FROM tbLocalFP a
																		
																	INNER JOIN tbColaborador c
																	ON  c.CodigoEmpresa = a.CodigoEmpresa
																	AND c.CodigoLocal   = a.CodigoLocal
																						
																	WHERE c.CodigoEmpresa	= @curCodigoEmpresa
																	AND   c.CodigoLocal		= @curCodigoLocal
																	AND   c.TipoColaborador = @curTipoColaborador
																	AND   c.NumeroRegistro  = @curNumeroRegistro
																  )
						-- insere na temp original
						IF RTRIM(LTRIM(@LinhaAux)) <> ''
							INSERT @xml SELECT RTRIM(LTRIM(@LinhaAux)), @OrdemAux, @OrdemAux + 31
						SELECT @LinhaAux = ''
--whArquivosFPESocialXML 1608, 'S-2399', 0, 'I', 'N', 'F', 59, 121324, null,'', 0, 'N', '2', '201407', 'N'
						SET @OrdemAux = @OrdemAux + 32
					END -- fim tomadores não dissidio
			END
			-- insere na temp original
			INSERT @xml SELECT '</dmDev>', @OrdemAux, @OrdemAux + 33
			-- limpa variaveis
			SET @OrdemAux = @OrdemAux + 34
			-- deleta 1.o registro
			DELETE #tmpPagamentos2399 
			WHERE CodigoEmpresa			= @curCodigoEmpresa
			AND   CodigoLocal			= @curCodigoLocal
			AND   TipoColaborador		= @curTipoColaborador
			AND   NumeroRegistro		= @curNumeroRegistro
			AND   PeriodoCompetencia	= @curPeriodoCompetencia
			AND   RotinaPagamento		= @curRotinaPagamento
			AND   DataPagamento			= @curDataPagamento			
		END -- fim temp pagamentos
		-- elimina a tabela ao fim do processamento
		DROP TABLE #tmpPagamentos2399 
		IF @ProcessoAdmJudMes <> '' AND @MultiplosVinculos <> '' 
		BEGIN
			INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)), @OrdemAux, @OrdemAux + 35
			INSERT @xml SELECT '<infoMV>' + 
									RTRIM(LTRIM(@MultiplosVinculos)) + 
								'</infoMV>' +
								'</verbasResc>',
								@OrdemAux, 
								@OrdemAux + 36		
		END
		ELSE
		BEGIN
			IF @ProcessoAdmJudMes = '' AND @MultiplosVinculos = '' 
			BEGIN
				INSERT @xml SELECT '</verbasResc>', @OrdemAux, @OrdemAux + 37			
			END
			ELSE
			BEGIN
				IF @ProcessoAdmJudMes <> '' INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)) + '</verbasResc>', @OrdemAux, @OrdemAux + 38
				IF @MultiplosVinculos <> '' INSERT @xml SELECT '<infoMV>' + RTRIM(LTRIM(@MultiplosVinculos)) + '</infoMV>' + '</verbasResc>', @OrdemAux, @OrdemAux + 39		
			END
		END
	END
	ELSE -- não tem movimento quitacao
	BEGIN
--whArquivosFPESocialXML 1608, 'S-2399', 0, 'I', 'N', 'F', 22, 121324, null,'', 0, 'N', '2', '201408', 'N'
		IF @ProcessoAdmJudMes <> '' AND @MultiplosVinculos <> '' 
		BEGIN
			INSERT @xml SELECT RTRIM(LTRIM(@ProcessoAdmJudMes)), @OrdemAux, @OrdemAux + 40
			INSERT @xml SELECT '<infoMV>' + 
									RTRIM(LTRIM(@MultiplosVinculos)) + 
								'</infoMV>' +
								'</verbasResc>', 
								@OrdemAux,
								@OrdemAux + 41		
		END
		ELSE
		BEGIN
			IF @ProcessoAdmJudMes <> '' INSERT @xml SELECT '<verbasResc>' + RTRIM(LTRIM(@ProcessoAdmJudMes)) + '</verbasResc>', @OrdemAux, @OrdemAux + 42
			IF @MultiplosVinculos <> '' INSERT @xml SELECT '<verbasResc>' + '<infoMV>' + RTRIM(LTRIM(@MultiplosVinculos)) + '</infoMV>' + '</verbasResc>', @OrdemAux, @OrdemAux + 43		
		END
	END
	-- fecha as tags
	INSERT @xml
	SELECT DISTINCT
				-- nao fiz, quarentena
				--'<quarentena>' +
				--	'<dtFimQuar>' + '' + '</dtFimQuar>'
				--'</quarentena>' +
			'</infoTSVTermino>' +
		'</evtTSVTermino>' +
	'</eSocial>',
	@OrdemAux,
	@OrdemAux + 44
	FROM tbLocalFP a
	
	INNER JOIN tbLocal b
	ON	b.CodigoEmpresa = a.CodigoEmpresa
	AND b.CodigoLocal   = a.CodigoLocal

	INNER JOIN tbColaborador c
	ON  c.CodigoEmpresa = a.CodigoEmpresa
	AND c.CodigoLocal   = a.CodigoLocal
				
	INNER JOIN tbEmpresaFP d
	ON d.CodigoEmpresa = a.CodigoEmpresa

	INNER JOIN tbColaboradorGeral e
	ON  e.CodigoEmpresa		= c.CodigoEmpresa
	AND e.CodigoLocal		= c.CodigoLocal
	AND e.TipoColaborador	= c.TipoColaborador
	AND e.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbCargo m
	ON  m.CodigoEmpresa	= c.CodigoEmpresa
	AND m.CodigoLocal   = c.CodigoLocal
	AND m.CodigoCargo   = c.CodigoCargo

	LEFT JOIN tbPessoal k
	ON  k.CodigoEmpresa		= c.CodigoEmpresa
	AND k.CodigoLocal		= c.CodigoLocal
	AND k.TipoColaborador	= c.TipoColaborador
	AND k.NumeroRegistro	= c.NumeroRegistro

	LEFT JOIN tbTipoMovimentacaoFolha l 
	ON  l.CodigoEmpresa				= k.CodigoEmpresa 
	AND	l.TipoMovimentacaoColab		= k.TipoMovimentacaoDemissao
	AND	l.CodigoMovimentacaoColab	= k.CodigoMovimentacaoDemissao

	LEFT JOIN tbFuncionario n
	ON  n.CodigoEmpresa		= c.CodigoEmpresa
	AND n.CodigoLocal		= c.CodigoLocal
	AND n.TipoColaborador	= c.TipoColaborador
	AND n.NumeroRegistro	= c.NumeroRegistro
	
	WHERE a.CodigoEmpresa	= @CodigoEmpresa
	AND   a.CodigoLocal		= @CodigoLocal
	AND   c.CodigoEmpresa	= @CodigoEmpresa
	AND   c.CodigoLocal		= @CodigoLocal
	AND   c.TipoColaborador = @TipoColaborador
	AND   c.NumeroRegistro  = @NumeroRegistro
END
GOTO ARQ_FIM

ARQ_S3000: 
---- INICIO XML Evento Exclusao de Eventos
BEGIN
--execute whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = 0,@NomeArquivo = 'S-3000',@TipoColaborador = 'E',@NumeroRegistro = '1',@NroRecibo = '23132132',@ESocialExcluido = 'S-1200',@IndApuracao = 2,@PerApuracao = '2015'
	IF @TipoColaborador IS NOT NULL
	BEGIN
--execute whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = '',@NomeArquivo = 'S-3000',@TipoColaborador = 'E',@NumeroRegistro = '1',@NroRecibo = '2313213213213213213213213213213212312312',@ESocialExcluido = 'S-1200',@IndApuracao = 1,@PerApuracao = '201505'
--execute whArquivosFPESocialXML @CodigoEmpresa = '1608',@CodigoLocal = '',@NomeArquivo = 'S-3000',@TipoColaborador = 'E',@NumeroRegistro = '1',@NroRecibo = '32123132132',@ESocialExcluido = 'S-2190',@IndApuracao = Null,@PerApuracao = Null
	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtExclusao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtExclusao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(e.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<infoExclusao>' +
				'<tpEvento>' + COALESCE(RTRIM(LTRIM(@ESocialExcluido)),'') + '</tpEvento>' +
				'<nrRecEvt>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecEvt>' +
				'<ideTrabalhador>' +
					'<cpfTrab>' + COALESCE(RTRIM(LTRIM(c.CPFColaborador)),'') + '</cpfTrab>' +
					'<nisTrab>' +	CASE WHEN RTRIM(LTRIM(@ESocialExcluido)) NOT IN ('S-1210', 'S-2190') THEN
										COALESCE(RTRIM(LTRIM(c.NumeroPIS)),'') 
									ELSE
										''
									END +
					'</nisTrab>' +
				'</ideTrabalhador>' +
			CASE WHEN @IndApuracao IS NOT NULL THEN				
				'<ideFolhaPagto>' +
					'<indApuracao>' + COALESCE(RTRIM(LTRIM(CONVERT(CHAR(1),@IndApuracao))),'') + '</indApuracao>' +
				CASE WHEN @IndApuracao = '2' THEN
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '</perApur>'
				ELSE
					'<perApur>' + LEFT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),4) + '-' + RIGHT(COALESCE(RTRIM(LTRIM(@PerApuracao)),''),2) + '</perApur>'
				END +
				'</ideFolhaPagto>' 
			ELSE
				'' 
			END +
			'</infoExclusao>' +
		'</evtExclusao>' +
	'</eSocial>',
		d.MatriculaESocial,
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbColaborador c
		ON  c.CodigoEmpresa = a.CodigoEmpresa
		AND c.CodigoLocal   = a.CodigoLocal
					
		INNER JOIN tbColaboradorGeral d
		ON  d.CodigoEmpresa		= c.CodigoEmpresa
		AND d.CodigoLocal		= c.CodigoLocal
		AND d.TipoColaborador	= c.TipoColaborador
		AND d.NumeroRegistro	= c.NumeroRegistro

		INNER JOIN tbEmpresaFP e
		ON e.CodigoEmpresa = a.CodigoEmpresa

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
		AND   c.CodigoEmpresa	= @CodigoEmpresa
		AND   c.CodigoLocal		= @CodigoLocal
		AND   c.TipoColaborador = @TipoColaborador
		AND   c.NumeroRegistro  = @NumeroRegistro
	END
	ELSE
	BEGIN
	-- dados empresa
	INSERT @xml
	SELECT DISTINCT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<eSocial xmlns="http://www.esocial.gov.br/schema/evt/evtExclusao/' + RTRIM(LTRIM(@VersaoLayout)) + '">' +
		'<evtExclusao Id="ID' + 
											COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + 
											COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '000000' + 
											@DataHoraProc +
											@SequenciaArq + '">' +
			'<ideEvento>' + 
			'<tpAmb>' + COALESCE(RTRIM(LTRIM(@Ambiente)),COALESCE(RTRIM(LTRIM(c.TipoAmbiente)),'2')) + '</tpAmb>' +
			'<procEmi>' + '1' + '</procEmi>' +
			'<verProc>' + RTRIM(LTRIM(@VersaoSoftware)) + '</verProc>' +
			'</ideEvento>' +
			'<ideEmpregador>' +
				'<tpInsc>' + COALESCE(RTRIM(LTRIM(a.TipoInscricaoLocal)),'1') + '</tpInsc>' +
				'<nrInsc>' + COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),8),'00000000') + '</nrInsc>' +
			'</ideEmpregador>' +
			'<infoExclusao>' +
				'<tpEvento>' + COALESCE(RTRIM(LTRIM(@ESocialExcluido)),'') + '</tpEvento>' +
				'<nrRecEvt>' + COALESCE(RTRIM(LTRIM(@NroRecibo)),'') + '</nrRecEvt>' +
			'</infoExclusao>' +
		'</evtExclusao>' +
	'</eSocial>',
		COALESCE(LEFT(RTRIM(LTRIM(b.CGCLocal)),14),'00000000000000'),
		@OrdemAux + 1
		FROM tbLocalFP a
		
		INNER JOIN tbLocal b
		ON	b.CodigoEmpresa = a.CodigoEmpresa
		AND b.CodigoLocal   = a.CodigoLocal

		INNER JOIN tbEmpresaFP c
		ON c.CodigoEmpresa = a.CodigoEmpresa

		WHERE a.CodigoEmpresa	= @CodigoEmpresa
		AND   a.CodigoLocal		= @CodigoLocal
	END
	---- FIM XML Evento Exclusao de Eventos
END
GOTO ARQ_FIM

ARQ_FIM:
BEGIN
	-- se existir dados na temp
	IF EXISTS (SELECT 1 FROM @xml)
	BEGIN
		-- retira acentos das palavras
		--ÁÀÂÃáàâã
		UPDATE @xml
		SET
		Linha = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Linha,'Á','A'),'À','A'),'Â','A'),'Ã','A'),'á','a'),'à','a'),'â','a'),'ã','a')
		--ÉÈÊéèê
		UPDATE @xml
		SET
		Linha = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Linha,'É','E'),'È','E'),'Ê','E'),'é','e'),'è','e'),'ê','e')
		--ÍÌÎíìî
		UPDATE @xml
		SET
		Linha = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Linha,'Í','I'),'Ì','I'),'Î','I'),'í','i'),'ì','i'),'î','i')
		--ÓÒÔÕóòôõ
		UPDATE @xml
		SET
		Linha = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Linha,'Ó','O'),'Ò','O'),'Ô','O'),'ó','o'),'ò','o'),'ô','o'),'õ','o')
		--ÚÙÛúùû
		UPDATE @xml
		SET
		Linha = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Linha,'Ú','U'),'Ù','U'),'Û','U'),'ú','u'),'ù','u'),'û','u')
	END
	-- descarrega os dados obtidos
	SELECT Linha, Ordem 
	FROM @xml
	WHERE Linha IS NOT NULL
	ORDER BY OrdemAux
END
GO
GRANT EXECUTE ON dbo.whArquivosFPESocialXML TO SQLUsers
GO
