select * from tbPlanoPagamento where CodigoPlanoPagamento = '500'

select CodigoPlanoPagamento,
       DescricaoPlanoPagamento,
	   PercentualDescNFPlanoPagamento,
	   PercentualDescontoPEC
from tbPlanoPagamento where BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'