CREATE VIEW dbo.Relatorio_Faturamento
AS

/*View para Geração do Relatório de Rentabilidades
*Atualização: 29/07/2017
*Rensposável: Luís Felipe Ferreira
*Motivo: Atendimento ao Chamado: 53087
*Adequação do Relatório aos campos de Cadastro de Rentabildiade
*/

SELECT     B.id_empresa, B.data, B.frete, B.creditoIcmsSemFrete, B.seguro, B.fretegoias, B.seguro2, B.frete3, B.seguro3,
		   B.perc_creditoIcms, B.perc_debitoIcms, B.assobens,Ba.nome_Banco,B.baseCalculoIcmsPesado,B.bonificacaoEspecialAtacado,
		   B.bonificacaoEspecialObjetivo,B.bonificacaoEspecialVarejo, B.bonusespecialdiretoria, B.nome, B.comissaoGerente,B.Premiacao,
		   B.comissaoVendedor, B.comissaoVendedorFrete,C.conc_faturar, C.conc_vendedora, B.contprotege, B.creditoOficina, B.despesaLubService,
		   B.diferencaIcms, B.DsrGere, B.descansoSemanalRemunerado, B.DsrFrete, B.encargSComiGere, B.encargosSemComissao, B.encargSComiFrete,
		   B.fundoLocalizacao, B.num_fz, U.nome_usuario, B.porcentagemCreditoIcms, B.despesaAdministrativa, B.IntermVenda, B.ImpBoniEspeAta,
		   B.ImpBoniEspeObj, B.ImpBoniEspVarej, B.ImpFundoVenda, B.perc_notaFiscalComp, VM.venda_mes, C.form_pagamento, M.modelo, B.notaFiscalComp,
		   EM.nome_empresa, B.perc_comissaoGerente, B.perc_comissaoVendedor, B.IssAtacado, B.Iss, B.IssVarejo,
		   B.encargSComiFreteGer, B.IssFundoVenda, B.fretePagoCliente, B.resultadoContabil, MT.modelo_tipo, MS.sub_seguimento,
		   B.baseCalculoIcms, B.valorNotaFisComIpi, B.valorCorrecaoCdi, B.valorDaVenda, B.valorEntrada, B.valorFinanciado, V.vendedor
FROM       dbo.base AS B INNER JOIN
           dbo.cliente AS C ON B.id_cliente = C.id_cliente INNER JOIN
           dbo.modelo AS M ON B.id_modelo = M.id INNER JOIN
           dbo.ano_modelo AS AM ON B.id_anomodelo = AM.id INNER JOIN
           dbo.vendedor AS V ON B.id_vendedor = V.id_vendedor INNER JOIN
           dbo.Banco AS Ba ON B.id_Banco = Ba.id_Banco LEFT OUTER JOIN
		   dbo.usuario as U ON B.id_Gerente = U.id INNER JOIN
		   dbo.venda_mes as VM ON B.id_vendames = VM.id LEFT OUTER JOIN
		   dbo.empresa as EM ON B.conc_origem = EM.id INNER JOIN
		   dbo.modelo_tipo as MT ON B.id_modelotipo = MT.id INNER JOIN
		   dbo.modelo_seguimento as MS ON MT.id_seguimento = MS.id_seguimento

