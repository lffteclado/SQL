select * from tbCliFor  --Tabela Clientes/Fornecedores

select * from tbCliFor where EmailCliFor = 'faturasautomaticas@grupovdl.com.br' --Teste para ver quem possui este email

select * from tbCliFor where EmailCliFor IS NULL --Busca o campo Email que esteja vazio


Update tbCliFor set EmailCliFor = 'faturasautomaticas@grupovdl.com.br' where EmailCliFor IS NULL

--Comando que varre a tabela Clientes/Fornecedores onde o campo email está em branco, atualiza para o email informado