select rC.id id_repasse_calculado,
    eC.id id_entidade_cooperado,
    coop.id id_cooperado,
    coop.nome nome_cooperado,
    rep.id id_repasse,
    rep.numero_repasse,
    rC.valor_credito,
     rC.data_pagamento,
    rC.foi_gerado_CNAB,
    enti.id,
    enti.sigla,
    enti.nome entidade_nome,
    coop.cpf_cnpj,
    dbCooperado.agencia,
    dbCooperado.conta,
    dbCooperado.tipo,
    dbCooperado.numero_banco,
    dbCooperado.descricao,
    dbCooperado.valor_desconto_cnab,
	db.agencia,
    db.conta,
    db.tipo,
    banco.numero_banco,
    banco.descricao,
    db.valor_desconto_cnab
    from rl_repasse_credito rC
    inner join tb_repasse rep on (rep.id = rC.fk_repasse and rep.registro_ativo = 1 and rC.registro_ativo = 1)
    inner join tb_entidade enti on (enti.id = rC.fk_entidade and enti.registro_ativo = 1)
    left join rl_entidade_cooperado eC on (eC.fk_cooperado = rC.fk_cooperado and eC.fk_entidade = rC.fk_entidade and eC.registro_ativo = 1)
    left join tb_cooperado coop on (coop.id = rC.fk_cooperado and coop.registro_ativo = 1)
	/*and coop.id in (select entidadeCooperado.fk_cooperado
                    from rl_entidade_grupo_cooperado_vincular_cooperado vincularCooperado
                    inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.id = vincularCooperado.fk_entidade_cooperado and entidadeCooperado.registro_ativo = 1)
                    where vincularCooperado.fk_entidade_grupo_cooperado = 0 and vincularCooperado.registro_ativo = 1))*/
	left join rl_entidade_cooperado_dados_bancarios dB on (dB.id = rC.fk_entidade_cooperado_dados_bancarios and dB.registro_ativo = 1)
    left join tb_banco banco on (banco.id = rC.fk_banco and banco.registro_ativo = 1)
	outer apply (     
        select top 1 db.agencia, db.conta, db.tipo, db.fk_banco, banco.descricao, banco.numero_banco, dB.valor_desconto_cnab
		from  rl_entidade_cooperado_dados_bancarios dB 
		left join tb_banco banco on banco.id = db.fk_banco
		where dB.fk_entidade_cooperado = eC.id and dB.registro_ativo = 1 and dB.situacao = 1
		ORDER BY banco.descricao
    ) as dbCooperado  
    where rC.fk_entidade = 10
    --and coop.id is not null 27586
	and coop.id = 27586
	and rep.numero_repasse = 3970 

	/*
	select * from tb_repasse where numero_repasse = 3970 and fk_entidade = 10
	select * from rl_repasse_credito where fk_repasse = 17677 and fk_cooperado = 27586*/