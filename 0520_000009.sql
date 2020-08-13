select * from rl_entidade_cooperado_conversao where registro_ativo = 1

select * from rl_entidade_convenio

select * from tb_conversao_convenio where discriminator = 'Regra'

select * from tb_entidade where sigla = 'COOPIMIMG' -- 2
select * from tb_convenio where sigla = 'SULAMERICASAUDE' --461
select * from tb_convenio where sigla = 'CEMIGSAUDE ' --1607

select * from rl_entidade_convenio where fk_convenio = 461 and fk_entidade = 2 -- 5804

--select * from rl_entidade_convenio where fk_convenio = 1607 and fk_entidade = 2 --900

select * from tb_conversao_convenio where discriminator = 'Regra' and fk_entidade_convenio = 5804

select * from tb_conversao_convenio where discriminator = 'Regra' and fk_entidade_convenio = 900 and registro_ativo = 1 order by id desc

select * from rl_entidade_cooperado_conversao where fk_entidade = 2 and registro_ativo = 1 and data_final is null OR data_final > getdate()

select * from rl_entidade_cooperado_conversao where id = 7677

select * from tb_cooperado where id = 12355


select * from tb_conversao_convenio where discriminator = 'Regra' and fk_entidade_cooperado_conversao in (

	select id from rl_entidade_cooperado_conversao where fk_entidade = 2 and registro_ativo = 1

) and registro_ativo = 1