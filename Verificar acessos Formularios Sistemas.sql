/* Verificar acesso */
--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
SELECT @CodigoFormulario    = 'FT096'
SELECT @Formulario = CodigoFormulario FROM tbFormulariosSistema WHERE CodigoIdentificadorFormulario = @CodigoFormulario
select * from tbUsuarios where UsuarioAtivo = 'V' and CodigoUsuario not in (SELECT CodigoUsuario from tbPermissaoAcesso where CodigoFormulario = @Formulario)
/* fim verificar acesso */