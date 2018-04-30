--- Limpar tabela quando via CS não consegue retirar ou dar permissao

select * from  tbPermissaoAcesso where CodigoUsuario = 'HSREBOUCAS' and CodigoFormulario like '%frmag%'

select * from tbFormulariosSistema where CodigoSistema = '' and DescricaoFormulario like '%Capt%'

select * from tbFormulariosSistema where CodigoIdentificadorFormulario = 'AG008'

select * from  tbPermissaoAcesso where CodigoUsuario = 'CJUNIOR' and CodigoFormulario like '%frmcpDocumentosPrevistos%'

select * from tbFormulariosSistema where CodigoSistema = 'CE' and DescricaoFormulario like '%Inventário%'

--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHGAR51' and CodigoFormulario = 'frmosCaptaTTR'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHLFI23' and CodigoFormulario = 'frmceAlmoxarifadoCCusto'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpConsumoServico'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM46' and CodigoFormulario = 'frmcpDocumentosPrevistos'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabela'
--DELETE tbPermissaoAcesso where CodigoUsuario = 'LUIS6' and CodigoFormulario = 'frmceReajusteTabelaEscalonado'

sp_helptext whPermissaoManutencaoE

--select * from update tbPermissaoManutencao set IndiceControle where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceRelCEObsolescencia'

--select * from tbPermissaoManutencao  where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceRelCEObsolescencia'
--select * from tbPermissaoManutencao  where CodigoUsuario = 'AUDITORIA' and CodigoFormulario = 'frmceAcessoInventario'


--execute whPermissaoManutencaoE @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CE153 frmcePesquisaKardexConversao',@CodigoControle = null,@IndiceControle = 99



--DELETE tbPermissaoAcesso where CodigoUsuario = 'WBHADM47' and CodigoFormulario ='frmcvCaptacaoNFEDealer'

--Bloquenado Acesso

--execute whPermissaoManutencaoI @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CS005 frmcsCopiarPerfil',@CodigoControle = null,@IndiceControle = 99,@Permissao = 'IAE'

--Liberando Permissão
--execute whPermissaoManutencaoE @CodigoEmpresa = 1200,@CodigoUsuario = 'AUDITORIA',@CodigoFormulario = 'CS005 frmcsCopiarPerfil',@CodigoControle = null,@IndiceControle = 99
