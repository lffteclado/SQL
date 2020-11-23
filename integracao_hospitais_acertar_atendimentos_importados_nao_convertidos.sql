/*Integracao Hospitais Acertar Atendimentos Importados mas não convertidos*/
select atendimentoIntegracao.id as atendimentoId,
       acomodacaoAutorizada.id as acomodacao,
       procedimento.fk_tipo_guia as tipoGuia
into #atendimentosIntegracao
from tb_atendimento_integracao atendimentoIntegracao
inner join tb_integracao_hospital integracao on (atendimentoIntegracao.fk_integracao = integracao.id)
cross apply(
	select top 1  procedimentoIntegracao.fk_acomodacao,
	              procedimentoIntegracao.fk_tipo_guia
	from tb_procedimento_integracao procedimentoIntegracao
	where procedimentoIntegracao.fk_atendimento = atendimentoIntegracao.id
)procedimento
cross apply(
	select acomodacao.id
	from rl_entidade_acomodacao acomodacao
	where acomodacao.fk_entidade = 63
	and acomodacao.fk_acomodacao = procedimento.fk_acomodacao
	and acomodacao.situacao = 1
	and acomodacao.registro_ativo = 1
)acomodacaoAutorizada
where integracao.fk_entidade in(select id from tb_entidade where sigla = 'COOPMEDRS')
--and integracao.id = 158639 -- Por Integração
and integracao.data_importacao between '2020-11-01' and '2020-11-30' -- Por Período

go

update tb_dados_complementares_integracao
 set  fk_entidade_acomodacao = atendimentoIntegracao.acomodacao,
     fk_tipo_guia = atendimentoIntegracao.tipoGuia,
     fk_tipo_consulta = 110672, -- Primeira Consulta
     sql_update = isnull(sql_update,'')+'#1120-000338'
from tb_dados_complementares_integracao dadosIntegracao
inner join #atendimentosIntegracao atendimentoIntegracao on(atendimentoIntegracao.atendimentoId = dadosIntegracao.fk_atendimento)

go

drop table #atendimentosIntegracao


