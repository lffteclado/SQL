select ano_atendimento_para_campo_guia_tiss,* from rl_entidade_convenio where fk_entidade in (
select id from tb_entidade where sigla like '%SANTACOOPMACEIO%' -- 46
) and fk_convenio in (
select id from tb_convenio where sigla like '%59BATAINFAN%' -- 622
)

select * from tb_espelho where numero_espelho = 9097 and fk_entidade = 46 -- 630379

select numero_atendimento_automatico, numero_guia, guia_principal, guia_solicitacao_internacao, * from tb_atendimento where fk_espelho = 766243 and registro_ativo = 1

/*Faturado*/
select numero_atendimento_automatico, numero_guia, guia_principal, guia_solicitacao_internacao, * from tb_atendimento where numero_atendimento_automatico in (
1688
,2619
,2981
,3302
,4423) and ano_atendimento = '2019' and fk_entidade = 46

/*Glosado*/
select numero_atendimento_automatico, numero_guia, guia_principal, guia_solicitacao_internacao, * from tb_atendimento where numero_atendimento_automatico in (
8100
,8721
,9354
) and ano_atendimento = '2019' and fk_entidade = 46

select * from tb_fatura where numero_fatura = 9831 and fk_entidade = 46


--select * from update tb_atendimento set numero_guia = '', guia_principal = '', guia_solicitacao_internacao = '' where fk_espelho = 630379 and registro_ativo = 1

--update tb_atendimento set numero_guia = '' where id in (
15663249
,15619252
,15610642
)

