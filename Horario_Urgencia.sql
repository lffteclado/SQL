/* Relatorio de Convenios Ativos sem Horario de Urgencia Cadastrado */


select entidade.sigla as Entidade,
       convenio.sigla as Convenio,
       horarioUrgencia.hora_trabalho_inicial_segunda_a_sexta,
       horarioUrgencia.hora_trabalho_final_segunda_a_sexta,
	   horarioUrgencia.hora_trabalho_inicial_sabado,
	   horarioUrgencia.hora_trabalho_final_sabado
from rl_entidadeconvenio_historico_tabela_honorario horarioUrgencia
inner join rl_entidade_convenio entidadeConvenio on (entidadeConvenio.id = horarioUrgencia.fk_entidade_convenio and horarioUrgencia.registro_ativo = 1 and entidadeConvenio.registro_ativo = 1)
inner join tb_convenio convenio on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
inner join tb_entidade entidade on (entidade.id = entidadeConvenio.fk_entidade and entidade.registro_ativo = 1)
where (horarioUrgencia.hora_trabalho_inicial_segunda_a_sexta = null
	  or horarioUrgencia.hora_trabalho_inicial_sabado is null) order by entidade.sigla, convenio.sigla