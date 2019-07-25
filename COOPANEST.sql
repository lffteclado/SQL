select * from sysobjects where name like '%rl_integracao%'

select * from rl_integracao_sus_valores where fk_entidade = 23 and registro_ativo = 1 order by id desc

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