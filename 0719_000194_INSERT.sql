INSERT INTO [dbo].[tb_despesa]
           ([discriminator] --1
           ,[data_ultima_alteracao] --2
           ,[registro_ativo] -- 3
           ,[numero_auxiliares] --4
           ,[valor_honorario] --5
           ,[data_inicio_vigencia] --6
           ,[ch_moeda] --7
           ,[valor_acrescimo_tabela] --8
           ,[fk_usuario_ultima_alteracao] --9
           ,[fk_item_despesa] --10
           ,[fk_entidade_convenio] --11
           ,[fk_complemento] --12
           ,[fk_especialidade]--13
           ,[fk_entidade_hospital] --14
           ,[codigo_item_despesa_temp] --15
           ,[descricao_item_despesa_temp] --16
           ,[sql_update] --17
           ,[discriminator_fk_especialidade] --18
		   ) select 'EntidadeConvenioEspecialidade' as discriminator, --1
		             getdate() as data_ultima_alteracao, --2
					 1 as registro_ativo, --3
					 0 as numero_auxiliares, --4
		            (COALESCE((CONVERT(NUMERIC(19,2),[Valor Honorário])),0)) as valor_honorario, --5
				       [Vigencia Inicio] as data_inicio_vigencia, --6
					   [CH/MOEDA] as ch_moeda, --7
					   COALESCE(CONVERT(NUMERIC(19,2),[Acrescimo tabela]),0) as valor_acrescimo_tabela,	--8
					   12 as fk_usuario_ultima_alteracao, --9
					   fk_item_despesa as fk_item_despesa,--10
					   [Convênio ] as fk_entidade_convenio, --11
					   Complemento as fk_complemento, --12
					   [Especialidade (ANS)] as fk_especialidade, --13
					   Hospital as fk_entidade_hospital, --14	
					   [Codigo procedimento] as codigo_item_despesa_temp, --15
					   [Descrição procedimento] as descricao_item_despesa_temp, --16				  
					   '#0719-000194' as sql_update, --17
					   'especialidade' as discriminator_fk_especialidade --18
			 from tb_0719_000194
GO


