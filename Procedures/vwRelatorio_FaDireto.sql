--DROP VIEW dbo.vwRelatorio_FaDireto
CREATE VIEW dbo.vwRelatorio_FaDireto
AS

/*View para Gera��o do Relat�rio de Rentabilidades FaDireto
*Cria��o: 26/10/2017
*Renspos�vel: Lu�s Felipe Ferreira
*Motivo: Atendimento ao Chamado 60628
*/

SELECT B.data,
	   B.nome,
	   B.int_ValorVenda,
	   M.modelo,
	   B.id_empresa,
	   EM.nome_empresa as 'concVendedora',
	   B.form_pagamento,
	   B.banco,
	   E.nome_empresa as 'concFatura',
	   V.vendedor,
	   B.int_ValorFundo,
	   B.BonusEspecial,
	   B.BonLocalizacao,
	   B.BonAtacado,
	   B.BonVenda
FROM base_FaDireto B
inner join empresa E
on B.id_interveniente = E.id
inner join empresa EM
on B.id_empresa = EM.id
inner join modelo M
on B.id_modelo = M.id
inner join vendedor V
on B.id_vendedor = V.id_vendedor
where B.aprovaFaDireto = 'Aprovada'