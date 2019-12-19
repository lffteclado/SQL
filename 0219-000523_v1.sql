SELECT
    COALESCE(ultimoProcedimentoGlosado.situacao,0) AS 'ultimaGlosaSituacao', 
     glosaAnterior.id AS 'possuiGlosaAnterior',
    procedimento.valor_honorario + procedimento.valor_acrescimo + procedimento.valor_custo_operacional + procedimento.valor_filme as valorProcedimento, procedimentoFaturado.valor_total_faturado, ultimoProcedimentoGlosado.valor_total_glosa_atual
    ,ultimoProcedimentoGlosado.valor_acrescimo, ultimoProcedimentoGlosado.valor_custo_operacional, ultimoProcedimentoGlosado.valor_honorario, ultimoProcedimentoGlosado.valor_filme, conversaoGlosa.fk_glosa,
    case when (espelho.id is not null and espelho.data_cancelamento is not null) or (espelho.id is null) then 1
    when espelho.id is not null and espelho.data_cancelamento is null then 0
    end as espelhoCancelado
    from tb_procedimento procedimento
    CROSS APPLY (
     SELECT TOP 1 glosa.valor_honorario + 
            glosa.valor_acrescimo + 
            glosa.valor_custo_operacional + 
            glosa.valor_filme AS 'valor_total_glosa_atual', 
            glosa.situacao,
            glosa.id, glosa.valor_acrescimo, glosa.valor_custo_operacional,glosa.valor_honorario,glosa.valor_filme
     FROM tb_glosa glosa
     WHERE glosa.registro_ativo = 1
       AND glosa.fk_procedimento = procedimento.id
     ORDER BY glosa.id DESC
    
    ) ultimoProcedimentoGlosado
    OUTER APPLY (
     SELECT TOP 1 glosa.valor_honorario + 
            glosa.valor_acrescimo + 
            glosa.valor_custo_operacional + 
            glosa.valor_filme AS 'valor_total_glosa_anterior', 
            CASE WHEN glosa.situacao = 4 OR glosa.situacao = 5 
               THEN 1 
               ELSE 0 
            END AS 'ehRecebidaERecebidaParcial',
            glosa.id, glosa.valor_acrescimo, glosa.valor_custo_operacional,glosa.valor_honorario,glosa.valor_filme,glosa.situacao
     FROM tb_glosa glosa
     WHERE glosa.registro_ativo = 1
       AND glosa.fk_procedimento = procedimento.id
       AND glosa.id < ultimoProcedimentoGlosado.id
     ORDER BY glosa.id DESC
    
    ) glosaAnterior
    OUTER APPLY(
     SELECT 
       SUM(pagamentoFaturado.valor_honorario + 
         pagamentoFaturado.valor_acrescimo + 
         pagamentoFaturado.valor_custo_operacional + 
         pagamentoFaturado.valor_filme) AS 'valor_total_faturado'
     FROM tb_pagamento_procedimento pagamentoFaturado
     WHERE pagamentoFaturado.registro_ativo = 1
       AND pagamentoFaturado.fk_procedimento = procedimento.id
       AND pagamentoFaturado.fk_fatura IS NOT NULL
    ) procedimentoFaturado
    OUTER APPLY (
    select top 1 fk_glosa from rl_conversao_glosa_devida_parcial where fk_glosa = ultimoProcedimentoGlosado.id and registro_ativo = 1
    ) as conversaoGlosa
    OUTER APPLY(
     select espelho.data_cancelamento, espelho.id from tb_atendimento atendimento
     inner join tb_espelho espelho on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
     where atendimento.registro_ativo = 1 and atendimento.id = procedimento.fk_atendimento
    ) as espelho
    WHERE procedimento.id= 30224614
    AND ((procedimento.valor_honorario + 
       procedimento.valor_acrescimo + 
       procedimento.valor_custo_operacional + 
       procedimento.valor_filme)  <> 
       COALESCE(procedimentoFaturado.valor_total_faturado,0))
    AND ((procedimento.valor_honorario + 
       procedimento.valor_acrescimo + 
       procedimento.valor_custo_operacional + 
       procedimento.valor_filme) - 
       COALESCE(procedimentoFaturado.valor_total_faturado,0)) >= 
       CASE WHEN COALESCE(glosaAnterior.ehRecebidaERecebidaParcial,0) = 1 AND COALESCE(ultimoProcedimentoGlosado.situacao,0) = 0
           THEN glosaAnterior.valor_total_glosa_anterior 
         ELSE ultimoProcedimentoGlosado.valor_total_glosa_atual END