select cartaGlosa.numero_carta,
	   procedimento.fk_grau_participacao,
       tabelaTiss.descricao,
	   atendimento.id,
	   atendimento.senha,
	   procedimento.id
from tb_carta_glosa cartaGlosa
inner join tb_glosa glosa with(nolock) on (glosa.fk_carta_glosa = cartaGlosa.id and glosa.registro_ativo = 1 and cartaGlosa.registro_ativo = 1)
inner join tb_procedimento procedimento with(nolock) on (procedimento.id = glosa.fk_procedimento and procedimento.registro_ativo = 1)
inner join rl_entidade_grau_participacao grauParticipacao with(nolock) on (grauParticipacao.id = procedimento.fk_grau_participacao and grauParticipacao.registro_ativo = 1)
inner join tb_tabela_tiss tabelaTiss with(nolock) on (tabelaTiss.id = grauParticipacao.fk_grau_participacao)
inner join tb_atendimento atendimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
where cartaGlosa.fk_entidade = 43 and cartaGlosa.numero_carta in (
70841
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70842
,70844
,70844
,70844
,70844
,70858
,70858
,70858
,70858
,70858
,70858
,70858
,70858
,70862
,70862
,70862
,70862
,70862
,70862
,70862
,70859
,70859
,70859
,70859
,70859
,70859
,70859
,70859
,70859
,70859
,70859
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70860
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70861
,70863
,70863
,70863
,70863
,70863
,70863
,70863
,70863
,70865
,70865
,70865
,70865
,70865
) order by cartaGlosa.numero_carta

--895 Clínico
--43 Cirurgião
