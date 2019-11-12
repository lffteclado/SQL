-- Verificar registros que est�o como N�O sinconizados e comparar no web
-- Rodar no Sasc_novo                                                       
select * from tb_data_sync_inss WHERE  exists(
select id from tb_declaracao_inss where tb_data_sync_inss.fk_declaracao_inss=id and registro_ativo=1
)
AND processado_web=0

--Verificar quais s�o do nosso sistema
-- Rodar no Sasc_novo

select * from tb_declaracao_inss where id in(
select distinct fk_declaracao_inss from tb_data_sync_inss WHERE  exists(
select id from tb_declaracao_inss where tb_data_sync_inss.fk_declaracao_inss=id and registro_ativo=1
)
AND processado_web=0)


--Pegar os id do sasc e comparar no web para ver quais j� foram sincronizados
--Rodar no Sasf_Pessoa
SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (8315326,
8315327,
8315328,
8315329,
8315330

) AND codidesis=9



--Apos verificar l�, os que j� estiverem atualizar para processados
-- Rodar no Sasc_novo
update tb_data_sync_inss set processado_web=1 WHERE  exists(
select id from tb_declaracao_inss where tb_data_sync_inss.fk_declaracao_inss=id and registro_ativo=1
)
AND processado_web=0

--Atualizar a tabela
-- Rodar no Sasc_novo
--delete from tb_total_inss_cooperado where year(mes_ano)=2019