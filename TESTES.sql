--EXEC sp_BloqueiaAbaixoCusto 2620, 2, 'V'

--EXEC sp_BloqueiaDescMinimo 260, 0, 'V', '51.00'

SELECT DadosEmpresaPreImpresso, * FROM dbPostoImperialDP.dbo.tbLocalFT
WHERE CodigoEmpresa = 2890
--AND CodigoLocal = 1

SELECT DescontoMinimoPedido, * FROM dbPostoImperialDP.dbo.tbLocalFT
WHERE CodigoEmpresa = 2890
--AND CodigoLocal = @CodigoLocal