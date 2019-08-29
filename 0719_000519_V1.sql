/* Acertar Parametrização de Digitação, registros duplicados
*  impedindo a correta configuração dos campos obrigatorios na Digitação
*  Chamado: #0719-000519
*  */
select digitacaoB.id,
       digitacaoB.fk_entidade_convenio,
	   digitacaoB.data_ultima_alteracao
	   into #tmp
from tb_digitacao digitacaoB
cross apply(
	select entidadeConvenio.id
	from tb_digitacao digitacao
	inner join rl_entidade_convenio entidadeConvenio on (digitacao.fk_entidade_convenio = entidadeConvenio.id
	 and entidadeConvenio.registro_ativo = 1 and digitacao.registro_ativo = 1 and entidadeConvenio.ativo = 1)
	inner join tb_entidade entidade on (entidadeConvenio.fk_entidade = entidade.id and entidade.registro_ativo = 1)
	inner join tb_convenio convenio on (entidadeConvenio.fk_convenio = convenio.id and convenio.registro_ativo = 1)
	--where entidade.id = 12
	group by entidadeConvenio.id, entidade.sigla, convenio.sigla
	having count(digitacao.id) > 1
) as qtd
where digitacaoB.fk_entidade_convenio = qtd.id

select distinct fk_digitacao from tb_configuracao_digitacao where fk_digitacao not in (

select distinct digitacaoC.id
from tb_digitacao digitacaoC
cross apply(
	select fk_digitacao as id
	from tb_configuracao_digitacao where fk_digitacao in (
			select id from #tmp
) and obrigatorio = 1 and ativo = 1
) as ultimoId
where digitacaoC.id = ultimoId.id

) and fk_digitacao in (select id from #tmp) and obrigatorio = 0

GO

--update tb_digitacao set registro_ativo = 0,
--       sql_update = ISNULL(sql_update, '')+'0719-000519'
--where id in (

--			select digitacaoC.id
--			from tb_digitacao digitacaoC
--			cross apply(
--				select max(id) as id
--				 from #tmp tmp
--				 where digitacaoC.fk_entidade_convenio = tmp.fk_entidade_convenio
--			) as ultimoId
--			where digitacaoC.id <> ultimoId.id
--)

GO

--update tb_configuracao_digitacao set registro_ativo = 0,
--       sql_update = ISNULL(sql_update, '')+'0719-000519'
--where fk_digitacao in (

--		select digitacaoC.id
--			from tb_digitacao digitacaoC
--			cross apply(
--				select max(id) as id
--				 from #tmp tmp
--				 where digitacaoC.fk_entidade_convenio = tmp.fk_entidade_convenio
--			) as ultimoId
--			where digitacaoC.id <> ultimoId.id
--)

--GO

--drop table #tmp