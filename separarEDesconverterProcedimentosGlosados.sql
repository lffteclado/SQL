IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('separarEDesconverterProcedimentosGlosados'))
BEGIN
	DROP PROCEDURE [dbo].[separarEDesconverterProcedimentosGlosados]
END
GO

create  PROCEDURE [dbo].[separarEDesconverterProcedimentosGlosados]  @idEntidadeCooperadoConversao bigint
AS
BEGIN

/**
* Ajuste efetuado para considerar Conversões com data final que não sejam nulas
* Conforme chamado: #0820-000146 
* Retirado "entidadeCooperadoConversao.data_final is null"
*/

--select getdate()

set nocount on
DECLARE @procedimentosGlosados TABLE (idsProcedimento bigint,
valor_honorario_glosa numeric(19,2),
valor_acrescimo_glosa numeric(19,2),
valor_custo_operacional_glosa numeric(19,2),
valor_filme_glosa numeric(19,2),
valor_desconto_glosa numeric(19,2),
valor_honorario_espelho numeric(19,2),
valor_acrescimo_espelho numeric(19,2),
valor_custo_operacional_espelho numeric(19,2),
valor_filme_espelho numeric(19,2),
valor_desconto_espelho numeric(19,2),

fk_entidade_cooperado_conversao_desconvertida bigint);

	insert into @procedimentosGlosados (idsProcedimento ,
	valor_honorario_glosa ,
	valor_acrescimo_glosa,
	valor_custo_operacional_glosa,
	valor_filme_glosa,
	valor_desconto_glosa,
	valor_honorario_espelho,
	valor_acrescimo_espelho,
	valor_custo_operacional_espelho,
	valor_filme_espelho ,
	valor_desconto_espelho,
	fk_entidade_cooperado_conversao_desconvertida)
	
select procedimento.id,
			coalesce(glosas.valor_honorario,CONVERT(NUMERIC(19,2),0.00)) as valor_honorario,
			coalesce(glosas.valor_acrescimo,CONVERT(NUMERIC(19,2),0.00)) as valor_acrescimo,
			coalesce(glosas.valor_custo_operacional,CONVERT(NUMERIC(19,2),0.00)) as valor_custo_operacional,
			coalesce(glosas.valor_filme,CONVERT(NUMERIC(19,2),0.00)) as valor_filme,
			coalesce(glosas.valor_desconto,CONVERT(NUMERIC(19,2),0.00))  as valor_desconto,

			coalesce(espelho.valor_honorario,CONVERT(NUMERIC(19,2),0.00)) as valor_honorario_espelho,
			coalesce(espelho.valor_acrescimo,CONVERT(NUMERIC(19,2),0.00)) as valor_acrescimo_espelho,
			coalesce(espelho.valor_custo_operacional,CONVERT(NUMERIC(19,2),0.00)) as valor_custo_operacional_espelho,
			coalesce(espelho.valor_filme,CONVERT(NUMERIC(19,2),0.00)) as valor_filme_espelho,
			coalesce(espelho.valor_desconto,CONVERT(NUMERIC(19,2),0.00))  as valor_desconto_espelho,

			entidadeCooperadoConversao.id
	from tb_procedimento 
	procedimento inner join tb_atendimento
	atendimento on(procedimento.fk_atendimento=atendimento.id and procedimento.registro_ativo=1 and atendimento.registro_ativo=1)
	inner join rl_entidade_cooperado_conversao entidadeCooperadoConversao on( atendimento.fk_entidade=entidadeCooperadoConversao.fk_entidade and entidadeCooperadoConversao.registro_ativo=1
		and procedimento.fk_cooperado_recebedor_cobranca=entidadeCooperadoConversao.fk_cooperado_destino and procedimento.fk_cooperado_recebedor_cobranca_anterior=entidadeCooperadoConversao.fk_cooperado_origem
		and ((procedimento.data_realizacao between entidadeCooperadoConversao.data_inicial and entidadeCooperadoConversao.data_final) or (entidadeCooperadoConversao.data_inicial<=procedimento.data_realizacao /*and entidadeCooperadoConversao.data_final is null*/)))


	CROSS apply(
		select 
			sum(coalesce(valor_honorario,0)) as valor_honorario,
			sum(coalesce(valor_acrescimo,0)) as valor_acrescimo,
			sum(coalesce(valor_custo_operacional,0)) as valor_custo_operacional,
			sum(coalesce(valor_filme,0)) as valor_filme,
			sum(coalesce(valor_desconto,0))  as valor_desconto
			from tb_glosa 
		where fk_procedimento=procedimento.id and registro_ativo=1 and situacao IN (0,1,2,3,7)
		and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0
			group by fk_procedimento
	) as glosas
	OUTER apply(
		select sum(coalesce(valor_honorario,0)) as valor_honorario,
			sum(coalesce(valor_acrescimo,0)) as valor_acrescimo,
			sum(coalesce(valor_custo_operacional,0)) as valor_custo_operacional,
			sum(coalesce(valor_filme,0)) as valor_filme,
			sum(coalesce(valor_desconto,0))  as valor_desconto
			from tb_pagamento_procedimento 
		where fk_procedimento=procedimento.id and registro_ativo=1  and fk_fatura is null
		and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0
			group by fk_procedimento
	) as espelho
	where entidadeCooperadoConversao.id=@idEntidadeCooperadoConversao
	and exists(select id from tb_pagamento_procedimento where fk_fatura is not null and registro_ativo=1 and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0 )
	

