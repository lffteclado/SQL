
CREATE /*ALTER*/ TRIGGER [dbo].[TRI_SITUACAO_ATENDIMENTO_PAGAMENTO_ESPELHO] ON [dbo].[tb_pagamento_espelho]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON

   IF EXISTS(SELECT * FROM inserted)
    BEGIN
		declare @table table (fk_procedimento bigint,
		valorEspelhado numeric (19,2),
		valorEspelhoPago numeric (19,2),
		valorRepassado numeric (19,2),
		espelhado bit,
		espelhoPago bit,
		repassado bit
		)
		
		insert into @table 
		select pagamentoProcedimento.fk_procedimento,0,0,0,0,0,0
		from inserted inser 
		inner join tb_atendimento atendimento with (nolock) on (atendimento.registro_ativo=1 and 
																 atendimento.fk_espelho=inser.fk_espelho)
		inner join tb_procedimento procedimento with (nolock) on (procedimento.registro_ativo=1 and 
																  procedimento.fk_atendimento=atendimento.id)
		inner join tb_pagamento_procedimento 
				   pagamentoProcedimento with (nolock) on (pagamentoProcedimento.registro_ativo=1
				                                            and pagamentoProcedimento.fk_procedimento=procedimento.id)

		/*
    	insert into rl_situacao_procedimento
		select fk_procedimento,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		  from @table pagamentoEspelho
		 where not exists(select fk_procedimento 
							from rl_situacao_procediment
o 
						   where fk_procedimento=pagamentoEspelho.fk_procedimento)
		*/
		update temporaria
		   set temporaria.valorEspelhado= valorTotal
		  from @table temporaria
		 cross apply(select sum(pagamentoProcedimento.valor_honorario+
							    pagamentoProcedimento.valor_acrescimo+
							    pagamentoProcedimento.valor_custo_operacional-
							    pagamentoProcedimento.valor_desconto+
							    pagamentoProcedimento.valor_filme) as valorTotal
		from tb_pagamento_procedimento pagamentoProcedimento with(nolock)		  
	   where pagamentoProcedimento.fk_procedimento=temporaria.fk_procedimento and 
		     pagamentoProcedimento.fk_fatura is null and 
		     pagamentoProcedimento.registro_ativo=1) as tabelao
				
		--pagamentoEspelho
		update temporaria set temporaria.valorEspelhoPago= isnull(tabelao.valorTotal,0),temporaria.espelhoPago=0
		  from @table temporaria
		 cross apply (select sum((pagamentoEspelho.percentual_pagamento)*
								 (pagamento.valor_honorario+
								  pagamento.valor_acrescimo+
	
							  pagamento.valor_custo_operacional-
								  pagamento.valor_desconto+pagamento.valor_filme)/100) as valorTotal, pagamento.fk_procedimento
                        from tb_pagamento_procedimento pagamento with (nolock)
					   inner join tb_procedimento procedimento with (nolock) ON(procedimento.id=pagamento.fk_procedimento and 
																				procedimento.registro_ativo=1)
					   inner join tb_atendimento atendimento with (nolock) ON(atendimento.id=procedimento.fk_atendimento and 
									
										  atendimento.registro_ativo=1)
					   inner join tb_pagamento_espelho pagamentoEspelho with (nolock) ON(pagamentoEspelho.fk_espelho=atendimento.fk_espelho and 
																						 pagamentoEspelho.registro_ativo=1 and 
																					
	 pagamentoEspelho.fk_repasse is null)
					   where temporaria.fk_procedimento=pagamento.fk_procedimento 
					     and pagamento.registro_ativo=1 
						 and pagamento.fk_fatura is null
					   group by pagamento.fk_procedimento) as tabelao
		
		--Repassado
		update temporaria
		   set temporaria.valorRepassado= isnull(tabelao.valorTotal,0),temporaria.repassado=0
		  from @table temporaria 
		 cross apply (select sum((pagamentoEspelho.percentual_pagamento)*
								 (pagamento.valor_honorario+
								 
 pagamento.valor_acrescimo+
								  pagamento.valor_custo_operacional-
								  pagamento.valor_desconto+pagamento.valor_filme)/100) as valorTotal, pagamento.fk_procedimento
                        from tb_pagamento_procedimento pagamento with (nolock)
 
					   inner join tb_procedimento procedimento with (nolock) ON(procedimento.id=pagamento.fk_procedimento and 
																				procedimento.registro_ativo=1)
					   inner join tb_atendimento atendimento with (nolock) ON(atendimento.id=procedimento
.fk_atendimento and 
																			  atendimento.registro_ativo=1)
					   inner join tb_pagamento_espelho pagamentoEspelho with (nolock) ON(pagamentoEspelho.fk_espelho=atendimento.fk_espelho and 
																						 pagamentoEspelho.registro_ativ
o=1 and 
																						 pagamentoEspelho.fk_repasse is not null)
					   where temporaria.fk_procedimento=pagamento.fk_procedimento 
					     and pagamento.registro_ativo=1 
						 and pagamento.fk_fatura is null
					   group by pagamento.fk_pro
cedimento) as tabelao


		--faturado
		update temporaria
		   set temporaria.valorEspelhado=temporaria.valorEspelhado-
										 temporaria.valorEspelhoPago-
										 temporaria.valorRepassado, 
			   temporaria.espelhado = 0
		from @table temporaria 

		inner join rl_situacao_procedimento situacao on(temporaria.fk_procedimento=situacao.fk_procedimento)
		
		update temporaria
		   set temporaria.espelhado= 1
		  from @table temporaria 
		 where temporaria.valorEspelhado>0
		 
		update temporaria
		   se
t temporaria.espelhoPago= 1
		  from @table temporaria 
		 where temporaria.valorEspelhoPago>0

		update temporaria
		   set temporaria.repassado= 1
		  from @table temporaria 
		 where temporaria.valorRepassado>0

		update situacao 
		   set situacao.esp
elhado=temporaria.espelhado,
			   situacao.espelhoPago=temporaria.espelhoPago,
			   situacao.repassado=temporaria.repassado,
			   situacao.valorEspelhado =temporaria.valorEspelhado,
			   situacao.valorEspelhoPago=temporaria.valorespelhoPago,
			   sit
uacao.valorRepassado=temporaria.valorRepassado
		  from rl_situacao_procedimento  situacao
		 inner join @table temporaria on(situacao.fk_procedimento=temporaria.fk_procedimento)
   END
END


