select * from rl_integracao_sus_valores
 where fk_entidade = 23 and nome_hospital = 'HOSPITAL SAO FRANCISCO DE ASSIS' order by id desc


 select top 10 * from rl_integracao_sus_valores where fk_integracao_sus = 156

 select * from tb_hospital where sigla = 'BHOFTALMO' -- 924

select * from rl_integracao_sus_status_atendimentos order by id desc
 where data_ultima_alteracao > '2019-07-31 00:57:48.3130000' order by id desc and gerou_atendimento = 0

 select * from rl_integracao_sus_status_atendimentos
  where fk_integracao_sus = 126 and data_ultima_alteracao > '2019-08-01 00:22:19.0570000'

select * from tb_hospital where id in (

  select fk_hospital from rl_integracao_sus_status_atendimentos
   where fk_integracao_sus = 126 and data_ultima_alteracao > '2019-08-01 00:22:19.0570000'
)


 select * from rl_integracao_sus_status_atendimentos WHERE gerou_atendimento = 0

 select cnes, * from tb_entidade where id = 23 -- 3433471

 select sigla, * from tb_entidade where cnes like '%3433471'

--update rl_integracao_sus_status_atendimentos set gerou_atendimento = 1 where id = 267

select top 50 numero_atendimento_automatico, * from tb_atendimento order by id desc
 where fk_entidade = 23 and data_ultima_alteracao > '2019-07-31 00:57:48.3130000'

 select * from tb_espelho where data_ultima_alteracao > '2019-07-29 00:57:48.3130000'

select * from rl_entidade_convenio where id = 3528

select * from tb_convenio where id = 634

select * from rl_entidade_hospital where id = 247

select * from tb_hospital where id = 124

select * from tb_aviso_sistema where fk_entidade = 3 

--update tb_aviso_sistema set registro_ativo = 0 where fk_entidade = 3


select top 10 * from tb_importacao_base order by id desc

--update tb_importacao_base set importado = 0 where id = 16547

select * from tb_procedimento where fk_atendimento = 17541875

select top 100 * from rl_integracao_sus_valores  where fk_hospital = 211 and fk_entidade = 23 order by id desc

select * from rl_integracao_sus_valores  where fk_entidade = 23 order by id desc


select * from rl_integracao_sus_valores
 where fk_entidade = 23 and competencia = '201810' and gerou_atendimento = 1




/*
update rl_integracao_sus_valores
       set nome_paciente = 'DIVERSOS',
	   data_inicio = GETDATE(),
	   data_fim = GETDATE(),
	   data_realizacao = GETDATE()
	   where fk_integracao_sus = 154
	
		where fk_hospital = 129
		and fk_integracao_sus = 126
		  and fk_entidade = 3


		
	