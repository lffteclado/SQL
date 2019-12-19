select * from tb_espelho
 where numero_espelho = 141921 
 and fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST') --727002

 select * from tb_atendimento
  where numero_atendimento_automatico in (2780076, 2777071) and fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST')
/*
update tb_atendimento
   set situacaoAtendimento = 2,
   fk_espelho = 727002,
   data_ultima_alteracao = GETDATE(),
   fk_usuario_ultima_alteracao = 1,
   sql_update = ISNULL(sql_update,'')+'1219-000162'
  where id = 19806119*/

select id from tb_atendimento
 where numero_atendimento_automatico in (2780076) and fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST')

select * from tb_procedimento where fk_atendimento in (

select id from tb_atendimento
 where numero_atendimento_automatico in (2780076) and fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST')

) and registro_ativo = 1

select * from tb_pagamento_procedimento where fk_procedimento in (

	select id from tb_procedimento where fk_atendimento in (

		select id from tb_atendimento
		 where numero_atendimento_automatico in (2780076) and fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST')

) and registro_ativo = 1

)