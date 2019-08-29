/* Acertar Parametrização de Digitação, registros duplicados
*  impedindo a correta configuração dos campos obrigatorios na Digitação
*  Chamado: #0719-000519
*  */
select digitacaoB.id as id_digitacao,
       digitacaoB.fk_entidade_convenio
	   --digitacaoB.data_ultima_alteracao
	   into #tmp
from tb_digitacao digitacaoB
cross apply(
	select entidadeConvenio.id
	from tb_digitacao digitacao
	inner join rl_entidade_convenio entidadeConvenio on (digitacao.fk_entidade_convenio = entidadeConvenio.id
	 and entidadeConvenio.registro_ativo = 1 and digitacao.registro_ativo = 1 and entidadeConvenio.ativo = 1)
	--inner join tb_entidade entidade on (entidadeConvenio.fk_entidade = entidade.id and entidade.registro_ativo = 1)
	--inner join tb_convenio convenio on (entidadeConvenio.fk_convenio = convenio.id and convenio.registro_ativo = 1)
	--where entidadeConvenio.fk_entidade = 12
	group by entidadeConvenio.id
	having count(digitacao.id) > 1
) as qtd
where digitacaoB.fk_entidade_convenio = qtd.id

--select * from #tmp

--select id from tb_configuracao_digitacao where fk_digitacao in (

--	select distinct fk_digitacao from tb_configuracao_digitacao where fk_digitacao in (
--		select id_digitacao from #tmp
--	) and obrigatorio = 1 and ativo = 1

--)

GO

update tb_digitacao set registro_ativo = 0,
       sql_update = ISNULL(sql_update,'')+'0719-000519' where id not in (
		select distinct fk_digitacao from tb_configuracao_digitacao where fk_digitacao in (
			select id_digitacao from #tmp
		) and obrigatorio = 1 and ativo = 1
)

GO

update tb_configuracao_digitacao set registro_ativo = 0,
       sql_update = ISNULL(sql_update, '')+'0719-000519'
where id not in (

		select id from tb_configuracao_digitacao where fk_digitacao in (

			select distinct fk_digitacao from tb_configuracao_digitacao where fk_digitacao in (
				select id_digitacao from #tmp
			) and obrigatorio = 1 and ativo = 1

		)
)

GO

drop table #tmp