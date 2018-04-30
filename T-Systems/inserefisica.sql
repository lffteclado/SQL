select
*
into #tmpCliForFisica
from tbCliForFisica
where CodigoCliFor = ( select distinct min(CodigoCliFor) from tbCliForFisica )

update #tmpCliForFisica
set CodigoCliFor = 485365049,              ----- > informar aqui o codigo do cliente
CPFFisica = '00485365049'                 ----- > informar aqui o CPF do cliente

insert tbCliForFisica
select * from #tmpCliForFisica

drop table #tmpCliForFisica