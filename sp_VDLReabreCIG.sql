--CREATE PROCEDURE sp_VDLReabreCIG 
	@NumeroCIG numeric(6)
AS
BEGIN TRANSACTION

UPDATE tbCIGVeiculo SET DataEnvioFabrica = NULL, 
						EnviadoFabrica = 'F' 
WHERE NumeroCIG = @NumeroCIG

COMMIT TRANSACTION

SELECT DataEnvioFabrica,EnviadoFabrica,NumeroCIG,CodigoCliFor
FROM tbCIGVeiculo WHERE NumeroCIG = @NumeroCIG

