select top 10 fk_hospital, nome_hospital, * from rl_integracao_sus_valores where fk_entidade = 23 order by id desc -- 211 BIOCOR INSTITUTO

select * from tb_hospital where nome like '%BIOCOR%' and id = 211

select * from rl_entidade_hospital where id = 211

select * from tb_entidade where sigla like '%COOPANEST%'