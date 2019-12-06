--Convenio GOOD LIFE
--Entidade GINECOOP

select * from tb_glosa where fk_carta_glosa = 216175 and registro_ativo = 1
select valor_total, * from tb_procedimento where id = 29192499
select * from tb_atendimento where id = 20274042
select * from tb_carta_glosa where id = 216175 and registro_ativo = 1
select * from tb_espelho where id = 771984
select * from tb_arquivo_retorno_glosa where registro_ativo = 1 and fk_retorno_glosa = 21
select * from tb_retorno_glosa order by id desc
select * from rl_situacao_procedimento where fk_procedimento = 29167899
select * from tb_pagamento_procedimento where fk_procedimento = 29167899

/***************************************************************/

select valor_total, fk_atendimento, * from tb_procedimento where id in (29167905, 29167899)
select * from rl_situacao_procedimento where fk_procedimento in (27436949) --(29192504) --(29167905, 29167899)
select * from tb_pagamento_procedimento where fk_procedimento in (27436949) --(29192504) --(29167905, 29167899)

select fk_atendimento, * from tb_procedimento where id in (29192510)

select * from tb_glosa where fk_procedimento = 27436949
union all
select * from tb_glosa where fk_procedimento = 29167899

select * from tb_carta_glosa where id = 216175

select fk_espelho, * from tb_atendimento where id IN (19029526, 19029867)

select * from tb_espelho where id = 625317

select * from tb_procedimento where fk_atendimento = 20274042

--update tb_procedimento set faturar = 1 where id = 29192510
--update tb_atendimento set faturar = 1 where id = 20294299

--update rl_situacao_procedimento set valorEspelhado = valorGlosado, espelhado = glosado where fk_procedimento = 29167905

--update rl_situacao_procedimento set valorGlosado = 0.00, glosado = 0 where fk_procedimento = 29167905

--update tb_pagamento_procedimento set registro_ativo = 0 where fk_procedimento = 29167905

--update tb_glosa set situacao = 4 where fk_procedimento = 29192510
--update tb_glosa set situacao = 4 where fk_procedimento = 29167899

--sp_helptext gerarPagamentoProcedimentoPorEspelho

DECLARE @RC int
DECLARE @idEspelho bigint = 771984
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


select * from tb_espelho where id = 771984



select * from rl_situacao_procedimento where fk_procedimento = 29167905
select * from tb_pagamento_procedimento where fk_procedimento = 29167905

select * from tb_atendimento where id in (
	select fk_atendimento, id from tb_procedimento where id in (
		select fk_procedimento from tb_glosa
		 where fk_carta_glosa = 216175 and registro_ativo = 1
	) and registro_ativo = 1
)and registro_ativo = 1

select * from rl_situacao_procedimento where  fk_procedimento in (
	select id from tb_procedimento where id in (
		select fk_procedimento from tb_glosa
		 where fk_carta_glosa = 216175 and registro_ativo = 1
	) and registro_ativo = 1
) and valorGlosado between 90 and 100


select atendimento.numero_atendimento_automatico,
       procedimento.id,
	   procedimento.data_realizacao,
	   linha.campo_comparacao,
	   itemDespesa.codigo,
	   carta.numero_carta,
	   linha.valor_pago_recurso,
	   situacaoProcedimento.valorGlosado
from tb_atendimento atendimento
inner join tb_procedimento procedimento on( atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
inner join tb_arquivo_retorno_glosa linha on(atendimento.numero_guia = linha.campo_comparacao and linha.registro_ativo = 1)
inner join tb_retorno_glosa arquivo on(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
inner join tb_glosa glosa on(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
inner join tb_carta_glosa carta on(glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
inner join rl_situacao_procedimento situacaoProcedimento on(situacaoProcedimento.fk_procedimento = procedimento.id and situacaoProcedimento.glosado = 1)
inner join rl_entidade_convenio entidadeConvenio on(entidadeConvenio.id = atendimento.fk_convenio
														and entidadeConvenio.fk_convenio = arquivo.fk_convenio
													)
cross apply(
	select item.id, item.codigo from tb_item_despesa item
	 where procedimento.fk_item_despesa = item.id
) as itemDespesa
where linha.fk_retorno_glosa = 36
      and procedimento.data_realizacao = linha.data_realizacao
	  and itemDespesa.codigo = linha.codigo_item_despesa
	  and glosa.situacao in (3,7)
	  and entidadeConvenio.fk_entidade = 6
	  and situacaoProcedimento.valorGlosado between (linha.valor_pago_recurso - arquivo.diferenca)
	       and (linha.valor_pago_recurso + arquivo.diferenca)

select * from tb_entidade where id = 6

select * from tb_espelho where numero_espelho = 33330 and fk_entidade = 6

select * from tb_atendimento where fk_espelho = 786157 and registro_ativo = 1

select * from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 786157 and registro_ativo = 1
)

select * from tb_pagamento_procedimento where fk_procedimento in(
select id from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 786157 and registro_ativo = 1
)) and valor_honorario = 0.00

select * from rl_situacao_procedimento where fk_procedimento in (
select id from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 786157 and registro_ativo = 1
)
) and glosado = 1


select * from tb_carta_glosa where fk_entidade = 6 order by id desc