select * from tb_entidade where sigla like 'SEMPCOOP' --16

select numero_espelho, unificado, data_unificacao, * from tb_espelho where numero_espelho in (16214, 16233, 16227) and fk_entidade = 16

/*
16214	563484 148 Registros
16227	564622 3737 Registros
16233	565074 326 Registros
*/

select numero_espelho from tb_espelho where id in (

select fk_espelho_antigo from tb_atendimento where fk_espelho = 564622 and registro_ativo = 1

)

select fk_espelho_antigo, fk_espelho, * from tb_atendimento where fk_espelho = 564622 and fk_espelho_antigo is not null

select fk_espelho_antigo, fk_espelho, * from tb_atendimento where fk_espelho_antigo in (565074)

/*
update tb_atendimento set fk_espelho = fk_espelho_antigo, sql_update = ISNULL(sql_update,'')+'#0919-000438'
 where fk_espelho = 564622 and fk_espelho_antigo = 565074

GO

update tb_espelho set unificado = NULL, data_unificacao = NULL, sql_update = ISNULL(sql_update,'')+'#0919-000438' where id = 564622

*/
