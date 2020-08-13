select top 10 * from tb_pagamento_procedimento where id = 24050313
select * from sysobjects where name like '%repasse%'
select * from tb_lancamento_repasse
select * from tb_fatura where id = 60416 -- 208444.17

select sum(valor_honorario) from tb_pagamento_procedimento where fk_fatura = 60416

select * from rl_situacao_procedimento where faturado = 1

select fk_integracao_ws, * from tb_atendimento
 where fk_convenio = 3656
  --and numero_importacao is not null
  --and pk_importacao is not null
  --and fk_importacao_unimed is not null
  --and fk_integracao_sus is not null
  --and fk_integracao_ws is not null
  and fk_integracao_unimed is not null