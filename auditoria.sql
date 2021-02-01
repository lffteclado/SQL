/*select * from tb_gestao_contratos with(nolock) where registro_ativo = 1

--update tb_gestao_contratos set registro_ativo = 0 where registro_ativo = 1

select top 10 * from rl_entidadeconvenio_historico_tabela_honorario order by id desc

select top 10 * from rl_entidadeconvenio_historico_tabela_honorario_AUD order by id desc


select top 10 * from rl_entidadeconvenio_historico_tabela_honorario order by id desc


select  top 10* from rl_entidadeconvenio_historico_tabela_honorario_AUD order by id desc

select * from rl_entidadeconvenio_historico_tabela_honorario_AUD
WHERE data_ultima_alteracao > '2020-10-14'

select  top 10 * from rl_entidadeconvenio_historico_tabela_honorario  where id = 10641

select top 10 * from REVINFO WHERE REV = 69297639*/


select auditoria.id
       ,auditoria.REVTYPE
       ,auditoria.data_inicio_vigencia
	   ,auditoria.data_final_vigencia
       ,auditoria.fk_entidade_convenio
	   ,auditoria.fk_entidade_hospital
	   ,auditoria.fk_entidade_acomodacao
	   ,auditoria.fk_edicao_tabela_honorarios
	   ,auditoria.data_ultima_alteracao
	   --,tabelaHonorario.pk_importacao
	   ,auditoria.fk_cooperado
	   ,auditoria.fk_entidade_convenio_complemento
	   ,auditoria.fk_tabela_tiss
	   ,auditoria.fk_tipo_tabela_tiss
	   ,auditoria.fk_grau_participacao
	   ,auditoria.fk_acomodacao
	   ,auditoria.valor_fator_custo_operacional
	   ,auditoria.hora_trabalho_inicial_segunda_a_sexta
	   ,auditoria.hora_trabalho_final_segunda_a_sexta
	   ,auditoria.hora_trabalho_inicial_sabado
	   ,auditoria.hora_trabalho_final_sabado
	   ,auditoria.data_hora_inclusao
	   ,auditoria.codigo_ans
	   ,auditoria.fk_ch
	   ,auditoria.fk_edicao_fator_porte
	   ,auditoria.fk_ch_operacional
	   ,auditoria.acrescimo_tabela
	   ,auditoria.valor_filme
	   ,auditoria.desconto_convenio
	   ,auditoria.acrescimo_convenio
	   ,auditoria.tipo_cobranca_video
	   ,auditoria.percentual_cobranca_video
	   ,auditoria.mudanca_porte_aproximacao
	   ,auditoria.acrescimo_tabela_custo_operacional
	   ,auditoria.validar_numero_auxiliares
	   ,auditoria.validar_numero_auxiliares_anestesia
	   ,auditoria.zerar_procedimentos_quando_exceder_auxiliares
	   ,auditoria.gerar_inconsistencia_quantidade_auxiliares_excedida
	   ,auditoria.validar_procedimento_maior_auxilio
	   ,auditoria.calculo_uco
	   ,auditoria.considerar_calculo_filme_grau_participacao_acomodacao
	   ,auditoria.mudanca_porte_zero
	   ,auditoria.calculo_termo_aditivo
	   ,auditoria.observacao_negociacao
	   --,tabelaHonorario.resolveu_dependencia
	   --,tabelaHonorario.sql_update
	   ,auditoria.registro_ativo
	   ,auditoria.fk_usuario_ultima_alteracao
	   --,tabelaHonorario.sigla
	   --,edicaoTabelaHonorarios.edicao
	   --,edicaoFatorPorte.descricao
	   --,entidadeConvenioComplemento.descricao
	   --,ch.codigo
	   --,ch.valor_coeficiente_honorario
	   --,usuario.nome
	   ,auditoria.fk_edicao_fator_porte
from rl_entidadeconvenio_historico_tabela_honorario_AUD auditoria
/*inner join tb_edicao_tabela_honorarios edicaoTabelaHonorarios on(edicaoTabelaHonorarios.id = auditoria.fk_edicao_tabela_honorarios)
inner join tb_tabela_honorarios tabelaHonorario on(tabelaHonorario.id = edicaoTabelaHonorarios.fk_tabela_honorarios)
left join tb_edicao_fator_porte edicaoFatorPorte on(edicaoFatorPorte.id = auditoria.fk_edicao_fator_porte)
left join rl_entidadeconvenio_complemento entidadeConvenioComplemento on(entidadeConvenioComplemento.id = auditoria.fk_entidade_convenio_complemento)
left join tb_ch ch on(ch.id = auditoria.fk_ch)
inner join tb_usuario usuario on(usuario.id = auditoria.fk_usuario_ultima_alteracao)*/
 where auditoria.fk_entidade_convenio = 4535