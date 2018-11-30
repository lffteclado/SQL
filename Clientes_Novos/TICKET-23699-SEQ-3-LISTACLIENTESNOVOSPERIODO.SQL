declare @Mes		numeric(2)
declare @Ano		numeric(4)
------------------------------------------------------------------------------------
-- Informar Periodo
set @Ano = 2011	-- formato 'aaaa'
set @Mes = 11		-- formato 'mm'
------------------------------------------------------------------------------------


SELECT DISTINCT
ltrim(rtrim(convert(char(4), tbCliFor.CodigoEmpresa)))
+ ';' + ltrim(rtrim(convert(char(14), tbCliFor.CodigoCliFor)))
+ ';' + ltrim(rtrim(convert(char(60), tbCliFor.NomeCliFor)))
+ ';' + ltrim(rtrim(convert(char(30), tbCliFor.MunicipioCliFor)))
+ ';' + ltrim(rtrim(convert(char(4), isnull(tbCliFor.DDDTelefoneCliFor,0))))
+ ';' + ltrim(rtrim(convert(char(15), isnull(tbCliFor.TelefoneCliFor,0))))
+ ';' + ltrim(rtrim(convert(char(20), tbCliFor.DataCadastroCliFor, 103)))
+ ';' + ltrim(rtrim(convert(char(8), tbClienteCentroCusto.CentroCusto)))
FROM tbCliFor (nolock)
INNER JOIN tbClienteCentroCusto  (NOLOCK)
ON tbClienteCentroCusto.CodigoEmpresa = tbCliFor.CodigoEmpresa
AND tbClienteCentroCusto.CodigoCliFor = tbCliFor.CodigoCliFor
WHERE tbCliFor.ClassificacaoCliFor != 'F'
and datepart(yy,DataCadastroCliFor) = @Ano
and datepart(mm,DataCadastroCliFor) = @Mes

