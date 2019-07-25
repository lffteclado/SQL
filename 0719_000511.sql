select * from sysobjects where name like '%endereco%'

Adalberto Freire Sobrinho - CRM / 19186

select sigla, * from tb_entidade where sigla like '%BHCOOP%' -- 17

select * from tb_cooperado where nome  = 'Adalberto Freire Sobrinho' and numero_conselho = '19186' -- 15905

select * from rl_entidade_cooperado where fk_entidade = 17 and fk_cooperado = 15905 -- 33313

select in_endereco_correspondencia, * from tb_endereco where id = 101242 -- Residencial 0

select * from tb_correspondencia_endereco where fk_entidade_cooperado = 33313

select * from rl_entidade_cooperado where id = 33259

select * from tb_cooperado where id = 4146

select id from rl_entidade_cooperado
 where fk_entidade = 17 and situacao_cooperado = 0 and id not in (
select * from tb_correspondencia_endereco where fk_endereco in (

select id from tb_endereco where registro_ativo = 1 and id in (
	select fk_endereco from tb_correspondencia_endereco where registro_ativo = 1 and fk_entidade_cooperado in (
		select id from rl_entidade_cooperado
		where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
	)
) and fk_tipo_endereco = 0 and fk_entidade = 17




select id, descricao, * from tb_tipo_endereco

tb_endereco