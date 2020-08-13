/*select * from tb_entidade where sigla = 'COOPMEDRS' -- 63 Id da Cooperativa
select * from tb_repasse where numero_repasse = 377 and fk_entidade = 63 -- 18714 Id do Repasse

select * from tb_cooperado
 where nome = 'Poglia e Poitevin Servicos Medicos S/S Ltda'
 and cpf_cnpj = '23879013000188' -- 26121 Id do Cooperado

select * from tb_cooperado
 where nome = 'Barbara Schneider Eisele'
 and cpf_cnpj = '00967812038' -- 28072 Id do Cooperado

select * from rl_repasse_credito
 where fk_repasse = 18714
 and fk_cooperado in (26121, 28072)
 and valor_credito in (77.45,  4555.35) -- Ids repasse Credito 2154453, 2154513*/

/* Alterando o repasse para NÃO enviar os Cooperados no Repasse - So vale para repasses com dados historicos */

update rl_repasse_credito set nao_enviar_cooperado_cnab = 1,
                              sql_update = isnull(sql_update, '')+'#0720-000439'
where id in (2154453, 2154513)


