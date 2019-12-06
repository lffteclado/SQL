SELECT NULL AS pk_importacao,                                                                                                                                                              
             0 AS resolveu_dependencia,                                                                                                                                                         
             getdate() data_ultima_alteracao,                                                                                                                                                        
             1 AS registro_ativo,                                                                                                                                                              
             getdate() data_lancamento,                                                                                                                                                            
             'Servico Especial Fixo' AS descricao,                                                                                                                                                     
             null AS numero_lancamento,                                                                                                                                                            
             participante.valor AS valor_lancamento,                                                                                                                                                     
             12 AS fk_usuario_ultima_alteracao,
             NULL AS fk_convenio,                                                                                                                                                              
             participante.fk_cooperado AS fk_cooperado_recebedor_cobranca,                                                                                                                                         
             servicoEspecial.fk_entidade AS fk_entidade,                                                                                                                                                   
            (select id from rl_entidade_usuario where fk_entidade = 25 and fk_usuario = 12 AND registro_ativo = 1) AS fk_entidade_usuario_cadastro,
             NULL AS fk_espelho,                                                                                                                                                               
             NULL AS fk_fatura,                                                                                                                                                                
             NULL AS fk_importacao_unimed,                                                                                                                                                         
             0 AS fk_lancamento_repasse,                                                                                                                                                           
             12 AS fk_repasse,                                                                                                                                                              
             servicoEspecial.id,
			 composicao.id                                                                                                                                                            
      FROM rl_saldo_repasse_fixo saldo                                                                                                                                                           
      inner join tb_cooperado servicoEspecial on(saldo.fk_servico_especial=servicoEspecial.id and servicoEspecial.registro_ativo=1 and saldo.registro_ativo=1 and servicoEspecial.discriminator='se' and servicoEspecial.tipo_servico=1)                                                           
      cross apply(select id from tb_composicao_servico_especial where registro_ativo=1 and fk_servico_especial = saldo.fk_servico_especial and ((CONVERT(DATE,data_inicial)<=CONVERT(DATE,getdate())  and data_final is null ) or CONVERT(DATE,data_inicial)<=CONVERT(DATE,getdate())  and CONVERT(DATE,data_final) >= CONVERT(DATE,getdate()))) as composicao
      --cross apply(select id from tb_composicao_servico_especial where registro_ativo=1 and fk_servico_especial = saldo.fk_servico_especial and (data_inicial <= '2019-12-04' and data_final is null ) or (data_inicial <= '2019-12-04' and data_final <= '2019-12-04')) as composicao
	  inner join tb_participantes_composicao_servico_especial participante on(composicao.id=participante.fk_composicao_servico_especial and participante.registro_ativo=1)
      where fk_entidade=25 and isnull(participante.valor,0.0)>0


--select * from tb_composicao_servico_especial where id in (1539, 1592)