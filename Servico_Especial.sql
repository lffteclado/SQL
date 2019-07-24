select * from sysobjects where name like '%servico%'

--select top 10 * from rl_lancamento_servico_especial_fixo -> tb_participantes_composicao_servico_especial 

select * from rl_lancamento_servico_especial_fixo

select * from rl_saldo_repasse_fixo

select id from rl_saldo_repasse_fixo

select * from tb_cooperado where id in (select fk_servico_especial from rl_saldo_repasse_fixo) 

select * from sysobjects where name like '%saldo_repasse_fixo%'
	  
select * from tb_composicao_servico_especial where data_inclusao > '2019-05-29' and fk_servico_especial = 30848 --1504
	  
select nome, tipo_servico, situacao, * from tb_cooperado where tipo_servico = 1 and fk_entidade in (select id from tb_entidade where sigla like '%BHCOOP%')
	  
select * from  tb_participantes_composicao_servico_especial where data_ultima_alteracao > '2019-05-29' --10141 10142 10143

select * from tb_participantes_composicao_servico_especial where fk_composicao_servico_especial = 1510
	  
	  
select nome, * from tb_cooperado where id in (30691)


