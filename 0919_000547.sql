select procedimento.id,
       cartaGlosa.numero_carta,
	   atendimento.numero_atendimento_automatico,
	   atendimento.senha,
	   procedimento.valor_honorario,
	   procedimento.fk_item_despesa,
	   planilha.carta,
	   planilha.atendimento,
	   planilha.procedimento,
	   planilha.valor,
	   planilha.senha
from tb_procedimento procedimento 
inner join tb_glosa glosa with(nolock) on (procedimento.id = glosa.fk_procedimento and procedimento.registro_ativo = 1 and glosa.registro_ativo = 1)
inner join tb_carta_glosa cartaGlosa with(nolock) on (glosa.fk_carta_glosa = cartaGlosa.id and cartaGlosa.registro_ativo = 1)
inner join tb_atendimento atendimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
cross apply (

select Carta as carta,
       Atendimento as atendimento,
	   [PROCEDIMENTO A CONSTAR] as procedimento,
	   [VALOR A CONSTAR] as valor,
	   [Senha] as senha
from dbo.[0919_000547] pla
where pla.Atendimento = atendimento.numero_atendimento_automatico and pla.Carta = cartaGlosa.numero_carta

)as planilha
where cartaGlosa.numero_carta in (select Carta from dbo.[0919_000547]) and atendimento.numero_atendimento_automatico in (select Atendimento from dbo.[0919_000547])


--select * from sysobjects where name like '%00547%'

--update dbo.[0919_000547] set [Senha] = 1509063319 where [Atendimento] = 139472 and [Cooperado] = 'Juliana Soares Cunha'

--select * from dbo.[0919_000547]

--drop table dbo.[0919_000547]

