update tb_atendimento
 set   tb_atendimento.senha = planilha.senha,
 sql_update = ISNULL(atendimento.sql_update,'')+'0919-000547'
from tb_procedimento procedimento 
inner join tb_glosa glosa with(nolock) on (procedimento.id = glosa.fk_procedimento and procedimento.registro_ativo = 1 and glosa.registro_ativo = 1)
inner join tb_carta_glosa cartaGlosa with(nolock) on (glosa.fk_carta_glosa = cartaGlosa.id and cartaGlosa.registro_ativo = 1)
inner join tb_atendimento atendimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
cross apply (

select carta as carta,
       atendimento as atendimento,
	   procedimento_correto as procedimento,
	   valor_correto as valor,
	   senha as senha
from dbo.[0919_000547] pla
where pla.Atendimento = atendimento.numero_atendimento_automatico and pla.Carta = cartaGlosa.numero_carta

)as planilha
where cartaGlosa.numero_carta in (select Carta from dbo.[0919_000547]) and atendimento.numero_atendimento_automatico in (select Atendimento from dbo.[0919_000547])