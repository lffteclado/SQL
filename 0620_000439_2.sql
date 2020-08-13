select atendimento.numero_atendimento_automatico,
       atendimento.paciente,
	   atendimento.numero_guia,
	   procedimento.data_realizacao,
	   procedimento.data_inicio,
	   procedimento.data_fim
 from tb_procedimento procedimento
inner join tb_atendimento atendimento on (atendimento.id = procedimento.fk_atendimento)
where procedimento.sql_update like '%#0620-000439%' and atendimento.sql_update like '%#0620-000439%'
order by atendimento.numero_atendimento_automatico

select * from tb_atendimento where id = 20386630

select * from tb_procedimento where fk_atendimento = 20386630

491450