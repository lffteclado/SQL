select * from tb_atendimento where id in (
select fk_atendimento from tb_procedimento where id in (
	select fk_procedimento from tb_glosa where fk_carta_glosa = 212032
) and registro_ativo = 1
)

select * from tb_entidade where sigla like '%UNICOOPER%'

select fk_procedimento, * from tb_glosa where fk_carta_glosa = 212032

select senha, * from tb_atendimento where id = 18039861 and senha = 'L219036'

--update tb_atendimento set senha = 'L175491', sql_update = ISNULL(sql_update,'')+'1019-000124' where id = 18039861 and senha = 'L219036'

select fk_atendimento, * from tb_procedimento where id =  26189442

select * from tb_carta_glosa where numero_carta = 70841 and fk_entidade = 43

select * from rl_entidade_grau_participacao where id in (43,895)

select * from tb_tabela_tiss where id in (109917,109929)

select * from tb_glosa where fk_carta_glosa = 212033

select * from tb_procedimento where fk_atendimento = 18039861


