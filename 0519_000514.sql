select * from sysobjects where name like '%horario%' -- 96

select * from tb_horario_trabalho where discriminator = 'EntidadeUsuario' and fk_entidade = 25

select * from tb_horario_trabalho where id = 100

select * from rl_usuario_horario_trabalho where fk_horario_trabalho = 100

select * from rl_dias_semana_horario_trabalho where fk_horario_trabalho = 100

select * from rl_dias_semana_horario_trabalho diaSemana
inner join rl_usuario_horario_trabalho usuarioTrabalho on diaSemana.fk_horario_trabalho = usuarioTrabalho.id and usuarioTrabalho.fk_usuario = 12578
 where dia_semana = 4

 select * from rl_entidade_usuario where id = 13
 select * from tb_usuario where id = 12


 select diaSemana.fk_horario_trabalho,
		diaSemana.dia_semana,
		diaSemana.inicio_intervalo_1,
		diaSemana.fim_intervalo_1,
		diaSemana.inicio_intervalo_2,
		diaSemana.fim_intervalo_2
         from rl_dias_semana_horario_trabalho diaSemana
 inner join tb_horario_trabalho horarioTrabalho on diaSemana.fk_horario_trabalho = horarioTrabalho.id and horarioTrabalho.registro_ativo = 1 and diaSemana.registro_ativo = 1
 where horarioTrabalho.id in (select fk_horario_trabalho from rl_usuario_horario_trabalho usuarioHorarioTrabalho where fk_usuario = 11238)
 and getdate() between horarioTrabalho.inicio and horarioTrabalho.fim
 and diaSemana.dia_semana = 1
 and horarioTrabalho.liberar_bloquear = 0
 
 select usuarioHorarioTrabalho.horarioTrabalho from UsuarioHorarioTrabalhoUsuario usuarioHorarioTrabalho where usuarioHorarioTrabalho.entidadeUsuario = 12578
 
 select fk_horario_trabalho from rl_usuario_horario_trabalho usuarioHorarioTrabalho where fk_usuario = 11238
  

 where '2019-07-26 16:58:21.8770000' between diaSemana.horarioTrabalho.inicio  and diaSemana.horarioTrabalho.fim
 and diaSemana.horarioTrabalho in (select usuarioHorarioTrabalho.horarioTrabalho from UsuarioHorarioTrabalhoUsuario usuarioHorarioTrabalho where usuarioHorarioTrabalho.entidadeUsuario = 12578)
 and diaSemana.diaDaSemana = 4
 and horarioTrabalho.liberarBloquear = 1
 order by diaSemana.diaDaSemana