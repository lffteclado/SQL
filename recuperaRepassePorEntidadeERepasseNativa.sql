 SELECT obj.id, 
    obj.data_pagamento, 
    obj.data_ultima_alteracao, 
    obj.id AS idCooperado, 
    obj.fk_entidade, 
    obj.fk_repasse, 
    obj.foi_gerado_CNAB, 
    obj.valor_credito, 
    cooperado.nome,
    obj.valor_desconto_cnab
    FROM rl_repasse_credito obj
    INNER JOIN tb_entidade entidade on (obj.fk_entidade=entidade.id AND obj.registro_ativo=1 AND entidade.registro_ativo=1) 
    INNER JOIN tb_repasse repasse on(repasse.id=obj.fk_repasse AND repasse.registro_ativo=1) 
    INNER JOIN tb_cooperado cooperado on(cooperado.id=obj.fk_cooperado AND cooperado.registro_ativo=1) 
     WHERE entidade.id = 23 AND repasse.id= 18020 and obj.fk_banco in (0,15,20,30,32,33)
