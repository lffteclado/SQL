select * from sysobjects where name like '%000444%'

select * from [1019_000444] where cnpj_hospital = '16513178004597' and hospital like '%UNIMED BHTE COOP%'

--update [1019_000444] set cnpj_hospital  = '16513178001067' where cnpj_hospital = '16513178004597' and hospital like '%UNIMED BHTE COOP%'

--drop table [1019_000444]

select top 10 * from tb_atendimento order by id desc 

select * from tb_entidade where id = 23

select * from tb_procedimento

select * from rl_entidade_grau_participacao where id = 449 -- 109923

select * from tb_tabela_tiss where id = 109923

select * from tb_atendimento where id = 21104663

select * from tb_tabela_tiss where id = 110681

select * from tb_convenio where sigla like '%PMMG/IPSM%' and cnpj = '17444779000137'

select * from tb_espelho where numero_espelho = 151363 and fk_entidade = 23

select * from tb_hospital where cnpj = '16513178001067'

select * from tb_atendimento where sql_update = '1019-000444'