--inserindo novo procedimento com valor de glosa e espelho
insert into tb_procedimento (
resolveu_dependencia                              ,
data_ultima_alteracao							  ,
registro_ativo									  ,
data_fim										  ,
data_inicio										  ,
data_realizacao									  ,
desconto_hospitalar								  ,
faturar											  ,
forcar_atendimento								  ,
forma_execucao									  ,
guia_procedimento								  ,
hora_fim										  ,
hora_inicio										  ,
percentual_desconto_hospitalar					  ,
quantidade										  ,
quantidade_ch									  ,
quantidade_porte								  ,
tuss											  ,
urgencia										  ,
valor_acrescimo									  ,
valor_ch										  ,
valor_custo_operacional							  ,
valor_desconto									  ,
valor_filme										  ,
valor_honorario									  ,
valor_percentual								  ,
valor_total										  ,
fk_usuario_ultima_alteracao						  ,
fk_acomodacao									  ,
fk_atendimento									  ,
fk_complexidade									  ,
fk_cooperado_executante_complemento				  ,
fk_cooperado_recebedor_cobranca					  ,
fk_cooperado_recebedor_cobranca_anterior		  ,
fk_entidade_cooperado_especialidade				  ,
fk_grau_participacao							  ,
fk_item_despesa									  ,
fk_procedimento_detalhar_unimed					  ,
fk_procedimento_tuss							  ,
fk_tecnica										  ,
fk_tipo_guia									  ,
fk_unidade_medida								  ,
fk_via_acesso									  ,
autorizado_unimed								  ,
foiAlterado										  ,
numero_guia										  ,
registro_adequecao								  ,
procedimentoConvertidoServicoEspecialRepasse	  ,
procedimentoConvertidoCooperadoRepassado		  ,
valor_acrescimo_convenio						  ,
fk_item_porte_anestesia							  ,
referencia_procedimento_integracao				  ,
valor_desconto_anterior							  ,
valor_honorario_anterior						  ,
valor_acrescimo_convenio_anterior				  ,
data_criacao_rateio								  ,
referencia_procedimento_rateio					  ,
fk_tecnica_anterior_tmp							  ,
desconto_hospitalar_bkp							  ,
data_separacao_uco								  ,
referencia_separacao_uco						  ,
referencia_procedimento_integracao_entidade		  ,
fk_procedimento_tuss_anterior					  ,
referencia_procedimento_unimed					  ,
referencia_procedimento_prontuario				  ,
fk_procedimento_origem							  ,
fk_entidade_cooperado_conversao_desconvertida)

