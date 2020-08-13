

select * from rl_repasse_credito where fk_cooperado in (18555, 18438, 12047) and fk_repasse in (
 select id from tb_repasse where numero_repasse = 1887 and fk_entidade in (Select id from tb_entidade where sigla = 'COOPANEST')
)


0 --Banco do Brasil
26 -- Unibanco
30 -- Bilbao
33 -- Bancoob

select * from tb_banco where id in (0, 26,30,33)




18438 Clinica de Anestesia Ltda. Bancoob
18555 SABINEST - CLINICA MEDICA DE ANESTESIOLOGISTAS HOSPITAL ALBERT SABIN LTDA - EPP Banco do Brasil
12047 Sanest - Serviço de Anestesiologia Medica - EPP Bancoob
