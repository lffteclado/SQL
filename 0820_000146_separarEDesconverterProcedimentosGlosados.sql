/*
select * from rl_entidade_cooperado_conversao
 where registro_ativo = 1
 and fk_entidade = 23
 and fk_cooperado_destino in (select id from tb_cooperado where nome = 'Paula de Siqueira Ramos ME')
 and fk_cooperado_origem in (select id from tb_cooperado where nome = 'Paula de Siqueira Ramos')

Andreia Santos Cardoso - Andreia Santos Cardoso ME -- 6467
Bruno de Oliveira Matos - Bruno de Oliveira Matos ME -- 6397
Claudia Leal Ferreira H. - Claudia Leal Ferreira Horiguchi ME -- 6465
Elisa Duarte Candido - Elisa Duarte Candido ME --6464
Fernanda Vilela Dias - Fernanda Vilela Dias ME -- 6469
Leandro Gomes Bittencourt - Leandro Gomes Bittencourt ME -- 6471
Lucas Rodrigues de Castro - Lucas Rodrigues de Castro ME -- 6468
Luiza Samarane Garreto - Luiza Samarane Garretto ME -- 6466
Marcella Carmem Silva R. - Marcella Carmem Silva Reginaldo ME -- 6451
Matheus Leandro Lana D. - Matheus Leandro Lana Diniz ME -- 6470
Nathalia Vasconcelos C. - Nathalia Vasconcelos Ciotto ME -- 6413
Paula de Siqueira Ramos - Paula de Siqueira Ramos ME -- 6414
*/

GO
exec separarEDesconverterProcedimentosGlosados 6467
GO
exec separarEDesconverterProcedimentosGlosados 6397
GO
exec separarEDesconverterProcedimentosGlosados 6465
GO
exec separarEDesconverterProcedimentosGlosados 6464
GO
exec separarEDesconverterProcedimentosGlosados 6469
GO
exec separarEDesconverterProcedimentosGlosados 6471
GO
exec separarEDesconverterProcedimentosGlosados 6468
GO
exec separarEDesconverterProcedimentosGlosados 6466
GO
exec separarEDesconverterProcedimentosGlosados 6451
GO
exec separarEDesconverterProcedimentosGlosados 6470
GO
exec separarEDesconverterProcedimentosGlosados 6413
GO
exec separarEDesconverterProcedimentosGlosados 6414
GO