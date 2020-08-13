select * from tb_cooperado where nome = 'Ana Carolina Bueno de Rezende' -- 8624

select sigla, * from tb_entidade where id = 23

select * from rl_entidade_cooperado where fk_entidade = 23 and fk_cooperado = 8624

select * from  rl_entidade_cooperado_dados_bancarios  where fk_entidade_cooperado = 40259

--update rl_entidade_cooperado_dados_bancarios set situacao = 1, registro_ativo = 0  where id = 47637

select * from tb_repasse where fk_entidade = 23 and numero_repasse = 1879


select fk_repasse, * from rl_repasse_credito where fk_entidade = 23 and fk_repasse = 17730


select * from tb_cooperado where id in (
	12047
    ,18555
    ,18438
)