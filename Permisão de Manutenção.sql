--CREATE PROCEDURE whPermissaoManutencaoE Bloqueando
-- Desenvolvedor: Sergio Pontes da Cunha
-- Data: 
-- Classe: clsPermissaoManutencao
-- Sistema:  Controle de Sistema
-- Motivo: Deletar Permissao de Manutencao

--execute whPermissaoManutencaoE @CodigoEmpresa = 1200,
--@CodigoUsuario = 'AUDITORIA',
--@CodigoFormulario = 'CS005 frmcsCopiarPerfil',
--@CodigoControle = null,
--@IndiceControle = 99

@CodigoEmpresa dtInteiro04 ,
@CodigoFormulario dtCharacter60 ,
@CodigoControle dtCharacter60 = null,
@IndiceControle dtInteiro04 = 0,
@CodigoUsuario char(30) = Null
AS 
SELECT @CodigoFormulario = SUBSTRING(@CodigoFormulario,7,60)

DELETE from tbPermissaoManutencao 
WHERE 
CodigoEmpresa = @CodigoEmpresa And 
CodigoFormulario = @CodigoFormulario And 
( CodigoControle = @CodigoControle or @CodigoControle is null) And 
IndiceControle = isnull(@IndiceControle,IndiceControle) And 
CodigoUsuario = @CodigoUsuario


sp_helptext whPermissaoManutencaoI

Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE PROCEDURE whPermissaoManutencaoI Liberando

-- Autor: STrgio Pontes da Cunha
-- Data: 29/11/1998
-- Objetivo: Incluspo de registros na tbPermissaoManutencao
-- Utilizatpo: clsControle

--execute whPermissaoManutencaoI @CodigoEmpresa = 1200,
--@CodigoUsuario = 'AUDITORIA',
--@CodigoFormulario = 'CS005 frmcsCopiarPerfil',
--@CodigoControle = null,
--@IndiceControle = 99,
--@Permissao = 'IAE'

@CodigoEmpresa dtInteiro04 ,
@CodigoFormulario dtCharacter60 ,
@CodigoControle dtCharacter60 = NULL,
@IndiceControle dtInteiro04 = 0,
@CodigoUsuario char(30) = Null,
@Permissao char(3) 
AS 
SELECT @CodigoFormulario = SUBSTRING(@CodigoFormulario,7,60)

select @CodigoFormulario

		Insert tbPermissaoManutencao (CodigoEmpresa,
						CodigoFormulario,
 						CodigoControle,
						IndiceControle,
						CodigoUsuario,
						Permissao)
		Select @CodigoEmpresa, 
				 @CodigoFormulario, 
				 @CodigoControle, 
				 @IndiceControle, 
				 @CodigoUsuario, 
				 @Permissao 

--SQL2000 Order By CodigoFormulario , CodigoControle , IndiceControle





