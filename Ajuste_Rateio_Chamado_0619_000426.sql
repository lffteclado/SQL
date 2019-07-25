/* Criar um Backup da Tabela para recuperar os valores caso algum procedimento fique zerado */
select * into tmp_tb_procedimento from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 558443 and registro_ativo = 1
) and registro_ativo = 1

GO

/* Atualizar os valores dos procedimentos com o valor de origem antes do rateio */
update procedimento set
procedimento.valor_honorario = (procedimento.valor_honorario + pagamentoRateio.valor_honorario),
procedimento.valor_acrescimo = (procedimento.valor_acrescimo + pagamentoRateio.valor_acrescimo),
procedimento.valor_filme = (procedimento.valor_filme + pagamentoRateio.valor_filme),
procedimento.valor_custo_operacional = (procedimento.valor_custo_operacional + pagamentoRateio.valor_custo_operacional),
procedimento.valor_desconto = (procedimento.valor_desconto + pagamentoRateio.valor_desconto),
procedimento.valor_total = (procedimento.valor_honorario + pagamentoRateio.valor_honorario)
                           + (procedimento.valor_acrescimo + pagamentoRateio.valor_acrescimo)
						   + (procedimento.valor_filme + pagamentoRateio.valor_filme)
						   + (procedimento.valor_custo_operacional + pagamentoRateio.valor_custo_operacional)
						   - (procedimento.valor_desconto + pagamentoRateio.valor_desconto),
procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'#0619-000426'
FROM tb_procedimento procedimento
	CROSS APPLY (
	select sum(procedSelect.valor_honorario) as valor_honorario,
	sum(procedSelect.valor_acrescimo) as valor_acrescimo, 
	sum(procedSelect.valor_filme) as valor_filme,
	sum(procedSelect.valor_custo_operacional) as valor_custo_operacional,
	sum(procedSelect.valor_desconto) as valor_desconto
	FROM tb_procedimento procedSelect
	WHERE procedSelect.referencia_procedimento_rateio = procedimento.id
	AND procedSelect.registro_ativo = 1
	) pagamentoRateio
inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.id in (
	select id from tb_atendimento
	where fk_espelho = 558443 and fk_entidade = 43 and registro_ativo = 1)
AND atendimento.fk_entidade = 43
AND atendimento.ano_atendimento = 2019
AND procedimento.registro_ativo = 1
AND procedimento.referencia_procedimento_rateio is null

GO

/* Setando registro ativo = 0 nos pagamentos procedimentos criados no rateio */
update tb_pagamento_procedimento set registro_ativo = 0 where fk_procedimento in (
select id from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 558443 and registro_ativo = 1
) and registro_ativo = 1
)and registro_ativo = 1

GO

/*Setar registro ativo 0 para os procedimentos criados no rateio */
update tb_procedimento set registro_ativo = 0, sql_update = ISNULL(sql_update,'')+'#0619-000426' where referencia_procedimento_rateio in (
select referencia_procedimento_rateio from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 558443 and fk_entidade = 43 and registro_ativo = 1
) and referencia_procedimento_rateio is not null
)

GO

/* Atualizar caso algum procedimento tenha ficado com valor zerado ou null com base no backup realizado anteriormente */
update procedimento set
procedimento.valor_honorario = (pagamentoRateio.valor_honorario),
procedimento.valor_acrescimo = (pagamentoRateio.valor_acrescimo),
procedimento.valor_filme = (pagamentoRateio.valor_filme),
procedimento.valor_custo_operacional = (pagamentoRateio.valor_custo_operacional),
procedimento.valor_desconto = (pagamentoRateio.valor_desconto),
procedimento.valor_total = (pagamentoRateio.valor_honorario)
                           + (pagamentoRateio.valor_acrescimo)
						   + (pagamentoRateio.valor_filme)
						   + (pagamentoRateio.valor_custo_operacional)
						   - (pagamentoRateio.valor_desconto),
procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'#0619-000426'
FROM tb_procedimento procedimento
	CROSS APPLY (
	select (procedSelect.valor_honorario) as valor_honorario,
	(procedSelect.valor_acrescimo) as valor_acrescimo, 
	(procedSelect.valor_filme) as valor_filme,
	(procedSelect.valor_custo_operacional) as valor_custo_operacional,
	(procedSelect.valor_desconto) as valor_desconto
	FROM tmp_tb_procedimento procedSelect
	WHERE procedSelect.id = procedimento.id
	AND procedSelect.registro_ativo = 1
	) pagamentoRateio
inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.id in (
	select id from tb_atendimento
	where fk_espelho = 558443 and fk_entidade = 43 and registro_ativo = 1)
AND atendimento.fk_entidade = 43
AND atendimento.ano_atendimento = 2019
AND procedimento.registro_ativo = 1
AND procedimento.referencia_procedimento_rateio is null
AND procedimento.valor_honorario is null

GO

/* Procedure para criar os novos registro na tabela pagamento procedimento */
DECLARE @RC int
DECLARE @idEspelho bigint = 558443
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

-- TODO: Defina valores de parâmetros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO