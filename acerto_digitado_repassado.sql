/*
select * from rl_entidade_importacao_unimed where fk_entidade = 14 and fk_fatura in (
select id from tb_fatura where numero_fatura = 38513 and fk_entidade = 14
)*/

--select valor_total, valor_desconto_manual, * from tb_fatura where numero_fatura = 38473 and fk_entidade = 14

select ID, sigla from tb_entidade where sigla like '%UNICOOPER%'

select * from tb_atendimento where numero_atendimento_automatico = 28503 and ano_atendimento = 2019 and fk_entidade = 43

select valorDigitados, valorRepassados, * from tb_atendimento where valorDigitados is not null and valorRepassados is not null

select valorRepassado, valorDigitado, * from rl_situacao_procedimento where valorRepassado <> 0.00 and valorDigitado <> 0.00

select valorRepassado, valorDigitado, repassado, digitado, * from rl_situacao_procedimento where repassado = 1 and digitado = 1

select * from tb_procedimento where fk_atendimento = 14403284

select fk_fatura, * from tb_pagamento_procedimento where fk_procedimento in (
select id from tb_procedimento where fk_atendimento = 14403284
)and registro_ativo = 1

select * from tb_procedimento where id = 20879715

select * from tb_espelho where numero_espelho = 112551

select * from tb_fatura where id = 91053

/*
tb_procedimento
tb_pagamento_procedimento
tb_fatura
tb_pagamento_fatura
tb_glosa

*/

/*
update tb_procedimento set resolveu_dependencia = resolveu_dependencia where fk_atendimento = 14403284
GO
update tb_pagamento_procedimento set resolveu_dependencia = resolveu_dependencia where fk_procedimento in (
select id from tb_procedimento where fk_atendimento = 14403284) */

/*
update tb_pagamento_procedimento set registro_ativo = 0 where fk_procedimento in (
select id from tb_procedimento where fk_atendimento = 14403284)*/

--update tb_pagamento_fatura set resolveu_dependencia = resolveu_dependencia where 


select top 10 * from tb_pagamento_procedimento

select digitado, repassado, valorDigitado, valorRepassado, * from rl_situacao_procedimento where fk_procedimento in(
select id from tb_procedimento where fk_atendimento = 14403284)

select * from tb_pagamento_fatura 

