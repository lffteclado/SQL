select procedimento.id,
       despesa.codigo, 
       despesa.descricao
from tb_procedimento procedimento
inner join tb_item_despesa despesa on procedimento.fk_item_despesa = despesa.id and despesa.registro_ativo = 1
inner join tb_rateio_procedimento rateio on rateio.fk_item_despesa = despesa.id and rateio.registro_ativo = 1 and rateio.fk_entidade = 43
where procedimento.registro_ativo = 1 and procedimento.fk_atendimento = 16837260 and rateio.fk_cooperado = 13677