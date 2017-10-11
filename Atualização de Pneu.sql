declare @Prod varchar(50)
declare @Preco money
set @Prod = 'C337580111I' set @Preco = '1091.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C641118102N' set @Preco = '1224.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C346637115I' set @Preco = '1268.85'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C749050' set @Preco = '1330.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = '87109' set @Preco = '860.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C571096' set @Preco = '707.20'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C507853101N' set @Preco = '2147.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C551552101N' set @Preco = '2300.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C704061103N' set @Preco = '2234.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C110974101N' set @Preco = '2336.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C567304101N' set @Preco = '2336.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C814333108N' set @Preco = '2169.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C385696101N' set @Preco = '2408.90'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C754021' set @Preco = '1894.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C569105101N' set @Preco = '1893.63'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C572248101I' set @Preco = '2285.95'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C247340110N' set @Preco = '2285.95'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C765995101N' set @Preco = '1965.40'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C826679101N' set @Preco = '2542.70'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C110812' set @Preco = '2571.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = '280950' set @Preco = '2287.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C978950116N' set @Preco = '2353.20'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C285635' set @Preco = '2285.95'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C703945101I' set @Preco = '1670.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C479768101I' set @Preco = '1840.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = '833312' set @Preco = '3718.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C634435401I' set @Preco = '907.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C706349101N' set @Preco = '1857.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C596578101N' set @Preco = '1922.40'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C553217101N' set @Preco = '2161.10'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C545624' set @Preco = '2264.46'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C667719' set @Preco = '2106.60'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C190423103N' set @Preco = '2230.40'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C336211' set @Preco = '2230.40'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C304171101N' set @Preco = '2469.10'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C10115290PN' set @Preco = '104.50'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C10115990PN' set @Preco = '134.20'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C10122590PN' set @Preco = '153.10'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C1028709ABN' set @Preco = '69.95'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C1029709ABN' set @Preco = '87.60'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C589014N' set @Preco = '137.50'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C7321' set @Preco = '25.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
set @Prod = 'C7322' set @Preco = '25.00'
if exists(select * from tbProduto where CodigoProduto = @Prod)
	begin 
	insert into tbTabelaPreco (CodigoEmpresa,CodigoTipoTabelaPreco,CodigoProduto,DataValidadeTabelaPreco,ValorTabelaPreco,ReajusteEfetuado) values (260,1,@Prod,'2016-05-09',@Preco,'V')
	insert into tempItemForaTabela(CodPro,CodPreco,CodAlt) values (@Prod,@Preco,'A')
end
	else 
if not exists(select * from tbProduto where CodigoProduto = @Prod )
	begin
	insert into tempItemForaTabela(CodPro,CodPreco) values (@Prod,@Preco)
end
