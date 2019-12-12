---Setar os valores baseados no pagamento procedimento.
--declare @idEspelho bigint = 934365

update tb_espelho set valor_total_custo_operacional = (
select sum(coalesce(pagamento.valor_custo_operacional,0)) from tb_pagamento_procedimento pagamento
inner join tb_procedimento procedimento on(pagamento.fk_procedimento=procedimento.id  and procedimento.registro_ativo=1)
inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento)
where atendimento.fk_espelho=tb_espelho.id and pagamento.fk_fatura is null and pagamento.registro_ativo=1),
valor_total_filme = (
select sum(coalesce(pagamento.valor_filme,0)) from tb_pagamento_procedimento pagamento
inner join tb_procedimento procedimento on(pagamento.fk_procedimento=procedimento.id  and procedimento.registro_ativo=1)
inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento)
where atendimento.fk_espelho=tb_espelho.id and pagamento.fk_fatura is null and pagamento.registro_ativo=1),
valor_total_honorario = (
select sum(coalesce(pagamento.valor_honorario,0)) from tb_pagamento_procedimento pagamento
inner join tb_procedimento procedimento on(pagamento.fk_procedimento=procedimento.id  and procedimento.registro_ativo=1)
inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento)
where atendimento.fk_espelho=tb_espelho.id and pagamento.fk_fatura is null and pagamento.registro_ativo=1),
valor_total_acrescimo = (
select sum(coalesce(pagamento.valor_acrescimo,0)) from tb_pagamento_procedimento pagamento
inner join tb_procedimento procedimento on(pagamento.fk_procedimento=procedimento.id  and procedimento.registro_ativo=1)
inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento)
where atendimento.fk_espelho=tb_espelho.id and pagamento.fk_fatura is null and pagamento.registro_ativo=1),
valor_total_desconto = (
select sum(coalesce(pagamento.valor_desconto,0)) from tb_pagamento_procedimento pagamento
inner join tb_procedimento procedimento on(pagamento.fk_procedimento=procedimento.id  and procedimento.registro_ativo=1) 
inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento)
where atendimento.fk_espelho=tb_espelho.id and pagamento.fk_fatura is null and pagamento.registro_ativo=1)
where tb_espelho.id=934365
GO
If Exists(Select * from Tempdb..SysObjects Where Name Like '##TempEspelho%')
BEGIN
    drop table ##TempEspelho
