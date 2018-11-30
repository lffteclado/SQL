select CodigoPlanoPagamento, DescricaoPlanoPagamento, PercentualDescNFPlanoPagamento, PercentualDescontoPEC
from tbPlanoPagamento
where EntradaSaidaPlanoPagamento = 'S' and BloqueadoPlanoPagto = 'F'

--select * from tbPlanoPagamento where EntradaSaidaPlanoPagamento = 'S' and BloqueadoPlanoPagto = 'F'