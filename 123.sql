select * from tb_entidade where sigla like '%UNICOOPER%' -- 43

select * from tb_tabela_tiss where id in (

	select fk_grau_participacao from rl_entidade_grau_participacao where fk_entidade = 43 and registro_ativo = 1

)
select * from tb_tabela_tiss where descricao like '%Clinico%'


fk_entidade
REFERENCES sasc_producao_desenv.dbo.tb_entidade (id)
fk_usuario_ultima_alteracao
REFERENCES sasc_producao_desenv.dbo.tb_usuario (id)
fk_grau_participacao
REFERENCES sasc_producao_desenv.dbo.tb_tabela_tiss (id)