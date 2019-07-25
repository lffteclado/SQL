select entidade.sigla,
       atendimento.ano_atendimento,
       atendimento.numero_atendimento_automatico,
	   atendimento.data_cadastro,
	   atendimento.data_ultima_alteracao,
       situacaoProcedimento.digitado,
       situacaoProcedimento.repassado,
	   situacaoProcedimento.valorDigitado,
	   situacaoProcedimento.valorRepassado
from rl_situacao_procedimento situacaoProcedimento
inner join tb_procedimento procedimento on situacaoProcedimento.fk_procedimento = procedimento.id and procedimento.registro_ativo = 1
inner join tb_atendimento atendimento on atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1
inner join tb_entidade entidade on entidade.id = atendimento.fk_entidade and entidade.registro_ativo = 1
where --atendimento.fk_entidade = 43
	  --and atendimento.ano_atendimento = 2019
      situacaoProcedimento.digitado <> 0
	  and situacaoProcedimento.repassado <> 0
	  and situacaoProcedimento.valorDigitado <> 0
	  and situacaoProcedimento.valorRepassado <> 0
order by atendimento.data_cadastro desc