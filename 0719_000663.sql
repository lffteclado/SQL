select espelho.id,
       espelho.numero_espelho,
       espelho.valor_liquido,
	   convenio.sigla
from tb_espelho espelho
	inner join rl_entidade_convenio entidadeConvenio on (entidadeConvenio.id = espelho.fk_entidade_convenio and entidadeConvenio.registro_ativo = 1 and espelho.registro_ativo = 1)
	inner join tb_convenio convenio on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
 where espelho.numero_espelho in (
18996
,18259 
,18063 
,17947 
,17677 
,17547 
,17475 
,17154 
,16490 
,16448 
,16402 
,16319 
,16272 
,16137 
,15507 
,15031 
)and entidadeConvenio.fk_entidade in (select id from tb_entidade where sigla like '%GINECOOP%') order by convenio.sigla, espelho.numero_espelho

select * from rl_entidade_convenio where id = 229
select * from tb_convenio where id = 206

select * from tb_pagamento_procedimento where fk_procedimento in (
	select id from tb_procedimento where fk_atendimento in ( 
		select id from tb_atendimento where fk_espelho in (
			select id from tb_espelho where numero_espelho in (
					18996
					,18259 
					,18063 
					,17947 
					,17677 
					,17547 
					,17475 
					,17154 
					,16490 
					,16448 
					,16402 
					,16319 
					,16272 
					,16137 
					,15507 
					,15031 
			)and fk_entidade in (select id from tb_entidade where sigla like '%GINECOOP%')
		)
	)
) and valor_honorario < 0

select * from tb_pagamento_procedimento where