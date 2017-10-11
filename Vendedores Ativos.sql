--select * from sysobjects where name like 'tb%suarioFT'

--select CodigoRepresentante, RepresentanteBloqueado from tbRepresentante where RepresentanteBloqueado = 'F'

--select * from tbRepresentante

--select * from tbUsuarioFT
--select * from tbUsuarios



select tbUs.NomeUsuario,
		tbUF.CodigoUsuario,
		tbRe.CodigoRepresentante,
		tbRe.RepresentanteBloqueado,
		tbUs.UsuarioAtivo
		from tbRepresentante tbRe
		inner join tbUsuarioFT tbUF on
		tbRe.CodigoRepresentante = tbUF.CodigoRepresentante
		inner join tbUsuarios tbUs on
		tbUF.CodigoUsuario = tbUs.CodigoUsuario
		where tbRe.RepresentanteBloqueado = 'F' and tbUs.UsuarioAtivo = 'V'