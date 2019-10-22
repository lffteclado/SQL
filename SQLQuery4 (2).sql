select top 10 * from tb_glosa

select * from tb_entidade where sigla like '%UNICOOPER%'

select * from tb_atendimento where numero_atendimento_automatico = 111721 and fk_entidade = 43

select fk_item_despesa, * from tb_procedimento where fk_atendimento = 16517940 -- 24050359

select fk_carta_glosa, * from tb_glosa where fk_procedimento = 24050359

select * from tb_carta_glosa where numero_carta = 69744 --163215

select * from tb_item_despesa where codigo = '10101012'

select * from tb_item_despesa where id = 9681



