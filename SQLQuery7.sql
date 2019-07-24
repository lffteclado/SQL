SELECT glosa.id, glosa.data_glosa,
       cooperadoRecebedor.nome AS 'cooperado_recebedor',
	   atendimento.paciente,
	   procedimento.guia_procedimento,
	   espelho.numero_espelho,
	   convenio.sigla,
	   atendimento.numero_guia,
	   atendimento.hora_alta, 
	   procedimento.data_realizacao, 
	   carta.numero_carta,
	   procedimentoTUSS.codigo AS 'codigo_tuss',
	   itemDespesa.codigo AS 'codigo_item_despesa',
	   COALESCE(glosa.quantidadeCobrado,1) AS 'quantidade_cobrado',
	   COALESCE(glosa.quantidadeGlosado,1) AS 'quantidade_glosado',
	   procedimento.valor_total AS 'valor_total_procedimento',
	   glosa.valor_honorario AS 'valor_honorario_glosa',
	   glosa.valor_custo_operacional AS 'valor_custo_operacional_glosa',
	   glosa.valor_filme AS 'valor_filme_glosa',
	   glosa.valor_acrescimo AS 'valor_acrescimo_glosa',
	   glosa.valor_desconto AS 'valor_desconto_glosa',
	   motivoGlosa.descricao AS 'motivo_glosa',
	   glosa.erroItem_completo_unimed,
	   motivoUnimed.codigo AS 'codigo_motivo_unimed',
	   motivoUnimed.descricao AS 'descricao_motivo_unimed',
	   glosa.situacao, 
	   motivoGlosa.pk_importacao,
	   convenio.nome,
	   atendimento.numero_atendimento_automatico,
	   carta.data_emissao as emissaoCarta,
	   carta.data_vencimento as vencimentoCarta,
	   procedimento.valor_acrescimo			AS 'valor_acrescimo_procedimento'  FROM tb_glosa glosa WITH(NOLOCK)
INNER JOIN tb_procedimento procedimento WITH(NOLOCK)
ON (procedimento.id = glosa.fk_procedimento AND procedimento.registro_ativo = 1)
INNER JOIN tb_cooperado cooperadoRecebedor WITH(NOLOCK)
ON (cooperadoRecebedor.id = procedimento.fk_cooperado_recebedor_cobranca AND cooperadoRecebedor.registro_ativo = 1)
INNER JOIN tb_item_despesa itemDespesa WITH(NOLOCK)
ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo = 1)
LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSS WITH(NOLOCK)
ON (procedimentoTUSS.id = procedimento.fk_procedimento_tuss AND procedimentoTUSS.registro_ativo = 1)
INNER JOIN tb_atendimento atendimento WITH(NOLOCK)
ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo = 1)
INNER JOIN rl_entidade_convenio entidadeConvenio WITH(NOLOCK)
ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo = 1)
INNER JOIN tb_convenio convenio WITH(NOLOCK)
ON(convenio.id = entidadeConvenio.fk_convenio AND convenio.registro_ativo=1)
INNER JOIN tb_espelho espelho WITH(NOLOCK)
ON (espelho.id = atendimento.fk_espelho AND espelho.registro_ativo = 1)
LEFT JOIN tb_carta_glosa carta WITH(NOLOCK)
ON (carta.id = glosa.fk_carta_glosa AND carta.registro_ativo = 1)
LEFT JOIN tb_tabela_tiss motivoGlosa WITH(NOLOCK)
ON (motivoGlosa.id = glosa.fk_motivo_glosa AND motivoGlosa.registro_ativo=1)
LEFT JOIN tb_de_para_tuss_convenio motivoUnimed WITH(NOLOCK)
ON(motivoUnimed.id = glosa.fk_motivo_glosa_unimed AND motivoUnimed.registro_ativo=1)
WHERE glosa.registro_ativo=1 and glosa.autorizado_unimed = 1 and procedimento.autorizado_unimed = 1 and atendimento.autorizado_unimed = 1  and entidadeConvenio.id in (  2396 ) order by atendimento.numero_atendimento_automatico asc
--WHERE glosa.registro_ativo=1   AND entidadeConvenio.fk_entidade = :idEntidade and glosa.autorizado_unimed = 1 and procedimento.autorizado_unimed = 1 and atendimento.autorizado_unimed = 1  and  glosa.data_glosa between :dataEmissaoInferior and :dataEmissaoSuperior  and entidadeConvenio.id in (  2396 ) order by atendimento.numero_atendimento_automatico asc)