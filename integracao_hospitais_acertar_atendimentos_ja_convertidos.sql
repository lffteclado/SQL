/*Integração Hospitais Acertar atendimentos já convertidos*/
 select atendimento.id as idAtendimento
        ,acomodacao.id as idAcomodacao
		,procedimento.fk_tipo_guia as tipoGuia
 into #atendimentosInt
 from tb_atendimento atendimento
 inner join tb_integracao_hospital integracao on(integracao.id = atendimento.fk_integracao_hospital and atendimento.registro_ativo = 1)
 left join tb_espelho espelho on(espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
 cross apply(
	select top 1 fk_tipo_guia, proced.fk_acomodacao from tb_procedimento proced
	where proced.fk_atendimento = atendimento.id
	and proced.registro_ativo = 1
	and exists (select fk_procedimento from tb_pagamento_procedimento
	                where fk_procedimento = proced.id and registro_ativo = 1
					and fk_fatura is null)
 )procedimento
 cross apply(
	select top 1 acomod.id from rl_entidade_acomodacao acomod
	 where acomod.fk_acomodacao = procedimento.fk_acomodacao
	 and acomod.fk_entidade = 63
	 and acomod.situacao = 1
	 and registro_ativo = 1
 )acomodacao
 where integracao.fk_entidade in (select id from tb_entidade where sigla = 'COOPMEDRS')
	   and atendimento.situacaoAtendimento in (0,1)
	   and espelho.numero_espelho in (
			23424,23464,23505,23428,23452,23456,23457,23501,23503,23525,23433,23462,23463,
			23504,23511,23512,23482,23483,23484,23485,23487,23491,23492,23493,23495,23498,23471,23474,23475,23477,
			23479,23488,23489,23497,23539,23538
	   )
	   and espelho.fk_entidade in (select id from tb_entidade where sigla = 'COOPMEDRS')
	   /*and atendimento.fk_convenio in (select id from rl_entidade_convenio
	                                   where fk_entidade = 63
									   and fk_convenio = 974) -- BRADESCOSAUDERS*/
	   --and integracao.id = 163752
	   --integracao.data_importacao between '2020-10-01' and '2020-10-10'
go

update tb_dados_complementares set fk_tipo_guia = atendi.tipoGuia,
                                   fk_acomodacao_autorizada = atendi.idAcomodacao,
								   fk_tipo_consulta = 110672, -- Primeira Consulta
								   sql_update = isnull(sql_update,'')+'#1120-000338'
from tb_dados_complementares dados
inner join #atendimentosInt atendi on(dados.fk_atendimento = atendi.idAtendimento)

go

drop table #atendimentosInt