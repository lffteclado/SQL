select * from tb_convenio where sigla = 'ABERTTASAUDE' --2

select * from tb_entidade where sigla = 'GINECOOP' --6

select versao_tiss, * from rl_entidade_convenio where fk_convenio = 2 and fk_entidade = 6