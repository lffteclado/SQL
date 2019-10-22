select * from tb_atendimento where numero_atendimento_automatico = 259394 and fk_entidade = 43

select fk_entidade_fk_grau_participacao, fk_grau_participacao, * from tb_procedimento where fk_atendimento = 17540601

select * from rl_entidade_grau_participacao where id = 895

select * from rl_entidade_convenio where fk_entidade = 43 and fk_convenio = 41 --8

select * from tb_convenio where sigla like 'CASSI' --41

select * from tb_tabela_tiss where id = 109929

select top 100 * from tb_tabela_tiss_versao_codigo where codigo = '12' and versao_tiss = 8

select top 10 * from tb_tabela_tiss where id  = 110466

select top 10000 fk_atendimento from tb_procedimento where fk_grau_participacao is null and registro_ativo = 1 order by id desc