select procedimento.resolveu_dependencia                              ,
procedimento.data_ultima_alteracao							  ,
procedimento.registro_ativo									  ,
procedimento.data_fim										  ,
procedimento.data_inicio										  ,
procedimento.data_realizacao									  ,
procedimento.desconto_hospitalar								  ,
procedimento.faturar											  ,
1,
procedimento.forma_execucao									  ,
procedimento.guia_procedimento								  ,
procedimento.hora_fim										  ,
procedimento.hora_inicio										  ,
procedimento.percentual_desconto_hospitalar					  ,
procedimento.quantidade										  ,
procedimento.quantidade_ch									  ,
procedimento.quantidade_porte								  ,
procedimento.tuss											  ,
procedimento.urgencia										  ,
glosa.valor_acrescimo_glosa	+ glosa.valor_acrescimo_espelho   ,
procedimento.valor_ch										  ,
glosa.valor_custo_operacional_glosa	+	glosa.valor_custo_operacional_espelho,
glosa.valor_desconto_glosa + valor_desconto_espelho 		  ,
glosa.valor_filme_glosa + valor_filme_espelho				  ,
glosa.valor_honorario_glosa + valor_honorario_espelho		  ,
procedimento.valor_percentual								  ,
glosa.valor_acrescimo_glosa+glosa.valor_custo_operacional_glosa+glosa.valor_filme_glosa	+glosa.valor_honorario_glosa-glosa.valor_desconto_glosa+
isnull(glosa.valor_acrescimo_espelho,0)+isnull(glosa.valor_custo_operacional_espelho,0)+isnull(glosa.valor_filme_espelho,0)+isnull(glosa.valor_honorario_espelho,0)-isnull(glosa.valor_desconto_espelho,0),
procedimento.fk_usuario_ultima_alteracao						  ,
procedimento.fk_acomodacao									  ,
procedimento.fk_atendimento									  ,
procedimento.fk_complexidade									  ,
procedimento.fk_cooperado_executante_complemento				  ,
procedimento.fk_cooperado_recebedor_cobranca_anterior					  ,
null as fk_cooperado_recebedor_cobranca_anterior		  ,
procedimento.fk_entidade_cooperado_especialidade				  ,
procedimento.fk_grau_participacao							  ,
procedimento.fk_item_despesa									  ,
procedimento.fk_procedimento_detalhar_unimed					  ,
procedimento.fk_procedimento_tuss							  ,
procedimento.fk_tecnica										  ,
procedimento.fk_tipo_guia									  ,
procedimento.fk_unidade_medida								  ,
procedimento.fk_via_acesso									  ,
procedimento.autorizado_unimed								  ,
procedimento.foiAlterado										  ,
procedimento.numero_guia										  ,
procedimento.registro_adequecao								  ,
procedimento.procedimentoConvertidoServicoEspecialRepasse	  ,
procedimento.procedimentoConvertidoCooperadoRepassado		  ,
procedimento.valor_acrescimo_convenio						  ,
procedimento.fk_item_porte_anestesia							  ,
procedimento.referencia_procedimento_integracao				  ,
procedimento.valor_desconto_anterior							  ,
procedimento.valor_honorario_anterior						  ,
procedimento.valor_acrescimo_convenio_anterior				  ,
procedimento.data_criacao_rateio								  ,
procedimento.referencia_procedimento_rateio					  ,
procedimento.fk_tecnica_anterior_tmp							  ,
procedimento.desconto_hospitalar_bkp							  ,
procedimento.data_separacao_uco								  ,
procedimento.referencia_separacao_uco						  ,
procedimento.referencia_procedimento_integracao_entidade		  ,
procedimento.fk_procedimento_tuss_anterior					  ,
procedimento.referencia_procedimento_unimed					  ,
procedimento.referencia_procedimento_prontuario				  ,
procedimento.id	,
glosa.fk_entidade_cooperado_conversao_desconvertida
from tb_procedimento procedimento
inner join @procedimentosGlosados glosa on(procedimento.id=glosa.idsProcedimento)


-- corrigindo valor do procedimento antigo
update procedimento 
set procedimento.forcar_atendimento=1,
procedimento.valor_honorario        =isnull(procedimento.valor_honorario        ,0.00)- novoProcedimento.valor_honorario        ,
procedimento.valor_acrescimo        =isnull(procedimento.valor_acrescimo        ,0.00)- novoProcedimento.valor_acrescimo        , 
procedimento.valor_desconto         =isnull(procedimento.valor_desconto         ,0.00)-	novoProcedimento.valor_filme            ,
procedimento.valor_custo_operacional=isnull(procedimento.valor_custo_operacional,0.00)-	novoProcedimento.valor_custo_operacional,
procedimento.valor_total            =isnull(procedimento.valor_total            ,0.00)-	novoProcedimento.valor_total,
procedimento.fk_entidade_cooperado_conversao_desconvertida            = glosa.fk_entidade_cooperado_conversao_desconvertida
from tb_procedimento procedimento
inner join @procedimentosGlosados glosa on(procedimento.id=glosa.idsProcedimento)
inner join tb_procedimento novoProcedimento on(novoProcedimento.fk_procedimento_origem=procedimento.id)


