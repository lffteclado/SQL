select top 1 * from tbProduto

select top 1 * from tbProdutoFT

select * from sysobjects where name like 'tb%Saldo%'

select * from tbClassificacaoFiscal where CodigoClassificacaoFiscal = '1'

select CodigoProduto,
 ((QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox) - QtdeSaidaSaldoAtuAlmoxarifado) as Saldo
 from tbSaldoAtualAlmoxarifado where QtdeAntSaldoAtuAlmoxarifado > 0.00 and CodigoAlmoxarifado = 'A' order by CodigoProduto

 select CodigoProduto,
 ((QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox) - QtdeSaidaSaldoAtuAlmoxarifado) as Saldo
 from tbSaldoAtualAlmoxarifado where ((QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox) - QtdeSaidaSaldoAtuAlmoxarifado) > 0.00 and CodigoAlmoxarifado = 'A' order by CodigoProduto


SELECT CodigoProduto, CodigoClassificacaoFiscal
 FROM tbProduto tbP WHERE CodigoProduto in (SELECT CodigoProduto from tbProdutoFT)
  and CodigoClassificacaoFiscal in (select CodigoClassificacaoFiscal from tbClassificacaoFiscal where TributaPIS = 'F' and TributaCOFINS = 'F') order by CodigoProduto


 SELECT CodigoClassificacaoFiscal,
 TributaPIS,
 TributaCOFINS FROM tbClassificacaoFiscal WHERE TributaPIS = 'F' and TributaCOFINS = 'F'


 SELECT DISTINCT tbP.CodigoProduto,
		tbP.CodigoClassificacaoFiscal,
		tbC.TributaPIS,
		tbC.TributaCOFINS,
		((tbAx.QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox) - QtdeSaidaSaldoAtuAlmoxarifado) as Saldo
 FROM tbProduto tbP

 INNER JOIN tbClassificacaoFiscal tbC on tbP.CodigoClassificacaoFiscal = tbC.CodigoClassificacaoFiscal
 INNER JOIN tbSaldoAtualAlmoxarifado tbAx on tbP.CodigoProduto = tbAx.CodigoProduto

 WHERE tbP.CodigoProduto in (SELECT CodigoProduto from tbProdutoFT)
 
 AND tbC.TributaPIS = 'F'
 AND tbC.TributaCOFINS = 'F'
 AND tbAx.CodigoAlmoxarifado = 'A'
 AND ((tbAx.QtdeAntSaldoAtuAlmoxarifado + tbAx.QtdeEntradaSaldoAtuAlmox) - tbAx.QtdeSaidaSaldoAtuAlmoxarifado) > 0.00












EXECUTE whSaldoAtualAlmoxProducaoP @CodigoEmpresa = 930,@CodigoLocal = 0,@CodigoProduto = 'QAP6060305'

select * from tbSaldoAtualAlmoxarifado where CodigoProduto = 'QAP6060305'


