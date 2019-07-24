/**
* Script para ajustar o status do atendimento glosado para "Devida"
* Cooperativa: GINECOOP
* Numero Atendimento 174539 Espelho 24657
*/

update tb_glosa set situacao = 2, sql_update=ISNULL(sql_update,'')+'#0519-000015' where id in (27191, 27196)

--select situacao, sql_update, * from tb_glosa where id in (27191, 27196)