--trocando pagamento_procedimento espelhado pro novo procedimento
update pagamento set pagamento.fk_procedimento= novoProcedimento.id
from tb_pagamento_procedimento pagamento 
inner join @procedimentosGlosados procedimentosGlosados on(procedimentosGlosados.idsProcedimento=pagamento.fk_procedimento and pagamento.fk_fatura is null 
and pagamento.registro_ativo=1)
inner join tb_procedimento novoProcedimento on(novoProcedimento.fk_procedimento_origem=procedimentosGlosados.idsProcedimento)


--gerando nova glosa no novo procedimento
insert into tb_glosa 
(
resolveu_dependencia				,
data_ultima_alteracao				,
registro_ativo						,
data_glosa							,
observacao							,
quantidadeCobrado					,
quantidadeGlosado					,
situacao							,
valor_acrescimo						,
valor_custo_operacional				,
valor_desconto						,
valor_filme							,
valor_honorario						,
fk_usuario_ultima_alteracao			,
fk_carta_glosa						,
fk_entidade_motivo_glosa			,
fk_motivo_glosa						,
fk_motivo_glosa_unimed				,
fk_procedimento						,
fk_convenio_temp					,
autorizado_unimed					,
valor_acrescimoConvenio				,
erroItem_completo_unimed			,
fk_entidade_usuario_criacao			,
glosadoSemGlosa						,
guia_operadora						,
numero_guia_recurso_glosa           ,
data_recebimento
)
select 
0 resolveu_dependencia				,
glosaAntiga.data_ultima_alteracao				,
glosaAntiga.registro_ativo						,
glosaAntiga.data_glosa							,
glosaAntiga.observacao							,
glosaAntiga.quantidadeCobrado					,
glosaAntiga.quantidadeGlosado					,
glosaAntiga.situacao							,
glosaAntiga.valor_acrescimo			,
glosaAntiga.valor_custo_operacional	,
glosaAntiga.valor_desconto				,
glosaAntiga.valor_filme				,
glosaAntiga.valor_honorario            ,
glosaAntiga.fk_usuario_ultima_alteracao			,
glosaAntiga.fk_carta_glosa						,
glosaAntiga.fk_entidade_motivo_glosa			,
glosaAntiga.fk_motivo_glosa						,
glosaAntiga.fk_motivo_glosa_unimed				,
procedimento.id						            ,
glosaAntiga.fk_convenio_temp					,
glosaAntiga.autorizado_unimed					,
glosaAntiga.valor_acrescimoConvenio				,
glosaAntiga.erroItem_completo_unimed			,
glosaAntiga.fk_entidade_usuario_criacao			,
glosaAntiga.glosadoSemGlosa						,
glosaAntiga.guia_operadora						,
glosaAntiga.numero_guia_recurso_glosa           ,
glosaAntiga.data_recebimento
from @procedimentosGlosados novoValorGlosa
inner join tb_procedimento procedimento on(procedimento.fk_procedimento_origem=novoValorGlosa.idsProcedimento)
cross apply (select *
from tb_glosa 
				where novoValorGlosa.idsProcedimento=fk_procedimento and 
				registro_ativo=1 and   
				situacao IN (0,1,2,3,7)) as glosaAntiga

/*
update glosa set 
glosa.valor_acrescimo=0,
glosa.valor_custo_operacional=0,
glosa.valor_desconto=0,
glosa.valor_filme=0,
glosa.valor_honorario=0
from tb_glosa glosa 
inner join @procedimentosGlosados procedimento on(glosa.fk_procedimento=procedimento.idsProcedimento)
*/

--excluindo glosa antiga
update glosa set 
glosa.registro_ativo=0
from tb_glosa glosa 
inner join @procedimentosGlosados procedimento on(glosa.fk_procedimento=procedimento.idsProcedimento)


--select getdate()

END