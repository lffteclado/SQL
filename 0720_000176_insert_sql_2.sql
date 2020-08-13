/*Sequencia 2*/
INSERT INTO [dbo].[tb_despesa]
           ([discriminator]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[numero_auxiliares]
           ,[percentual_fator]
           ,[valor_custo_operacional]
           ,[valor_honorario]
           ,[data_final_vigencia]
           ,[data_inicio_vigencia]
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
           ,[valor_filme]
           ,[sql_update]
           ,[desconsiderar_uti])
select   'EntidadeConvenio' as discriminator
           ,0 as resolveu_dependencia
           ,getdate() as data_ultima_alteracao
           ,1 as registro_ativo
           ,tabela.auxiliares as numero_auxiliares
           ,tabela.fator as percentual_fator
           ,tabela.custo_operacional as valor_custo_operacional
           ,tabela.valor_honorario as valor_honorario
           ,tabela.data_fim_vigencia as data_final_vigencia
           ,tabela.data_inicio_vigencia as data_inicio_vigencia
           ,tabela.ch_moeda as ch_moeda
           ,0 as desconsiderar_apartamento
           ,0 as desconsiderar_enfermaria
           ,0 desconsiderar_externo
           ,0 as desconsiderar_urgencia
           ,tabela.acrescimo as valor_acrescimo_tabela
           ,tabela.porte as valor_porte_anestesia
           ,12 as fk_usuario_ultima_alteracao
           ,itemDespesa.id as fk_item_despesa
           ,5813 as fk_entidade_convenio--Esse id já é do BRADESCOOPERA. Se for testar com outro convenio é so alterar o id do fk_entidade_convenio
           ,tabela.filme as valor_filme
           ,'#0720-000176' as sql_update
           ,0 as desconsiderar_uti
from tb_procedimentos_bradescoopera tabela
cross apply(select distinct top 1 despesa.id,
                    despesa.codigo,
					despesa.descricao
		     from tb_item_despesa despesa
			 where despesa.codigo = tabela.codigo_procedimento
			 and despesa.descricao = tabela.descricao
			 and despesa.registro_ativo = 1
			 order by despesa.id desc ) as itemDespesa
go

drop table tb_procedimentos_bradescoopera
