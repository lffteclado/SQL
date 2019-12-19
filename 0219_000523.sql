select * from tb_carta_glosa
 where numero_carta = 72291
  and fk_entidade in (select id from tb_entidade where sigla = 'UNICOOPER') -- 215676

 select valor_acrescimo,
        valor_acrescimoConvenio,
		valor_custo_operacional,
		valor_desconto,
		valor_desconto_anterior,
		valor_filme,
		valor_honorario,
		valor_honorario_anterior,
		valor_recebido,
		fk_procedimento
 from tb_glosa
  where fk_carta_glosa = 215676 and registro_ativo = 1 -- 29656798

select valor_acrescimo,
       valor_acrescimo_convenio,
	   valor_acrescimo_convenio_anterior,
	   valor_ch,
	   valor_custo_operacional,
	   valor_desconto,
	   valor_desconto_anterior,
	   valor_filme,
	   valor_honorario,
	   valor_honorario_anterior,
	   valor_percentual,
	   valor_total
 from tb_procedimento where id = 29180160

 select * from rl_situacao_procedimento where fk_procedimento = 29180160