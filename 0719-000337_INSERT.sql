select * from tb_de_para_especialidade_codigo_atuacao where lower(descricao) like lower('%Médico em cirurgia vascular%') 

select * from tb_especialidade_codigo_atuacao
select * from tb_de_para_especialidade_codigo_atuacao

--insert into tb_de_para_especialidade_codigo_atuacao (sql_update,
                                                     data_ultima_alteracao,
													 registro_ativo,
													 codigo,
													 descricao,
													 fk_usuario_ultima_alteracao,
													 fk_convenio,
													 fk_tabela_tiss)
					       					  select '#0719-000337' as sql_update,
											         GETDATE() as data_ultima_alteracao,
													 1 as registro_ativo,
													 codigo,
													 especialidade as descricao,
													 1 as fk_usuario_ultima_alteracao,
													 270 as fk_convenio,
													 fk_tabela_tiss
											  from tb_especialidade_codigo_atuacao