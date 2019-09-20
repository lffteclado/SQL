-- 1º Passo. Olhar o que tem no data sync para sincronizar e que esteja no tb_declaracao_inss como ativo

select *from tb_declaracao_inss where id in(
select fk_declaracao_inss from tb_data_sync_inss where  processado_web = 0 and fk_declaracao_inss in(
select id from tb_declaracao_inss where registro_ativo = 1)) and sistema_origem_dados=1

-- 2º Passo. Verificar se ja tem no Sasc Web.  e upatar aqueles que já estão.
