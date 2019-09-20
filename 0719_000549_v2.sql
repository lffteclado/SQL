 SELECT 'Fatura' AS tipo,
    fatura.numero_fatura,
    convenio.sigla,
    data_emissao,
    data_vencimento,
    ISNULL(atendimentoFatura.qnt,0) as quantidadeAtendimento,
    CASE fatura.fatura_isolada
       WHEN  1 THEN fatura.valor_total_honorario
       ELSE (fatura.valor_total_honorario - fatura.valor_total_desconto)
       END as honorario,
    fatura.valor_custo_operacional as custoOperacional,
    fatura.valor_total_filme as filme,
    fatura.valor_total_acrescimo as acrescimo,
    fatura.valor_custeio as custeio,
    fatura.valor_ir as ir,
    fatura.valor_desconto_manual as desconto,
    fatura.valor_pis as pis,
    fatura.valor_cofins as cofins,
    fatura.valor_csll as csll,
    fatura.valor_iss as iss,
    fatura.base_iss as baseIss,
    fatura.valor_multa as multa,
	case fatura.status_fatura
	when 0 then
    (
       valor_total_honorario +
       valor_total_custo_operacional +
       valor_total_filme +
       valor_total_acrescimo +
       valor_custeio -
       valor_total_desconto
    )
	when 1 then
	(
       valor_total_honorario +
       valor_total_custo_operacional +
       valor_total_filme +
       valor_total_acrescimo +
       valor_custeio -
       valor_total_desconto
    ) - pagamento.valor_pagamento
	 end AS valorTotalAtendimento,
	case fatura.status_fatura
	when 0 then
		fatura.valor_liquido
	when 1 then
		fatura.valor_liquido - pagamento.valor_pagamento
	 end as valorLiquido,
    ISNULL(fatura.numero_nota_fiscal,'') as notaFiscal,
    ISNULL(classificacaoFatura.descricao, '') as classificacao,
    ISNULL(fatura.texto_acompanhamento_cobranca,'') as acompanhamentoCobranca,
    2 AS numeroTipo
    FROM tb_fatura fatura WITH (NOLOCK)
    INNER JOIN tb_entidade entidade WITH (NOLOCK)
       ON ( entidade.id = fatura.fk_entidade
         AND entidade.registro_ativo = 1 )
    INNER JOIN tb_convenio convenio WITH (NOLOCK)
       ON ( convenio.id = fatura.fk_convenio 
         AND convenio.registro_ativo = 1
         AND convenio.situacao = 1 )
	LEFT JOIN tb_pagamento_fatura pagamento WITH(NOLOCK) 
	   ON (pagamento.fk_fatura = fatura.id and pagamento.registro_ativo = 1) 
    LEFT JOIN rl_entidade_classificacao_espelho classificacaoFatura WITH(NOLOCK)
       ON (classificacaoFatura.id = fatura.fk_classificacao
       AND classificacaoFatura.registro_ativo = 1)
    OUTER APPLY
    (
       SELECT COUNT (DISTINCT atendimento.id) as qnt
       FROM tb_atendimento atendimento
       INNER JOIN  tb_procedimento procedimento
         ON (procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo = 1)  
       INNER JOIN tb_pagamento_procedimento pagamentoProcedimento
         ON (pagamentoProcedimento.fk_procedimento = procedimento.id
       AND pagamentoProcedimento.registro_ativo = 1)
       WHERE atendimento.registro_ativo = 1
       AND pagamentoProcedimento.fk_fatura = fatura.id
     ) as atendimentoFatura
    WHERE  fatura.valor_total > 0
       AND fatura.registro_ativo = 1
       AND entidade.id = 6
       AND fatura.status_fatura in (0,1)
       AND data_cancelamento IS NULL
       AND fatura.autorizado_unimed = 1 and fatura.id = 112832