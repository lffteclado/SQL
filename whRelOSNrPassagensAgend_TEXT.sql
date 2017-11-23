--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE PROCEDURE dbo.whRelOSNrPassagensAgend
/* INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Controle de Oficina - StarClass
 AUTOR........: Marcio Schvartz
 DATA.........: 03/12/2010
 OBJETIVO.....: Consolidar o Número de Passagens pela Oficina por mes a mes

 ALTERACAO....: André Adam - 16/11/2016
 OBJETIVO.....: Alterado retorno para considerar o numero de meses selecionados e adicionado a possibilidade de retorno analitico.

whRelOSNrPassagensAgend 1608,0, '2016-01-01', '2016-12-04', 'V'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC */

DROP TABLE #tmp1
DROP TABLE #tmpAnalitico
DROP TABLE #tmpTipoAgendamento
DROP TABLE tmpAnaliticoRel

DECLARE @CodigoEmpresa		numeric(4)
DECLARE @CodigoLocal		numeric(4)
DECLARE @PeriodoInicial	datetime
DECLARE @PeriodoFinal		datetime
DECLARE @Analitico		char(1)

--AS

SET NOCOUNT	ON 


DECLARE @Mes					numeric(2)
DECLARE @Ano					char(4)
DECLARE @MediaNrPassagens		numeric(10,2)
DECLARE @MediaServicosAgendados numeric(10,2)
DECLARE @TotalServicosAgendados numeric(10,2)
DECLARE @MediaPercServAgendados numeric(10,2)
DECLARE @QuantidadeMes			numeric(10)
DECLARE @MediaStatus			numeric(10,2)
DECLARE @NumeroMeses			numeric(4)

SELECT

@CodigoEmpresa = 930,
@CodigoLocal = 0,
@PeriodoInicial = '2017-01-01 00:00:00:000',
@PeriodoFinal = '2017-12-31 00:00:00:000',
@Analitico = 'V'

CREATE TABLE #tmp1 
(
	Periodo varchar(6),
	Mes numeric(2),
	DescricaoMes varchar(10),
	Quantidade numeric(10,2),
	QtdServAgendados numeric(10,2),
	PercServAgendados numeric(10,2),
	EmAndamento numeric(10,2) NULL,
	Finalizado numeric(10,2) NULL,
	Cancelado numeric(10,2) NULL
)

CREATE TABLE #tmpAnalitico 
(
     Periodo varchar(6),
	Chassi varchar(30),
	Modelo varchar(30),
	Cliente varchar(60),
	NumeroOS numeric(6),
	DataAbertura datetime,
	DataEncerramento datetime
)

CREATE TABLE #tmpTipoAgendamento
(
	Mes numeric(2),
	TipoAgendamento varchar(11) NULL
)

SELECT @NumeroMeses = 0

