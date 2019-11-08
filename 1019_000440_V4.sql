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


