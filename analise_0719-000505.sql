select * from tb_entidade where sigla like '%UNICOOPER%' --43
select * from tb_espelho where numero_espelho = 119726 and fk_entidade = 43 and fk_entidade_convenio = 2776 -- 623278
select * from tb_convenio where sigla like '%CEMIGSAUDE%'
select * from rl_entidade_convenio where fk_entidade = 43 and fk_convenio = 1607


select id from tb_atendimento where fk_entidade = 43 and fk_espelho = 623278 and situacaoAtendimento = 1