-----------------------------------------------------------------------------
WHILE @PeriodoInicial <= @PeriodoFinal BEGIN

	SELECT @Mes = MONTH(@PeriodoInicial), @Ano = YEAR(@PeriodoInicial)

	INSERT INTO #tmp1
	SELECT	Periodo = @Ano + right('00' + CONVERT(varchar(2), @Mes),2)
			, Mes = (@Mes)
			, DescricaoMes =(CASE WHEN @Mes = 1 THEN 'Jan\ '
								 WHEN @Mes = 2 THEN 'Fev\ '
								 WHEN @Mes = 3 THEN 'Mar\ '
								 WHEN @Mes = 4 THEN 'Abr\ '
								 WHEN @Mes = 5 THEN 'Mai\ '
								 WHEN @Mes = 6 THEN 'Jun\ '
								 WHEN @Mes = 7 THEN 'Jul\ '
								 WHEN @Mes = 8 THEN 'Ago\ '
								 WHEN @Mes = 9 THEN 'SET\ '
								 WHEN @Mes = 10 THEN 'Out\ '
								 WHEN @Mes = 11 THEN 'Nov\ '
								 WHEN @Mes = 12 THEN 'Dez\ '
							END) + right(@Ano, 2)
				, Quantidade = 0

			--, Quantidade =		(	SELECT coalesce(count(*), 0) 
			--						FROM tbOROS (NOLOCK)
			--						WHERE CodigoEmpresa = @CodigoEmpresa
			--						AND CodigoLocal = @CodigoLocal
			--						AND FlagOROS = 'S'
			--						AND CONVERT(char(6), DataEncerramentoOS, 112) = @Ano + right('00' + CONVERT(varchar(2), @Mes),2))
			
			, QtdServAgendados =	(	SELECT count(*)
									FROM tbPreOS (NOLOCK)
									WHERE CodigoEmpresa = @CodigoEmpresa
									AND CodigoLocal = @CodigoLocal
									AND CONVERT(char(6), DataAgendamentoInicio, 112) = @Ano + right('00' + CONVERT(varchar(2), @Mes),2))
			, PercServAgendados = 0
			, EmAndamento = 0
			, Finalizado = 0
			, Cancelado = 0

			------ Agrupar por chassi a quantidade de passagens do mês
			SELECT   coalesce(count(veic.ChassiVeiculoOS), 0) Qtde
			INTO #tmpProcessar
			FROM tbOS os (NOLOCK)
			
			INNER JOIN tbOROSCIT ocit (NOLOCK)
			ON	ocit.CodigoEmpresa = os.CodigoEmpresa
			AND	ocit.CodigoLocal = os.CodigoLocal
			AND	ocit.FlagOROS = os.FlagOROS
			AND	ocit.NumeroOROS = os.NumeroOROS

			INNER JOIN tbOROS oros (NOLOCK)
			ON	oros.CodigoEmpresa = os.CodigoEmpresa
			AND	oros.CodigoLocal = os.CodigoLocal
			AND	oros.FlagOROS = os.FlagOROS
			AND	oros.NumeroOROS = os.NumeroOROS

			INNER JOIN tbVeiculoOS veic (NOLOCK)
			ON	veic.CodigoEmpresa = oros.CodigoEmpresa
			AND	veic.ChassiVeiculoOS = oros.ChassiVeiculoOS

			INNER JOIN tbCategoriaVeiculoOS catveic (NOLOCK)
			ON	catveic.CodigoEmpresa = veic.CodigoEmpresa
			AND	catveic.CodigoCategoriaVeiculoOS = veic.CodigoCategoriaVeiculoOS

			WHERE os.CodigoEmpresa = @CodigoEmpresa
				AND os.CodigoLocal = @CodigoLocal
				AND os.FlagOROS = 'S'
				AND	ocit.StatusOSCIT in ('N')
				AND CONVERT(char(6), oros.DataEncerramentoOS, 112) = @Ano + right('00' + CONVERT(varchar(2), @Mes),2)
			GROUP BY oros.DataAberturaOS
			
			--- Somar o total de passagens do mês
			SELECT @QuantidadeMes = coalesce(sum(Qtde), 0) FROM #tmpProcessar
			
			--- Atualiza a #tmp1 com a quantidade de passagens do mês corrente
			UPDATE #tmp1 SET Quantidade = @QuantidadeMes WHERE Mes = @Mes

			drop TABLE #tmpProcessar

	-- Status da Pre-OS ----------------------
	INSERT INTO #tmpTipoAgendamento
	SELECT 
		@Mes as Mes,
		CASE WHEN DataAgendamentoInicio IS NOT NULL AND DataEntradaVeiculo IS NOT NULL AND DataTerminoServico IS NULL AND rtrim(ltrim(MotivoCancelamentoPreOS))= '' THEN
			'ANDAMENTO'
		WHEN DataAgendamentoInicio IS NOT NULL AND DataEntradaVeiculo IS NOT NULL AND DataTerminoServico IS NOT NULL AND rtrim(ltrim(MotivoCancelamentoPreOS))= '' THEN
			'FINALIZADO'
		WHEN rtrim(ltrim(MotivoCancelamentoPreOS)) <> '' THEN
			'CANCELADO'
		END as TipoAgendamento
	FROM tbPreOS (NOLOCK)
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
	AND CONVERT(char(6), DataAgendamentoInicio, 112) = @Ano + right('00' + CONVERT(varchar(2), @Mes),2)	

	UPDATE #tmp1 SET EmAndamento = coalesce((SELECT count(*) FROM #tmpTipoAgendamento WHERE Mes = @Mes AND TipoAgendamento = 'ANDAMENTO'), 0) WHERE Mes = @Mes AND left(Periodo, 4) = @Ano
	UPDATE #tmp1 SET Finalizado = coalesce((SELECT count(*) FROM #tmpTipoAgendamento WHERE Mes = @Mes AND TipoAgendamento = 'FINALIZADO'), 0) WHERE Mes = @Mes AND left(Periodo, 4) = @Ano
	UPDATE #tmp1 SET Cancelado = coalesce((SELECT count(*) FROM #tmpTipoAgendamento WHERE Mes = @Mes AND TipoAgendamento = 'CANCELADO'), 0) WHERE Mes = @Mes AND left(Periodo, 4) = @Ano
	------------------------------------------

	IF @Analitico = 'V'
	BEGIN

	   INSERT INTO #tmpAnalitico
	   SELECT  Periodo = @Ano + right('00' + CONVERT(varchar(2), @Mes),2),
			 Chassi = veic.ChassiVeiculoOS,
			 Modelo = veic.MarcaVeiculoOS,
			 Cliente = clif.NomeCliFor,
			 NumeroOS = oros.NumeroOROS,
			 DataAbertura = oros.DataAberturaOS,
			 DataEncerramento = oros.DataEncerramentoOS
			FROM tbOS os (NOLOCK)
			
			INNER JOIN tbOROSCIT ocit (NOLOCK)
			ON	ocit.CodigoEmpresa = os.CodigoEmpresa
			AND	ocit.CodigoLocal = os.CodigoLocal
			AND	ocit.FlagOROS = os.FlagOROS
			AND	ocit.NumeroOROS = os.NumeroOROS

			INNER JOIN tbOROS oros (NOLOCK)
			ON	oros.CodigoEmpresa = os.CodigoEmpresa
			AND	oros.CodigoLocal = os.CodigoLocal
			AND	oros.FlagOROS = os.FlagOROS
			AND	oros.NumeroOROS = os.NumeroOROS

			INNER JOIN tbVeiculoOS veic (NOLOCK)
			ON	veic.CodigoEmpresa = oros.CodigoEmpresa
			AND	veic.ChassiVeiculoOS = oros.ChassiVeiculoOS

			INNER JOIN tbCategoriaVeiculoOS catveic (NOLOCK)
			ON	catveic.CodigoEmpresa = veic.CodigoEmpresa
			AND	catveic.CodigoCategoriaVeiculoOS = veic.CodigoCategoriaVeiculoOS

			INNER JOIN tbCliFor clif (NOLOCK)
			ON clif.CodigoCliFor = oros.CodigoCliFor
			AND clif.CodigoEmpresa = os.CodigoEmpresa

			WHERE os.CodigoEmpresa = @CodigoEmpresa
				AND os.CodigoLocal = @CodigoLocal
				AND os.FlagOROS = 'S'
				AND	ocit.StatusOSCIT in ('N')
				AND CONVERT(char(6), oros.DataEncerramentoOS, 112) = @Ano + right('00' + CONVERT(varchar(2), @Mes),2)

	END

	SELECT @NumeroMeses = @NumeroMeses + 1

	SELECT @PeriodoInicial = dateadd(m, 1, @PeriodoInicial)
