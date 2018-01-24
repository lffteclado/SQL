--CREATE TABLE tempPedidoDIM (
--	Codigo VARCHAR(30),
--	NumeroEncomenda VARCHAR(30)
--)

insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A4600160520', '0000081964')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A4570530001', '0000081829')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A3660707533', '0000081931')
insert into tempPedidoDIM (Codigo, NumeroEncomenda) values ('A6510910460', '0000081882')

 where Codigo = 'A6510910460' and NumeroEncomenda = '0000081882'

select * from [dbVDL].[dbo].tempPedidoDIM

select * into tbEncomendaBKP29112017 from tbEncomenda

select * from [dbVDL].[dbo].tempPedidoDIM where Codigo collate Latin1_General_CS_AS not in  (SELECT CodigoProduto
FROM tbEncomenda tbE
INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
AND CodigoEmpresa = 2630 and CodigoLocal = 0)

CREATE PROCEDURE sp_vdl_di 

@CodigoEmpresa NUMERIC(4),
@CodigoLocal NUMERIC(2)

AS  
BEGIN TRANSACTION  
	IF (@CodigoEmpresa = 1200)
		BEGIN
			DELETE [dbAutosete].[dbo].tbEncomenda
			FROM [[dbAutosete]].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal
		END
	IF (@CodigoEmpresa = 262)
		BEGIN
			DELETE [dbCalisto].[dbo].tbEncomenda
			FROM [dbCalisto].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 930)
		BEGIN
			DELETE [dbCardiesel_I].[dbo].tbEncomenda
			FROM [dbCardiesel_I].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 2630)
		BEGIN
			DELETE [dbGoias].[dbo].tbEncomenda
			FROM [dbGoias].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 2620)
		BEGIN
			DELETE [dbUberlandia].[dbo].tbEncomenda
			FROM [dbUberlandia].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 2890)
		BEGIN
			DELETE [dbPostoImperialDP].[dbo].tbEncomenda
			FROM [dbPostoImperialDP].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 130)
		BEGIN
			DELETE [dbVadiesel].[dbo].tbEncomenda
			FROM [dbVadiesel].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
	IF (@CodigoEmpresa = 260)
		BEGIN
			DELETE [dbValadaresCNV].[dbo].tbEncomenda
			FROM [dbValadaresCNV].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and @CodigoLocal = @CodigoLocal	
		END
COMMIT TRANSACTION
DELETE FROM [dbVDL].[dbo].tempPedidoDIM