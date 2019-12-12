select distinct retornoGlosa.id
,entidade.sigla as cooperativa
,arquivoRetornoGlosa.campo_comparacao
,arquivoRetornoGlosa.valor_pago_recurso
,convenio.sigla
,arquivoRetornoGlosa.status_processamento
,arquivoRetornoGlosa.codigo_item_despesa
,item.codigo
,atendimento.numero_atendimento_automatico
,espelho.numero_espelho
--,procedimento.id
,situacao.valorGlosado
,arquivoRetornoGlosa.valor_recursado
from tb_arquivo_retorno_glosa arquivoRetornoGlosa
inner join tb_retorno_glosa retornoGlosa on(arquivoRetornoGlosa.fk_retorno_glosa=retornoGlosa.id)
inner join tb_entidade entidade on(entidade.id=retornoGlosa.fk_entidade and entidade.registro_ativo=1)
inner join tb_convenio convenio on(convenio.id=retornoGlosa.fk_convenio and convenio.registro_ativo=1)
inner join tb_atendimento atendimento on(atendimento.numero_guia = arquivoRetornoGlosa.campo_comparacao and atendimento.registro_ativo = 1)
inner join tb_procedimento procedimento on(procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo = 1)
inner join tb_item_despesa item on (item.id = procedimento.fk_item_despesa and item.codigo = arquivoRetornoGlosa.codigo_item_despesa)
inner join tb_espelho espelho on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
inner join rl_situacao_procedimento situacao on (situacao.fk_procedimento = procedimento.id)
where retornoGlosa.id = 8
      and arquivoRetornoGlosa.status_processamento=1
      and situacao.glosado = 1
	  and situacao.valorGlosado = arquivoRetornoGlosa.valor_recursado
	  order by retornoGlosa.id asc

/*
select distinct codigo from tb_item_despesa where codigo in (
select codigo_item_despesa from tb_arquivo_retorno_glosa where fk_retorno_glosa = 5)
*/