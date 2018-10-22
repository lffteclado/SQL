/*
select * from tbProdutoAuxiliar where CodigoProdutoAuxiliar = 'A00003801010002'

drop table #tmpI

select * from #tmpI

/*
Para o script funcionar foi criada a tabela abaixo que será alimentada pelo script gerado pelo Portal DTI
CREATE TABLE tempProdutoImportados (
	Codigo VARCHAR(30),--O codigo que deve ser concatenado com a letra
	Tipo VARCHAR(10) -- O tipo de produto: G = Importado, F = Fabricação Propria e N = Nacional
)
*/

--select * from tempProdutoImportados
/*
select * from tbEmpresa 

declare @Prod varchar(30)
declare @Tipo VARCHAR(10)
set @Prod ='A3520100876' set @Tipo ='G'

insert into tempProdutoImportados(Codigo,Tipo) values (@Prod, @Tipo)


/*
select 	CodigoProduto,
ProdutoImportadoDireto,
ProdutoImportado,
CodigoTributacaoProduto,
NacionalMaior40Import,
NacionalAte40Import
into #tmpI
from tbProdutoFT where (REPLACE(CodigoProduto,' ','') = 'A38626870429985')
or  (REPLACE(CodigoProduto,' ','') = 'A69472370139B51')


/* Atualização Tabela Item Auxiliar para Nacional (Não importado) */
/*
select 	CodigoProdutoAuxiliar,
Importado
into #tmpI
from tbProdutoAuxiliar where (REPLACE(CodigoProdutoAuxiliar,' ','') = 'A00003801010002')
or  (REPLACE(CodigoProdutoAuxiliar,' ','') = 'A00003801010305')
or  (REPLACE(CodigoProdutoAuxiliar,' ','') = 'A00003801010608')
or  (REPLACE(CodigoProdutoAuxiliar,' ','') = 'A00003801010911')

/*

update tbProdutoAuxiliar set Importado = 'F'
where CodigoProdutoAuxiliar in (select tbPA.CodigoProdutoAuxiliar
from tbProdutoAuxiliar tbPA
inner join #tmpI I on
I.CodigoProduto = tbPA.CodigoProdutoAuxiliar)

/* Atualização Tabela Produto FT para Nacional (Não importado) */

update tbProdutoFT set ProdutoImportadoDireto = 'F',
ProdutoImportado = 'F',
CodigoTributacaoProduto = 'F',
NacionalMaior40Import = 'F',
NacionalAte40Import = 'F'
where CodigoProduto in (select tbPFT.CodigoProduto
from tbProdutoFT tbPFT
inner join #tmpI I on
I.CodigoProduto = tbPFT.CodigoProduto and
I.ProdutoImportadoDireto = tbPFT.ProdutoImportadoDireto and
I.ProdutoImportado = tbPFT.ProdutoImportado and
I.CodigoTributacaoProduto = tbPFT.CodigoTributacaoProduto and
I.NacionalMaior40Import = tbPFT.NacionalMaior40Import and
I.NacionalAte40Import = tbPFT.NacionalAte40Import)