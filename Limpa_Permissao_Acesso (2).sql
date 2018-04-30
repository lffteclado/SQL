--- Limpar tabela quando via CS não consegue retirar ou dar permissao

select * from  tbPermissaoAcesso where CodigoUsuario = 'MASTER8' and CodigoFormulario like '%frmft%'

select * from  tbPermissaoAcesso where CodigoUsuario = 'LUIS3' and CodigoFormulario like '%frmft%'

DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS3' and CodigoFormulario = 'frmftNotasFiscais'
DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHRADM47' and CodigoFormulario = 'frmceEntradas'
DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHRADM47' and CodigoFormulario = 'frmceNotasEntAut'
DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHRADM46' and CodigoFormulario = 'frmceEntradaAutomatica'
DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHLFI23' and CodigoFormulario = 'frmpoApontamentoTouch'
DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHLFI23' and CodigoFormulario = 'frmpoCadastroBoxes'






DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM47' and CodigoFormulario ='frmcvCaptacaoNFEDealer'
