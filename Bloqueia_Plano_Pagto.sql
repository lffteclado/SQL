--- Bloqueia Plano de Pagamento

select * from tbPlanoPagamento where BloqueadoPlanoPagto = 'V'

update tbPlanoPagamento set BloqueadoPlanoPagto = 'F'
where CodigoPlanoPagamento between '700' and '726' 


--- Fleg desconto invisivel 


update tbPlanoPagamento set DescontoInvisivelPlanoPagto = 'F' where CodigoPlanoPagamento = '614'

select DescontoInvisivelPlanoPagto from tbPlanoPagamento where CodigoPlanoPagamento = '526'



