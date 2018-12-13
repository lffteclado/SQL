select * from tbClienteComplementar where CodigoCliFor = 4681238000180

select top 1 * from tbCliFor
/**
tbCliForLocal
tbCliForJuridica
tbCliForFisica
tbClienteComplementar
*/

--select * from sysobjects where name like 'tb%Cli%'

/* CLIENTE TABELA DE PREÇOS */
select tbCli.CodigoCliFor,
       tbCli.NomeCliFor, 
       tbCom.CodigoTipoTabelaPreco
from tbClienteComplementar tbCom
inner join tbCliFor tbCli on tbCom.CodigoCliFor = tbCli.CodigoCliFor
where (tbCli.ClienteAtivo = 'V' or tbCli.FornecedorAtivo = 'V') and tbCom.CodigoTipoTabelaPreco is not null

/* CLIENTE PLANO DE PAGAMENTO */
select tbCli.CodigoCliFor,
       tbCli.NomeCliFor, 
       tbCom.CodigoPlanoPagamento
from tbClienteComplementar tbCom
inner join tbCliFor tbCli on tbCom.CodigoCliFor = tbCli.CodigoCliFor
where (tbCli.ClienteAtivo = 'V' or tbCli.FornecedorAtivo = 'V') and tbCom.CodigoPlanoPagamento is not null
