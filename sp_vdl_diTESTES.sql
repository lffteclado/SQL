--CREATE TABLE tempPedidoDIM (
--	Codigo VARCHAR(30),
--	NumeroEncomenda VARCHAR(30)
--)

EXEC sp_vdl_di 260, 0

insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A0018303972', '12')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A4570530001', '0000081829')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A3660707533', '0000081931')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A6510910460', '0000081882')

 where Codigo = 'A6510910460' and NumeroEncomenda = '0000081882'

select * from [dbVDL].[dbo].tempPedidoDIM

select * FROM [dbo].tbEncomenda where CodigoProduto = 'A0018303972' and NumeroDocumentoEncomenda = '12'

select * into tbEncomendaBKP29112017 from tbEncomenda

select * from [dbVDL].[dbo].tempPedidoDIM where Codigo collate Latin1_General_CS_AS not in  (SELECT CodigoProduto
FROM [dbGoias].[dbo].tbEncomenda tbE
INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
AND CodigoEmpresa = 2630 and CodigoLocal = 0)

