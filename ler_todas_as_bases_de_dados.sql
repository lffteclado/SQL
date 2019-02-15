--Segue comando SQL, ler todas as bases de dados:

EXEC master.sys.sp_MSforeachdb 'USE [?] 
select * from tbUsuarios where CodigoUsuario = "CARAUJO"' 