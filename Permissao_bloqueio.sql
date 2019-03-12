--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)

--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = 930
SELECT @CodigoFormulario    = 'AF036'
---

SELECT @Formulario = CodigoFormulario
FROM tbFormulariosSistema
WHERE
CodigoIdentificadorFormulario = @CodigoFormulario

DELETE tbPermissaoAcesso
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoFormulario = @Formulario

INSERT tbPermissaoAcesso
SELECT 
@CodigoEmpresa,
tbUsuarios.CodigoUsuario,
@Formulario,
min(CodigoControle),
min(IndiceControle)
FROM tbControlesSistema, tbUsuarios
WHERE
CodigoFormulario = @Formulario AND
CodigoEmpresaDefaultUsuario = @CodigoEmpresa
GROUP BY tbUsuarios.CodigoUsuario


