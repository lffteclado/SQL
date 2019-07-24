/*
* Script para excluir o atendimento contido no espelho 57841,
* da bhcoop e também excluir o pagamento do mesmo, para não demonstrar
* no ato da geração do repasse uma vez que o mesmo consta como cancelado. 
* CHAMADO: #0419-000051
* AUTOR: Luís Felipe
*/

UPDATE tb_atendimento SET situacaoAtendimento = 6, sql_update = ISNULL(sql_update, '')+'#0419-000051'
 WHERE id = 16335318

GO

UPDATE tb_pagamento_espelho SET registro_ativo = 0, sql_update = ISNULL(sql_update,'')+'#0419-000051'
 WHERE id = 71

GO

UPDATE tb_pagamento_procedimento SET registro_ativo = 0, sql_update = ISNULL(sql_update,'')+'#0419-000051'
 WHERE id = 52440935