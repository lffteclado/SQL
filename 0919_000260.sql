UPDATE dados  SET dados.registro_ativo=0, dados.sql_update = ISNULL(dados.sql_update,'') + ' #Duplicado20092019'  
from tb_dados_complementares  dados
inner join tb_atendimento atendimento 
	on (atendimento.id = dados.fk_atendimento and atendimento.registro_ativo = 1)
WHERE dados.id IN (
                SELECT id
                FROM tb_dados_complementares dadosComplementares
                WHERE dadosComplementares.registro_ativo=1
					AND EXISTS (
                                SELECT dadosComplementares2.fk_atendimento
                                FROM tb_dados_complementares dadosComplementares2
                                WHERE dadosComplementares.fk_atendimento = dadosComplementares2.fk_atendimento
										AND dadosComplementares2.registro_ativo=1
                                        AND dadosComplementares.id <> (
                                                SELECT TOP 1 id
                                                FROM tb_dados_complementares
                                                WHERE fk_atendimento = dadosComplementares2.fk_atendimento
												AND registro_ativo=1
                                                ORDER BY id DESC
                                                )
                                GROUP BY dadosComplementares2.fk_atendimento
                                HAVING count(*) > 1
                                )
                )
AND dados.registro_ativo=1
AND atendimento.situacaoAtendimento <> 6
and atendimento.autorizado_unimed = 1
