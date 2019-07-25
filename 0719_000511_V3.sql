/* Todos os endereços com Correspondencia Marcados - 403 */
select * from tb_correspondencia_endereco  where fk_endereco in (
		/* Todos os Endereços dos Cooperados Ativos - 926 */ 
		select id from tb_endereco where fk_cooperado in (
			select fk_cooperado from rl_entidade_cooperado
			where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
		) and registro_ativo = 1 and fk_entidade = 17

) and registro_ativo = 1




/* Endereços sem correspondencia - 523 */
select * from tb_endereco where fk_cooperado in (
			select fk_cooperado from rl_entidade_cooperado
			where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
		) and registro_ativo = 1 and fk_entidade = 17 and id not in (

											select fk_endereco from tb_correspondencia_endereco  where fk_endereco in (
													/* Todos os Endereços dos Cooperados Ativos */
													select id from tb_endereco where fk_cooperado in (
														select fk_cooperado from rl_entidade_cooperado
														where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
													) and registro_ativo = 1 and fk_entidade = 17

											) and registro_ativo = 1 

         ) and fk_tipo_endereco = 0


/* Todos os endereços Residencial com Correspondencia Marcados - 304 */
select fk_endereco from tb_correspondencia_endereco  where fk_endereco in (
		/* Todos os Endereços dos Cooperados Ativos - 926 */ 
		select id from tb_endereco where fk_cooperado in (
			select fk_cooperado from rl_entidade_cooperado
			where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
		) and registro_ativo = 1 and fk_entidade = 17 and fk_tipo_endereco = 0

) and registro_ativo = 1



/* Todos os endereços Comercial com Correspondencia Marcados - 98 */
select fk_endereco from tb_correspondencia_endereco  where fk_endereco in (
		/* Todos os Endereços dos Cooperados Ativos - 926 */ 
		select id from tb_endereco where fk_cooperado in (
			select fk_cooperado from rl_entidade_cooperado
			where fk_entidade = 17 and situacao_cooperado = 0 and registro_ativo = 1
		) and registro_ativo = 1 and fk_entidade = 17 and fk_tipo_endereco = 1

) and registro_ativo = 1