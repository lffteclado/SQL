select * from tb_entidade where sigla like '%UNICOOPER%' --43
 
select * from rl_entidade_cooperado_conversao where fk_entidade = 43 and fk_cooperado_origem = 24959

select * from rl_entidade_cooperado_conversao where fk_entidade = 43 and fk_cooperado_destino = 14441

select sum(valor_lancamento) from rl_repasse_lancamento where fk_entidade = 43 and fk_repasse = 11514 and fk_cooperado_lancamento = 14441 and registro_ativo = 1

select * from rl_repasse_lancamento where fk_entidade = 43 and fk_repasse = 11514 and fk_cooperado_lancamento = 1621 and registro_ativo = 1


-- fk_entidade = 43 and fk_repasse = 11514 and

select * from tb_pagamento_procedimento where id = 67570332

select * from tb_procedimento where id = 18571328

select top 10 * from tb_repasse where fk_entidade = 43 and registro_ativo = 1  order by id desc

-- Laura de Araújo Porto

select * from tb_cooperado where nome like '%Christiane Virginia Dias Soria%' and numero_conselho = '44337'

select * from rl_repasse_lancamento
         where fk_cooperado_lancamento = 1621
         and registro_ativo = 1 and fk_entidade = 43
		 and data_ultima_alteracao > '2019-08-01 00:00:00.0000000' -- and fk_repasse = 11514

select * from tb_cooperado where nome like '%Laura de Araújo Porto%' and numero_conselho = '43843'

select * from rl_repasse_lancamento
         where fk_cooperado_lancamento = 6969
         and registro_ativo = 1 and fk_entidade = 43
		 and data_ultima_alteracao > '2019-08-01 00:00:00.0000000' -- and fk_repasse = 11514

select * from tb_cooperado where nome like '%Amanda Silva Passarella Falci%' --24342

select * from rl_repasse_lancamento
         where fk_cooperado_lancamento = 24342
         and registro_ativo = 1 and fk_entidade = 43 order by id desc and fk_repasse = 11514

select * from tb_repasse where id in (
10225
,9339
,9302
,9283
,8775
)

select * from tb_cooperado where id = 14441

select * from rl_entidade_cooperado where fk_cooperado = 24959 and fk_entidade = 43

select * from tb_repasse where id = 11514

select * from tb_repasse where id = 11420

select getdate()

and repasse.numero_repasse = 1644 and cooperadoPJ.nome = 'Geromater - Serviços Médicos Ltda'