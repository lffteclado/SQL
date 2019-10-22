select numero_espelho, * from tb_espelho where data_emissao between '2019-06-01' and '2019-06-30' and fk_entidade in (
select id from tb_entidade where sigla like '%SANTACOOPMACEIO%'
) and fk_entidade_convenio = 2120

/*
8952
8944
8938
8906
8889
*/

select * from rl_entidade_convenio where fk_entidade = 46 and fk_convenio = 1343

select * from tb_espelho where numero_espelho = 8952 and data_emissao between '2019-06-01' and '2019-06-30' and fk_entidade_convenio = 2120


select * from tb_atendimento where fk_espelho in (
	select id from tb_espelho where data_emissao between '2019-06-01' and '2019-06-30'
) and fk_convenio = 2172 and registro_ativo = 1  --and fk_entidade = 46 and registro_ativo = 1

select top 10 * from tb_procedimento 