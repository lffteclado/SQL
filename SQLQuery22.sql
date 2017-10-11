--select * from sysobjects where name like 'tb%suario%'

select CodigoUsuario, NomeUsuario, UsuarioAtivo from tbUsuarios where UsuarioAtivo = 'V'