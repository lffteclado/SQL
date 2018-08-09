--- Limpar tabela quando via CS n�o consegue retirar ou dar permissao

select * from  tbPermissaoAcesso where CodigoUsuario = 'DPEREIRA' and CodigoFormulario like 'frmcgParametros'

select * from tbFormulariosSistema where CodigoSistema = '' and DescricaoFormulario like '%Capt%'

frmosVeicOficina

select * from tbFormulariosSistema where CodigoIdentificadorFormulario = 'FT073'

select * from tbFormulariosSistema where CodigoFormulario = 'frmosListaOROS'


select * from  tbPermissaoAcesso where CodigoUsuario = 'WBHLFI23' and CodigoFormulario like '%frmftEmpresa%'

select * from tbFormulariosSistema where CodigoSistema = 'CE' and DescricaoFormulario like '%Invent�rio%'

--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHLFI23' and CodigoFormulario = 'frmftLocal'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM27' and CodigoFormulario = 'frmcgParametros'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpConsumoServico'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpDocumentosPrevistos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabela'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabelaEscalonado'

--sp_helptext whPermissaoManutencaoE

--select * from update tbPermissaoManutencao set IndiceControle where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceRelCEObsolescencia'

--select * from tbPermissaoManutencao  where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceRelCEObsolescencia'
--select * from tbPermissaoManutencao  where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceAcessoInventario'


--execute whPermissaoManutencaoE @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CE153 frmcePesquisaKardexConversao',@CodigoControle = null,@IndiceControle = 99



--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM47' and CodigoFormulario ='frmcvCaptacaoNFEDealer'

--Bloquenado Acesso

--execute whPermissaoManutencaoI @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CS005 frmcsCopiarPerfil',@CodigoControle = null,@IndiceControle = 99,@Permissao = 'IAE'

--Liberando Permiss�o
--execute whPermissaoManutencaoE @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CS005 frmcsCopiarPerfil',@CodigoControle = null,@IndiceControle = 99

SELECT * from tbPermissaoAcesso (NOLOCK)
Where CodigoEmpresa = 2630 And CodigoFormulario = 'frmcbLanctosTransferencia' And CodigoUsuario = 'WMIRANDA'


--DELETE tbPermissaoAcesso where CodigoUsuario = 'DPEREIRA' and CodigoFormulario = 'frmftCancelNFiscal'
--GO
--DELETE tbPermissaoAcesso where CodigoUsuario = 'ACLAUDIA' and CodigoFormulario = 'frmcgParametros'
--GO
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM27' and CodigoFormulario = 'frmcgParametros'
