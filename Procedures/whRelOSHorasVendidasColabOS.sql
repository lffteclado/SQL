if exists(select 1 from sysobjects where id = object_id('whRelOSHorasVendidasColabOS'))
	DROP PROCEDURE dbo.whRelOSHorasVendidasColabOS
GO
CREATE PROCEDURE dbo.whRelOSHorasVendidasColabOS

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
EMPRESA.......: T-Systems do Brasil
PROJETO.......: OS - Controle de Oficina
AUTOR.........: Edvaldo Ragassi
DATA..........: 21/08/2006
UTILIZADO EM..: rptRelacaoHorasVendColaborador
OBJETIVO......: Exibir as Horas Vendidas por Colaborador para efeito de Comissao.

ALTERACAO.....:	Edson Marson - 03/06/2014
OBJETIVO......:	Será usada pelo form novo (frmftComissoesFP), porem o resultado foi agrupado.
				Ticket 154843/2014 - FM 13373/2014
 
ALTERACAO.....:	Edson Marson - 22/07/2014
OBJETIVO......:	Correções após visita de apresentação da tela nova ao cliente Besser Comercial.
				Ticket 154843/2014 - FM 13596/2014

whRelOSHorasVendidasColabOS 1608,0,0,9999,'1900-01-01','2014-12-31','P','F'
whRelOSHorasVendidasColabOS 4840,3,0,9999,'1900-01-01','2099-12-31','R','F'

select * from tbIndisponibColaboradorPO where CodigoEmpresa = 1608 and TipoHorarioColabIndispPO = 'A'
select * from tbApontamentoPO WHERE CodigoColaboradorOS = 58

SELECT * FROM tbOROSCIT WHERE NumeroOROS = 38887
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			NUMERIC(04),
@CodigoLocal			NUMERIC(04),
@DeCodigoColaborador	NUMERIC(08)	= NULL,
@AteCodigoColaborador	NUMERIC(08)	= NULL,
@DaDataNF				DATETIME,
@AteDataNF				DATETIME,
@TipoHoraInterna		CHAR(1)		= 'R',	-- 'R' = HORA REAL | 'P' = HORA PREVISTA
@UtilizaTPR				char(1)		= 'F',
@DoCentroCusto 			dtInteiro08	= NULL,
@AteCentroCusto    		dtInteiro08	= NULL,
@Origem					CHAR(2)		= NULL,
@SemNF                  char(1)     = 'F'

WITH ENCRYPTION
AS 

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE	@HorasVendidas	NUMERIC(16,4)

