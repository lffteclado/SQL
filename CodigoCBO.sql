  select 
      --especialidade.id as 'idEspecialidade', 
      especialidade.descricao as 'Especialidade', 
      codigoCBO.codigo as 'CBO',
	  codigoCBO.versaoTISS
      from  tb_tabela_tiss especialidade      
        cross apply ( 
        select top 1 (obj.id) as 'idCbo',
		       obj.codigo as 'codigo',
			   obj.versao_tiss as versaoTISS
	    from tb_tabela_tiss_versao_codigo obj 
        inner join tb_tabela_tiss esp on esp.id = obj.fk_tabela_tiss and esp.registro_ativo = 1 
        where esp.id  = especialidade.id 
        order by obj.id desc 
        ) as codigoCBO 
      where especialidade.discriminator = 'especialidade' 


	  select (obj.id) as 'idCbo',
		       obj.codigo as 'codigo',
			   obj.versao_tiss as versaoTISS, *
	    from tb_tabela_tiss_versao_codigo obj 
        inner join tb_tabela_tiss esp on esp.id = obj.fk_tabela_tiss and esp.registro_ativo = 1 
         where esp.id  = 231702
        order by obj.id desc 


	  /*
	   outer apply( 
        select ecE.id, ecE.principal from rl_entidadecooperado_especialidade ecE 
        where ecE.fk_especialidade = especialidade.id and ecE.fk_entidade_cooperado = 40259 and ecE.registro_ativo = 1 
      ) as entCoopEsp */