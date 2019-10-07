select * from tb_atendimento_AUD where id = 17961422

select * from tb_espelho_AUD where id = 564731

select * from tb_carta_glosa_AUD where id = 212606

select * from tb_glosa_AUD where id = 2459548

select * from tb_fatura_AUD where id = 104228

select * from tb_historico_atendimento_carta_glosa where id_carta_glosa = 212606

select * from tb_historico_atendimento_espelho where id_atendimento = 17961422

select distinct usuarioCriacao.nome as 'Usuário Criação',
       convert(varchar(10),atendimentoAUD.data_cadastro,103) as 'Data Criação',
	   atendimentoAUD.valor_total_atendimento as 'Valor Atendimento',
	   usuarioAlteracao.nome as 'Usuário Ultima Alteração'
from tb_atendimento_AUD atendimentoAUD
inner join rl_entidade_usuario entidadeUsuario with(nolock) on (entidadeUsuario.id = atendimentoAUD.fk_usuario)
inner join tb_usuario usuarioCriacao with(nolock) on (usuarioCriacao.id = entidadeUsuario.fk_usuario)
inner join tb_usuario usuarioAlteracao with(nolock) on (usuarioAlteracao.id = atendimentoAUD.fk_usuario_ultima_alteracao)
 where atendimentoAUD.id = 17961422


select distinct usuarioCriacao.nome as 'Usuário Criação',
       convert(varchar(10),espelhoAUD.data_criacao,103) as 'Data Criação',
	   espelhoAUD.valor_liquido as 'Valor Liquido',
       usuarioAlteracao.nome as 'Usuário Ultima Alteração',
	   convert(varchar(10),espelhoAUD.data_ultima_alteracao,103) as 'Data Ultima Alteração',
	   usuarioUnificacao.nome as 'Usuário Unificação',
	   convert(varchar(10),espelhoAUD.data_unificacao,103) as 'Data Unificação'
from tb_espelho_AUD espelhoAUD
inner join rl_entidade_usuario entidadeUsuario with(nolock) on (entidadeUsuario.id = espelhoAUD.fk_entidade_usuario_criacao)
inner join tb_usuario usuarioCriacao with(nolock) on (usuarioCriacao.id = entidadeUsuario.fk_usuario)
inner join tb_usuario usuarioAlteracao with(nolock) on (usuarioAlteracao.id = espelhoAUD.fk_usuario_ultima_alteracao) 
inner join tb_usuario usuarioUnificacao with(nolock) on (usuarioUnificacao.id = espelhoAUD.fk_usuario_unificacao) 
 where espelhoAUD.id = 564731

select usuarioCriacao.nome as 'Usuário Criação',
	   convert(varchar(10),glosaAUD.data_glosa,103) as 'Data Criação',
	   glosaAUD.valor_honorario as 'Valor Glosado',
       usuarioAlteracao.nome as 'Usuário Ultima Alteração',
	   convert(varchar(10),glosaAUD.data_ultima_alteracao,103) as 'Data Ultima Alteração',
	   glosaAUD.observacao
from tb_glosa_AUD glosaAUD
inner join rl_entidade_usuario entidadeUsuario with(nolock) on (entidadeUsuario.id = glosaAUD.fk_entidade_usuario_criacao)
inner join tb_usuario usuarioCriacao with(nolock) on (usuarioCriacao.id = entidadeUsuario.fk_usuario)
inner join tb_usuario usuarioAlteracao with(nolock) on (usuarioAlteracao.id = glosaAUD.fk_usuario_ultima_alteracao)
 where glosaAUD.id = 2459548



 select usuarioCriacao.nome as 'Usuário Criação',
        convert(varchar(10),faturaAUD.data_criacao,103) as 'Data Criação',
		faturaAUD.valor_total as 'Valor Total',
		 usuarioAlteracao.nome as 'Usuário Ultima Alteração',
		 convert(varchar(10),faturaAUD.data_ultima_alteracao,103) as 'Data Ultima Alteração'
from tb_fatura_AUD faturaAUD
inner join rl_entidade_usuario entidadeUsuario with(nolock) on (entidadeUsuario.id = faturaAUD.fk_entidade_usuario_criacao)
inner join tb_usuario usuarioCriacao with(nolock) on (usuarioCriacao.id = entidadeUsuario.fk_usuario)
inner join tb_usuario usuarioAlteracao with(nolock) on (usuarioAlteracao.id = faturaAUD.fk_usuario_ultima_alteracao)
  where faturaAUD.id = 104228