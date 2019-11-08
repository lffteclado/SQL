select distinct
       atendimento.id as idtendimento,
       atendimento.guia_principal,
       atendimento.paciente,
       itemDespesa.codigo,
	   procedimento.id as id_procedimento,
	   procedimento.valor_honorario,
	   arquivoGlosa.data_realizacao,
	   glosa.fk_procedimento,
	   espelho.numero_espelho,
	   espelho.fk_entidade
from tb_procedimento procedimento with(nolock)
inner join tb_atendimento atendimento with(nolock) on (procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo = 1 and atendimento.registro_ativo = 1)
inner join tb_item_despesa itemDespesa with(nolock) on (procedimento.fk_item_despesa = itemDespesa.id and itemDespesa.registro_ativo = 1)
inner join tb_glosa glosa with(nolock) on (glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
inner join tb_espelho espelho with(nolock) on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
inner join tb_arquivo_retorno_glosa arquivoGlosa with(nolock) on (
           arquivoGlosa.codigo_item_despesa = itemDespesa.codigo
		    and arquivoGlosa.data_realizacao = procedimento.data_realizacao
			and arquivoGlosa.campo_comparacao = atendimento.guia_principal
			and arquivoGlosa.registro_ativo = 1)
order by atendimento.paciente