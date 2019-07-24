--  Retornar o atendimento 14555
	GO
	UPDATE tb_atendimento
	SET situacaoAtendimento = 0,
    sql_update = ISNULL(sql_update,'')+'#0419-000028' 
	WHERE id = 16401442
	GO
	DELETE FROM rl_atendimento_motivo_exclusao WHERE fk_atendimento = 16401442