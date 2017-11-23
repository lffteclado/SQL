CREATE PROCEDURE sp_vdl_di

--sp_vdl_di 'CodigoPlano','V ou F'

		@CodigoEmpresa NUMERIC(4),
		@CodigoPlanoPagamento CHAR(4),   
		@DescontoInvisivelPlanoPagto CHAR(1) = 'F'
	AS
		BEGIN TRANSACTION
			IF(@CodigoEmpresa = 1200)
				BEGIN
					UPDATE dbAutosete.dbo.tbPlanoPagamento
					SET DescontoInvisivelPlanoPagto = @DescontoInvisivelPlanoPagto
					WHERE CodigoPlanoPagamento = @CodigoPlanoPagamento
				END
		COMMIT TRANSACTION