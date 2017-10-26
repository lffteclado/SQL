--DROP VIEW dbo.Relatorio_FaDireto
CREATE VIEW dbo.Relatorio_FaDireto
AS

/*View para Geração do Relatório de Rentabilidades FaDireto
*Criação: 26/10/2017
*Rensposável: Luís Felipe Ferreira
*Motivo: Atendimento ao Chamado 60628
*/

SELECT B.data,
	   B.nome,
	   B.int_ValorVenda,
	   M.modelo,
	   B.id_empresa,
	   E.nome_empresa,
	   B.form_pagamento,
	   B.banco,
	   V.vendedor,
	   B.int_ValorFundo,
	   B.BonusEspecial,
	   B.BonLocalizacao,
	   B.BonAtacado,
	   B.BonVenda
FROM base_FaDireto B
inner join empresa E
on B.id_interveniente = E.id
inner join modelo M
on B.id_modelo = M.id
inner join vendedor V
on B.id_vendedor = V.id_vendedor
where B.aprovaFaDireto = 'Aprovada'