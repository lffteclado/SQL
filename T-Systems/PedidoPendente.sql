
-- Pedido pendente com o seguinte erro [MICROSOFT][ODBC SQL SERVER DRIVER][SQL SERVER]THE STATEMENT HAS BEEN TERMINATED. [MICROSOFT][ODBC SQL SERVER DRIVER][SQL S
--RVER]VIOLATION OF PRIMARY KEY CONSTRAINT PKDOCUMENTONFE.CANNOT INSERT DUPLICATE KEY IN OBJECT DBO.TBDOCUMENTONFE..70237 NOTA FISCAL NAO EFETIVADA
-- Script utilizado apenas para Vadiesel


Select Distinct * into #tmp from tbPedidoChaveAcessoNFE
go
Delete from tbPedidoChaveAcessoNFE
go
Insert Into tbPedidoChaveAcessoNFE
Select * from #tmp

go

ALTER TABLE tbPedidoChaveAcessoNFE ADD CONSTRAINT pkChaveAcessoNFE PRIMARY KEY (CodigoEmpresa, CodigoLocal,CentroCusto,NumeroPedido,SequenciaPedido)

