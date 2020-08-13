select * from sysobjects where name like '%CBO%'

select top 100 * from rl_cooperado_cbo order by id desc

select * from tb_tabela_tiss where discriminator = 'especialidade' and registro_ativo = 1 order by id desc


select distinct codigo, fk_tabela_tiss from tb_tabela_tiss_versao_codigo where fk_tabela_tiss in (
select id from tb_tabela_tiss
 where discriminator = 'especialidade' and registro_ativo = 1
)


select top 100 * from tb_arquivo_tiss_gerado_file order by id desc

