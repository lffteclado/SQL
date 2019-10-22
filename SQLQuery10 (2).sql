update tb_glosa
 set valor_honorario = planilha.valor,
     sql_update = ISNULL(glosa.sql_update,'')+'0919-000547'
from tb_procedimento procedimento 
inner join tb_glosa glosa with(nolock) on (procedimento.id = glosa.fk_procedimento and procedimento.registro_ativo = 1 and glosa.registro_ativo = 1)
inner join tb_carta_glosa cartaGlosa with(nolock) on (glosa.fk_carta_glosa = cartaGlosa.id and cartaGlosa.registro_ativo = 1)
inner join tb_atendimento atendimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
cross apply (

select valor_correto as valor
from dbo.[0919_000547] pla
where pla.Atendimento = atendimento.numero_atendimento_automatico and pla.carta = cartaGlosa.numero_carta 

)as planilha
where cartaGlosa.numero_carta in (select carta from dbo.[0919_000547]) and atendimento.numero_atendimento_automatico in (select atendimento from dbo.[0919_000547])
and glosa.valor_honorario >= planilha.valor