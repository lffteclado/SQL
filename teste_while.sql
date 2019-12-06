
BEGIN
    WHILE EXISTS(SELECT 1 FROM ##tempProcedimento WHERE finalizado = 0)
		BEGIN
		
			DECLARE @idProcedimento BIGINT = (select top 1 id_procedimento from ##tempProcedimento where finalizado = 0);
			DECLARE @idAtendimentoGlosa BIGINT = (select top 1 atendimento.id from tb_atendimento atendimento
										inner join tb_procedimento procedimento on(procedimento.fk_atendimento = atendimento.id)
										where procedimento.id =  @idProcedimento
									  );


			DECLARE @RC int
			DECLARE @idEspelho bigint
			DECLARE @idAtendimento bigint = 19029526
			DECLARE @idCartaDeGlosa bigint
			DECLARE @usuario bigint = 1

			EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
			@idEspelho
			,@idAtendimento
			,@idCartaDeGlosa
			,@usuario

			UPDATE ##tempProcedimento
				SET finalizado = 1
			where id_procedimento = @idProcedimento

		END;
END;




--select count(*) as totalRegistros from ##tempProcedimento

--select * from ##tempProcedimento
--UPDATE ##tempProcedimento SET finalizado = 0