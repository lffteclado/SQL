update tb_despesa set data_final_vigencia = '2018-09-30', sql_update = ISNULL(sql_update,'')+'0919-000642' where id in (
select despesa.id
from tb_despesa despesa
cross apply(
 select top 1 codigo,descricao from tb_item_despesa item
  where despesa.fk_item_despesa = item.id
        and item.registro_ativo = 1 order by id desc
) as itemDespesa
inner join [0919_000642] planilha on (planilha.codigo = itemDespesa.codigo)
inner join  tb_tabela_tiss tabelaTiss on (despesa.fk_especialidade = tabelaTiss.id and tabelaTiss.registro_ativo = 1 and despesa.fk_especialidade = planilha.fk_especialidade)
where despesa.discriminator = 'EntidadeConvenioEspecialidade' and fk_entidade_convenio = 2086  )

GO

INSERT INTO [dbo].[tb_despesa]
           ([discriminator]
           ,[pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[numero_auxiliares]
           ,[percentual_fator]
           ,[quantidade_filme]
           ,[valor_custo_operacional]
           ,[valor_honorario]
           ,[grupo]
           ,[sub_grupo]
           ,[data_final_vigencia]
           ,[data_inicio_vigencia]
           ,[situacao]
           ,[ch_moeda]
           ,[desconsiderar_apartamento]
           ,[desconsiderar_enfermaria]
           ,[desconsiderar_externo]
           ,[desconsiderar_urgencia]
           ,[valor_acrescimo_tabela]
           ,[valor_porte_anestesia]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_item_despesa]
           ,[fk_entidade_convenio]
           ,[fk_complemento]
           ,[fk_especialidade]
           ,[fk_edicao_tabela_honorarios]
           ,[fk_item_fator]
           ,[fk_item_porte_anestesia]
           ,[fk_ch]
           ,[fk_entidade_cooperado]
           ,[fk_entidade_hospital]
           ,[codigo_fk_item_despesa]
           ,[descricao_fk_item_despesa]
           ,[codigo_fk_item_porte_anestesia]
           ,[quantidade_ch]
           ,[quantidade_uco]
           ,[valor_filme]
           ,[codigo_fk_item_fator]
           ,[codigo_item_despesa_temp]
           ,[descricao_item_despesa_temp]
           ,[fk_hospital_fk_entidade_hospital]
           ,[fk_entidade_fk_entidade_hospital]
           ,[fk_convenio_fk_entidade_convenio]
           ,[fk_entidade_fk_entidade_convenio]
           ,[pk_importacao_fk_complemento]
           ,[pk_importacao_fk_ch]
           ,[sql_update]
           ,[percentual_fator_cbhpm]
           ,[reducao_porte_anestesia]
           ,[tipo_ch_moeda]
           ,[desconsiderar_acrescimo]
           ,[desconsiderar_custeio]
           ,[tp_grupo_subgrupo]
           ,[fk_fator]
           ,[fk_porte_anestesia]
           ,[pk_importacao_fk_hospital_fk_entidade_hospital]
           ,[pk_importacao_fk_entidade_fk_entidade_hospital]
           ,[pk_importacao_fk_especialidade]
           ,[discriminator_fk_especialidade]
           ,[fk_com_con_fk_complemento]
           ,[fk_convenio_fk_complemento]
           ,[fk_entidade_fk_complemento]
           ,[fk_ch_anterior]
           ,[desconsiderar_uti]
           ,[fk_cooperado_fk_entidade_cooperado]
           ,[fk_entidade_fk_entidade_cooperado]
           ,[procedimento_origem_converter]
           ,[procedimento_destino_converter])
     SELECT
           'EntidadeConvenioEspecialidade' AS discriminator,
           null AS pk_importacao,
           0 as resolveu_dependencia,
           getdate() as data_ultima_alteracao,
           1 as registro_ativo,
           0 as numero_auxiliares,
           null as percentual_fator,
           null as quantidade_filme,
           null as valor_custo_operacional,
           planilha.valor as valor_honorario,
           null as grupo,
           null as sub_grupo,
           null as data_final_vigencia,
           planilha.vigencia as data_inicio_vigencia,
           null as situacao,
           'M' as ch_moeda,
           0 as desconsiderar_apartamento,
           0 as desconsiderar_enfermaria,
           0 as desconsiderar_externo,
           0 as desconsiderar_urgencia,
           5.00 as valor_acrescimo_tabela,
           null as valor_porte_anestesia,
           12 as fk_usuario_ultima_alteracao,
           itemDespesa.id as fk_item_despesa,
           2086 as fk_entidade_convenio,
           null as fk_complemento,
           especialidade.id as fk_especialidade,
           null as fk_edicao_tabela_honorarios,
           null as fk_item_fator,
           null as fk_item_porte_anestesia,
           null as fk_ch,
           null as fk_entidade_cooperado,
           null as fk_entidade_hospital,
           null as codigo_fk_item_despesa,
           null as descricao_fk_item_despesa,
           null as codigo_fk_item_porte_anestesia,
           null as quantidade_ch,
           null as quantidade_uco,
           null as valor_filme,
           null as codigo_fk_item_fator,
           null as codigo_item_despesa_temp,
           null as descricao_item_despesa_temp,
           null as fk_hospital_fk_entidade_hospital,
           null as fk_entidade_fk_entidade_hospital,
           null as fk_convenio_fk_entidade_convenio,
           null as fk_entidade_fk_entidade_convenio,
           null as pk_importacao_fk_complemento,
           null as pk_importacao_fk_ch,
           '0919-000642' as sql_update,
           null as percentual_fator_cbhpm,
           null as reducao_porte_anestesia,
           null as tipo_ch_moeda,
           null as desconsiderar_acrescimo,
           null as desconsiderar_custeio,
           null as tp_grupo_subgrupo,
           null as fk_fator,
           null as fk_porte_anestesia,
           null as pk_importacao_fk_hospital_fk_entidade_hospital,
           null as pk_importacao_fk_entidade_fk_entidade_hospital,
           null as pk_importacao_fk_especialidade,
           null as discriminator_fk_especialidade,
           null as fk_com_con_fk_complemento,
           null as fk_convenio_fk_complemento,
           null as fk_entidade_fk_complemento,
           null as fk_ch_anterior,
           0 as desconsiderar_uti,
           null as fk_cooperado_fk_entidade_cooperado,
           null as fk_entidade_fk_entidade_cooperado,
           null as procedimento_origem_converter,
           null as procedimento_destino_converter
from [0919_000642] planilha with(nolock)
inner join tb_tabela_tiss especialidade with(nolock) on (planilha.fk_especialidade = especialidade.id)
cross apply(
 select top 1 id,codigo,descricao from tb_item_despesa item
  where planilha.codigo = item.codigo
        and item.registro_ativo = 1 order by id desc
) as itemDespesa

GO

drop table [0919_000642]


