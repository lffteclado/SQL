EXECUTE whPPedido @CodigoEmpresa = 2620,@CodigoLocal = 0,@CentroCusto = 27720,@NumeroPedido = 661061,@SequenciaPedido = 0

select * from tbDocumento where NumeroDocumento = 661061
select * from tbPedido where NumeroPedido = 661061

sp_helptext whPPedido

EXECUTE whBGListarItensFichaProducao @CodigoEmpresa = 2620,@CodigoLocal = 0,@NumeroLote = 13834

select CodigoUsuario, AssinaturaEletronicaUsuario from tbUsuarios WHERE UsuarioAtivo = 'V' 
select count(*) as 'QtdMensagens' from tbMensagemInterna (nolock) where Lido = 'F' and CodigoUsuarioDestino = 'LUIS5'