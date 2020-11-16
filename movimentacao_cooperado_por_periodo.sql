--select * from tb_entidade where sigla = 'COOPERCON'--10


select movimentacao.id
       ,cooperado.nome
       ,tipo.descricao
	   ,movimentacao.data_movimentacao
 from tb_cooperado cooperado
inner join rl_entidade_cooperado entidadeCooperado on(entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 10)
cross apply(
 select top 1 * from rl_cooperado_movimentacao mov
  where fk_entidade_cooperado = entidadeCooperado.id
  and mov.registro_ativo = 1
  order by id desc
) as movimentacao
inner join tb_tipo_movimentacao tipo on(tipo.id = movimentacao.fk_tipo_movimentacao)
where movimentacao.data_movimentacao <= '2017-12-31'
order by cooperado.nome



--and entidadeCooperado.situacao_cooperado = 4

/*
Cadastro de Cooperado
Acrescimo/Correção
Distrib Sobras na forma de Incorporação ao Capital
Distribuição de Sobras - Negativa
Distribuição de Sobras - Positiva
Integralização de Capital
Reativar Cooperado
*/