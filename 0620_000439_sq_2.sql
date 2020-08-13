update tb_atendimento set numero_guia = convert(nvarchar(255), alterar.numero_guia_novo),
						  sql_update = ISNULL(sql_update,'')+'#0620-000439'
from tb_atendimento atendimento
cross apply(
 select distinct idAtendimento, numero_guia_novo from tb_dados_alterar
)alterar
where atendimento.id = alterar.idAtendimento

go

update tb_procedimento set data_realizacao = alterar.data_realizacao_novo,
                           data_inicio = alterar.data_realizacao_novo,
						   data_fim = alterar.data_realizacao_novo,
                           sql_update = ISNULL(sql_update,'')+'#0620-000439'
from tb_procedimento procedimento
cross apply(
	select distinct idProcedimento, data_realizacao_novo from tb_dados_alterar
)alterar
where alterar.idProcedimento = procedimento.id

go

drop table tb_dados_alterar



