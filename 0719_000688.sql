select top 100 * from tb_dados_solicitacao where indicacao_clinica is not null order by id desc

select * from tb_espelho where numero_espelho = 70780 and fk_entidade in (select id from tb_entidade where sigla like '%BELCOOP%')

select * from tb_dados_solicitacao where id = 989

select * from tb_atendimento where id = 12166516

select top 100 * from tb_procedimento order by id desc

select * from 

select top 10 * from tb_arquivo_tiss_gerado_file order by id desc

select * from tb_arquivo_tiss_gerado where id = 155776
select * from tb_arquivo_tiss_gerado where id = 149215

select * from sysobjects where name like '%tiss%'