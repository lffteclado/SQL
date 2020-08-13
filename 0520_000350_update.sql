/* Chamado #0520-000350, atualização do Valor Honorário para R$ 30,68 do Atendimento: 118836  Ano: 2020  */

update tb_procedimento set valor_honorario = 30.68,
                           sql_update = ISNULL(sql_update,'')+'#0520-000350'
					   where id = 36174830