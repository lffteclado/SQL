--- Atualizar percentual de desconto Faturamento / Usuários Faturamento /Parametros Oficina

select * from tbUsuarioFT where CodigoUsuario  = 'GLEIDSON6' and PermiteAlterarTabPrecoPecas = 'V'

select PermiteAlterarTabPrecoPecas from tbUsuarioFT where CodigoUsuario  = 'GLEIDSON3' and PermiteAlterarTabPrecoPecas = 'V'

update tbUsuarioFT set PercDescontoPeca  = 0,PercDescontoMaodeObra = 0,PercDescontoCombLubrif = 0 
where CodigoUsuario  = 'GLEIDSON6'

---Bloqueia permissao de acesso
update tbUsuarioFT set PermiteAlterarTabPrecoPecas = 'F'
where CodigoUsuario  ! = 'CRIS' AND CodigoUsuario  ! = 'GLEIDSON' AND CodigoUsuario  ! = 'LUIS8'

---Libera Permissao de Acesso
update tbUsuarioFT set PermiteAlterarTabPrecoPecas = 'V'
where CodigoUsuario  = 'CRIS'
