select distinct atendimento.numero_atendimento_automatico
       --,alterar.numero_atendimento as numero_alterar
	   ,atendimento.paciente
	   ,alterar.numero_guia_novo
	   ,data_realizacao_novo
	   --,alterar.paciente as paciente_alterar
	   ,procedimento.id as idProcedimento
	   ,atendimento.id as idAtendimento
	    --into tb_dados_alterar
	    from tb_atendimento atendimento 
inner join tb_procedimento procedimento on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1 and atendimento.registro_ativo = 1)
inner join tb_alterar alterar on (alterar.numero_atendimento = atendimento.numero_atendimento_automatico and atendimento.fk_entidade = 43)
inner join rl_situacao_procedimento situacao on (situacao.fk_procedimento = procedimento.id)
where alterar.data_realizacao = procedimento.data_realizacao
and atendimento.paciente = alterar.paciente
and situacao.glosado = 1
and atendimento.numero_guia = alterar.numero_guia
order by atendimento.paciente

select * from tb_alterar

select * from tb_dados_alterar

select * from tb_atendimento where numero_atendimento_automatico = 491558 and fk_entidade = 43 and numero_guia = '90008168121'

select * from rl_situacao_procedimento where fk_procedimento in (34563425, 34563426)

select * from tb_procedimento where fk_atendimento = 20386775

EDILENO CANDIDO VILACA
JOAO VICTOR DE CASTRO MARINHO
NOAH SOARES VENADES
VICTOR GRACIANO COSTA
