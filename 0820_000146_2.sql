select * from rl_entidade_cooperado_conversao
 where registro_ativo = 1
 and fk_entidade = 23
 and fk_cooperado_destino in (select id from tb_cooperado where nome = 'Leandro Gomes Bittencourt ME')
 and fk_cooperado_origem in (select id from tb_cooperado where nome = 'Leandro Gomes Bittencourt')

sp_helpText separarEDesconverterProcedimentosGlosados

--exec separarEDesconverterProcedimentosGlosados 6471
--GO
--exec separarEDesconverterProcedimentosGlosados 6467

entidadeCooperadoConversao.data_inicial (01/01/2019) <= procedimento.data_realizacao (12/04/2019) and entidadeCooperadoConversao.data_final is null

procedimento.data_realizacao between entidadeCooperadoConversao.data_inicial and entidadeCooperadoConversao.data_final
12/04/2019 -> 01/01/2019 e 31/03/2019


select * from tb_cooperado where nome like 'Matheus Leandro Lana D%'

select * from tb_atendimento
 where numero_atendimento_automatico = 134978  and ano_atendimento = '2020'
 and fk_entidade = 23
 and registro_ativo = 1

 select fk_cooperado_executante_complemento, fk_cooperado_recebedor_cobranca, * from tb_procedimento where fk_atendimento = 26848374

 select * from rl_situacao_procedimento where fk_procedimento in (
 select id from tb_procedimento where fk_atendimento = 19573112
 )

 select * from tb_glosa where fk_procedimento = 28718347

--DEVIDA("Devida", "2"),
--RECEBIDA("Recebida", "4"),

select valor_total from tb_procedimento where fk_atendimento = 19573112

--Claudia Leal Ferreira H / Luiza Samarane Garreto / Marcella Carmem Silva R. / Nathalia Vasconcelos C. / Matheus Leandro Lana D.

select id from tb_cooperado where nome in (
'Andreia Santos Cardoso ME'
,'Bruno de Oliveira Matos ME'
,'Claudia Leal Ferreira Horiguchi ME'
,'Elisa Duarte Candido ME'
,'Fernanda Vilela Dias ME'
,'Leandro Gomes Bittencourt ME'
,'Lucas Rodrigues de Castro ME'
,'Luiza Samarane Garretto ME'
,'Marcella Carmem Silva Reginaldo ME'
,'Matheus Leandro Lana Diniz ME'
,'Nathalia Vasconcelos Ciotto ME'
,'Paula de Siqueira Ramos ME'

)