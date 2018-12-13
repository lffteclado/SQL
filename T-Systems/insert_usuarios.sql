select * from tbUsuarios
WBHRAFN57                     
insert tbUsuarios values ('MASTER8','MASTER8','T',3610,0,'ADMINISTRADOR',55,'.','V','V','NULL','V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

select * from tbPermissaoAcesso where CodigoUsuario = 'WBHRAFN57'

select * from tbPermissaoAcesso where CodigoControle like '%Forn%' and CodigoUsuario = 'WBHRAFN57'

select * from tbPermissaoManutencao where CodigoUsuario = 'WBHRAFN57'

select * from tbSistemasAutorizados where CodigoUsuario = 'WBHRAFN57'