select * from tb_pagamento_fatura where fk_fatura in
 (select id from tb_fatura where numero_fatura = 9719 and fk_entidade in
 (select id from tb_entidade where sigla like '%SANTACOOPMACEIO%') and fk_convenio in
 (select id from tb_convenio where sigla like '%Asfal%'))

 --update tb_pagamento_fatura set data_pagamento = '2019-06-27', sql_update = ISNULL(sql_update,'')+'#0719-000426' where id = 88312