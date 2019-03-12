DECLARE @CodigoFormulario varchar(5)
DECLARE @Formulario       varchar(40)
DECLARE @CodigoEmpresa    numeric(4)
--- Informar a Empresa e o Form
SELECT @CodigoEmpresa = CodigoEmpresa from tbEmpresa
SELECT @CodigoFormulario    = 'AF036'
SELECT @Formulario = CodigoFormulario FROM tbFormulariosSistema WHERE CodigoIdentificadorFormulario = @CodigoFormulario
select CodigoUsuario, NomeUsuario, UsuarioAtivo from tbUsuarios where CodigoUsuario not in (SELECT CodigoUsuario from tbPermissaoAcesso where CodigoFormulario = @Formulario) and UsuarioAtivo = 'V'
/* fim verificar acesso */

select * from tbUsuarioFT

select tbUF.CodigoUsuario,tbU.NomeUsuario,tbUF.CodigoRepresentante,tbUF.CITCliente,
tbUF.CITGarantia,tbUF.CITRevisao,tbUF.CITInterna from tbUsuarioFT tbUF 
inner join tbUsuarios tbU on 
tbUF.CodigoUsuario = tbU.CodigoUsuario
where tbUF.CodigoUsuario in ('CTEIXEIRA','CTEIXEIRA','JALVES',                        
'WBHADM47','WBHGAR51','ADMINISTRADOR','ADMINISTRATOR','MROCHA','VPPIRES','LFORTES',                       
'LUIS3','WBHBO123','AFERREIRA','AROCHA','WBHAVEI80','WBHTP38','EHFONSECA','WBHBO120',                      
'WBHCTEC49','WBHVEI154Q','WCOSTA','AUDITORIA','WBHADM46','WBHCTEC15F','WBHOFI50T',                     
'MMORAES','WBHLFI23','BSOUZA','WBHBO51','WBHCTEC46','WBHCTEC48','WBHGAR50')                      
and ( tbUF.CITCliente = 'V' or tbUF.CITGarantia = 'V' or tbUF.CITRevisao = 'V' or tbUF.CITInterna = 'V')