-- execução chamado pelo form normal
IF @Origem IS NULL
BEGIN
	SELECT DISTINCT
		tbEmpresa.CodigoEmpresa, 
		tbEmpresa.RazaoSocialEmpresa,
		tbLocal.CodigoLocal,
		tbLocal.DescricaoLocal,
		tbItemOROS.NumeroOROS, 
		tbItemOROS.CodigoCIT, 
		tbItemOROS.SequenciaItemOS,
		tbOROSCIT.DataEmissaoNotaFiscalOS,	

		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)

									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									INNER JOIN tbNaturezaOperacao
												ON	tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND   tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND   tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND   tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND   tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND   tbNaturezaOperacao.CodigoTipoOperacao = 10),0)NumeroNotaFiscalMOB,


		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)

									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido
									INNER JOIN tbNaturezaOperacao
												ON  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND   tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND   tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND   tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND   tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0)NumeroNotaFiscalPEC,

		tbApontamentoMO.CodigoColaboradorOS CodigoColaboradorOS,
		tbColaboradorOS.NomeUsualColaboradorOS NomePessoal, 
		tbColaboradorOS.CentroCusto CentroCusto,
		HorasVendidas = CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						ELSE
							COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V' THEN
										CASE @TipoHoraInterna WHEN 'R'
											THEN tbItemMOOROS.HorasReaisItemMOOS
											ELSE tbItemMOOROS.HorasPrevistasItemMOOS
										END
									  ELSE	
										CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
											THEN tbItemOROS.QuantidadeItemOS
											ELSE tbItemMOOROS.HorasCalculoComissao
										END
									  END

							*		CASE WHEN	@UtilizaTPR = 'V' AND tbTTR.TempoRealPadraoTTR = 'R' THEN
										(SELECT SUM(ttr.TempoTTR) 
										 FROM	tbTTR ttr (NOLOCK)
										 WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										 AND	ttr.LivroTTR			= tbTTR.LivroTTR
										 AND	ttr.CapituloTTR			= tbTTR.CapituloTTR
										 AND	ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										 AND	ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										 AND	ttr.LinhaTTR			= tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										 FROM	tbApontamentoMO APO	
										 WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										 AND	APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										 AND	APO.FlagOROS			= tbApontamentoMO.FlagOROS
										 AND	APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										 AND	APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										 AND	APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										 AND	APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										 AND	APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									END
								/	(SELECT		SUM(APO.TotalHorasApontamentoMOOS)
										FROM	tbApontamentoMO APO
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS)
								),0)
							END,

		ValorTotal = CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
			
			CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						 FROM	tbApontamentoMO APO	
						 WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						 AND	APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						 AND	APO.FlagOROS			= tbApontamentoMO.FlagOROS
						 AND	APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						 AND	APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						 AND	APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						 AND	APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						 AND	APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
			
			ELSE
					
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
					*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
						(SELECT	SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
						WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
						AND		ttr.LivroTTR			= tbTTR.LivroTTR
						AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
						AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
						AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
						AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
					else
						(SELECT	SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					end
					/	(SELECT	SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
				END
			ELSE 
				
				CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END)
			
				ELSE
						
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
				*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
					else
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					end
				/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
					FROM	tbApontamentoMO APO
					WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
					AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
					AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
					AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
					AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
					AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
					AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END) 
				END
			END,
		NomeCliente =	(SELECT NomeCliFor FROM tbCliFor WHERE	tbCliFor.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
						AND	CodigoCliFor IN (SELECT CodigoCliFor FROM tbOROS OROS
						WHERE	OROS.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
						AND	OROS.CodigoLocal		= tbOROSCIT.CodigoLocal
						AND	OROS.FlagOROS			= tbOROSCIT.FlagOROS
						AND	OROS.NumeroOROS			= tbOROSCIT.NumeroOROS)),
		tbColaboradorOS.PercComissaoColaboradorOS,
		ValorComissao =	CAST((CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
					
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
			
						ELSE				
						
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
											THEN	CASE @TipoHoraInterna WHEN 'R'
													THEN tbItemMOOROS.HorasReaisItemMOOS
													ELSE tbItemMOOROS.HorasPrevistasItemMOOS
												END
											ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
													THEN tbItemOROS.QuantidadeItemOS
													ELSE tbItemMOOROS.HorasCalculoComissao
												END
										END
									*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
									else
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
							),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						END
					
					ELSE 
						
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
										THEN	CASE @TipoHoraInterna WHEN 'R'
												THEN tbItemMOOROS.HorasReaisItemMOOS
												ELSE tbItemMOOROS.HorasPrevistasItemMOOS
											END
										ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
												THEN tbItemOROS.QuantidadeItemOS
												ELSE tbItemMOOROS.HorasCalculoComissao
											END
									END
									*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
								else
									(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO	
									WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
									AND		APO.CodigoColaboradorOS	= tbApontamentoMO.CodigoColaboradorOS)
								end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
						),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN tbItemOROS.ValorUnitarioItemOS
								ELSE ValorUnitarioInvisivelItemOS 
								END) 
						END 
					END) * (tbColaboradorOS.PercComissaoColaboradorOS / 100) AS NUMERIC(16,2)),
				

		HorasVendidasTotal = COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END),0),

		ValorLiquidoOS = CASE ValorUnitarioInvisivelItemOS WHEN 0 
			THEN (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
					END)
			ELSE (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ValorUnitarioInvisivelItemOS 
					END) END
					
	FROM	tbItemOROS

	INNER JOIN  tbApontamentoMO
	ON	tbApontamentoMO.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbApontamentoMO.CodigoLocal		= tbItemOROS.CodigoLocal 
	AND	tbApontamentoMO.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbApontamentoMO.NumeroOROS		= tbItemOROS.NumeroOROS 
	AND	tbApontamentoMO.CodigoCIT		= tbItemOROS.CodigoCIT
	AND	tbApontamentoMO.TipoItemOS		= tbItemOROS.TipoItemOS
	AND	tbApontamentoMO.SequenciaItemOS	= tbItemOROS.SequenciaItemOS

	INNER JOIN  tbItemMOOROS
	ON	tbItemMOOROS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbItemMOOROS.CodigoLocal		= tbApontamentoMO.CodigoLocal 
	AND	tbItemMOOROS.FlagOROS			= tbApontamentoMO.FlagOROS 
	AND	tbItemMOOROS.NumeroOROS			= tbApontamentoMO.NumeroOROS 
	AND	tbItemMOOROS.CodigoCIT			= tbApontamentoMO.CodigoCIT
	AND	tbItemMOOROS.TipoItemOS			= tbApontamentoMO.TipoItemOS
	AND	tbItemMOOROS.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS

	left join tbTTR
	on  tbTTR.CodigoEmpresa				= tbItemMOOROS.CodigoEmpresa
	and tbTTR.LivroTTR					= tbItemMOOROS.LivroTTR
	and tbTTR.CapituloTTR				= tbItemMOOROS.CapituloTTR
	and tbTTR.GrupoConstrucaoTTR		= tbItemMOOROS.GrupoConstrucaoTTR
	and tbTTR.OperacaoTTR				= tbItemMOOROS.OperacaoTTR
	and tbTTR.LinhaTTR					= tbItemMOOROS.LinhaTTR

	INNER JOIN tbColaboradorOS 
	ON	tbColaboradorOS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbColaboradorOS.CodigoLocal			= tbApontamentoMO.CodigoLocal
	AND	tbColaboradorOS.CodigoColaboradorOS	= tbApontamentoMO.CodigoColaboradorOS

	INNER JOIN tbOROSCIT
	ON	tbOROSCIT.CodigoEmpresa			= tbItemOROS.CodigoEmpresa
	AND	tbOROSCIT.CodigoLocal			= tbItemOROS.CodigoLocal 
	AND	tbOROSCIT.FlagOROS				= tbItemOROS.FlagOROS 
	AND	tbOROSCIT.NumeroOROS			= tbItemOROS.NumeroOROS 
	AND	tbOROSCIT.CodigoCIT				= tbItemOROS.CodigoCIT

	INNER JOIN tbEmpresa 
	ON	tbEmpresa.CodigoEmpresa			= tbItemOROS.CodigoEmpresa 

	INNER JOIN tbLocal
	ON	tbLocal.CodigoEmpresa			= tbItemOROS.CodigoEmpresa
	AND	tbLocal.CodigoLocal				= tbItemOROS.CodigoLocal

	INNER JOIN tbCIT
	ON	tbCIT.CodigoEmpresa				= tbItemOROS.CodigoEmpresa
	AND	tbCIT.CodigoCIT					= tbItemOROS.CodigoCIT

	WHERE	tbItemOROS.CodigoEmpresa	= @CodigoEmpresa 
	AND	tbItemOROS.CodigoLocal			= @CodigoLocal 
	AND	tbApontamentoMO.CodigoColaboradorOS	BETWEEN ISNULL(@DeCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
							AND	ISNULL(@AteCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
	AND	tbOROSCIT.DataEmissaoNotaFiscalOS	BETWEEN @DaDataNF	AND	@AteDataNF
	AND	tbOROSCIT.StatusOSCIT			= 'N'
	AND	tbCIT.CalculaComissaoCIT		= 'V'

	UNION

	SELECT DISTINCT
		tbEmpresa.CodigoEmpresa, 
		tbEmpresa.RazaoSocialEmpresa,
		tbLocal.CodigoLocal,
		tbLocal.DescricaoLocal,
		tbItemOROS.NumeroOROS, 
		tbItemOROS.CodigoCIT, 
		tbItemOROS.SequenciaItemOS,
		tbOROSCIT.DataEmissaoNotaFiscalOS,	

		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)

									FROM tbOROSCITPedido
									INNER JOIN tbPedido
									ON  tbPedido.CodigoEmpresa		= tbOROSCITPedido.CodigoEmpresa
									AND tbPedido.CodigoLocal		= tbOROSCITPedido.CodigoLocal
									AND tbPedido.CentroCusto		= tbOROSCITPedido.CentroCusto
									AND tbPedido.NumeroPedido		= tbOROSCITPedido.NumeroPedido
									AND tbPedido.SequenciaPedido	= tbOROSCITPedido.SequenciaPedido

									INNER JOIN tbNaturezaOperacao
									ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
									AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND tbNaturezaOperacao.CodigoTipoOperacao = 10),0)NumeroNotaFiscalMOB,


		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)

									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido
									INNER JOIN tbNaturezaOperacao
												ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND tbNaturezaOperacao.CodigoTipoOperacao <> 10),0)NumeroNotaFiscalPEC,

		tbApontamentoMO.CodigoColaboradorOS  CodigoColaboradorOS,
		tbColaboradorOS.NomeUsualColaboradorOS NomePessoal, 
		tbColaboradorOS.CentroCusto CentroCusto,
		HorasVendidas = CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						ELSE
							COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
												THEN	CASE @TipoHoraInterna WHEN 'R'
														THEN tbItemMOOROS.HorasReaisItemMOOS
														ELSE tbItemMOOROS.HorasPrevistasItemMOOS
													END
												ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
														THEN tbItemOROS.QuantidadeItemOS
														ELSE tbItemMOOROS.HorasCalculoComissao
													END
											END

										*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
									else
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS)
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
								),0)
							END,

		ValorTotal =	CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
			
			CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
			
			ELSE
					
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
					else
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					end
					/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO
						WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
				END
			ELSE 
				
				CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END)
			
				ELSE
						
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
					else
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					end
				/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
					FROM	tbApontamentoMO APO
					WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
					AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
					AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
					AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
					AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
					AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
					AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END) 
				END
			END,
		NomeCliente = (SELECT NomeCliFor FROM tbCliFor WHERE	tbCliFor.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
								AND	CodigoCliFor IN (SELECT CodigoCliFor FROM tbOROS OROS
								WHERE	OROS.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
								AND	OROS.CodigoLocal	= tbOROSCIT.CodigoLocal
								AND	OROS.FlagOROS		= tbOROSCIT.FlagOROS
								AND	OROS.NumeroOROS		= tbOROSCIT.NumeroOROS)),
		tbColaboradorOS.PercComissaoColaboradorOS,
		ValorComissao =	CAST((CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
					
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
			
						ELSE				
						
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
											THEN	CASE @TipoHoraInterna WHEN 'R'
													THEN tbItemMOOROS.HorasReaisItemMOOS
													ELSE tbItemMOOROS.HorasPrevistasItemMOOS
												END
											ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
													THEN tbItemOROS.QuantidadeItemOS
													ELSE tbItemMOOROS.HorasCalculoComissao
												END
										END
								*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									END
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
							),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						END
					
					ELSE 
						
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
										THEN	CASE @TipoHoraInterna WHEN 'R'
												THEN tbItemMOOROS.HorasReaisItemMOOS
												ELSE tbItemMOOROS.HorasPrevistasItemMOOS
											END
										ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
												THEN tbItemOROS.QuantidadeItemOS
												ELSE tbItemMOOROS.HorasCalculoComissao
											END
									END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
								else
									(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO	
									WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
									AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
								end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
						),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN tbItemOROS.ValorUnitarioItemOS
								ELSE ValorUnitarioInvisivelItemOS 
								END) 
						END 
					END) * (tbColaboradorOS.PercComissaoColaboradorOS / 100) AS NUMERIC(16,2)),

		HorasVendidasTotal = COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END),0),

		ValorLiquidoOS = CASE ValorUnitarioInvisivelItemOS WHEN 0 
			THEN (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
					END)
			ELSE (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ValorUnitarioInvisivelItemOS 
					END) END
					
	FROM	tbItemOROS

	INNER JOIN  tbApontamentoMO
	ON	tbApontamentoMO.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbApontamentoMO.CodigoLocal		= tbItemOROS.CodigoLocal 
	AND	tbApontamentoMO.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbApontamentoMO.NumeroOROS		= tbItemOROS.NumeroOROS 
	AND	tbApontamentoMO.CodigoCIT		= tbItemOROS.CodigoCIT
	AND	tbApontamentoMO.TipoItemOS		= tbItemOROS.TipoItemOS
	AND	tbApontamentoMO.SequenciaItemOS	= tbItemOROS.SequenciaItemOS

	INNER JOIN  tbItemMOOROS
	ON	tbItemMOOROS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbItemMOOROS.CodigoLocal		= tbApontamentoMO.CodigoLocal 
	AND	tbItemMOOROS.FlagOROS			= tbApontamentoMO.FlagOROS 
	AND	tbItemMOOROS.NumeroOROS			= tbApontamentoMO.NumeroOROS 
	AND	tbItemMOOROS.CodigoCIT			= tbApontamentoMO.CodigoCIT
	AND	tbItemMOOROS.TipoItemOS			= tbApontamentoMO.TipoItemOS
	AND	tbItemMOOROS.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS

	left join tbTTR
	on tbTTR.CodigoEmpresa				= tbItemMOOROS.CodigoEmpresa
	and tbTTR.LivroTTR					= tbItemMOOROS.LivroTTR
	and tbTTR.CapituloTTR				= tbItemMOOROS.CapituloTTR
	and tbTTR.GrupoConstrucaoTTR		= tbItemMOOROS.GrupoConstrucaoTTR
	and tbTTR.OperacaoTTR				= tbItemMOOROS.OperacaoTTR
	and tbTTR.LinhaTTR					= tbItemMOOROS.LinhaTTR

	INNER JOIN tbColaboradorOS 
	ON	tbColaboradorOS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbColaboradorOS.CodigoLocal			= tbApontamentoMO.CodigoLocal
	AND	tbColaboradorOS.CodigoColaboradorOS	= tbApontamentoMO.CodigoColaboradorOS

	INNER JOIN tbOROSCIT
	ON	tbOROSCIT.CodigoEmpresa			= tbItemOROS.CodigoEmpresa
	AND	tbOROSCIT.CodigoLocal			= tbItemOROS.CodigoLocal 
	AND	tbOROSCIT.FlagOROS				= tbItemOROS.FlagOROS 
	AND	tbOROSCIT.NumeroOROS			= tbItemOROS.NumeroOROS 
	AND	tbOROSCIT.CodigoCIT				= tbItemOROS.CodigoCIT

	INNER JOIN tbEmpresa 
	ON	tbEmpresa.CodigoEmpresa			= tbItemOROS.CodigoEmpresa 

	INNER JOIN tbLocal
	ON	tbLocal.CodigoEmpresa			= tbItemOROS.CodigoEmpresa
	AND	tbLocal.CodigoLocal				= tbItemOROS.CodigoLocal

	INNER JOIN tbCIT
	ON	tbCIT.CodigoEmpresa				= tbItemOROS.CodigoEmpresa
	AND	tbCIT.CodigoCIT					= tbItemOROS.CodigoCIT

	WHERE	tbItemOROS.CodigoEmpresa	= @CodigoEmpresa 
	AND	tbItemOROS.CodigoLocal			= @CodigoLocal 
	AND	tbApontamentoMO.CodigoColaboradorOS	BETWEEN ISNULL(@DeCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
											AND	ISNULL(@AteCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
	AND	tbOROSCIT.DataEncerramentoOSCIT		BETWEEN @DaDataNF	AND	@AteDataNF
	AND	tbOROSCIT.DataEmissaoNotaFiscalOS	IS NULL
	AND	tbOROSCIT.NumeroNotaFiscalOS		IS NULL
	AND	tbOROSCIT.StatusOSCIT			= 'E'
	AND	tbOROSCIT.ValorLiquidoOS		= 0
	AND	tbCIT.CalculaComissaoCIT		= 'V'
	AND @SemNF                          = 'V'

	AND NOT EXISTS	(SELECT 1 FROM tbItemOROS it
					WHERE	it.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
					AND		it.CodigoLocal		= tbItemOROS.CodigoLocal 
					AND		it.FlagOROS			= tbItemOROS.FlagOROS 
					AND		it.NumeroOROS		= tbItemOROS.NumeroOROS 
					AND		it.CodigoCIT		= tbItemOROS.CodigoCIT
					AND		it.TipoItemOS		= tbItemOROS.TipoItemOS
					AND		it.SequenciaItemOS	= tbItemOROS.SequenciaItemOS
					AND		it.QuantidadeItemOS	!= 0)

		ORDER BY
			tbApontamentoMO.CodigoColaboradorOS, 
			tbOROSCIT.DataEmissaoNotaFiscalOS, 
			tbItemOROS.CodigoCIT
END
-- execução chamado pelo form ftComissoesFP
ELSE
BEGIN
	SELECT DISTINCT
		tbEmpresa.CodigoEmpresa, 
		tbEmpresa.RazaoSocialEmpresa,
		tbLocal.CodigoLocal,
		tbLocal.DescricaoLocal,
		tbItemOROS.NumeroOROS, 
		tbItemOROS.CodigoCIT, 
		tbItemOROS.SequenciaItemOS,
		tbOROSCIT.DataEmissaoNotaFiscalOS,	
		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)
									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									INNER JOIN tbNaturezaOperacao
												ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND  tbNaturezaOperacao.CodigoTipoOperacao = 10),0)NumeroNotaFiscalMOB,
		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)
									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido
									INNER JOIN tbNaturezaOperacao
												ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND tbNaturezaOperacao.CodigoTipoOperacao <> 10),0)NumeroNotaFiscalPEC,
		tbColaboradorOS.NumeroRegistro,
		tbColaboradorOS.NomeUsualColaboradorOS NomePessoal, 
		tbColaboradorOS.CentroCusto CentroCusto,
		HorasVendidas = CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						ELSE
							COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V' THEN
										CASE @TipoHoraInterna WHEN 'R'
											THEN tbItemMOOROS.HorasReaisItemMOOS
											ELSE tbItemMOOROS.HorasPrevistasItemMOOS
										END
									  ELSE	
										CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
											THEN tbItemOROS.QuantidadeItemOS
											ELSE tbItemMOOROS.HorasCalculoComissao
										END
									  END

							*		CASE WHEN @UtilizaTPR = 'V' AND tbTTR.TempoRealPadraoTTR = 'R' THEN
										(SELECT		SUM(ttr.TempoTTR) 
										 FROM tbTTR ttr (NOLOCK)
										 WHERE		ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										 AND		ttr.LivroTTR			= tbTTR.LivroTTR
										 AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										 AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										 AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										 AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										 FROM	tbApontamentoMO APO	
										 WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										 AND	APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										 AND	APO.FlagOROS			= tbApontamentoMO.FlagOROS
										 AND	APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										 AND	APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										 AND	APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										 AND	APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										 AND	APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									END
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS)
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
								),0)
							END,
		ValorTotal = CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
			CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						 FROM	tbApontamentoMO APO	
						 WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						 AND	APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						 AND	APO.FlagOROS			= tbApontamentoMO.FlagOROS
						 AND	APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						 AND	APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						 AND	APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						 AND	APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						 AND	APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
			ELSE
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
					*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND ttr.LivroTTR = tbTTR.LivroTTR
										AND ttr.CapituloTTR = tbTTR.CapituloTTR
										AND ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND ttr.LinhaTTR = tbTTR.LinhaTTR)
					else
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					END
					/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
				END
			ELSE 
				CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END)
				ELSE
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
				*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
					ELSE
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					END
				/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
					FROM	tbApontamentoMO APO
					WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
					AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
					AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
					AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
					AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
					AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
					AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END) 
				END
			END,
		NomeCliente = (SELECT NomeCliFor FROM tbCliFor WHERE	tbCliFor.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
								AND	CodigoCliFor IN (SELECT CodigoCliFor FROM tbOROS OROS
								WHERE	OROS.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
								AND	OROS.CodigoLocal	= tbOROSCIT.CodigoLocal
								AND	OROS.FlagOROS		= tbOROSCIT.FlagOROS
								AND	OROS.NumeroOROS		= tbOROSCIT.NumeroOROS)),
		tbColaboradorOS.PercComissaoColaboradorOS,
		ValorComissao =	CAST((CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE				
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
											THEN	CASE @TipoHoraInterna WHEN 'R'
													THEN tbItemMOOROS.HorasReaisItemMOOS
													ELSE tbItemMOOROS.HorasPrevistasItemMOOS
												END
											ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
													THEN tbItemOROS.QuantidadeItemOS
													ELSE tbItemMOOROS.HorasCalculoComissao
												END
										END
									*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									END
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
							),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						END
					ELSE 
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
										THEN	CASE @TipoHoraInterna WHEN 'R'
												THEN tbItemMOOROS.HorasReaisItemMOOS
												ELSE tbItemMOOROS.HorasPrevistasItemMOOS
											END
										ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
												THEN tbItemOROS.QuantidadeItemOS
												ELSE tbItemMOOROS.HorasCalculoComissao
											END
									END
									*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
								ELSE
									(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO	
									WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
									AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
								END
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
						),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN tbItemOROS.ValorUnitarioItemOS
								ELSE ValorUnitarioInvisivelItemOS 
								END) 
						END 
					END) * (tbColaboradorOS.PercComissaoColaboradorOS / 100) AS NUMERIC(16,2)),
		HorasVendidasTotal = COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END),0),
		ValorLiquidoOS = CASE ValorUnitarioInvisivelItemOS WHEN 0 
			THEN (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
					END)
			ELSE (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ValorUnitarioInvisivelItemOS 
					END) END,
		tbColaboradorOS.CodigoColaboradorOS

	INTO	#tbTemp
					
	FROM	tbItemOROS

	INNER JOIN  tbApontamentoMO
	ON	tbApontamentoMO.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbApontamentoMO.CodigoLocal		= tbItemOROS.CodigoLocal 
	AND	tbApontamentoMO.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbApontamentoMO.NumeroOROS		= tbItemOROS.NumeroOROS 
	AND	tbApontamentoMO.CodigoCIT		= tbItemOROS.CodigoCIT
	AND	tbApontamentoMO.TipoItemOS		= tbItemOROS.TipoItemOS
	AND	tbApontamentoMO.SequenciaItemOS	= tbItemOROS.SequenciaItemOS

	INNER JOIN  tbItemMOOROS
	ON	tbItemMOOROS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbItemMOOROS.CodigoLocal		= tbApontamentoMO.CodigoLocal 
	AND	tbItemMOOROS.FlagOROS			= tbApontamentoMO.FlagOROS 
	AND	tbItemMOOROS.NumeroOROS			= tbApontamentoMO.NumeroOROS 
	AND	tbItemMOOROS.CodigoCIT			= tbApontamentoMO.CodigoCIT
	AND	tbItemMOOROS.TipoItemOS			= tbApontamentoMO.TipoItemOS
	AND	tbItemMOOROS.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS

	left join tbTTR
	on tbTTR.CodigoEmpresa			= tbItemMOOROS.CodigoEmpresa
	and tbTTR.LivroTTR				= tbItemMOOROS.LivroTTR
	and tbTTR.CapituloTTR			= tbItemMOOROS.CapituloTTR
	and tbTTR.GrupoConstrucaoTTR	= tbItemMOOROS.GrupoConstrucaoTTR
	and tbTTR.OperacaoTTR			= tbItemMOOROS.OperacaoTTR
	and tbTTR.LinhaTTR				= tbItemMOOROS.LinhaTTR

	INNER JOIN tbColaboradorOS 
	ON	tbColaboradorOS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbColaboradorOS.CodigoLocal			= tbApontamentoMO.CodigoLocal
	AND	tbColaboradorOS.CodigoColaboradorOS	= tbApontamentoMO.CodigoColaboradorOS

	INNER JOIN tbOROSCIT
	ON	tbOROSCIT.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbOROSCIT.CodigoLocal	= tbItemOROS.CodigoLocal 
	AND	tbOROSCIT.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbOROSCIT.NumeroOROS	= tbItemOROS.NumeroOROS 
	AND	tbOROSCIT.CodigoCIT		= tbItemOROS.CodigoCIT

	INNER JOIN tbEmpresa 
	ON	tbEmpresa.CodigoEmpresa	= tbItemOROS.CodigoEmpresa 

	INNER JOIN tbLocal
	ON	tbLocal.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbLocal.CodigoLocal		= tbItemOROS.CodigoLocal

	INNER JOIN tbCIT
	ON	tbCIT.CodigoEmpresa		= tbItemOROS.CodigoEmpresa
	AND	tbCIT.CodigoCIT			= tbItemOROS.CodigoCIT

	WHERE	tbItemOROS.CodigoEmpresa		= @CodigoEmpresa 
	AND	tbItemOROS.CodigoLocal			= @CodigoLocal 
	AND	tbApontamentoMO.CodigoColaboradorOS	BETWEEN ISNULL(@DeCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
											AND	ISNULL(@AteCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
	AND	tbColaboradorOS.CentroCusto			BETWEEN ISNULL(@DoCentroCusto,tbColaboradorOS.CentroCusto)
											AND ISNULL(@AteCentroCusto, tbColaboradorOS.CentroCusto)
	AND	tbOROSCIT.DataEmissaoNotaFiscalOS	BETWEEN @DaDataNF	AND	@AteDataNF
	AND	tbOROSCIT.StatusOSCIT			= 'N'
	AND	tbCIT.CalculaComissaoCIT		= 'V'

	UNION

	SELECT DISTINCT
		tbEmpresa.CodigoEmpresa, 
		tbEmpresa.RazaoSocialEmpresa,
		tbLocal.CodigoLocal,
		tbLocal.DescricaoLocal,
		tbItemOROS.NumeroOROS, 
		tbItemOROS.CodigoCIT, 
		tbItemOROS.SequenciaItemOS,
		tbOROSCIT.DataEmissaoNotaFiscalOS,	
		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)
									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido
									INNER JOIN tbNaturezaOperacao
												ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND  tbNaturezaOperacao.CodigoTipoOperacao = 10),0)NumeroNotaFiscalMOB,
		COALESCE((SELECT MAX(tbPedido.NumeroNotaFiscalPed)
									FROM tbOROSCITPedido
									INNER JOIN tbPedido
												ON tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
												AND tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
												AND tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
												AND tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
												AND tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido
									INNER JOIN tbNaturezaOperacao
												ON tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
												AND tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									WHERE tbOROSCITPedido.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									AND tbOROSCITPedido.CodigoLocal = tbOROSCIT.CodigoLocal
									AND tbOROSCITPedido.FlagOROS = tbOROSCIT.FlagOROS
									AND tbOROSCITPedido.NumeroOROS = tbOROSCIT.NumeroOROS
									AND tbOROSCITPedido.CodigoCIT = tbOROSCIT.CodigoCIT
									AND tbNaturezaOperacao.CodigoTipoOperacao <> 10),0)NumeroNotaFiscalPEC,
		tbColaboradorOS.NumeroRegistro,
		tbColaboradorOS.NomeUsualColaboradorOS NomePessoal, 
		tbColaboradorOS.CentroCusto CentroCusto,
		HorasVendidas = CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						ELSE
							COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
												THEN	CASE @TipoHoraInterna WHEN 'R'
														THEN tbItemMOOROS.HorasReaisItemMOOS
														ELSE tbItemMOOROS.HorasPrevistasItemMOOS
													END
												ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
														THEN tbItemOROS.QuantidadeItemOS
														ELSE tbItemMOOROS.HorasCalculoComissao
													END
											END
										*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa = tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR = tbTTR.LivroTTR
										AND		ttr.CapituloTTR = tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR = tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR = tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR = tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS)
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
								),0)
							END,
		ValorTotal =	CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
			CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
			ELSE
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
					ELSE
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					END
					/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO
						WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
						END)
				END
			ELSE 
				CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					
					 * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END)
				ELSE
				(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN	CASE @TipoHoraInterna WHEN 'R'
										THEN tbItemMOOROS.HorasReaisItemMOOS
										ELSE tbItemMOOROS.HorasPrevistasItemMOOS
									END
								ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
										THEN tbItemOROS.QuantidadeItemOS
										ELSE tbItemMOOROS.HorasCalculoComissao
									END
							END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
					ELSE
						(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
						FROM	tbApontamentoMO APO	
						WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
						AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
						AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
						AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
						AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
						AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
						AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
						AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
					END
				/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
					FROM	tbApontamentoMO APO
					WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
					AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
					AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
					AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
					AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
					AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
					AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
				),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
						THEN tbItemOROS.ValorUnitarioItemOS
						ELSE ValorUnitarioInvisivelItemOS 
						END) 
				END
			END,
		NomeCliente = (SELECT NomeCliFor FROM tbCliFor WHERE	tbCliFor.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
								AND	CodigoCliFor IN (SELECT CodigoCliFor FROM tbOROS OROS
								WHERE	OROS.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
								AND	OROS.CodigoLocal	= tbOROSCIT.CodigoLocal
								AND	OROS.FlagOROS		= tbOROSCIT.FlagOROS
								AND	OROS.NumeroOROS		= tbOROSCIT.NumeroOROS)),
		tbColaboradorOS.PercComissaoColaboradorOS,
		ValorComissao =	CAST((CASE ValorUnitarioInvisivelItemOS WHEN 0 THEN 
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE				
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
											THEN	CASE @TipoHoraInterna WHEN 'R'
													THEN tbItemMOOROS.HorasReaisItemMOOS
													ELSE tbItemMOOROS.HorasPrevistasItemMOOS
												END
											ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
													THEN tbItemOROS.QuantidadeItemOS
													ELSE tbItemMOOROS.HorasCalculoComissao
												END
										END
								*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
									ELSE
										(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
										FROM	tbApontamentoMO APO	
										WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
										AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
										AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
										AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
										AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
										AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
										AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
										AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
									END
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
							),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						END
					ELSE 
						CASE WHEN @UtilizaTPR = 'F' and @TipoHoraInterna = 'R' THEN
							(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
							FROM	tbApontamentoMO APO	
							WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
							AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
							AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
							AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
							AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
							AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
							AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
							AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
						* (CASE tbCIT.OSInternaCIT WHEN 'V'
									THEN tbItemOROS.ValorUnitarioItemOS
									ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
									END)
						ELSE
							(COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
										THEN	CASE @TipoHoraInterna WHEN 'R'
												THEN tbItemMOOROS.HorasReaisItemMOOS
												ELSE tbItemMOOROS.HorasPrevistasItemMOOS
											END
										ELSE	CASE tbItemMOOROS.HorasCalculoComissao WHEN 0
												THEN tbItemOROS.QuantidadeItemOS
												ELSE tbItemMOOROS.HorasCalculoComissao
											END
									END
							*	CASE WHEN @UtilizaTPR = 'V' and tbTTR.TempoRealPadraoTTR = 'R' then
										(SELECT SUM(ttr.TempoTTR) FROM tbTTR ttr (NOLOCK)
										WHERE	ttr.CodigoEmpresa		= tbTTR.CodigoEmpresa
										AND		ttr.LivroTTR			= tbTTR.LivroTTR
										AND		ttr.CapituloTTR			= tbTTR.CapituloTTR
										AND		ttr.GrupoConstrucaoTTR	= tbTTR.GrupoConstrucaoTTR
										AND		ttr.OperacaoTTR			= tbTTR.OperacaoTTR
										AND		ttr.LinhaTTR			= tbTTR.LinhaTTR)
								ELSE
									(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO	
									WHERE	APO.CodigoEmpresa 		= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 		= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS			= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS			= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 			= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS			= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS		= tbApontamentoMO.SequenciaItemOS
									AND		APO.CodigoColaboradorOS = tbApontamentoMO.CodigoColaboradorOS)
								end
								/	(SELECT SUM(APO.TotalHorasApontamentoMOOS) 
									FROM	tbApontamentoMO APO
									WHERE	APO.CodigoEmpresa 	= tbApontamentoMO.CodigoEmpresa
									AND		APO.CodigoLocal 	= tbApontamentoMO.CodigoLocal
									AND		APO.FlagOROS		= tbApontamentoMO.FlagOROS
									AND		APO.NumeroOROS		= tbApontamentoMO.NumeroOROS
									AND		APO.CodigoCIT 		= tbApontamentoMO.CodigoCIT
									AND		APO.TipoItemOS		= tbApontamentoMO.TipoItemOS
									AND		APO.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS)
						),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
								THEN tbItemOROS.ValorUnitarioItemOS
								ELSE ValorUnitarioInvisivelItemOS 
								END) 
						END 
					END) * (tbColaboradorOS.PercComissaoColaboradorOS / 100) AS NUMERIC(16,2)),
		HorasVendidasTotal = COALESCE((CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END),0),
		ValorLiquidoOS = CASE ValorUnitarioInvisivelItemOS WHEN 0 
			THEN (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ((tbItemOROS.ValorLiquidoItemOS - ValorDescontoRateadoItemOROS) / CASE tbItemOROS.QuantidadeItemOS WHEN 0 THEN 1 ELSE tbItemOROS.QuantidadeItemOS END)
					END)
			ELSE (COALESCE((	CASE tbCIT.OSInternaCIT WHEN 'V'
							THEN	CASE @TipoHoraInterna WHEN 'R'
									THEN tbItemMOOROS.HorasReaisItemMOOS
									ELSE tbItemMOOROS.HorasPrevistasItemMOOS
								END
							ELSE	tbItemOROS.QuantidadeItemOS
						END
			),0)) * (CASE tbCIT.OSInternaCIT WHEN 'V'
					THEN tbItemOROS.ValorUnitarioItemOS
					ELSE ValorUnitarioInvisivelItemOS 
					END) END,
		tbColaboradorOS.CodigoColaboradorOS
					
	FROM	tbItemOROS

	INNER JOIN  tbApontamentoMO
	ON	tbApontamentoMO.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbApontamentoMO.CodigoLocal		= tbItemOROS.CodigoLocal 
	AND	tbApontamentoMO.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbApontamentoMO.NumeroOROS		= tbItemOROS.NumeroOROS 
	AND	tbApontamentoMO.CodigoCIT		= tbItemOROS.CodigoCIT
	AND	tbApontamentoMO.TipoItemOS		= tbItemOROS.TipoItemOS
	AND	tbApontamentoMO.SequenciaItemOS	= tbItemOROS.SequenciaItemOS

	INNER JOIN  tbItemMOOROS
	ON	tbItemMOOROS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbItemMOOROS.CodigoLocal		= tbApontamentoMO.CodigoLocal 
	AND	tbItemMOOROS.FlagOROS			= tbApontamentoMO.FlagOROS 
	AND	tbItemMOOROS.NumeroOROS			= tbApontamentoMO.NumeroOROS 
	AND	tbItemMOOROS.CodigoCIT			= tbApontamentoMO.CodigoCIT
	AND	tbItemMOOROS.TipoItemOS			= tbApontamentoMO.TipoItemOS
	AND	tbItemMOOROS.SequenciaItemOS	= tbApontamentoMO.SequenciaItemOS

	left join tbTTR
	on tbTTR.CodigoEmpresa			= tbItemMOOROS.CodigoEmpresa
	and tbTTR.LivroTTR				= tbItemMOOROS.LivroTTR
	and tbTTR.CapituloTTR			= tbItemMOOROS.CapituloTTR
	and tbTTR.GrupoConstrucaoTTR	= tbItemMOOROS.GrupoConstrucaoTTR
	and tbTTR.OperacaoTTR			= tbItemMOOROS.OperacaoTTR
	and tbTTR.LinhaTTR				= tbItemMOOROS.LinhaTTR

	INNER JOIN tbColaboradorOS 
	ON	tbColaboradorOS.CodigoEmpresa		= tbApontamentoMO.CodigoEmpresa
	AND	tbColaboradorOS.CodigoLocal			= tbApontamentoMO.CodigoLocal
	AND	tbColaboradorOS.CodigoColaboradorOS	= tbApontamentoMO.CodigoColaboradorOS

	INNER JOIN tbOROSCIT
	ON	tbOROSCIT.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbOROSCIT.CodigoLocal	= tbItemOROS.CodigoLocal 
	AND	tbOROSCIT.FlagOROS		= tbItemOROS.FlagOROS 
	AND	tbOROSCIT.NumeroOROS	= tbItemOROS.NumeroOROS 
	AND	tbOROSCIT.CodigoCIT		= tbItemOROS.CodigoCIT

	INNER JOIN tbEmpresa 
	ON	tbEmpresa.CodigoEmpresa	= tbItemOROS.CodigoEmpresa 

	INNER JOIN tbLocal
	ON	tbLocal.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbLocal.CodigoLocal		= tbItemOROS.CodigoLocal

	INNER JOIN tbCIT
	ON	tbCIT.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
	AND	tbCIT.CodigoCIT		= tbItemOROS.CodigoCIT

	WHERE	tbItemOROS.CodigoEmpresa		= @CodigoEmpresa 
	AND	tbItemOROS.CodigoLocal				= @CodigoLocal 
	AND	tbApontamentoMO.CodigoColaboradorOS	BETWEEN ISNULL(@DeCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
											AND	ISNULL(@AteCodigoColaborador, tbApontamentoMO.CodigoColaboradorOS)
	AND	tbColaboradorOS.CentroCusto			BETWEEN ISNULL(@DoCentroCusto,tbColaboradorOS.CentroCusto)
											AND ISNULL(@AteCentroCusto, tbColaboradorOS.CentroCusto)
	AND	tbOROSCIT.DataEncerramentoOSCIT		BETWEEN @DaDataNF	AND	@AteDataNF
	AND	tbOROSCIT.DataEmissaoNotaFiscalOS	IS NULL
	AND	tbOROSCIT.NumeroNotaFiscalOS		IS NULL
	AND	tbOROSCIT.StatusOSCIT				= 'E'
	AND	tbOROSCIT.ValorLiquidoOS			= 0
	AND	tbCIT.CalculaComissaoCIT			= 'V'

	AND NOT EXISTS	(SELECT 1 FROM tbItemOROS it
				WHERE	it.CodigoEmpresa	= tbItemOROS.CodigoEmpresa
				AND	it.CodigoLocal		= tbItemOROS.CodigoLocal 
				AND	it.FlagOROS			= tbItemOROS.FlagOROS
				AND	it.NumeroOROS		= tbItemOROS.NumeroOROS
				AND	it.CodigoCIT		= tbItemOROS.CodigoCIT
				AND	it.TipoItemOS		= tbItemOROS.TipoItemOS
				AND	it.SequenciaItemOS	= tbItemOROS.SequenciaItemOS
				AND	it.QuantidadeItemOS	!= 0)
	------------------------------------------------------------------------------------------
	-- Descarrega os dados
	------------------------------------------------------------------------------------------
	IF @DoCentroCusto = 1 AND @AteCentroCusto = 99999999
	BEGIN
		SELECT DISTINCT a.NomePessoal,
						a.CodigoLocal,
						a.NumeroRegistro,
						0 AS CentroCusto,
						replace(SUM(a.ValorTotal),'.',',') ValorBase,
						replace(a.PercComissaoColaboradorOS,'.',',') PercComissao,
						replace(SUM(a.ValorComissao), '.',',') ValorComissao,
						a.CodigoEmpresa,
						a.CodigoColaboradorOS CodigoMecanicoRepresentante,
						'OS' OrigemComissao,
						COALESCE(c.TipoFolha,1) TipoFolha,
						c.Categoria
		FROM #tbTemp a

		LEFT JOIN tbColaborador b
		ON  b.CodigoEmpresa		= a.CodigoEmpresa
		AND b.CodigoLocal		= a.CodigoLocal
		AND b.NumeroRegistro	= a.NumeroRegistro
		AND b.TipoColaborador	= 'F'

		LEFT JOIN tbCargo c
		ON  c.CodigoEmpresa		= b.CodigoEmpresa
		AND c.CodigoLocal		= b.CodigoLocal
		AND c.CodigoCargo		= b.CodigoCargo
		
		WHERE (PercComissaoColaboradorOS > 0 AND ValorTotal > 0)
		GROUP BY a.CodigoEmpresa,
				a.NomePessoal,
				a.CodigoLocal,
				a.NumeroRegistro,
				a.CentroCusto,
				a.PercComissaoColaboradorOS,
				a.CodigoColaboradorOS,
				c.TipoFolha,
				c.Categoria
		ORDER BY a.CodigoEmpresa,
				a.CodigoLocal,
				a.NomePessoal,
				a.CodigoColaboradorOS
--				a.CentroCusto
	END
	ELSE
	BEGIN
		SELECT DISTINCT a.NomePessoal,
						a.CodigoLocal,
						a.NumeroRegistro,
						a.CentroCusto,
						replace(SUM(a.ValorTotal),'.',',') ValorBase,
						replace(a.PercComissaoColaboradorOS,'.',',') PercComissao,
						replace(SUM(a.ValorComissao), '.',',') ValorComissao,
						a.CodigoEmpresa,
						a.CodigoColaboradorOS CodigoMecanicoRepresentante,
						'OS' OrigemComissao,
						COALESCE(c.TipoFolha,1) TipoFolha,
						c.Categoria
		FROM #tbTemp a

		LEFT JOIN tbColaborador b
		ON  b.CodigoEmpresa		= a.CodigoEmpresa
		AND b.CodigoLocal		= a.CodigoLocal
		AND b.NumeroRegistro	= a.NumeroRegistro
		AND b.TipoColaborador	= 'F'

		LEFT JOIN tbCargo c
		ON  c.CodigoEmpresa		= b.CodigoEmpresa
		AND c.CodigoLocal		= b.CodigoLocal
		AND c.CodigoCargo		= b.CodigoCargo
		
		WHERE (PercComissaoColaboradorOS > 0 AND ValorTotal > 0)
		GROUP BY a.CodigoEmpresa,
				a.NomePessoal,
				a.CodigoLocal,
				a.NumeroRegistro,
				a.CentroCusto,
				a.PercComissaoColaboradorOS,
				a.CodigoColaboradorOS,
				c.TipoFolha,
				c.Categoria
		ORDER BY a.CodigoEmpresa,
				a.CodigoLocal,
				a.NomePessoal,
				a.CodigoColaboradorOS,
				a.CentroCusto
	END
	DROP TABLE #tbTemp
	------------------------------------------------------------------------------------------
	-- Fim da procedure
	------------------------------------------------------------------------------------------
END

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelOSHorasVendidasColabOS TO SQLUsers
GO
