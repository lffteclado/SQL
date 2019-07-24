select numero_espelho, fk_entidade, * from tb_espelho
 where numero_espelho = 57841 and fk_entidade = 17

select situacaoAtendimento, fk_espelho, fk_entidade, numero_atendimento_automatico, * from tb_atendimento
 where fk_espelho = 533968 -- setar fk_espelho como null e alterar a situação para excluido

--update tb_atendimento set situacaoAtendimento = 6, sql_update = ISNULL(sql_update, '')+'#0419-000051'
-- where id = 16335318

select fk_espelho, * from tb_pagamento_espelho -- 162
  where fk_espelho = 533968 --setar para registro ativo 0

--update tb_pagamento_espelho set registro_ativo = 0, sql_update = ISNULL(sql_update,'')+'#0419-000051'
-- where id = 71

--update tb_pagamento_procedimento set registro_ativo = 0, sql_update = ISNULL(sql_update,'')+'#0419-000051'
--  where id = 52440935

select * from tb_pagamento_procedimento  where id = 52440935 --registro ativo 0 -- id 52440935 where fk_procedimento = 23718204 --registro ativo 0 -- id 52440935

select * from tb_procedimento where fk_atendimento = 16335318 -- 23718204

select fk_entidade, * from rl_entidade_dados_bancarios
 where fk_entidade = 17 and id = 162

 --select sigla, nome, * from tb_entidade where id = 17

--select * from sysobjects where name like '%espelho%'

/*
DIGITADO("Digitado"),0
  ESPELHADO("Espelhado"),1
  GLOSADO("Glosado"),2
  FATURADO("Faturado"),3
  PAGO("Pago"),4
  REPASSADO("Repassado"),5
  EXCLUIDO("Excluído");6
*/