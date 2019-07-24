select sql_update, situacao_cooperado, * from rl_entidade_cooperado where fk_cooperado =  10782 and fk_entidade = 6 -- 3326 / 3369

select nome, * from tb_entidade where sigla like '%GINECOOP%'

select nome, * from tb_cooperado where nome like '%Nucleo de Vídeo Cirurgia S/C Ltd%' -- 10782 / 17048

select fk_tipo_movimentacao, * from rl_cooperado_movimentacao where fk_entidade_cooperado = 3369 -- 109985 / 109983

select * from tb_tipo_movimentacao



--update rl_entidade_cooperado set situacao_cooperado = 2, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (3326, 3369)
--go
--update rl_cooperado_movimentacao set fk_tipo_movimentacao = 8, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (109985, 109983)

/*
ELIMINADO("Eliminado"), 7
DEMITIDO("Demitido"), 2

