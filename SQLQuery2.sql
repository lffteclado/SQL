select tbCF.CodigoCliFor,
		tbCF.NomeCliFor,
		tbCC.CodigoPlanoPagamento
		from tbClienteComplementar tbCC
		inner join tbCliFor tbCF on
		tbCF.CodigoCliFor = tbCC.CodigoCliFor
		where substring(tbCC.CodigoPlanoPagamento,1,1) = '8'

select * from sysobjects where name like '%vdl%'