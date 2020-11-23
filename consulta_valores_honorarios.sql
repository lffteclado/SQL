USE [sasc]
GO

/****** Object:  View [dbo].[vw_valores_honorarios]    Script Date: 16/07/2020 19:26:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER  view [dbo].[vw_valores_honorarios] as (
         select consulta.sigla as convenio,
				consulta.codigoProcedimento as procedimento, -- OBRIGATÓRIO
				consulta.descProcedimento as descricao,
				consulta.vlrHonorario as valorHonorario,
				consulta.tipo as tipo,
				replace(consulta.vigenciaInicial,'01/01/1900','') as vigenciaInicial,
				replace(consulta.vigenciaFinal,'01/01/1900','') as vigenciaFinal,
				consulta.idEntidade as idEntidade, -- OBRIGATÓRIO
				consulta.idConvenio as idConvenio,
				consulta.cpfCooperado as cpfCooperado, -- OBRIGATÓRIO
				consulta.vigenciaInicial_DT as vigenciaInicial_DT,
				consulta.vigenciaFinal_DT as vigenciaFinal_DT
				from 
				(select convenio.sigla as sigla,
					   convert(varchar, item.codigo) as codigoProcedimento,
					   (select top 1 descricao from tb_item_despesa with (nolock) where codigo = item.codigo ) as descProcedimento,
					   despesa.valor_honorario vlrHonorario, 
					   'EXCEÇÃO DE PROCEDIMENTO' as tipo,
					   Convert(varchar(10), isnull(despesa.data_inicio_vigencia,''),103) vigenciaInicial,
					   Convert(varchar(10), isnull(despesa.data_final_vigencia,''),103) vigenciaFinal,
					   entidadeConvenio.fk_entidade idEntidade,
					   entidadeConvenio.fk_convenio idConvenio,
					   convert(varchar, 'N/A') as cpfCooperado,
					   despesa.data_inicio_vigencia as vigenciaInicial_DT,
					   despesa.data_final_vigencia as vigenciaFinal_DT
				  from tb_entidade entidade with (nolock)
				 inner join rl_entidade_convenio entidadeConvenio with (nolock) on (entidadeConvenio.fk_entidade = entidade.id and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
				 inner join tb_convenio convenio with (nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
				 inner join tb_despesa despesa with (nolock) on (despesa.fk_entidade_convenio = entidadeConvenio.id and despesa.registro_ativo = 1)
				 inner join tb_item_despesa item with (nolock) on (item.id = despesa.fk_item_despesa and item.registro_ativo = 1)  
				 where /*(despesa.data_final_vigencia is null or despesa.data_final_vigencia >= GETDATE()) 
				   and*/ despesa.discriminator = 'EntidadeConvenio'
				   and despesa.fk_especialidade is null
				   and item.tipo_item_despesa = 0
				 union 
				select convenio.sigla as sigla,
					   convert(varchar, item.codigo) as codigoProcedimento,
					   (select top 1 descricao from tb_item_despesa with (nolock) where codigo = item.codigo ) as descProcedimento,
					   despesa.valor_honorario vlrHonorario, 
					   'EXCEÇÃO DE ESPECIALIDADE: ' + UPPER(especialidade.descricao) as tipo,
					   Convert(varchar(10), isnull(despesa.data_inicio_vigencia,''),103) vigenciaInicial,
					   Convert(varchar(10), isnull(despesa.data_final_vigencia,''),103) vigenciaFinal,
					   entidadeConvenio.fk_entidade idEntidade,
					   entidadeConvenio.fk_convenio idConvenio,
					   convert(varchar, cooperado.cpf_cnpj) as cpfCooperado,
					   despesa.data_inicio_vigencia as vigenciaInicial_DT,
					   despesa.data_final_vigencia as vigenciaFinal_DT
				  from tb_entidade entidade with (nolock)
				 inner join rl_entidade_convenio entidadeConvenio with (nolock) on (entidadeConvenio.fk_entidade = entidade.id and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
				 inner join tb_convenio convenio with (nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
				 inner join tb_despesa despesa with (nolock) on (despesa.fk_entidade_convenio = entidadeConvenio.id and despesa.registro_ativo = 1)
				 inner join tb_item_despesa item with (nolock) on (item.id = despesa.fk_item_despesa and item.registro_ativo = 1)
				 inner join tb_tabela_tiss especialidade with (nolock) on (especialidade.id = despesa.fk_especialidade)
				 inner join rl_entidade_cooperado entidadeCooperado with (nolock) on (entidadeCooperado.fk_entidade = entidade.id and entidadeCooperado.registro_ativo = 1)
				 inner join tb_cooperado cooperado with (nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and cooperado.registro_ativo = 1)
				 inner join rl_entidadecooperado_especialidade entidadeEspecialidade with (nolock) on (entidadeEspecialidade.fk_entidade_cooperado = entidadeCooperado.id and
																									   entidadeEspecialidade.fk_especialidade = especialidade.id and 
																									   entidadeEspecialidade.registro_ativo = 1)
				 where /*(despesa.data_final_vigencia is null or despesa.data_final_vigencia >= GETDATE()) 
				   and*/ despesa.fk_especialidade is not null
				   and item.tipo_item_despesa = 0
				 union 
				select convenio.sigla as sigla,
					   convert(varchar, item.codigo) as codigoProcedimento,
					   (select top 1 descricao from tb_item_despesa with (nolock) where codigo = item.codigo ) as descProcedimento,
					   case when despesa.valor_honorario is null then fator.valorFator else despesa.valor_honorario end as vlrHonorario,
					   upper(tabela.sigla) + ' ' + upper(edicaoTabela.edicao) as tipo,
					   Convert(varchar(10), isnull(tabelaVigente.vigenciaInicial,''),103) vigenciaInicial,
					   Convert(varchar(10), isnull(tabelaVigente.vigenciaFinal,''),103) vigenciaFinal,
					   entidadeConvenio.fk_entidade idEntidade,
					   entidadeConvenio.fk_convenio idConvenio,
					   convert(varchar, 'N/A') as cpfCooperado,
					   tabelaVigente.vigenciaInicial as vigenciaInicial_DT,
					   tabelaVigente.vigenciaFinal as vigenciaFinal_DT
				  from tb_despesa despesa
				 inner join tb_edicao_tabela_honorarios edicaoTabela with (nolock) on (edicaoTabela.id = despesa.fk_edicao_tabela_honorarios and edicaoTabela.registro_ativo = 1)
				 inner join tb_tabela_honorarios tabela with (nolock) on (edicaoTabela.fk_tabela_honorarios = tabela.id and tabela.registro_ativo = 1)
				 inner join tb_item_despesa item with (nolock) on (item.id = despesa.fk_item_despesa and item.registro_ativo = 1)
				 inner join rl_entidade_convenio entidadeConvenio with (nolock) on (entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
				 inner join tb_convenio convenio with (nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1) 
				 cross apply (select top 1 edicaoTabela.id as idEdicaoTabelahonorario,
									 honorario.id as idTabelahonorario,
									 entidadeHistoricoHonorario.fk_entidade_convenio as idEntidadeConvenio,
									 entidadeHistoricoHonorario.fk_edicao_fator_porte edicaoFatorPorte,
									 entidadeHistoricoHonorario.data_inicio_vigencia vigenciaInicial,
									 isnull(entidadeHistoricoHonorario.data_final_vigencia,'') vigenciaFinal
								from rl_entidadeconvenio_historico_tabela_honorario entidadeHistoricoHonorario with (nolock)
								left join tb_edicao_tabela_honorarios edicaoTabela with (nolock) on (edicaoTabela.id = entidadeHistoricoHonorario.fk_edicao_tabela_honorarios and 
																									 edicaoTabela.registro_ativo = 1)
								left join tb_tabela_honorarios honorario with (nolock) on (honorario.id = edicaoTabela.fk_tabela_honorarios and honorario.registro_ativo = 1)
							   where /*(entidadeHistoricoHonorario.data_final_vigencia is null or entidadeHistoricoHonorario.data_final_vigencia >= GETDATE()) 
								 and*/ entidadeHistoricoHonorario.registro_ativo = 1
								 and entidadeHistoricoHonorario.fk_entidade_convenio = entidadeConvenio.id
							   order by entidadeHistoricoHonorario.id desc) as tabelaVigente
				 outer Apply(select valor as valorFator 
							   from tb_fator with (nolock)	
							  where fk_item_fator = despesa.fk_item_fator 
								and fk_edicao_fator_porte = tabelaVigente.edicaoFatorPorte) as fator
				 where despesa.fk_especialidade is null
				   and item.tipo_item_despesa = 0
				   and edicaoTabela.id = tabelaVigente.idEdicaoTabelahonorario 
				   and tabela.id = tabelaVigente.idTabelahonorario   
				   )  consulta
)



GO