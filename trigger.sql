update temporaria
		set temporaria.valorEspelhado= isnull(valorTotal,0),temporaria.espelhado=0
		from @table temporaria
		cross apply(select sum(pagamentoProcedimento.valor_honorario+pagamentoProcedimento.valor_acrescimo+pagamentoProcedimento.valor_custo_operacional-pagamentoProcedimento.valor_desconto+pagamentoProcedimento.valor_filme) as valorTotal
		from 
		  tb_pagamento_procedimento pagamentoProcedimento with(nolock) 
		  
		  where pagamentoProcedimento.fk_procedimento=temporaria.fk_procedimento and 
		  pagamentoProcedimento.fk_fatura is null and 
		  pagamentoProcedimento.registro_ativo=1) as tabelao	
          
          BEGIN
          END
          