select * from tb_atendimento
 where numero_atendimento_automatico = 215442
  and ano_atendimento = 2020
  and fk_entidade in (
	select id from tb_entidade where sigla = 'UNICOOPER'
  )

select fk_cooperado_recebedor_cobranca, fk_cooperado_executante_complemento, fk_item_despesa, * from tb_procedimento where fk_atendimento = 25913789-- 9683 fk_cooperado_recebedor_cobranca

--update tb_procedimento set fk_cooperado_recebedor_cobranca = null, fk_item_despesa = null where id = 36315745

select * from sysobjects where name like '%inconsis%'

select  * from rl_atendimento_inconsistencia where fk_atendimento = 25855335 215442

select * from tb_cooperado

sp_helptext consistirAtendimento