END

-------- Totalizar Servicos Agendados
SELECT @TotalServicosAgendados = sum(QtdServAgendados) FROM #tmp1

-------- Media do Numero de Passagens / Servicos Agendados
SELECT @MediaNrPassagens = (coalesce(sum(Quantidade), 0) / @NumeroMeses) FROM #tmp1
SELECT @MediaServicosAgendados = (coalesce(sum(QtdServAgendados), 0) / @NumeroMeses) FROM #tmp1

-------- Percentual de Servicos Agendados
IF @TotalServicosAgendados > 0 BEGIN
	UPDATE #tmp1 SET PercServAgendados = coalesce(round((QtdServAgendados / Quantidade * 100),2), 0)
	WHERE Quantidade > 0 
END

-------- Media Percentual de Servicos Agendados
IF @MediaNrPassagens > 0 BEGIN
	SELECT @MediaPercServAgendados = coalesce(round((@MediaServicosAgendados / @MediaNrPassagens * 100),2), 0)
END

INSERT INTO #tmp1 (Periodo, Mes, DescricaoMes, Quantidade, QtdServAgendados, PercServAgendados) 
values ('999999', 13, 'Média', @MediaNrPassagens, @MediaServicosAgendados, @MediaPercServAgendados )

-- Média de EmAndamento
SELECT @MediaStatus = coalesce(sum(EmAndamento) / @NumeroMeses, 0) FROM #tmp1
UPDATE #tmp1 SET EmAndamento = @MediaStatus WHERE Mes = 13

-- Média de Finalizado
SELECT @MediaStatus = coalesce(sum(Finalizado) / @NumeroMeses, 0) FROM #tmp1
UPDATE #tmp1 SET Finalizado = @MediaStatus WHERE Mes = 13

-- Média de Cancelado
SELECT @MediaStatus = coalesce(sum(Cancelado) / @NumeroMeses, 0) FROM #tmp1
UPDATE #tmp1 SET Cancelado = @MediaStatus WHERE Mes = 13

--------
SET NOCOUNT OFF



------ Retorno
IF @Analitico = 'F'
BEGIN
    SELECT	Mes, DescricaoMes, Quantidade, 
		  Periodo, QtdServAgendados, PercServAgendados,
		  EmAndamento, Finalizado, Cancelado
    FROM #tmp1
    ORDER BY Periodo
END ELSE
BEGIN
     SELECT tmp.Mes, 
		  tmp.DescricaoMes,
		  tmp.Quantidade, 
		  tmp.Periodo, 
		  tmp.QtdServAgendados, 
		  tmp.PercServAgendados,
		  tmp.EmAndamento, 
		  tmp.Finalizado, 
		  tmp.Cancelado,
		  ana.Chassi,
		  ana.Modelo,
		  ana.Cliente,
		  ana.NumeroOS,
		  ana.DataAbertura,
		  ana.DataEncerramento
    FROM #tmp1 tmp

    FULL OUTER JOIN #tmpAnalitico ana
    ON tmp.Periodo = ana.Periodo

    ORDER BY tmp.Periodo
END

--select * into tmpAnaliticoRel2015 from #tmpAnalitico
--select * into tmpAnaliticoRel2016 from #tmpAnalitico
select * into tmpAnaliticoRel2017 from #tmpAnalitico
