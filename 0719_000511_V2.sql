



/* Total de Cooperados com Endereço Residencial Marcado com a Flag Correspondecia */
select * from tb_endereco where registro_ativo = 1 and id in (
	select fk_endereco from tb_correspondencia_endereco where registro_ativo = 1 and fk_entidade_cooperado in (
		select id from rl_entidade_cooperado
		where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
	)
)  and fk_entidade = 17

/* Cooperados e Endereços */
select id from tb_endereco where fk_cooperado in (
	select fk_cooperado from rl_entidade_cooperado
	where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
) and registro_ativo = 1 and fk_entidade = 17


/* Total de Cooperados com Endereços com a Flag Correspondencia Marcado */
select * from tb_correspondencia_endereco where registro_ativo = 1 and fk_entidade_cooperado in (
		/* Total de Cooperados Ativos na Entidade */
		select id from rl_entidade_cooperado
		where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
)



select * from tb_endereco endereco
inner join tb_correspondencia_endereco correspondencia on endereco.id = correspondencia.fk_endereco and correspondencia.registro_ativo = 1
inner join rl_entidade_cooperado entidadeCooperado on entidadeCooperado.id = correspondencia.fk_entidade_cooperado and entidadeCooperado.registro_ativo = 1
where entidadeCooperado.fk_entidade = 17 and endereco.fk_entidade = 17 and endereco.fk_tipo_endereco = 0

/*
0	Residencial
1	Comercial
2	Consultório
3	Correspondência
4	Para emissão Nota Fiscal
5	Caixa Postal

*/