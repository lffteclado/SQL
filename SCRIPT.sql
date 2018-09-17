declare
    @CodigoEmpresa numeric(4)
,   @CodigoLocal numeric(4)

select
    @CodigoEmpresa = 2630
,   @CodigoLocal = 2

exec dbo.whAtualizaParametroNFSE @CodigoEmpresa, @CodigoLocal, 'URLHOMOENVIO', 'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx'
exec dbo.whAtualizaParametroNFSE @CodigoEmpresa, @CodigoLocal, 'URLHOMOCONSULTA', 'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx'
exec dbo.whAtualizaParametroNFSE @CodigoEmpresa, @CodigoLocal, 'URLHOMOCANCELA', 'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx'

