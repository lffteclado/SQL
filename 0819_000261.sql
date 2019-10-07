select fk_usuario_ultima_alteracao, * from tb_atendimento where numero_atendimento_automatico = 44097 and fk_entidade in (
	select id from tb_entidade where sigla like '%SANTACOOPMACEIO%'
) and ano_atendimento = '2019' -- 17961422

select * from tb_atendimento_AUD where id = 17961422

select * from tb_espelho_AUD where id = 564731

select * from tb_carta_glosa_AUD where id = 212606

select fk_entidade_usuario_criacao, * from tb_fatura where numero_fatura = 9829 and fk_entidade = 46

select fk_entidade_usuario_criacao, * from tb_fatura_AUD where id = 104228

select * from tb_pagamento_fatura where fk_fatura = 104228 -- 98698

select * from tb_pagamento_fatura_AUD where id = 98698

select * from tb_carta_glosa where numero_carta = 2463 and fk_entidade = 46

select * from tb_glosa where fk_carta_glosa = 212606 and fk_procedimento = 26079141 order by id

select * from tb_glosa_AUD where id = 2459548

select * from tb_historico_atendimento_carta_glosa where id_carta_glosa = 212606

select * from tb_historico_atendimento_espelho where id_atendimento = 17961422

select * from sysobjects where name like 'tb%historico%'

select * from tb_usuario where id = 10177
union all
select * from tb_usuario where id = 10170

select * from rl_entidade_usuario where id = 11855


select * from tb_procedimento where fk_atendimento = 17961422 and registro_ativo = 1

select fk_procedimento_tuss, * from tb_procedimento where id in (
26085977
,26085979
,26085986
,26079141
)

select * from tb_tabela_tiss where id = 103983

/*
26085977
26085979
26085986
*/

select * from tb_glosa where fk_procedimento in (
26085977
,26085979
,26085986
)
/*
update tb_glosa set situacao = 4 where id in (
2456125
,2456126
,2456127
)