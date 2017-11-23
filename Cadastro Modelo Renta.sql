select * from modelo order by id desc where modelo = 'FURGAO 313 F32B'

--Modulo: Sprinter Modelo: FURGAO 313 F32B

insert into modelo (modelo, id_modelo_tipo, modelo_excluido) values ('FURGAO 313 F32B', 7, 41)

select * from modelo_seguimento

select * from modelo_tipo

select * from modelo where id_modelo_tipo = 7 order by id desc
