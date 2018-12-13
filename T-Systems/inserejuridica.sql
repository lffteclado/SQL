select
*
into #tmpCliForJuridica
from tbCliForJuridica
where CodigoCliFor = ( select distinct min(CodigoCliFor) from tbCliForJuridica )

update tbCliFor 
set TipoCliFor = 'J'
where CodigoCliFor = 5280906000120

update #tmpCliForJuridica
set CodigoCliFor = 5280906000120,              ----- > informar aqui o codigo do cliente
CGCJuridica = '05280906000120'                 ----- > informar aqui o CNPF do cliente

insert tbCliForJuridica
select * from #tmpCliForJuridica

drop table #tmpCliForJuridica


