--select * from sysobjects where name like '%tbCliente%'

select distinct(CodigoPlanoPagamento) from tbClienteComplementar where CodigoPlanoPagamento is not null

select CodigoPlanoPagamento from tbClienteComplementar where CodigoPlanoPagamento is not null

select top(5)CodigoPlanoPagamento from tbClienteComplementar where CodigoPlanoPagamento is not null

select substring(CodigoPlanoPagamento,1,1) from tbClienteComplementar where CodigoPlanoPagamento is not null

select CodigoCliFor, CodigoPlanoPagamento from tbClienteComplementar where substring(CodigoPlanoPagamento,1,1) = '6'

select top(50)* from tbLogTransNegocio where CamposTabela like '%8642410000148%' order by DataHoraOperacao DESC where NomeOpecaoorder 
select top(50)* from tbLogTrans order by DataHoraTransacao DESC

/*
update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = '5'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = '6'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,2) = '10'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = 'E'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = 'M'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = '3'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = 'C'

update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = '2'

--update tbClienteComplementar set CodigoPlanoPagamento = null where substring(CodigoPlanoPagamento,1,1) = '7' Por enquanto nao



sp_helptext spAClienteComplementar

*/