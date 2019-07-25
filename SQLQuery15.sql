--into tb_procedimentoBKP28062019
--into tb_pagamento_procedimentoBKP28062019

select id, valor_honorario, valor_acrescimo from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 558443 and registro_ativo = 1
) and registro_ativo = 1 and valor_honorario is null

select id, valor_honorario, valor_acrescimo, fk_procedimento from tb_pagamento_procedimento where fk_procedimento in (
select id from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho = 558443 and registro_ativo = 1
) and registro_ativo = 1
)and registro_ativo = 1
 