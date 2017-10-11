select * from tipo_usuario

select * from usuario where id_tipo_usuario = 12

update usuario set dataCadastroSenha = '2017-08-29 00:00:00.000' where id = 103

select * from clientePGC

select * from rentaPGC

SELECT Max(id_rentaPGC) AS id_rentaPGC, id_clientePGC FROM rentaPGC where id_clientePGC = 9 GROUP BY id_clientePGC