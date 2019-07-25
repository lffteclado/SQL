select  * from tb_atendimento where id = 14393573

select * from tb_procedimento where fk_atendimento = (
	select  id from tb_atendimento where id = 14393573
) and registro_ativo = 1

select fk_fatura,fk_procedimento,* from tb_pagamento_procedimento where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1
) and registro_ativo = 1

select fk_procedimento,* from tb_glosa where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1
) and registro_ativo = 1


select * from rl_situacao_procedimento where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1
)



-- Segue script de correção da situação do atendimento. Pagamento do procedimento não tem fk_fatura, portanto a situação 'P(pago)' estava incorreto.
-- Atendimento só contém espelho. Não houve glosa para o atendimento.
delete from rl_situacao_procedimento where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1
)

update tb_procedimento set resolveu_dependencia = resolveu_dependencia where id in (

	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1
)



update tb_pagamento_procedimento set resolveu_dependencia = resolveu_dependencia where fk_procedimento in (

	select id from tb_procedimento where fk_atendimento = (
		select  id from tb_atendimento where id = 14393573
	) and registro_ativo = 1

)

update tb_fatura set resolveu_dependencia = resolveu_dependencia where id in (
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = (
			select  id from tb_atendimento where id = 14393573
		) and registro_ativo = 1
	) and registro_ativo = 1
)

update tb_pagamento_fatura set resolveu_dependencia = resolveu_dependencia where fk_fatura in (
	select fk_fatura from tb_pagamento_procedimento where fk_procedimento in (
		select id from tb_procedimento where fk_atendimento = (
			select  id from tb_atendimento where id = 14393573
		) and registro_ativo = 1
	) and registro_ativo = 1
)


update tb_glosa set resolveu_dependencia = resolveu_dependencia
where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento = (
			select  id from tb_atendimento where id = 14393565
		) and registro_ativo = 1
)

DECLARE @RC int
DECLARE @idEspelho bigint
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint

SET @idAtendimento = 14393573
SET @usuario = 1
-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO