select * from sysobjects where name like '%rl_integracao%'

tb_linha_importacao_base

select * from rl_integracao_sus_valores where fk_entidade = 23 order by id desc

select top 10 * from tb_integracao_sus order by id desc --180

select percentual_atual_importacao, * from tb_integracao_sus where id = 182 --verificar percentual de importação SUS 

select top 10 * from tb_linha_importacao_base order by id desc

select * from tb_linha_importacao_base where fk_importacao_base = 78985 order by id desc

select top 1000 * from tb_importacao_base order by id desc where id = 78985

select top 10 * from tb_importacao_base order by id desc --76585 --verificar Status Importação 0 - Não importado 1 - Importado 2-Em andamento


select * from rl_integracao_sus_valores
 where fk_entidade = 23
       and registro_ativo = 1
	   and competencia = '201907'
	   --and gerou_atendimento = 1
	   and data_inicio = '2019-08-23'
	   and data_fim = '2019-08-23'
	   and nome_hospital like '%MADRE TERESA%' order by id desc

select sum(valor_aih) as valor from rl_integracao_sus_valores
 where fk_entidade = 23
       and registro_ativo = 1
	   and competencia = '201907'
	   --and gerou_atendimento is null
	   and data_inicio = '2019-08-23'
	   and data_fim = '2019-08-23'

select sigla, * from tb_entidade where sigla like '%COOPANEST%'

select sigla, * from tb_entidade where id = 32

--tb_linha_importacao_baseBKP19072019 

select * from tb_linha_importacao_base where fk_importacao_base = 16292 and registro_ativo = 1 and linha like '%HOSPITAL SAO FRANCISCO DE ASSIS%'
--3118500154462;0026840;HOSPITAL SAO FRANCISCO DE ASSIS                             ;201810;101054659650000;0000053,00;000000003058417;02;04;040066;0408050870

--update tb_linha_importacao_base set registro_ativo = 0 where id not in (
--6586995
--,6586996
--,6586997
--,6586998
--,6586999
--,6587000
--,6587001
--,6587002
--,6587003
--,6587004) and fk_importacao_base = 16292

SELECT TOP 10 * FROM tb_sobra_integracao

select * from tb_importacao_base where id = 16292 and tipo_importacao_base = 3 order by id desc --importado = 0 and 

--update tb_importacao_base set importado = 0 where id = 16292 

select sigla, acareacao_automatica, * from tb_entidade where id = 23

--update tb_entidade set acareacao_automatica = 0 where id = 23