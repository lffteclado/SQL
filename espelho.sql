select * from tb_correspondencia_endereco where fk_endereco in (1663,2932) and registro_ativo = 1 and fk_entidade_convenio = 900

select * from tb_correspondencia_endereco where registro_ativo = 1 and fk_entidade_convenio in
(select id from rl_entidade_convenio where fk_entidade = 2 and fk_convenio = 1607) --2932

select count(ce.id) from tb_correspondencia_endereco ce
inner join rl_entidade_convenio ec on ce.fk_entidade_convenio = ec.id
where ce.registro_ativo = 1 and ec.fk_entidade = 2 and fk_convenio = 1607


select * from tb_correspondencia_endereco where registro_ativo = 1 and fk_endereco = 2932

select id from rl_entidade_convenio where fk_entidade = 2 and fk_convenio = 1607

select * from tb_endereco where id = 38071

select fk_entidade, numero_espelho, * from tb_espelho where numero_espelho > 27080 and fk_entidade = 2 --560525

select sum(valor_total_atendimento) as valor from tb_atendimento where fk_espelho = 560525

select * from tb_atendimento where numero_atendimento_automatico = 53081 and fk_entidade = 2 fk_espelho = 560525

select * from tb_procedimento where fk_atendimento = 16541711

select * from tb_pagamento_procedimento where fk_procedimento = 16796946

select * from tb_convenio where nome like '%CEMIG SAUDE%'

select * from tb_endereco where fk_convenio = 1607

select sql_update, * from tb_espelho where id = 564704

select * from sysobjects where name like '%Endereco%'