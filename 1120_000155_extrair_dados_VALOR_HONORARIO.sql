CREATE TABLE [dbo].[procedimento](
	[codigo] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'10101012')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30717094')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30713137')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30713145')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715130')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715156')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715237')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30717094')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30207223')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30601304')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715121')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715342')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30717086')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30718066')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30719070')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30720087')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721130')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721172')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722292')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722349')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722373')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722381')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30723035')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30725100')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30726085')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30727103')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30728096')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30729130')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30601231')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715130')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30715156')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30717094')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30718040')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30719097')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30719119')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30720109')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721148')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721156')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721180')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30721202')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722357')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722403')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722420')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722446')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722497')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30722764')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30723060')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30724163')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30724171')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30724198')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30724201')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30724210')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30725062')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30725119')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30726093')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30726115')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30727120')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30727146')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30728118')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30729149')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30729262')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30101786')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30101794')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30101280')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30730031')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30711010')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30711029')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30711037')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712017')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712025')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712033')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712041')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712050')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712068')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712076')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712084')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712092')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712106')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712114')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712122')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712130')
GO
INSERT [dbo].[procedimento] ([codigo]) VALUES (N'30712149')
GO
select  convenio.sigla as 'Convênio'
       ,complemento.descricao as 'Complemento'
       ,itemDespesa.codigo as 'Procedimento'
	   ,case itemDespesa.tipo_item_despesa
	    when 0 then 'Procedimento'
		when 1 then 'Medicamento' 
		when 2 then 'Material'
		when 3 then 'Video'
		when 4 then 'Taxa'
		when 5 then 'Pacote'
		 end as 'Tipo Item Despesa'
	   ,format(despesa.valor_honorario,'c', 'pt-br') as 'Valor Honorário'
	   ,format(despesa.data_inicio_vigencia,'dd/MM/yyyy','pt-br') as 'Data Inicio Vigência'
	   ,format(despesa.data_final_vigencia,'dd/MM/yyyy','pt-br') as 'Data Final Vigência'
	   into #tb_excecoes
from tb_despesa despesa
inner join rl_entidade_convenio entidadeConvenio on(entidadeConvenio.id = despesa.fk_entidade_convenio
                                                    and despesa.registro_ativo = 1 and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
inner join tb_convenio convenio on(convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
left join rl_entidadeconvenio_complemento complemento on(complemento.id = despesa.fk_complemento and complemento.registro_ativo = 1)
cross apply (
 select top 1 item.codigo, item.tipo_item_despesa
 from tb_item_despesa item
 where item.id = despesa.fk_item_despesa
       and item.registro_ativo = 1
	   and item.codigo in (select codigo from procedimento)
 order by id desc
) itemDespesa
 where entidadeConvenio.fk_entidade in (select id from tb_entidade where sigla = 'COOPMEDRS')
 and (despesa.data_final_vigencia is null or despesa.data_final_vigencia >= getdate())
 and despesa.discriminator = 'EntidadeConvenio'

GO

 select  convenio.sigla as 'Convênio'
        ,complemento.descricao as 'Complemento'
        ,itemDespesa.codigo as 'Procedimento'
	    ,case itemDespesa.tipo_item_despesa
	    when 0 then 'Procedimento'
		when 1 then 'Medicamento' 
		when 2 then 'Material'
		when 3 then 'Video'
		when 4 then 'Taxa'
		when 5 then 'Pacote'
		 end as 'Tipo Item Despesa'
	    ,case edicao.valores_em
	    when 0 then format(coalesce(despesa.valor_honorario,0),'c', 'pt-br')
		when 1 then format(coalesce(fator.valor,0),'c', 'pt-br')
		 end as 'Valor Honorário'
	   ,format(historico.data_inicio_vigencia ,'dd/MM/yyyy','pt-br') as 'Data Inicio Vigência'
	   ,format(historico.data_final_vigencia,'dd/MM/yyyy','pt-br') as 'Data Final Vigência'
	   into #tb_sem_excecao
FROM tb_despesa despesa
INNER JOIN tb_item_despesa itemDespesa ON (itemDespesa.id = despesa.fk_item_despesa AND itemDespesa.registro_ativo = 1)
INNER JOIN rl_entidadeconvenio_historico_tabela_honorario historico on (historico.fk_edicao_tabela_honorarios = despesa.fk_edicao_tabela_honorarios)
INNER JOIN rl_entidade_convenio entidadeConvenio on(entidadeConvenio.id = historico.fk_entidade_convenio and entidadeConvenio.ativo = 1 and entidadeConvenio.registro_ativo = 1)
INNER JOIN tb_edicao_tabela_honorarios edicao on(edicao.id = historico.fk_edicao_tabela_honorarios and edicao.registro_ativo = 1)
left join rl_entidadeconvenio_complemento complemento on(complemento.id = historico.fk_entidade_convenio_complemento and complemento.registro_ativo = 1)
inner join tb_convenio convenio on(convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
left join tb_item_fator itemFator on(itemFator.id = despesa.fk_item_fator and itemFator.registro_ativo = 1)
left join tb_fator fator on(fator.fk_item_fator = itemFator.id and fator.registro_ativo = 1 and fator.fk_edicao_fator_porte = historico.fk_edicao_fator_porte)
WHERE despesa.discriminator='Fencom'
AND despesa.registro_ativo=1
AND entidadeConvenio.fk_entidade in (select id from tb_entidade where sigla = 'COOPMEDRS')
AND itemDespesa.codigo in (select codigo from procedimento)
and (historico.data_final_vigencia is null or historico.data_final_vigencia >= getdate())
AND historico.data_inicio_vigencia is not null
AND itemDespesa.codigo not in (select distinct Procedimento from #tb_excecoes)

GO

 select * from #tb_excecoes
 union all
 select * from #tb_sem_excecao
 order by Convênio, Procedimento

 GO

DROP TABLE procedimento
DROP TABLE #tb_excecoes
DROP TABLE #tb_sem_excecao