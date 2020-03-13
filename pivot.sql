select distinct co.cpf_cnpj cpf_cnpj,
		   ('BPFDEC|' + co.cpf_cnpj + '|' + co.nome + '||N|N|') as BPFDEC,
		   ('RTRT|' + 
		   isnull(convert(varchar, valoresRTRT.jan ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.fev ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.mar ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.abr ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.mai ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.jun ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.jul ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.ago ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.sep ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.oct ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.nov ),'000')+'|'+
		   isnull(convert(varchar, valoresRTRT.dez ),'000')+'|') as RTRT,
		   ('RTPO|' + 
		   isnull(convert(varchar, valoresRTPO.jan ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.fev ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.mar ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.abr ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.mai ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.jun ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.jul ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.ago ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.sep ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.oct ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.nov ),'000')+'|'+
		   isnull(convert(varchar, valoresRTPO.dez ),'000')+'|') as RTPO,
		   ('RTDP|' + 
		   isnull(convert(varchar, valoresRTDP.jan ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.fev ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.mar ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.abr ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.mai ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.jun ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.jul ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.ago ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.sep ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.oct ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.nov ),'000')+'|'+
		   isnull(convert(varchar, valoresRTDP.dez ),'000')+'|') as RTDP,
		   ('RTIRF|' + 
		   isnull(convert(varchar, valoresRTIRF.jan ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.fev ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.mar ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.abr ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.mai ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.jun ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.jul ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.ago ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.sep ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.oct ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.nov ),'000')+'|'+
		   isnull(convert(varchar, valoresRTIRF.dez ),'000')+'|') as RTIRF     
       from rl_dirf_cooperado dc with (nolock)
	   inner join tb_dirf di with (nolock) on di.id = dc.fk_dirf
	   inner join tb_cooperado co with (nolock) on co.id = dc.fk_cooperado	   
	   inner join rl_dirf_valores va with (nolock) on dc.id = va.fk_dirf_cooperados	   
	   cross apply (select [1] jan, [2] fev, [3] mar, [4] abr, [5] mai, [6] jun, 
					[7] jul, [8] ago, [9] sep, [10] oct, [11] nov, [12] dez
					from (select fk_dirf_cooperados, valor_retencao_trimestral, mes from rl_dirf_valores) as val
					pivot
				   (sum(valor_retencao_trimestral)
				   FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))p
				   where fk_dirf_cooperados = dc.id
				   and valor_retencao_trimestral > 0) valoresRTRT
	   cross apply (select [1] jan, [2] fev, [3] mar, [4] abr, [5] mai, [6] jun, 
					[7] jul, [8] ago, [9] sep, [10] oct, [11] nov, [12] dez
					from (select fk_dirf_cooperados, valor_inss, mes from rl_dirf_valores) as val
					pivot
				   (sum(valor_inss)
				   FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))p
				   where fk_dirf_cooperados = dc.id) valoresRTPO
       cross apply (select [1] jan, [2] fev, [3] mar, [4] abr, [5] mai, [6] jun, 
					[7] jul, [8] ago, [9] sep, [10] oct, [11] nov, [12] dez
					from (select fk_dirf_cooperados, valor_dependentes, mes from rl_dirf_valores) as val
					pivot
				   (sum(valor_dependentes)
				   FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))p
				   where fk_dirf_cooperados = dc.id) valoresRTDP
       cross apply (select [1] jan, [2] fev, [3] mar, [4] abr, [5] mai, [6] jun, 
					[7] jul, [8] ago, [9] sep, [10] oct, [11] nov, [12] dez
					from (select fk_dirf_cooperados, valor_imposto_retido, mes from rl_dirf_valores) as val
					pivot
				   (sum(valor_imposto_retido)
				   FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))p
				   where fk_dirf_cooperados = dc.id) valoresRTIRF
      where di.id = dc.fk_dirf                
		and di.id = 75
		and dc.tipo_codigo_retencao = 561
		and cpf_cnpj is not null
		order by cpf_cnpj

		select [1] jan, [2] fev, [3] mar, [4] abr, [5] mai, [6] jun, 
					[7] jul, [8] ago, [9] sep, [10] oct, [11] nov, [12] dez
					from (select fk_dirf_cooperados, valor_retencao_trimestral, mes from rl_dirf_valores) as val
					pivot
				   (sum(valor_retencao_trimestral)
				   FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))p
				   where fk_dirf_cooperados = (select max(id) from rl_dirf_cooperado)