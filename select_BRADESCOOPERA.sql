select * from rl_entidade_convenio where fk_entidade = 46 and fk_convenio in (
select id from tb_convenio where sigla = 'BRADESCOOPERA'
)