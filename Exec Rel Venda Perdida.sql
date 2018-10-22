EXECUTE whListaStoredsProcedures @NomeSP = whRelFTVendasPerdidas
go
EXECUTE whListaStoredsProcedures @NomeSP = whRelFTVendasPerdidas

sp_helptext whRelFTVendasPerdidas
/*
@CodigoEmpresa		dtInteiro04 ,
@CodigoLocal		dtInteiro04 ,
@TipoClassificacao      dtInteiro01 ,
@DataInicial            datetime,
@DataFinal         	datetime,
@LinhaProdutoInicial    dtInteiro08 = null,
@LinhaProdutoFinal      dtInteiro08 = null ,
@ProdutoInicial	 	Char(30) = null,
@ProdutoFinal		Char(30) = null,
@DoComodite			varchar(5) = null,
@AteComodite		varchar(5) = null,	
@DoResponsability	varchar(7) = null,
@AteResponsability	varchar(7) = null 

-- 3 Analitico / 4 Grafico

*/
exec dbAutosete.dbo.whRelFTVendasPerdidas 1200,0,3,'2017-06-01 00:00:00:000','2017-06-30 23:59:59:000',0,99999999,'0','ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ',NULL,NULL,NULL,NULL

 select * from rtVendasPerdidas