END
select *,'L' as status,0 as qtdeAtendimento
into ##TempEspelho
from
tb_espelho where id=934365
GO
update ##TempEspelho set valor_total_custo_operacional = valor_total_custo_operacional+valor_total_filme
GO
alter table ##TempEspelho add valorTotalAtendimento numeric(19,4),
valorBaseIrTemp numeric(19,4),
valorTotal numeric(19,4);
GO
--- Calculando quantidade de atendimento
update ##TempEspelho set qtdeAtendimento = (
select count(id) from tb_atendimento atendimento
where atendimento.fk_espelho=##TempEspelho.id)
GO
---- Calculando valor Total Atendimento
update ##TempEspelho set valorTotalAtendimento =(
coalesce(valor_total_custo_operacional,0)+
coalesce(valor_total_honorario,0)+
coalesce(valor_total_acrescimo,0)-
coalesce(valor_total_desconto,0))
GO
--Calculando valor de custeio.
update ##TempEspelho set taxa_custeio = coalesce((select top 1 percentual_custeio from rl_entidade_convenio where id=##TempEspelho.fk_entidade_convenio),0)
update ##TempEspelho set valor_custeio = taxa_custeio*valorTotalAtendimento/100
GO
--Calculando valor IR calcularIR()
update ##TempEspelho set valorBaseIrTemp =
coalesce(valor_total_honorario,0)-
coalesce(valor_total_desconto,0)+
coalesce(valor_total_acrescimo,0);
GO
update ##TempEspelho set valorBaseIrTemp =
case
when coalesce((select top 1 incidir_ir_custo_operacional from tb_impostos where id=##TempEspelho.fk_impostos),0)=1 then coalesce(valorBaseIrTemp,0)+coalesce(valor_total_custo_operacional,0)
ELSE valorBaseIrTemp
END
GO
update ##TempEspelho set valorBaseIrTemp =
case
when coalesce((select top 1 percentual_ir from tb_impostos where id=##TempEspelho.fk_impostos),0)=1 then coalesce(valorBaseIrTemp,0)+coalesce(valor_custeio,0)
ELSE valorBaseIrTemp
END
GO
update ##TempEspelho set valorBaseIrTemp =
(valorBaseIrTemp * coalesce((select top 1 percentual_ir from tb_impostos where id=##TempEspelho.fk_impostos),0))/100
GO
update ##TempEspelho set valor_ir =
case
when coalesce((select top 1 valor_minimo_ir from tb_impostos where id=##TempEspelho.fk_impostos),0)<=valorBaseIrTemp then valorBaseIrTemp
ELSE 0
END
GO

--Calculando valorTotal
update ##TempEspelho set valorTotal = coalesce(valorTotalAtendimento,0)+coalesce(valor_custeio,0)
GO
--Calculando Base Iss
update ##TempEspelho set base_iss =
coalesce(valor_total_honorario,0) - coalesce(valor_total_desconto,0) + coalesce(valor_total_custo_operacional,0)
GO
update ##TempEspelho set base_iss =
case
when coalesce((select top 1 incidir_iss_sobre_acrescimo from tb_impostos where id=##TempEspelho.fk_impostos),0)=1  then coalesce(base_iss,0)+coalesce(valor_total_acrescimo,0)
ELSE coalesce(base_iss,0)
END
GO
update ##TempEspelho set base_iss = (base_iss *
coalesce((select top 1 percentual_base_iss from tb_impostos where id=##TempEspelho.fk_impostos),0)) / 100
GO
update ##TempEspelho set base_iss =
case
when coalesce((select top 1 incidir_iss_sobre_acrescimo from tb_impostos where id=##TempEspelho.fk_impostos),0)=1  then coalesce(base_iss,0)+coalesce(valor_custeio,0)
ELSE coalesce(base_iss,0)+coalesce(valor_custeio,0)+coalesce(valor_total_acrescimo,0)
END
go
-- Calculando valor iss calcularISS().
update ##TempEspelho set valor_iss = (base_iss *
coalesce((select top 1 percentual_iss from tb_impostos where id=##TempEspelho.fk_impostos),0)) / 100
GO
-- Calculando Pis calcularPIS()
update ##TempEspelho set valor_pis = (valorTotal*
coalesce((select top 1 percentual_pis from tb_impostos where id=##TempEspelho.fk_impostos),0)) /100
go
update ##TempEspelho set valor_pis =
CASE
WHEN coalesce((select top 1 valor_minimo_pis from tb_impostos where id=##TempEspelho.fk_impostos),0) <=valor_pis then valor_pis
ELSE 0
END
GO
-- Calculando Cofins calcularCOFINS()
update ##TempEspelho set valor_cofins = (valorTotal*
coalesce((select top 1 percentual_cofins from tb_impostos where id=##TempEspelho.fk_impostos),0)) /100
go
update ##TempEspelho set valor_cofins =
CASE
WHEN coalesce((select top 1 valor_minimo_cofins from tb_impostos where id=##TempEspelho.fk_impostos),0) <=valor_cofins then valor_cofins
ELSE 0
END
GO
-- Calculando Cofins calcularCOFINS()
update ##TempEspelho set valor_cofins = (valorTotal*
coalesce((select top 1 percentual_cofins from tb_impostos where id=##TempEspelho.fk_impostos),0) / 100)
go
update ##TempEspelho set valor_cofins =
CASE
WHEN coalesce((select top 1 valor_minimo_cofins from tb_impostos where id=##TempEspelho.fk_impostos),0) <=valor_cofins then valor_cofins
ELSE 0
END
GO
-- Calculando CSSL calcularCSLL()
update ##TempEspelho set valor_csll = (valorTotal*
coalesce((select top 1 percentual_contribuicao_social from tb_impostos where id=##TempEspelho.fk_impostos),0)) /100
go
update ##TempEspelho set valor_csll =
CASE
WHEN coalesce((select top 1 valor_minimo_csll from tb_impostos where id=##TempEspelho.fk_impostos),0) <=valor_csll then valor_csll
ELSE 0
END
GO
-- Calculando retem ir.calcularRetemIr()
update ##TempEspelho set valor_liquido =
case
when (select top 1 retem_ir from tb_impostos where id=##TempEspelho.fk_impostos) is not null and (select top 1 retem_ir from tb_impostos where id=##TempEspelho.fk_impostos)=0 then coalesce(valorTotal,0)-coalesce(valor_ir,0)
ELSE coalesce(valorTotal,0)
END
GO
-- Calculando valor liquido calcularValorLiquido()
update ##TempEspelho set valor_liquido =
CASE
when (select top 1 retem_iss from tb_impostos where id=##TempEspelho.fk_impostos) is not null and (select top 1 retem_iss from tb_impostos where id=##TempEspelho.fk_impostos)=0 then valor_liquido - valor_iss
ELSE valor_liquido
END
GO
update ##TempEspelho set valor_liquido =
CASE
when (select top 1 retem_pis from tb_impostos where id=##TempEspelho.fk_impostos) is not null and (select top 1 retem_pis from tb_impostos where id=##TempEspelho.fk_impostos)=0 then valor_liquido - valor_pis
ELSE valor_liquido
END
GO
update ##TempEspelho set valor_liquido =
CASE
when (select top 1 retem_cofins from tb_impostos where id=##TempEspelho.fk_impostos) is not null and (select top 1 retem_cofins from tb_impostos where id=##TempEspelho.fk_impostos)=0 then valor_liquido - valor_cofins
ELSE valor_liquido
END
GO
update ##TempEspelho set valor_liquido =
CASE
when (select top 1 retem_csll from tb_impostos where id=##TempEspelho.fk_impostos) is not null and (select top 1 retem_csll from tb_impostos where id=##TempEspelho.fk_impostos)=0 then valor_liquido - valor_csll
ELSE valor_liquido
END
GO
update espelhoreal set
espelhoreal.valor_total_custo_operacional =temp.valor_total_custo_operacional  ,
espelhoreal.valor_custeio    =  temp.valor_custeio  ,
espelhoreal.valor_ir         =  temp.valor_ir       ,
espelhoreal.base_iss         =  temp.base_iss       ,
espelhoreal.valor_iss        =  temp.valor_iss      ,
espelhoreal.valor_pis        =  temp.valor_pis      ,
espelhoreal.valor_cofins     =  temp.valor_cofins   ,
espelhoreal.valor_csll       =  temp.valor_csll     ,
espelhoreal.valor_liquido    =  temp.valor_liquido  ,
espelhoreal.valor_total      =  temp.valorTotal    ,
espelhoreal.taxa_custeio     =  temp.taxa_custeio
from tb_espelho espelhoreal
inner join ##TempEspelho temp on(espelhoreal.id=temp.id)
where espelhoreal.sendo_importado_temp = 1

GO
update tb_espelho set valor_total_custo_operacional =0
where valor_total_custo_operacional is null
update tb_espelho set valor_total_filme =0
where valor_total_filme is null
update tb_espelho set valor_total_honorario =0
where valor_total_honorario is null
update tb_espelho set valor_total_acrescimo =0
where valor_total_acrescimo is null
update tb_espelho set valor_total_desconto =0
where valor_total_desconto is null