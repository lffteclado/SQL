IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('retornaAtendimentosInconsistentesPorEspelho'))
BEGIN
	DROP FUNCTION [dbo].retornaAtendimentosInconsistentesPorEspelho
END
GO
CREATE FUNCTION [dbo].retornaAtendimentosInconsistentesPorEspelho(@idEspelho AS INT)   
RETURNS TABLE   
AS   
RETURN   
(select stuff((  
(SELECT ', ' + CAST(atendimento.numero_atendimento_automatico AS VARCHAR(255))
FROM tb_procedimento procedimento WITH(NOLOCK)
INNER JOIN tb_atendimento atendimento WITH(NOLOCK) ON(atendimento.id=procedimento.fk_atendimento AND procedimento.registro_ativo = 1 AND atendimento.registro_ativo = 1)
INNER JOIN tb_cooperado exe WITH(NOLOCK) ON(exe.id=procedimento.fk_cooperado_executante_complemento AND exe.registro_ativo = 1)
INNER JOIN tb_cooperado rec WITH(NOLOCK) ON(rec.id=procedimento.fk_cooperado_recebedor_cobranca AND rec.registro_ativo = 1)
INNER JOIN tb_espelho esp WITH(NOLOCK) ON(esp.id=atendimento.fk_espelho AND esp.registro_ativo = 1)
WHERE atendimento.fk_espelho = @idEspelho and exe.id <> rec.id and rec.discriminator='pf'
group by atendimento.numero_atendimento_automatico order by atendimento.numero_atendimento_automatico 
FOR XML PATH (''))),1,1,'') as campo
) 

