select sum(valor_honorario) from tb_procedimento where fk_atendimento in (
	select id from tb_atendimento where fk_espelho in (
		select id from tb_espelho where numero_espelho = 8938 and registro_ativo = 1 and data_emissao between '2019-06-01' and '2019-06-30'
	) and registro_ativo = 1 and ano_atendimento = '2019' and fk_entidade = 46
) and registro_ativo = 1


select top 1000 numero_espelho, * from tb_espelho where fk_entidade = 46 order by id desc

select * from rl_entidade_convenio where id = 2120

select * from tb_convenio where id = 186

select * from tb_usuario where id = 10177 --Ebenezer Ferreira de Moraes