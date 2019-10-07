/*Desfazer a unificação dos Espelho: 16233 no espelho 16227*/

update tb_atendimento set fk_espelho = fk_espelho_antigo, sql_update = ISNULL(sql_update,'')+'#0919-000438'
 where fk_espelho = 564622 and fk_espelho_antigo = 565074

GO

update tb_atendimento set fk_espelho_antigo = NULL where fk_espelho_antigo in (565074)