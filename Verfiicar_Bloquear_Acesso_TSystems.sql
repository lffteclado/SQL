select * from tbEmpresa
/* Verificar acesso */
--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)
--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = 2890
SELECT @CodigoFormulario    = 'CE005'
SELECT @Formulario = CodigoFormulario FROM tbFormulariosSistema WHERE CodigoIdentificadorFormulario = @CodigoFormulario
select * from tbUsuarios where CodigoUsuario not in (SELECT CodigoUsuario from tbPermissaoAcesso where CodigoFormulario = @Formulario)
/* fim verificar acesso */


--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)

--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = 260
SELECT @CodigoFormulario    = 'CR084'
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


### usuario consulta 
insert into tbPermissaoManutencao(CodigoEmpresa,CodigoFormulario,CodigoControle,IndiceControle,CodigoUsuario,Permissao)
		select '2890',tbFor.CodigoFormulario,
					tbCon.CodigoControle,
					tbCon.IndiceControle,
					'CONSULTOR',
					'IAE'

			from tbFormulariosSistema tbFor 
			inner join tbControlesSistema tbCon on
			tbCon.CodigoFormulario = tbFor.CodigoFormulario 

--- ajuste em varia bases de dados 


insert into dbVadiesel.dbo.tbPermissaoAcesso(
			dbVadiesel.dbo.CodigoEmpresa,
			dbVadiesel.dbo.tbAc.CodigoUsuario,
			dbVadiesel.dbo.CodigoFormulario,
			dbVadiesel.dbo.CodigoControle,
			dbVadiesel.dbo.IndiceControle)
			select '130',
					'WSILVAV',
					CodigoFormulario,
					CodigoControle,
					IndiceControle
					from tbPermissaoAcesso where CodigoUsuario = 'WSILVA'
#############################################################


select * from tbEmpresa
/* Verificar acesso */
--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)
--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = 2620
SELECT @CodigoFormulario    = 'CE005'
SELECT @Formulario = CodigoFormulario FROM tbFormulariosSistema WHERE CodigoIdentificadorFormulario = @CodigoFormulario
select * from tbUsuarios where CodigoUsuario not in (SELECT CodigoUsuario from tbPermissaoAcesso where CodigoFormulario = @Formulario)
/* fim verificar acesso */


--- Bloqueio formulario do Controle de Sistemas
DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)

--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = 2620
SELECT @CodigoFormulario    = 'CE005'
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
CodigoEmpresaDefaultUsuario = @CodigoEmpresa AND
(CodigoUsuario <> 'DOLIVEIRA2'                    
AND CodigoUsuario <> 'LGUSTAVO'    
AND CodigoUsuario <> 'MMORAES' 
AND CodigoUsuario <> 'LUIS5' )
   
GROUP BY tbUsuarios.CodigoUsuario