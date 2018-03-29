select * from modelo where modelo like '%CHASSI 313%'

--Modulo: Sprinter Modelo: FURGAO 313 F32B

insert into modelo (modelo, id_modelo_tipo, modelo_excluido) values ('CHASSI 313 - C32B', 7, 41)

select * from modelo_seguimento

select * from modelo_tipo

select * from modelo where id_modelo_tipo = 7 order by id desc
