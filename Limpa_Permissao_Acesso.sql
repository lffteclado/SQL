--- Limpar tabela quando via CS não consegue retirar ou dar permissao

select * from  tbPermissaoAcesso where CodigoUsuario = 'WBHRADM3' and CodigoFormulario like '%frmos%'

select * from tbFormulariosSistema where CodigoSistema = '' and DescricaoFormulario like '%Capt%'

select * from  tbPermissaoAcesso where CodigoUsuario = 'VALADARES' and CodigoFormulario like '%frmft%'

--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHRADM3' and CodigoFormulario = 'frmosMaoObra'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpCaptacaoDocumentos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpConsumoServico'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpDocumentosPrevistos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabela'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabelaEscalonado'



--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM47' and CodigoFormulario ='frmcvCaptacaoNFEDealer'
