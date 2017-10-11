--select top(1) * from tbPlanoPagamento where CodigoPlanoPagamento = '1025'
--select CodigoPlanoPagamento, DescricaoPlanoPagamento, BloqueadoPlanoPagto from tbPlanoPagamento where BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'
--select CodigoPlanoPagamento, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'
--select * from sysobjects where name like '%tb%Cliente%'
--select * from tbPlanoPagtoVDL

select ClienteAtivo top(5) from tbCliFor where ClienteAtivo = 'F'

select * from tbClienteComplementar where AgrupaNotaFaturamento = 'F'

--select CodigoCliFor, CodigoPlanoPagamento from tbClienteComplementar where CodigoPlanoPagamento is not null and ClienteBloqueadoPorFalencia = 'F'

select tbCC.CodigoCliFor,
		tbCF.NomeCliFor,
		tbCC.CodigoPlanoPagamento
		from tbClienteComplementar tbCC
		inner join tbCliFor tbCF on
		tbCF.CodigoCliFor = tbCC.CodigoCliFor
		where substring (tbCC.CodigoPlanoPagamento,1,1) = '6'

--DescricaoProduto = substring(DescricaoProduto,1(inicio),3(fim))

--insert into tbPlanoPagtoVDL (Cont, CodPlano, PerPlano) values (88, 547, 0)

--execute sp_AcertoPlanoVDL

--sp_helptext sp_AcertoPlanoVDL

--Listar Clientes Ativos com o Campo Agrupar NF na Fatura

select tbCC.CodigoCliFor, 
       tbCF.NomeCliFor,
	   tbCF.ClienteAtivo,
	   tbCC.AgrupaNotaFaturamento
from tbClienteComplementar tbCC
		inner join tbCliFor tbCF on
		tbCF.CodigoCliFor = tbCC.CodigoCliFor
where tbCF.ClienteAtivo = 'V' and tbCC.AgrupaNotaFaturamento = 'F'

--****************************************************************