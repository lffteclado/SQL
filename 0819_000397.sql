select * from tb_de_para_especialidade_codigo_atuacao

select * from tb_de_para_especialidade_codigo_atuacao

select * from rl_entidade_grau_participacao where fk_entidade = 2 and registro_ativo = 1

select top 10 * from tb_procedimento

select * from tb_atendimento where ano_atendimento = 2019 and numero_atendimento_automatico = 74105 and fk_entidade = 2

select * from tb_tabela_tiss_tipo_guia_temp where id = 110681

select fk_grau_participacao * from tb_procedimento where fk_atendimento = 19122283

select * from rl_entidade_grau_participacao where id = 854 

select * from tb_tabela_tiss where id = 109929

select * from tb_tabela_tiss where id in (

select fk_grau_participacao from rl_entidade_grau_participacao where fk_entidade = 2 and registro_ativo = 1

) order by descricao --descricao like '%Pediatra sala de parto%'
--union all
--select * from tb_tabela_tiss where descricao like '%Coordenação%'


select * from tb_tabela_tiss where id in (
select fk_tabela_tiss from tb_de_para_especialidade_codigo_atuacao
)

select * from tb_tabela_tiss where descricao like '%Coordenação%'


select * from tb_tabela_tiss where descricao in(
'Anestesista'
,'Auxiliar de Anestesista'
,'Auxiliar SADT'
,'Cirurgião'
,'Clínico'
,'Consultor'
,'Instrumentador'
,'Intensivista'
,'Pediatra na sala de parto'
,'Pediatra no berçario'
,'Perfusionista'
,'Primeiro Auxiliar'
,'Quarto Auxiliar'
,'Segundo Auxiliar'
,'Terceiro Auxiliar') order by descricao

select getdate()



select * from sysobjects where name like '%guia%'