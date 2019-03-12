select * from dbo.base_FaDireto where data between '2017-10-01' and '2017-10-31' and aprovaFaDireto = 'Aprovada' and id_empresa = 5

sp_helptext Relatorio_Faturamento

select * from dbo.Relatorio_FaDireto where data between '2017-10-01' and '2017-10-31' and id_empresa = 5 ORDER BY data desc

SELECT B.data,
	   B.int_ValorVenda,
	   M.modelo,
	   E.nome_empresa,
	   B.nome,
	   B.form_pagamento,
	   B.banco, 
	   EM.nome_empresa,
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
where B.id_empresa = ? and data >= ? and data <= ? ORDER BY data";
