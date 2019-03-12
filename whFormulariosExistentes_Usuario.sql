Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create Procedure dbo.whFormulariosExistentes
/*------------------------------------------------------------------------------------------------
' Empresa       : CDC - Consulters/Humaita
' Projeto       : 
' Respons_vel   : STrgio Pontes da Cunha
' Data Criatao  : 
' Objetivo      : Retorno de todos os formularios que nao fazem parte de tbPermissaoAcesso 
'		de um Usu_rio.
' EXECUTE whFormulariosExistentes @CodigoEmpresa = 930,@CodigoUsuario = 'ACARVALHO',@CodigoSistema = 'CG'
*/ 
@CodigoEmpresa dtInteiro04,
@CodigoUsuario Char(30),
@CodigoSistema Char(2) = Null

As
Declare @CodigoFormulario VarChar(40)
Declare @DescricaoFormulario VarChar(255)

	CREATE TABLE #tmpFormSist
                (CodigoIdentificadorFormulario Char(5),
		 CodigoFormulario Char(40),
		 DescricaoFormulario VarChar(255))

	INSERT #tmpFormSist 
	SELECT CodigoIdentificadorFormulario, CodigoFormulario, DescricaoFormulario FROM tbFormulariosSistema
	WHERE (tbFormulariosSistema.CodigoSistema = IsNull(@CodigoSistema,tbFormulariosSistema.CodigoSistema))

	IF (@@ERROR <> 0)
		RETURN (-1)

	DECLARE Cur_FormSiste INSENSITIVE CURSOR FOR
	SELECT DISTINCT tbFormulariosSistema.CodigoFormulario, 
			tbFormulariosSistema.DescricaoFormulario
	FROM	tbFormulariosSistema 
	INNER JOIN tbPermissaoAcesso ON 
		tbFormulariosSistema.CodigoFormulario = tbPermissaoAcesso.CodigoFormulario
	WHERE	(tbPermissaoAcesso.CodigoEmpresa = @CodigoEmpresa) AND 
		(tbPermissaoAcesso.CodigoUsuario = @CodigoUsuario)

	IF (@@ERROR <> 0)
		RETURN (-1)

	OPEN Cur_FormSiste

	FETCH NEXT FROM Cur_FormSiste INTO
			@CodigoFormulario,
			@DescricaoFormulario
	IF (@@ERROR <> 0)
	BEGIN
		CLOSE Cur_FormSiste
		DEALLOCATE  Cur_FormSiste
		RETURN (-1)
	END

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		DELETE 	FROM #tmpFormSist 
		WHERE	CodigoFormulario = @CodigoFormulario

		IF (@@ERROR <> 0)
		BEGIN
			CLOSE Cur_FormSiste
			DEALLOCATE  Cur_FormSiste
			RETURN (-1)
		END
	
		FETCH NEXT FROM Cur_FormSiste INTO
				@CodigoFormulario,
				@DescricaoFormulario
	END


	CLOSE Cur_FormSiste
	DEALLOCATE Cur_FormSiste

	SELECT * FROM #tmpFormSist
      



