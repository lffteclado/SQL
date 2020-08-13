SELECT DISTINCT
GETDATE() AS data_ultima_alteracao
,1 AS registro_ativo
,funcao.id AS idFuncao
,'FUNCAO' AS tipoFuncao
,12 AS fk_usuario_ultima_alteracao
,entidadePerfil.id AS fk_entidade_perfil_acesso
,'#0420-000148' AS sql_update
,0 AS processado INTO #tmp
 FROM rl_entidade_perfil_acesso entidadePerfil
 CROSS APPLY(
	select id from tb_arvore_funcao
 ) funcao
  WHERE registro_ativo = 1

BEGIN
    WHILE EXISTS(select 1 from #tmp where processado = 0)
    BEGIN
			
		declare @fk_entidade_perfil_acesso bigint = (select top 1 fk_entidade_perfil_acesso from #tmp where processado = 0 order by fk_entidade_perfil_acesso ASC)
		declare @idFuncao bigint = (select top 1 idFuncao from #tmp where processado = 0 order by fk_entidade_perfil_acesso ASC)

		--select * from #tmp where processado = 0 order by fk_entidade_perfil_acesso ASC

		--select * from rl_seguranca_entidade_perfil_acesso where idFuncao = @idFuncao and fk_entidade_perfil_acesso = @fk_entidade_perfil_acesso

        WHILE NOT EXISTS(select 1 from rl_seguranca_entidade_perfil_acesso where idFuncao = @idFuncao and fk_entidade_perfil_acesso = @fk_entidade_perfil_acesso)   
        BEGIN
             INSERT INTO rl_seguranca_entidade_perfil_acesso (
							data_ultima_alteracao
							,registro_ativo
							,idFuncao
							,tipoFuncao
							,fk_usuario_ultima_alteracao
							,fk_entidade_perfil_acesso
							,sql_update)
							 VALUES (
							 GETDATE()
							 ,1
							 ,@idFuncao
							 ,'FUNCAO'
							 ,12
							 ,@fk_entidade_perfil_acesso
							 ,'#0420-000148')

							 
        END;   
		UPDATE #tmp SET processado = 1 WHERE idFuncao = @idFuncao AND fk_entidade_perfil_acesso = @fk_entidade_perfil_acesso    
    END;
END;


DROP TABLE #tmp