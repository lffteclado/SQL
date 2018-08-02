select * from dbo.Ocupacao$ where TITULO like '%Super%'

sp_helptext exec sp_AcertoPlanoVDL

select * from tbPlanoPagtoVDL

select * from tbClienteComplementar where CodigoPlanoPagamento like '6%'

select * from sysobjects where name like 'tb%Cli%'

select * from tbPlanoPagamento where BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

--update tbPlanoPagtoVDL set PerPlano = 30 where CodPlano = 715

