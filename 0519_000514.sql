select * from sysobjects where name like '%horario%' -- 96

select * from tb_horario_trabalho where discriminator = 'EntidadeUsuario' and fk_entidade = 25

select * from tb_horario_trabalho where id = 96

select * from rl_usuario_horario_trabalho where fk_horario_trabalho = 100

select * from rl_dias_semana_horario_trabalho where fk_horario_trabalho = 100

select * from rl_dias_semana_horario_trabalho diaSemana
inner join rl_usuario_horario_trabalho usuarioTrabalho on diaSemana.fk_horario_trabalho = usuarioTrabalho.id and usuarioTrabalho.fk_usuario = 12578
 where dia_semana = 4


 select * from rl_dias_semana_horario_trabalho diaSemana
 where '2019-07-26 16:58:21.8770000' between diaSemana.horarioTrabalho.inicio  and diaSemana.horarioTrabalho.fim
 and diaSemana.horarioTrabalho in (select usuarioHorarioTrabalho.horarioTrabalho from UsuarioHorarioTrabalhoUsuario usuarioHorarioTrabalho where usuarioHorarioTrabalho.entidadeUsuario = 12578)
 and diaSemana.diaDaSemana = 4
 and horarioTrabalho.liberarBloquear = 1
 order by diaSemana.diaDaSemana