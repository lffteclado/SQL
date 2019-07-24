select * from tb_entidade where sigla like '%COOPIMIMG%'

select sigla, * from tb_convenio where sigla like '%S.BRADESCO%'

select * from tb_espelho where numero_espelho = 26753 and fk_entidade = 2

select * from tb_endereco where fk_entidade = 2 and discriminator = 'Convenio' and fk_tipo_endereco is null

select fk_tipo_endereco, * from tb_endereco where fk_convenio = 503 

select * from tb_cidade where id = 2573

select * from tb_tipo_endereco --1


(select descricao_cidade_temp from tb_endereco where fk_entidade = 2 and discriminator = 'Entidade' )

select * from tb_procedimento where fk_atendimento = 17125969

select * from tb_atendimento where numero_atendimento_automatico = 39093 and fk_entidade = 2

select top 100 * from tb_glosa where fk_procedimento = 24927700

select * from tb_atendimento where senha = 'K1DZA60' -- 17125969

select * from tb_espelho where id = 555498

select * from tb_correspondencia_endereco where discriminator = 'EntidadeConvenio' AND fk_entidade_convenio in (823, 886)

select * from rl_entidade_convenio where fk_entidade = 2 and fk_convenio = 270 -- 886

select * from rl_entidade_convenio where fk_entidade = 2 and fk_convenio = 2 -- 823

select * from rl_entidade_convenio where id = 886

select sigla, * from tb_convenio where sigla like '%PMMG/IPSM%' --270

select sigla, * from tb_convenio where sigla like '%ABERTTA%' -- 2

select in_endereco_correspondencia, * from tb_endereco where fk_convenio = 814

select in_endereco_correspondencia, * from tb_endereco where id = 412

select * from rl_entidade_convenio where id = 886

select * from tb_correspondencia_endereco where fk_entidade_convenio = 886
