select * from tbUsuarios   --Controle de Sistemas
select * from tbUsuarioFT  --Faturamento
select * from tbRepresentanteComplementar --Vendedor/Representante FT

select cs.CodigoUsuario, cs.NomeUsuario, vr.CodigoRepresentante, vr.NomeRepresentante, ft.PercDescontoPeca, ft.PercDescontoMaodeObra, 
ft.PercDescontoCombLubrif, vr.PercDescontoPec, vr.PercDescontoMob, vr.PercDescontoClo from tbUsuarioFT ft inner join tbUsuarios cs 
on cs.CodigoUsuario = ft.CodigoUsuario inner join tbRepresentanteComplementar vr on ft.CodigoRepresentante = vr.CodigoRepresentante 
where cs.UsuarioAtivo = 'V'order by cs.CodigoUsuario
/*Concatena as três tabelas para que mostre o login, nome do usuário no CS, cód. do representante, nome do representante, e os seus devidos
percentuais de descontos, tanto de Oficina (Usuários Faturamento) quanto de FT e TK (Vendedor/Representante)*/
