--- PESQUISA LIMITE PERCENTUAL DE DESCONTO VENDEDORES

select FT.CodigoUsuario,FT.PercDescontoPeca,FT.PercDescontoMaodeObra,FT.PercDescontoCombLubrif
from tbUsuarioFT AS FT INNER JOIN tbUsuarios AS C ON FT.CodigoUsuario = C.CodigoUsuario 
where C.UsuarioAtivo = 'V' and C.CodigoLocalDefaultUsuario = 1