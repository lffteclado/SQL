select * from tb_pagamento_fatura where fk_fatura in(
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = 14393564
	)and registro_ativo = 1	
)

select * from tb_fatura where id in (
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = 14393564
	)and registro_ativo = 1
)

select digitado, repassado, valorDigitado, valorRepassado, * from rl_situacao_procedimento where fk_procedimento in(
	select id from tb_procedimento where fk_atendimento = 13980616
)

delete from rl_situacao_procedimento where fk_procedimento in(
	select id from tb_procedimento where fk_atendimento = 14393564
)

GO

DECLARE @RC int
DECLARE @idEspelho bigint
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint

SET @idAtendimento = 14393564
SET @usuario = 1
-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario

GO

update tb_procedimento set resolveu_dependencia = resolveu_dependencia where fk_atendimento = 14393564

GO

update tb_pagamento_procedimento set resolveu_dependencia = resolveu_dependencia where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = 14393564
)

GO

update tb_fatura set resolveu_dependencia = resolveu_dependencia where id in (
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = 14393564
	)and registro_ativo = 1
)

GO

update tb_pagamento_fatura set resolveu_dependencia = resolveu_dependencia where fk_fatura in(
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = 14393564
	)and registro_ativo = 1	
)

GO

update tb_glosa set resolveu_dependencia = resolveu_dependencia
where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
			select  id from tb_atendimento where id = 14393564
		) and registro_ativo = 1
)

GO

select digitado, repassado, valorDigitado, valorRepassado, * from rl_situacao_procedimento where fk_procedimento in(
	select id from tb_procedimento where fk_atendimento = 14393564
)


