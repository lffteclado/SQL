select top 10 * from tb_linha_importacao_base where fk_importacao_base = 76643 order by id desc --76642

select * from tb_linha_importacao_base where data_ultima_alteracao between '2019-09-11 12:00:00.0000000' and '2019-09-11 12:27:16.0310000'

select * from tb_importacao_base order by id desc -- 76643

select top 10 * from tb_procedimento

--update tb_importacao_base set importado = 0 where id = 76598

select * from tb_procedimento where id = 29241836 -- Tipo Guia 110680 29241828 110679

select * from tb_tabela_tiss_tipo_guia_temp

select * from tb_procedimento_integracao where fk_integracao = 80627 order by id desc

select top 10 * from tb_integracao_hospital where fk_importacao_base = 76643 order by id desc

--update tb_integracao_sus set registro_ativo = 0, sql_update=ISNULL(sql_update,'')+'0919-000324' where id = 184

select * from tb_procedimento where id in (26165617, 26165618, 26165619)