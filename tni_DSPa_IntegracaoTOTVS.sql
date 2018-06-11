if object_id('tni_DSPa_IntegracaoTOTVS') is not null
	drop trigger dbo.tni_DSPa_IntegracaoTOTVS
go
create trigger dbo.tni_DSPa_IntegracaoTOTVS on tbIntegracaoTOTVS
for insert as
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Caixa
 AUTOR........: Luis Carlos
 DATA.........: 25/10/2000
 UTILIZADO EM : tni_DSPa_IntegracaoTOTVS 
 OBJETIVO.....: Ao inserir registro na tbIntegracaoTOTVS dispara trigger acima que executa esta SP

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
begin


	--===================================================================================================
	-- Reagenda processo EDI para envio dos dados ao TOTVS
	-----------------------------------------------------------------------------------------------------
	declare
		@DataAlvo datetime,
		@HoraFormatada dtHora,
		@TempoLimite numeric(3,2)

	select @TempoLimite = 2
	select @DataAlvo = dateadd(minute,@TempoLimite,getdate())
	select @HoraFormatada = datepart(hour,@DataAlvo) + convert(numeric(5,2),datepart(minute,@DataAlvo))/100

	update tbEDIATProcesso
	set HorarioProcessoAT = @HoraFormatada
	from inserted i
	where
		tbEDIATProcesso.CodigoProcessoEDI = 19
	and tbEDIATProcesso.CodigoEmpresa = i.CodigoEmpresa
	and tbEDIATProcesso.CodigoLocal = i.CodigoLocal
	and ( tbEDIATProcesso.HorarioProcessoAT <= @HoraFormatada - (@TempoLimite/100) or
	      tbEDIATProcesso.HorarioProcessoAT >  @HoraFormatada + (@TempoLimite/100) )

	return

end
go
