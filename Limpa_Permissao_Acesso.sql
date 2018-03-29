--- Limpar tabela quando via CS não consegue retirar ou dar permissao

select * from  tbPermissaoAcesso where CodigoUsuario = 'LFERREIRA' and CodigoFormulario like '%frmcg%'

select * from tbFormulariosSistema where CodigoSistema = '' and DescricaoFormulario like '%Capt%'

select * from tbFormulariosSistema where CodigoIdentificadorFormulario = 'CR079'

select * from  tbPermissaoAcesso where CodigoUsuario = 'VALADARES' and CodigoFormulario like '%frmft%'

--DELETE tbPermissaoAcesso where CodigoUsuario = 'WGOAD11' and CodigoFormulario = 'frmcgHistoricoLancto'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpCaptacaoDocumentos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpConsumoServico'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpDocumentosPrevistos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabela'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabelaEscalonado'



--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM47' and CodigoFormulario ='frmcvCaptacaoNFEDealer'
