sp_helptext Relatorio_Faturamento

Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW dbo.Relatorio_Faturamento
AS
SELECT     C.num_nf, B.num_fz, B.data, B.valorDaVenda, M.modelo, C.conc_faturar, B.nome, C.form_pagamento, Ba.nome_Banco, C.conc_vendedora, AM.ano, V.vendedor, 
                      B.fundoDeVenda, B.bonusespecialdiretoria, B.fundoLocalizacao, B.bonificacaoEspecialObjetivo, B.bonificacaoEspecialAtacado, B.bonificacaoEspecialVarejo, 
                      B.resultadoContabil, B.valorCorrecaoCdi, B.valorCorrigido, B.id_empresa
FROM         dbo.base AS B INNER JOIN
                      dbo.cliente AS C ON B.id_cliente = C.id_cliente INNER JOIN
                      dbo.modelo AS M ON B.id_modelo = M.id INNER JOIN
                      dbo.ano_modelo AS AM ON B.id_anomodelo = AM.id INNER JOIN
                      dbo.vendedor AS V ON B.id_vendedor = V.id_vendedor INNER JOIN
                      dbo.Banco AS Ba ON B.id_Banco = Ba.id_Banco

