select CodigoPlanoPagamento as AutoSete, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbAutosete.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Cardiesel, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbCardiesel_I.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Goias, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbGoias.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Posto_Imperial, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbPostoImperialDP.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Rede_Mineira, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbRedeMineira.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Uberlandia, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbUberlandia.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Vadiesel, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbVadiesel.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'

select CodigoPlanoPagamento as Valadares, DescricaoPlanoPagamento, BloqueadoPlanoPagto, PlanoEspecial from dbValadaresCNV.dbo.tbPlanoPagamento where PlanoEspecial = 'F' and BloqueadoPlanoPagto = 'F' and EntradaSaidaPlanoPagamento = 'S'
