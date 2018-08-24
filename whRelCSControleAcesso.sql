Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 	
CREATE PROCEDURE dbo.whRelCSControleAcesso

/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------

 EMPRESA......: T-Systems
 PROJETO......: Controle de Sistemas
 AUTOR........: 
 DATA.........: 19/10/2006
 OBJETIVO.....: Apresentar os formulários aos quais o usuario tem acesso 
 ALTERAÇÃO....: 
 DATA.........: 16/02/2012
 OBJETIVO.....: Possibilitar a escolha entre usuários ATIVOS e INATIVOS.

whRelCSControleAcesso @CodigoEmpresa = 1608, @UsuarioDe = 'FI051', @UsuarioAte = 'FI051', @SistemaDe = 'CR', @SistemaAte = 'CR', @FormularioDe = 'CR062', @FormularioAte = 'CR062', @UsuarioAtivo = 'V'
		
----------------------------------------------------------------------------------------
FIM_CABEC_PROC*/ 

	@CodigoEmpresa	dtInteiro04,
	@UsuarioDe		char(30) = NULL,
	@UsuarioAte		char(30) = NULL,
	@SistemaDe		char(2) = NULL,	
	@SistemaAte		char(2) = NULL,
	@FormularioDe	varchar(40) = NULL,		
	@FormularioAte	varchar(40) = NULL,
	@UsuarioAtivo	char(1) = NULL 

AS 

SET NOCOUNT ON		

SELECT 
	
	tbUsuarios.CodigoUsuario,
	tbUsuarios.NomeUsuario,
    tbUsuarios.UsuarioAtivo,
	tbUsuarios.DefaultAcessoUsuario,
	tbFormulariosSistema.CodigoIdentificadorFormulario,
	tbFormulariosSistema.CodigoFormulario,
	tbFormulariosSistema.DescricaoFormulario,
	tbSistemasAplicativos.CodigoSistema,
	tbSistemasAplicativos.DescricaoSistema

INTO #tmp

FROM  tbFormulariosSistema, tbUsuarios (nolock), tbSistemasAplicativos

WHERE 
tbFormulariosSistema.CodigoSistema = tbSistemasAplicativos.CodigoSistema AND
tbUsuarios.CodigoUsuario BETWEEN @UsuarioDe AND @UsuarioAte AND
tbSistemasAplicativos.CodigoSistema BETWEEN @SistemaDe AND @SistemaAte AND
(tbUsuarios.UsuarioAtivo = @UsuarioAtivo OR @UsuarioAtivo = '') AND 
tbFormulariosSistema.CodigoIdentificadorFormulario BETWEEN @FormularioDe AND @FormularioAte


SELECT DISTINCT
#tmp.CodigoUsuario,
#tmp.NomeUsuario,
#tmp.CodigoIdentificadorFormulario,
CASE WHEN tbControlesSistema.CodigoControle IS NOT NULL THEN
	COALESCE(tbControlesSistema.CodigoControle,'') + ' ' + COALESCE(CONVERT(VARCHAR(2),tbControlesSistema.IndiceControle),'') + ' ' + #tmp.CodigoFormulario
ELSE
	#tmp.CodigoFormulario 
END AS CodigoFormulario,
CASE WHEN tbControlesSistema.CodigoControle IS NOT NULL THEN
	COALESCE(tbControlesSistema.CodigoControle,'') + ' ' + COALESCE(CONVERT(VARCHAR(2),tbControlesSistema.IndiceControle),'') + ' ' + #tmp.DescricaoFormulario 
ELSE
	#tmp.DescricaoFormulario 
END AS DescricaoFormulario,
#tmp.CodigoSistema,
#tmp.DescricaoSistema,
#tmp.UsuarioAtivo,
#tmp.DefaultAcessoUsuario,
tbPermissaoAcesso.CodigoUsuario,
tbPermissaoManutencao.CodigoUsuario,


CASE WHEN (tbPermissaoAcesso.CodigoUsuario IS NULL) THEN
	'POSSUI ACESSO' 
ELSE 
	'NÃO POSSUI ACESSO' 
END AS Acesso,

CASE WHEN (tbPermissaoManutencao.CodigoUsuario IS NULL) THEN 
      'TOTAL' 
ELSE
     tbPermissaoManutencao.Permissao		
END AS PermissaoManutencao

FROM #tmp

LEFT JOIN tbControlesSistema (nolock) on
          tbControlesSistema.CodigoFormulario = #tmp.CodigoFormulario AND
          tbControlesSistema.CodigoControle like 'sst%' AND
          tbControlesSistema.IndiceControle <> 99
			
LEFT JOIN tbPermissaoAcesso (nolock) ON
          tbPermissaoAcesso.CodigoEmpresa = @CodigoEmpresa AND
          tbPermissaoAcesso.CodigoUsuario = #tmp.CodigoUsuario AND
          tbPermissaoAcesso.CodigoFormulario = #tmp.CodigoFormulario AND
		  ( tbPermissaoAcesso.IndiceControle = tbControlesSistema.IndiceControle OR tbControlesSistema.IndiceControle IS NULL )

LEFT JOIN tbPermissaoManutencao (nolock) ON
          tbPermissaoManutencao.CodigoEmpresa = @CodigoEmpresa  AND
          tbPermissaoManutencao.CodigoFormulario = #tmp.CodigoFormulario AND
          tbPermissaoManutencao.CodigoUsuario = #tmp.CodigoUsuario AND
		  ( tbPermissaoManutencao.IndiceControle = tbControlesSistema.IndiceControle OR tbControlesSistema.IndiceControle IS NULL )

WHERE 
#tmp.CodigoUsuario BETWEEN @UsuarioDe AND @UsuarioAte AND
#tmp.CodigoSistema BETWEEN @SistemaDe AND @SistemaAte AND
#tmp.CodigoIdentificadorFormulario BETWEEN @FormularioDe AND @FormularioAte

ORDER BY #tmp.CodigoUsuario,
         #tmp.CodigoIdentificadorFormulario


DROP TABLE #tmp
SET NOCOUNT OFF 



