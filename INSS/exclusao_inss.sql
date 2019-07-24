-- 1� Passo verificar se a declara��o foi feita no sasc.

select nome, numero_conselho, * from tb_cooperado
 where nome like '%Bruna Salgado Rabelo%' and numero_conselho = '66659'  --29330

select sigla, * from tb_entidade where sigla like 'ONCOOP%' --7

select sistema_origem_dados, id, data, * from tb_declaracao_inss
where fk_cooperado = 19467 and data >= '2019-05-04' and fk_entidade = 7
 and registro_ativo = 1 and cnpj = 17689407000170 and sistema_origem_dados = 1


-- Se as declara��es conter no campo sistema_origem_dados o valor 1 poder� ser exclu�da, po�s a declara��o foi feita pelo sistema

-- 2� Passo. Criar o select de dele��o da declara��o no sasc no banco SASF_Pessoa. (Sasc antigo)
-- No campo codsascjava vai o id da declara��o pesquisada acima. 
-- Enviar o script de dele��o ao suporte TI
	
select * from AD_Recolhimento_INSS where codsascjava in (
-- ID 
) and codidesis=9

delete from AD_Recolhimento_INSS where codsascjava in (
-- ID
) and codidesis=9

-- 3� Passo. Quando o suporte TI retornar o chamado com a exclus�o das declara��o no Sasc antigo, realizar a atualiza��o no banco Sasc.

/*
Update tb_declaracao_inss set sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000341' where id in(
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
)
                                                             
delete from  tb_data_sync_inss  where fk_declaracao_inss in(
--ID
)
and processado_web=0

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 and fk_cooperado = --FK DO COOPERADO


-- 1� Passo verificar se a declara��o foi feita no sasc .

select * from tb_cooperado where nome = 'NOME DO COOPERADO'

select sistema_origem_dados, id, * from tb_declaracao_inss
where fk_cooperado = --id cooperado
where data > 'yyyy-MM-dd' 

-- Se as declara��es conter no campo sistema_origem_dados o valor 1 poder� ser exclu�da, po�s a declara��o foi feita pelo sistema

-- 2� Passo. Criar o select de dele��o da declara��o no sasc no banco SASF_Pessoa. (Sasc antigo)
-- No campo codsascjava vai o id da declara��o pesquisada acima. 
-- Enviar o script de dele��o ao suporte TI
	
select * from AD_Recolhimento_INSS where codsascjava in (
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739  
) and codidesis=9

delete from AD_Recolhimento_INSS where codsascjava in (
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
) and codidesis=9

-- 3� Passo. Quando o suporte TI retornar o chamado com a exclus�o das declara��o no Sasc antigo, realizar a atualiza��o no banco Sasc.


Update tb_declaracao_inss set sincronizar=0,registro_ativo=0, sql_update='#NUMERO DO CHAMADO' where id in(
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
)
                                                             
delete from  tb_data_sync_inss  where fk_declaracao_inss in(
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
)
and processado_web=0

DELETE
select * FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 and fk_cooperado = 23286