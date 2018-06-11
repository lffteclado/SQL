IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whDPMAXPecas'))
	DROP PROCEDURE dbo.whDPMAXPecas
GO

CREATE PROCEDURE dbo.whDPMAXPecas
@CodigoEmpresa int,
@CodigoLocal int,
@Arquivo varchar(20),	-- 'CONCESSAO', 'USUARIOS', 'CLIENTES', 'CONTATOS', 'FATURAMENTO', 'CARTEIRA'
@DataInicial datetime = null,
@DataFinal  datetime = null,
@FonteFornecimento numeric(4) = null
 
/*
whDPMAXPecas @CodigoEmpresa = 3530, @CodigoLocal = 0, @Arquivo = 'CONCESSAO'
whDPMAXPecas @CodigoEmpresa = 3530, @CodigoLocal = 0, @Arquivo = 'USUARIOS'
whDPMAXPecas @CodigoEmpresa = 3530, @CodigoLocal = 0, @Arquivo = 'CLIENTES'
whDPMAXPecas @CodigoEmpresa = 3530, @CodigoLocal = 0, @Arquivo = 'CONTATOS'
whDPMAXPecas @CodigoEmpresa = 1608, @CodigoLocal = 0, @Arquivo = 'FATURAMENTO', @DataInicial = '2012-01-01', @DataFinal= '2017-05-01'
whDPMAXPecas @CodigoEmpresa = 3530, @CodigoLocal = 0, @Arquivo = 'CARTEIRA'
*/

AS

set nocount on

declare @linha	numeric(10)
declare @CodigoCliFor numeric(14)
declare @CodigoRepresentante int, @codigo_externo varchar(255)
declare @Quantidade numeric(10)
declare @VendaFT char(1), @VendaTK char(1)
declare @canal char(20), @canal1 char(20)					-- BALCAO, TELEPECAS




--select convert(varchar(2), month(GETDATE()), 103)
--select convert(varchar(10), GETDATE(), 103)
--select convert(varchar(10), dateadd(month, -1, GETDATE()), 103)

if @DataInicial is null 
	select @DataInicial = convert(varchar(4), year(GETDATE())) + '/' + right('00' + convert(varchar(2), month(GETDATE())), 2) + '/01'

	
if @DataFinal is null 
	select @DataFinal = dateadd(month,1, @DataInicial) -1


--select @DataInicial, @DataFinal


-- Tabela temporária @Concessao 
declare @Concessao table(linha int, ctcli char(8), dms char(15), cnpj char(14), inscricao_estadual char(255)
						, nome char(60), razao_social varchar(255), tipo_logradouro varchar(255), logradouro varchar(255)
						, numero varchar(255), complemento varchar(255), cep varchar(8), cidade varchar(255), uf varchar(2)
						, telefone_principal varchar(25), telefone_secundario varchar(25))

-- Tabela temporária @Usuarios
declare @Usuarios table(linha int, ctcli_concessao char(15), usuario char(50), codigo_externo char(255)
						, cpf char(11), nome char(255), email char(255), telefone varchar(25), celular varchar(25)
						, canal char(50), papel char(50))

-- Tabela temporária @Clientes 
declare @Clientes table(linha numeric(10) identity, CodigoCliFor char(14), ctcli_concessao char(15), cpf_cnpj char(14), tipo_pessoa char(20)
						, codigo_externo char(255), canal char(20), nome char(255), nome_fantasia char(255)
						, tipo_logradouro char(255), logradouro char(255), numero char(255), complemento char(255), cep char(8)
						, cidade char(255), uf char(2), telefone_principal char(25), telefone_secundario char(25)
						, celular char(25), fax char(25), email char(255), rg char(255)
						, inscricao_estadual char(255), ramo_atividade char(255), contribuinte_icms char(17), produtor_rural char(14)
						, nome_contato char(255), cargo_contato char(255), telefone_contato char(25), celular_contato char(25)
						, nextel_contato char(25), email_contato char(255))
						

-- Tabela temporária @Faturamento
declare @Faturamento table(linha numeric(10) identity, conta_concessionario varchar(8), numero_nota_fiscal dtInteiro12, codigo_venda varchar(6), 
							data_nota_fiscal varchar(10), nome_cliente varchar(255), tipo_pessoa varchar(20), cpf_cnpj varchar(20),
							cep varchar(8), cidade varchar(255), uf varchar(2), ddd varchar(25), telefone varchar(25),
							vin varchar(30), modelo varchar(100), ano_modelo varchar(4), placa_veiculo varchar(20), numero_peca varchar(255),
							qtde_venda numeric(10), valor_venda numeric(14,2), codigo_vendedor varchar(255),
							classificacao_peca varchar(50), descricao_peca varchar(100),
							canal_venda varchar(11), codigo_ibge_cidade varchar(18))


--declare @Faturamento_Agrup table(linha numeric(10) identity, conta_concessionario varchar(8), numero_nota_fiscal dtInteiro12, codigo_venda varchar(6), 
--							data_nota_fiscal varchar(10), nome_cliente varchar(255), tipo_pessoa varchar(20), cpf_cnpj varchar(20),
--							cep varchar(8), cidade varchar(255), uf varchar(2), ddd varchar(25), telefone varchar(25),
--							vin varchar(30), modelo varchar(100), ano_modelo varchar(4), placa_veiculo varchar(20), numero_peca varchar(255),
--							qtde_venda varchar(30), valor_venda dtValorMonetario, codigo_vendedor varchar(255),
--							classificacao_peca varchar(50), descricao_peca varchar(100),
--							canal_venda varchar(11), codigo_ibge_cidade varchar(18))

declare @Faturamento_Agrup table( numero_nota_fiscal dtInteiro12, numero_peca varchar(255),
							qtde_venda numeric(10), valor_venda numeric (14,2))


declare @FaturamentoFinal table(linha numeric(10) identity, conta_concessionario varchar(8), numero_nota_fiscal dtInteiro12, codigo_venda varchar(6), 
							data_nota_fiscal varchar(10), nome_cliente varchar(255), tipo_pessoa varchar(20), cpf_cnpj varchar(20),
							cep varchar(8), cidade varchar(255), uf varchar(2), ddd varchar(25), telefone varchar(25),
							vin varchar(30), modelo varchar(100), ano_modelo varchar(4), placa_veiculo varchar(20), numero_peca varchar(255),
							qtde_venda numeric(10), valor_venda numeric(14,2), codigo_vendedor varchar(255),
							classificacao_peca varchar(50), descricao_peca varchar(100),
							canal_venda varchar(11), codigo_ibge_cidade varchar(18))
							
---------------------------------------------------------------------------------------------------
-- CONCESSAO
---------------------------------------------------------------------------------------------------
if @Arquivo = 'CONCESSAO' begin

	-- Gerar linha cabeçalho
	insert into @Concessao
	select	'1', 'ctcli', 'dms', 'cnpj', 'inscricao_estadual', 'nome', 'razao_social'
			, 'tipo_logradouro', 'logradouro', 'numero', 'complemento'
			, 'cep', 'cidade', 'uf', 'telefone_principal', 'telefone_secundario'


	-- Gerar linha detalhe
	insert into @Concessao
	select	linha = '2'
			, ctcli = l.ContaConcessao
			, dms = 'TSystems'
			, cnpj = l.CGCLocal
			, inscricao_estadual = l.InscricaoEstadualLocal
			, nome = e.NomeFantasiaEmpresa
			, razao_social = e.RazaoSocialEmpresa
			, tipo_logradouro = ''
			, logradouro = l.RuaLocal
			, numero = l.NumeroEndLocal
			, complemento = l.ComplementoEndLocal
			, cep = l.CEPLocal
			, cidade = l.MunicipioLocal
			, uf = l.UFLocal
			, telefone_principal = '(' + isnull(convert(varchar(2), convert(numeric(4), l.DDDLocal)), '') + ')' + isnull(l.TelefoneLocal, '')
			, telefone_secundario = '(' + isnull(convert(varchar(2), convert(numeric(4), l.DDDLocal)), '') + ')' + isnull(l.TelefoneLocal, '')
	--		, *
	from tbEmpresa e with (nolock)
	inner join tbLocal l with (nolock) on e.CodigoEmpresa = l.CodigoEmpresa
	where l.CodigoEmpresa = @CodigoEmpresa
	and l.CodigoLocal = @CodigoLocal

	-- Retorno do select
	select	LinhaTexto =	ltrim(rtrim(isnull(ctcli, ''))) + ';' +
							ltrim(rtrim(isnull(dms, ''))) + ';' +
							ltrim(rtrim(isnull(cnpj, ''))) + ';' +
							ltrim(rtrim(isnull(inscricao_estadual, ''))) + ';' +
							ltrim(rtrim(isnull(nome, ''))) + ';' +
							ltrim(rtrim(isnull(razao_social, ''))) + ';' +
							ltrim(rtrim(isnull(tipo_logradouro, ''))) + ';' +
							ltrim(rtrim(isnull(logradouro, ''))) + ';' +
							ltrim(rtrim(isnull(numero, ''))) + ';' +
							ltrim(rtrim(isnull(complemento, ''))) + ';' +
							ltrim(rtrim(isnull(cep, ''))) + ';' +
							ltrim(rtrim(isnull(cidade, ''))) + ';' +
							ltrim(rtrim(isnull(uf, ''))) + ';' +
							ltrim(rtrim(isnull(telefone_principal, '')))  + ';' +
							ltrim(rtrim(isnull(telefone_secundario, '')))  + ';' 
	from @Concessao 
	order by linha
end



---------------------------------------------------------------------------------------------------
-- USUARIOS
---------------------------------------------------------------------------------------------------
if @Arquivo = 'USUARIOS' begin

	-- Gerar linha cabeçalho
	insert into @Usuarios
	select '1', 'ctcli_concessao', 'usuario', 'codigo_externo', 'cpf', 'nome', 'email', 'telefone', 'celular', 'canal', 'papel'

	
	-- Gerar linha detalhe
	insert into @Usuarios
	select	distinct 
			linha = '2'
		
			, ctcli_concessao = l.ContaConcessao
			, usuario = left(rc.NomeRepresentante, 50)
			, codigo_externo = rc.CodigoRepresentante
			, cpf = rc.CPFRepresentante
			, nome = rc.NomeRepresentante

			, email		=	case	when isnull(r.NumeroRegistro, 0) > 0 
										then	(	select colend.EMailColaborador 
													from tbColaborador col with (nolock)
													inner join tbColaboradorEndereco colend with (nolock) on colend.CodigoEmpresa = col.CodigoEmpresa and colend.CodigoLocal = col.CodigoLocal and colend.TipoColaborador = col.TipoColaborador and colend.NumeroRegistro = col.NumeroRegistro	
													where col.CodigoEmpresa = l.CodigoEmpresa and col.CodigoLocal = l.CodigoLocal and col.TipoColaborador = r.TipoColaborador and col.NumeroRegistro = r.NumeroRegistro )
									when isnull(r.NumeroRegistro, 0) <= 0 
										then	rend.EMailRepresen
									else '???'
							end

			, telefone	=	case	when isnull(r.NumeroRegistro, 0) > 0 
										then	(	select '(' + isnull(convert(varchar(4), convert(numeric(4), colend.DDDColaborador)), '') + ')' + isnull(colend.TelefoneColaborador, '')
													from tbColaborador col with (nolock) 
													inner join tbColaboradorEndereco colend with (nolock) on colend.CodigoEmpresa = col.CodigoEmpresa and colend.CodigoLocal = col.CodigoLocal and colend.TipoColaborador = col.TipoColaborador and colend.NumeroRegistro = col.NumeroRegistro	
													where col.CodigoEmpresa = l.CodigoEmpresa and col.CodigoLocal = l.CodigoLocal and col.TipoColaborador = r.TipoColaborador and col.NumeroRegistro = r.NumeroRegistro )
									when isnull(r.NumeroRegistro, 0) <= 0 
										then	'(' + isnull(convert(varchar(4), convert(numeric(4), rend.DDDTelefoneRepresentante)), '') + ')' + isnull(rend.TelefoneRepresentante, '')
									else '???'
							end

			, celular	=	case	when isnull(r.NumeroRegistro, 0) > 0 
										then	(	select '(' + isnull(convert(varchar(4), convert(numeric(4), colend.DDDTelefoneCelularColaborador)), '') + ')' + isnull(colend.TelefoneCelularColaborador, '')
													from tbColaborador col with (nolock)
													inner join tbColaboradorEndereco colend with (nolock) on colend.CodigoEmpresa = col.CodigoEmpresa and colend.CodigoLocal = col.CodigoLocal and colend.TipoColaborador = col.TipoColaborador and colend.NumeroRegistro = col.NumeroRegistro	
													where col.CodigoEmpresa = l.CodigoEmpresa and col.CodigoLocal = l.CodigoLocal and col.TipoColaborador = r.TipoColaborador and col.NumeroRegistro = r.NumeroRegistro )
									when isnull(r.NumeroRegistro, 0) <= 0 
										then	'(' + isnull(convert(varchar(4), convert(numeric(4), rend.DDDCelularRepresen)), '') + ')' + isnull(rend.CelularRepresen, '')
									else '???'
							end

			, canal =	case	
								-------------------------------------------------------------------
								-- Listar usuários que fazem venda no FT:BALCAO + TK:TELEPECAS
								-------------------------------------------------------------------
								when 
										(	
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) 
														on cdoc.CodigoEmpresa = dft.CodigoEmpresa and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento 
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento and cdoc.CodigoCliFor = dft.CodigoCliFor 
														and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)
											
											or exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa and docrec.CodigoLocal = dft.CodigoLocal 
														and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento and docrec.NumeroDocumento = dft.NumeroDocumento 
														and docrec.DataDocumento = dft.DataDocumento and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
										)

										and
										
										(	
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) 
														on cdoc.CodigoEmpresa = dft.CodigoEmpresa and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento 
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento and cdoc.CodigoCliFor = dft.CodigoCliFor 
														and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)

											or exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa and docrec.CodigoLocal = dft.CodigoLocal 
														and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento and docrec.NumeroDocumento = dft.NumeroDocumento 
														and docrec.DataDocumento = dft.DataDocumento and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
										)
										
										then	'BALCAO, TELEPECAS' 
								

								-------------------------------------------------------------------
								-- Listar usuários que fazem venda apenas no FT:BALCAO
								-------------------------------------------------------------------
								when 
										(	
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) on cdoc.CodigoEmpresa = dft.CodigoEmpresa 
														and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento 
														and cdoc.CodigoCliFor = dft.CodigoCliFor and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)
											
											or exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
														and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
														and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
										)

										and
										
											not 
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) on cdoc.CodigoEmpresa = dft.CodigoEmpresa 
														and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento 
														and cdoc.CodigoCliFor = dft.CodigoCliFor and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)

										and
										
											not
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
														and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
														and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
										
										
										then	'BALCAO' 
																		
								-------------------------------------------------------------------
								-- Listar usuários que fazem venda apenas no TK:TELEMARKETING
								-------------------------------------------------------------------
								when 
										not exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) on cdoc.CodigoEmpresa = dft.CodigoEmpresa 
														and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento 
														and cdoc.CodigoCliFor = dft.CodigoCliFor and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)
										
										and
										
										not exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
														and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
														and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'FT'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
										
										and
											(
											
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbComissaoDocumento cdoc with (nolock) on cdoc.CodigoEmpresa = dft.CodigoEmpresa 
														and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento 
														and cdoc.CodigoCliFor = dft.CodigoCliFor and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where dft.CodigoEmpresa = r.CodigoEmpresa
														and dft.CodigoLocal = l.CodigoLocal 
														and dft.EntradaSaidaDocumento in ('E','S') 
														and dft.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and cdoc.CodigoRepresentante = r.CodigoRepresentante)

											or
											exists (	select 1
														from tbDocumentoFT dft with (nolock)
														inner join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
														and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
														and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
														and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
														where docrec.CodigoEmpresa = r.CodigoEmpresa
														and docrec.CodigoLocal = l.CodigoLocal 
														and docrec.EntradaSaidaDocumento in ('E','S') 
														and docrec.TipoLancamentoMovimentacao <> 11
														and dft.OrigemDocumentoFT = 'TK'
														and docrec.CodigoRepresentante = r.CodigoRepresentante)
											)
										
										then	'TELEPECAS' 
						
						end	
								

			, papel =			-- VENDEDOR, GERENTE ou ASSISTENTE
						case	when exists (	select 1 from tbUsuarios usu with (nolock) 
												inner join tbUsuarioFT uft with (nolock) on uft.CodigoUsuario = usu.CodigoUsuario 
												where usu.AdministradorSistema = 'V'
												and uft.CodigoRepresentante = r.CodigoRepresentante)
									then 'GERENTE'
							
								when exists (	select 1 from tbUsuarios usu with (nolock) 
												inner join tbUsuarioFT uft with (nolock) on uft.CodigoUsuario = usu.CodigoUsuario
												where usu.AdministradorSistema = 'F'
												and uft.CodigoRepresentante = r.CodigoRepresentante)
									then 'VENDEDOR'
						
								else 'ASSISTENTE'
						end
	
	from tbEmpresa e with (nolock)
	inner join tbLocal l with (nolock) on e.CodigoEmpresa = l.CodigoEmpresa
	inner join tbRepresentante r with (nolock) on r.CodigoEmpresa = e.CodigoEmpresa
	left join tbRepresentanteComplementar rc with (nolock) on rc.CodigoEmpresa = r.CodigoEmpresa and rc.CodigoRepresentante = r.CodigoRepresentante
	left join tbRepresentanteEndereco rend with (nolock) on rc.CodigoEmpresa = rend.CodigoEmpresa and rc.CodigoRepresentante = rend.CodigoRepresentante
	inner join tbUsuarioFT uft with (nolock) on uft.CodigoRepresentante = r.CodigoRepresentante
	
	where l.CodigoEmpresa = @CodigoEmpresa
	and l.CodigoLocal = @CodigoLocal

	
	
	-- Retorno do select
	if @Arquivo = 'USUARIOS' begin
		select LinhaTexto =		ltrim(rtrim(isnull(ctcli_concessao, ''))) + ';' +
								ltrim(rtrim(isnull(usuario, ''))) + ';' +
								ltrim(rtrim(isnull(codigo_externo, ''))) + ';' +
								ltrim(rtrim(isnull(cpf, ''))) + ';' +
								ltrim(rtrim(isnull(nome, ''))) + ';' +
								ltrim(rtrim(isnull(email, ''))) + ';' +
								ltrim(rtrim(isnull(telefone, ''))) + ';' +
								ltrim(rtrim(isnull(celular, ''))) + ';' +
								ltrim(rtrim(isnull(canal, ''))) + ';' +
								ltrim(rtrim(isnull(papel, ''))) + ';'
		from @Usuarios 
		order by linha
	end

end

---------------------------------------------------------------------------------------------------
-- FATURAMENTO
---------------------------------------------------------------------------------------------------
IF @Arquivo = 'FATURAMENTO' BEGIN


	-- Gerar linha cabeçalho
	--insert into @Faturamento
	--select	'ctcli_concessao', 'numero_nota', 'canal', 'data', 'nome_cliente', 'tipo_cliente', 'cpf_cnpj', 
	--		'cep', 'cidade', 'uf', 'ddd_telefone', 'telefone', 'chassi', 'modelo', 'ano', 'placa', 
	--		'codigo_peca', 'quantidade', 'valor', 'codigo_externo'


	-- Gerar linha detalhe
	insert into @Faturamento
	select	--distinct 
			--linha = '2',
			conta_concessionario = LEFT(CONVERT(VARCHAR(8),tbLocal.ContaConcessao),8),
			--numero_nota_fiscal = ltrim(rtrim(right(convert(char(8), 100000000 + tbItemDocumento.NumeroDocumento),8))),
			--numero_nota_fiscal = right(convert(char(13), 1000000000000 + tbItemDocumento.NumeroDocumento), 8),
			numero_nota_fiscal = left(convert(varchar(12), tbItemDocumento.NumeroDocumento), 8)   ,
			codigo_venda = ltrim(rtrim(case	when tbCentroCustoSistema.Sistema = 'BALCÃO' then 'BALCAO'
											when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' then 'TELEPE'					
											when tbDocumentoFT.OrigemDocumentoFT = 'FT' then 'BALCAO'
											when tbDocumentoFT.OrigemDocumentoFT = 'TK' then 'TELEPE'
											when tbDocumentoFT.OrigemDocumentoFT = 'OS' then tbDocumentoFT.CodigoCIT
											else '' end)),
			data_nota_fiscal = coalesce(convert(varchar(10),tbItemDocumento.DataDocumento,103), ''),
			nome_cliente =  ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(CONVERT(varCHAR(60),tbCliFor.NomeCliFor),60)
										else LEFT(CONVERT(varCHAR(60),tbClienteEventual.NomeCliEven),60)end)) ,
			tipo_pessoa = left(ltrim(rtrim(convert(char(1),tbCliFor.TipoCliFor))),1),
			cpf_cnpj =	 ltrim(rtrim(case when tbCliFor.TipoCliFor = 'J' and tbCliForJuridica.CGCJuridica <> 'ISENTO' then right('00000000000000' + ltrim(rtrim(tbCliForJuridica.CGCJuridica)), 14)
						when tbCliFor.TipoCliFor = 'F' and tbCliForFisica.CPFFisica <> 'ISENTO' then right('00000000000' + ltrim(rtrim(tbCliForFisica.CPFFisica)), 11)
						else right('00000000000' + ltrim(rtrim(tbDocumentoFT.CodigoClienteEventual)), 11) end)),
			cep =   ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(CONVERT(VARCHAR(8),tbCliFor.CEPCliFor),8)
										else LEFT(CONVERT(varCHAR(60),tbClienteEventual.CEPCliEven),8)end)) , 
			cidade =  ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(CONVERT(VARCHAR(40),tbCliFor.MunicipioCliFor),40)
										else LEFT(CONVERT(varCHAR(60),tbClienteEventual.MunicipioCliEven),40)end)) , 
			uf = ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(CONVERT(VARCHAR(2),tbCliFor.UFCliFor),2)
										else LEFT(CONVERT(varCHAR(60),tbClienteEventual.UnidadeFederacao),2)end)) , 
			ddd = ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(CONVERT(VARCHAR(3),tbCliFor.DDDTelefoneCliFor),3)
										else LEFT(CONVERT(varCHAR(60),tbClienteEventual.DDDTelefoneCliEven),3)end)) , 
			telefone =  ltrim(rtrim(case when tbCliFor.ClienteEventual = 'F'
										then LEFT(replace(replace(CONVERT(VARCHAR(9),tbCliFor.TelefoneCliFor), '-',''), '.', ''),9)
										else LEFT(replace(replace(CONVERT(VARCHAR(9),tbClienteEventual.TelefoneCliEven), '-',''), '.', ''),9)end)) , 
			vin = replace(ltrim(rtrim(case	when tbDocumentoFT.OrigemDocumentoFT = 'OS' then LEFT(CONVERT(VARCHAR(17),tbOROS.ChassiVeiculoOS),17) else '' end)), ';', ' '),
			modelo = replace(ltrim(rtrim(case when tbDocumentoFT.OrigemDocumentoFT = 'OS' then LEFT(CONVERT(VARCHAR(20),tbVeiculoOS.ModeloVeiculoOS),20) else '' end)), ';', ' '),
			ano_modelo = LEFT(CONVERT(VARCHAR(4),tbVeiculoOS.AnoModeloVeiculoOS),4) ,  
			placa_veiculo =	LEFT(lTRIM(RTRIM(convert(varchar(8), tbVeiculoOS.PlacaVeiculoOS))),3)  + '-' + RIGHT(lTRIM(RTRIM(convert(varchar(8), tbVeiculoOS.PlacaVeiculoOS))),4) ,
			numero_peca = replace(ltrim(rtrim(case	when tbItemDocumento.TipoRegistroItemDocto in ('PEC','CLO') then coalesce(convert(varchar(21),tbProdutoTabPrecoMBBras.CodigoProdutoTabPrecoMBBras),convert(varchar(21),tbItemDocumento.CodigoProduto))
								else	case when tbMaoObraOS.ClassificacaoDemonstrativoMOOS = 0 or left(tbItemDocumento.CodigoItemDocto,3) = 'ELE'
	 										then 'MOO'
											else		case when tbMaoObraOS.ClassificacaoDemonstrativoMOOS in (1,2) or left(tbItemDocumento.CodigoItemDocto,3) = 'TAP'
															then 'MOF'
															else 'OUTROS'
														end
										end
						  end)), ';', ' '),
			
			qtde_venda = tbItemDocumento.QtdeLancamentoItemDocto,

			
			valor_venda = case	-- Devolução
								when (tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'E' AND tbNaturezaOperacao.CodigoTipoOperacao = 7)
									then (tbItemDocumento.ValorContabilItemDocto * -1)
								-- Cancelamento Devolução Venda
								when tbDocumento.CondicaoNFCancelada = 'V' AND (tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'E' AND tbNaturezaOperacao.CodigoTipoOperacao = 7 )
									then tbItemDocumento.ValorContabilItemDocto
								-- Cancelamento Venda
								when tbDocumento.CondicaoNFCancelada = 'V' AND (tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'S' AND tbNaturezaOperacao.CodigoTipoOperacao in (3, 4))
									then 0	--(tbItemDocumento.ValorContabilItemDocto * -1)
								-- Venda
								else tbItemDocumento.ValorContabilItemDocto
							end,

			codigo_vendedor = left(convert(varchar(11), coalesce(	
			
									case	when tbDocumento.TipoLancamentoMovimentacao = 7
									and exists (	select 1 from tbComissaoDocumento cdoc with (nolock) 
															where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
															cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
															cdoc.EntradaSaidaDocumento in ('E','S') and
															cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
															cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
															cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
															cdoc.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao) 
												then (	select top 1 cdoc.CodigoRepresentante 
														from tbComissaoDocumento cdoc with (nolock) 
														where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
														cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
														cdoc.EntradaSaidaDocumento in ('E','S') and
														cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
														cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
														cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
														cdoc.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao)


											when tbDocumento.TipoLancamentoMovimentacao = 7
											and exists(select top 1 docrec.CodigoRepresentante 
														from tbDoctoReceberRepresentante docrec with (nolock) 
														where docrec.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
														docrec.CodigoLocal = tbDocumentoFT.CodigoLocal and
														docrec.EntradaSaidaDocumento in ('E','S') and
														docrec.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
														docrec.DataDocumento = tbDocumentoFT.DataDocumento and
														docrec.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
														docrec.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao)


														then (	select top 1 docrec.CodigoRepresentante 
																from tbDoctoReceberRepresentante docrec with (nolock) 
																where docrec.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
																docrec.CodigoLocal = tbDocumentoFT.CodigoLocal and
																docrec.EntradaSaidaDocumento in ('E','S') and
																docrec.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
																docrec.DataDocumento = tbDocumentoFT.DataDocumento and
																docrec.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
																docrec.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao)
												


										when tbDocumento.TipoLancamentoMovimentacao = 11
											and exists (	select 1 from tbComissaoDocumento cdoc with (nolock) 
															where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
															cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
															cdoc.EntradaSaidaDocumento in ('E','S') and
															cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
															--cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
															cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor)
												then (	select top 1 cdoc.CodigoRepresentante 
														from tbComissaoDocumento cdoc with (nolock) 
														where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
														cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
														cdoc.EntradaSaidaDocumento in ('E','S') and
														cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
														--cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
														cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
														cdoc.TipoLancamentoMovimentacao = 7)--tbDocumentoFT.TipoLancamentoMovimentacao)


											when tbDocumento.TipoLancamentoMovimentacao = 11
												and exists(select top 1 docrec.CodigoRepresentante 
														from tbDoctoReceberRepresentante docrec with (nolock) 
														where docrec.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
														docrec.CodigoLocal = tbDocumentoFT.CodigoLocal and
														docrec.EntradaSaidaDocumento in ('E','S') and
														docrec.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
														--docrec.DataDocumento = tbDocumentoFT.DataDocumento and
														docrec.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
														docrec.TipoLancamentoMovimentacao = 7)--tbDocumentoFT.TipoLancamentoMovimentacao)


														then (	select top 1 docrec.CodigoRepresentante 
																from tbDoctoReceberRepresentante docrec with (nolock) 
																where docrec.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
																docrec.CodigoLocal = tbDocumentoFT.CodigoLocal and
																docrec.EntradaSaidaDocumento in ('E','S') and
																docrec.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
																--docrec.DataDocumento = tbDocumentoFT.DataDocumento and
																docrec.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
																docrec.TipoLancamentoMovimentacao = 7)--tbDocumentoFT.TipoLancamentoMovimentacao)
												
											when exists (Select top 1 CodigoRepresentante  
															from	tbRepresentantePedido repped  (nolock)
															where repped.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															repped.CodigoLocal = tbDocumento.CodigoLocal and
															repped.CentroCusto = tbDocumentoFT.CentroCusto and
															repped.NumeroPedido = tbDocumento.NumeroPedidoDocumento
															and repped.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento)
													
													then	(Select top 1 CodigoRepresentante  
															from	tbRepresentantePedido repped  (nolock)
															where repped.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															repped.CodigoLocal = tbDocumento.CodigoLocal and
															repped.CentroCusto = tbDocumentoFT.CentroCusto and
															repped.NumeroPedido = tbDocumento.NumeroPedidoDocumento
															and repped.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento)

											when  exists (Select top 1 CodigoRepresentante  
															from	tbRepresentantePedido repped  (nolock)
															where repped.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															repped.CodigoLocal = tbDocumento.CodigoLocal and
															repped.CentroCusto = tbDocumentoFT.CentroCusto and
															repped.NumeroPedido = tbDocumento.NumeroPedidoDocumento)
													
													then	(Select top 1 CodigoRepresentante  
															from	tbRepresentantePedido repped  (nolock)
															where repped.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															repped.CodigoLocal = tbDocumento.CodigoLocal and
															repped.CentroCusto = tbDocumentoFT.CentroCusto and
															repped.NumeroPedido = tbDocumento.NumeroPedidoDocumento)

											when  exists (Select top 1 CodigoRepresentante  
															from	tbVendaPerdida vperd  (nolock)
															where vperd.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															vperd.CodigoLocal = tbDocumento.CodigoLocal and
															vperd.CentroCusto = tbDocumentoFT.CentroCusto and
															vperd.NumeroPedido = tbDocumento.NumeroPedidoDocumento)
													
													then	(Select top 1 CodigoRepresentante  
															from	tbVendaPerdida vperd  (nolock)
															where vperd.CodigoEmpresa = tbDocumento.CodigoEmpresa and
															vperd.CodigoLocal = tbDocumento.CodigoLocal and
															vperd.CentroCusto = tbDocumentoFT.CentroCusto and
															vperd.NumeroPedido = tbDocumento.NumeroPedidoDocumento)

										
											
											when exists (select 1 from tbDMSTransitoNFe dms 
														 inner join tbLocal loc on dms.CNPJ = loc.CGCLocal 														 
														 where loc.CodigoEmpresa = tbDocumento.CodigoEmpresa 
														 and loc.CodigoLocal = tbDocumento.CodigoLocal
														 and dms.NumeroDocumento = tbDocumento.NumeroDocumento 
														 and dms.CodigoCliFor = tbDocumento.CodigoCliFor
														 and dms.CodigoRetorno = 100
														 AND dms.StatusNFe = 'NFE'
														 AND CHARINDEX('VENDEDOR:', dms.XmlNFE) > 0)

													then (select top 1 
																LEFT(
																	REPLACE(LTRIM(RTRIM(SUBSTRING(dms.XmlNFE, CHARINDEX('VENDEDOR:', dms.XmlNFE) + 10 , 10))), ' ', '|')
																	,
																	CASE WHEN CHARINDEX('|', REPLACE(LTRIM(RTRIM(SUBSTRING(dms.XmlNFE, CHARINDEX('VENDEDOR:', dms.XmlNFE) + 10 , 10))), ' ', '|')) -1 > 0 
																		THEN CHARINDEX('|', REPLACE(LTRIM(RTRIM(SUBSTRING(dms.XmlNFE, CHARINDEX('VENDEDOR:', dms.XmlNFE) + 10 , 10))), ' ', '|')) -1
																		ELSE 1 END
																	)
													
														 from tbDMSTransitoNFe dms 
														 inner join tbLocal loc on dms.CNPJ = loc.CGCLocal 														 
														 where loc.CodigoEmpresa = tbDocumento.CodigoEmpresa 
														 and loc.CodigoLocal = tbDocumento.CodigoLocal
														 and dms.NumeroDocumento = tbDocumento.NumeroDocumento 
														 and dms.CodigoCliFor = tbDocumento.CodigoCliFor
														 and dms.CodigoRetorno = 100
														 AND dms.StatusNFe = 'NFE')
											end


										, (Select top 1 CodigoRepresentante  
											from tbRepresentantePedido repped  (nolock)
											where repped.CodigoEmpresa = tbDocumento.CodigoEmpresa 
											and repped.CodigoLocal = tbDocumento.CodigoLocal )
																			
																			
																			
															)), 11),
															
																				
			/*																							
			classificacao_peca =	ltrim(rtrim(case	when tbLinhaProduto.TipoLinhaProduto = 0 then 'Peças Originais'
														when tbLinhaProduto.TipoLinhaProduto = 1 then 'Motores Veiculares Originais'
														when tbLinhaProduto.TipoLinhaProduto = 2 then 'Agregados Originais'
														when tbLinhaProduto.TipoLinhaProduto = 3 then 'Peças de Outras Fontes'
														when tbLinhaProduto.TipoLinhaProduto = 4 then 'Acessórios'
														when tbLinhaProduto.TipoLinhaProduto = 5 then 'Motores Recondicionados'
														when tbLinhaProduto.TipoLinhaProduto = 6 then 'Lubrificantes'
														when tbLinhaProduto.TipoLinhaProduto = 7 then 'Pneus'
														when tbLinhaProduto.TipoLinhaProduto = 8 then 'Outros'
														when tbLinhaProduto.TipoLinhaProduto = 9 then 'OM (Outras Mercadorias)'
														else ''
												end)),			
			*/
			

				classificacao_peca =	ltrim(rtrim(case	when (tbLinhaProduto.TipoLinhaProduto in (0, 1, 2) and tbProdutoTabPrecoMBBras.OrigemTabela = 'CAMINHAO') then '1'					-- 1. Genuína C&O
														when (tbLinhaProduto.TipoLinhaProduto in (0, 1, 2) and tbProdutoTabPrecoMBBras.OrigemTabela = 'SPRINTER' or tbProdutoTabPrecoMBBras.OrigemTabela = 'MB180') then '2'			-- 2. Genuína Vans
														when (tbLinhaProduto.TipoLinhaProduto = 3  and tbProdutoTabPrecoMBBras.OrigemTabela in ('CAMINHAO','SPRINTER', 'MB180')) then '3'	-- 3. Alliance
														when (tbLinhaProduto.TipoLinhaProduto in (0,1,2,3) and tbProdutoTabPrecoMBBras.OrigemTabela IS NULL) then '5'    -- 5.Outras Fontes C&O
														when tbLinhaProduto.TipoLinhaProduto = 6 then '4'	-- 4. Lubrificantes			
														when (tbLinhaProduto.TipoLinhaProduto = 3 and tbProdutoTabPrecoMBBras.OrigemTabela in ('SPRINTER', 'MB180')) then '6'					-- 6. Outras Fontes Vans
														when tbLinhaProduto.TipoLinhaProduto = 7 then '7'																				-- 7. Pneus
														--when (tbLinhaProduto.TipoLinhaProduto in (0, 1, 2) and tbProdutoTabPrecoMBBras.OrigemTabela IS NULL) then ''					-- 1. Genuína C&O
																			
														else '8'																															-- 8.Outros
												end)),			

			descricao_peca = replace(left(ltrim(rtrim(coalesce(tbProduto.DescricaoProduto, ''))),100), ';', ' '),

			canal_venda = ltrim(rtrim(case	when tbLinhaProduto.TipoLinhaProduto = 7 then 'PNEUS'
											when tbCentroCustoSistema.Sistema = 'BALCÃO' then 'BALCAO'
											when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' then 'TELEPE'					
											when tbDocumentoFT.OrigemDocumentoFT = 'FT' then 'BALCAO'
											when tbDocumentoFT.OrigemDocumentoFT = 'TK' then 'TELEPE'
											when tbDocumentoFT.OrigemDocumentoFT = 'OS' then 'OFICIN'
											else ''
									 end)),
			
			-- codigo_ibge_cidade = ltrim(rtrim(coalesce(tbCEP.NumeroMunicipio, '0000000')))
			codigo_ibge_cidade = ltrim(rtrim(coalesce((select cep.NumeroMunicipio from tbCEP cep with (nolock) where cep.NumeroCEP = tbCliFor.CEPCliFor), '0000000')))

	from tbItemDocumento with (nolock)
	inner join tbEmpresa with (nolock) on tbEmpresa.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	inner join tbLocal with (nolock) on tbLocal.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and tbLocal.CodigoLocal = tbItemDocumento.CodigoLocal
	
	inner join tbCliFor with (nolock) on tbCliFor.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and tbCliFor.CodigoCliFor  = tbItemDocumento.CodigoCliFor
	left join tbCliForFisica with (nolock) on tbCliFor.CodigoEmpresa = tbCliForFisica.CodigoEmpresa and tbCliFor.CodigoCliFor  = tbCliForFisica.CodigoCliFor
	left join tbCliForJuridica with (nolock) on tbCliFor.CodigoEmpresa = tbCliForJuridica.CodigoEmpresa and tbCliFor.CodigoCliFor  = tbCliForJuridica.CodigoCliFor
	--inner join tbCEP (nolock) on tbCEP.NumeroCEP = tbCliFor.CEPCliFor
	
	inner join tbDocumentoFT with (nolock) on
		tbDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
		tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento and
		tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento and
		tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor and
		tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

	left join tbCentroCustoSistema with (nolock) on 
	    tbCentroCustoSistema.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
		tbCentroCustoSistema.CentroCusto = tbDocumentoFT.CentroCusto
		
	left join tbClienteEventual  with (nolock) on
		tbDocumentoFT.CodigoEmpresa = tbClienteEventual.CodigoEmpresa and
		tbDocumentoFT.CodigoClienteEventual = tbClienteEventual.CodigoClienteEventual

	inner join tbDocumento with (nolock) on
		tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
		tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
		tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
		tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
		tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

	inner join tbNaturezaOperacao with (nolock) on
		tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao

	left join tbPedidoOS with (nolock) on
		tbPedidoOS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbPedidoOS.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbPedidoOS.CentroCusto = tbDocumentoFT.CentroCusto and
		tbPedidoOS.NumeroPedido = tbDocumento.NumeroPedidoDocumento and
		tbPedidoOS.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento

	left join tbOROS with (nolock) on
		tbOROS.CodigoEmpresa = tbPedidoOS.CodigoEmpresa and
		tbOROS.CodigoLocal = tbPedidoOS.CodigoLocal and
		tbOROS.FlagOROS = 'S' and 
		tbOROS.NumeroOROS = tbPedidoOS.CodigoOrdemServicoPedidoOS

	left join tbVeiculoOS with (nolock) on
		tbVeiculoOS.CodigoEmpresa = tbPedidoOS.CodigoEmpresa and
		tbVeiculoOS.ChassiVeiculoOS = tbOROS.ChassiVeiculoOS

	left join tbMaoObraOS with (nolock) on
		tbMaoObraOS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and 
		tbMaoObraOS.CodigoMaoObraOS = tbItemDocumento.CodigoItemDocto

	left join tbProdutoTabPrecoMBBras with (nolock) on
		tbProdutoTabPrecoMBBras.CodigoProduto = tbItemDocumento.CodigoProduto and 
		tbProdutoTabPrecoMBBras.DataAtualizacao = (select top 1 pmbb1.DataAtualizacao
													from tbProdutoTabPrecoMBBras pmbb1
													where pmbb1.CodigoProduto = tbProdutoTabPrecoMBBras.CodigoProduto )

	left join tbProduto with (nolock) on
		tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 

	left join tbProdutoFT with (nolock) on
		tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto and
		tbProdutoFT.CodigoFonteFornecimento = isnull(@FonteFornecimento, tbProdutoFT.CodigoFonteFornecimento)
		
	left join tbLinhaProduto with (nolock) on
		tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa and
		tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto 
		-- and tbLinhaProduto.TipoLinhaProduto <> 7	-- tirar pneus, conf. docto Valentin ticket 241824 (recolocar pneus conf. Valentin email enviado Bruno)

	left join tbFonteFornecimento with (nolock) on
		tbFonteFornecimento.CodigoEmpresa = tbProdutoFT.CodigoEmpresa and
		tbFonteFornecimento.CodigoFonteFornecimento = tbProdutoFT.CodigoFonteFornecimento

	where tbItemDocumento.CodigoEmpresa 		= @CodigoEmpresa
	and   tbItemDocumento.CodigoLocal   		= @CodigoLocal
	and   tbItemDocumento.DataDocumento	 	BETWEEN @DataInicial and @DataFinal 
	--and   tbDocumento.CondicaoNFCancelada		= 'F'    ticket 270032
	--and	  tbDocumento.TipoLancamentoMovimentacao <> 11 
	--and   tbDocumento.EntradaSaidaDocumento		= 'S'
	and   tbDocumentoFT.OrigemDocumentoFT 		in ('FT','TK','OS')
	and   tbItemDocumento.TipoRegistroItemDocto	in ('PEC','CLO','MOB')

	---------------------------------------------------------------------------------------------------------------------
	-- CONSIDERAR DOCUMENTOS DE VENDA E DEVOLUÇÃO DE VENDAS - Ticket 104361 - MBB
	---------------------------------------------------------------------------------------------------------------------
	and	(	
			----------------------------------------------------------------------------------------
			-- VENDAS
			----------------------------------------------------------------------------------------
			(	tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'S'
				and	(	(	
							tbDocumentoFT.OrigemDocumentoFT = 'OS' 
							and (tbNaturezaOperacao.CodigoTipoOperacao = 3 or tbNaturezaOperacao.CodigoTipoOperacao = 10 )
							and tbOROS.ChassiVeiculoOS is not null
							and tbOROS.ChassiVeiculoOS <> ''
						)
						or 
						(	
							tbDocumentoFT.OrigemDocumentoFT in ('FT','TK') 
							and (tbNaturezaOperacao.CodigoTipoOperacao = 3 or tbNaturezaOperacao.CodigoTipoOperacao = 98)-- só venda tkt 104361
							and tbItemDocumento.TipoRegistroItemDocto <> 'MOB'
						)
					)
				
				and	(	(	
							tbItemDocumento.TipoRegistroItemDocto in ('PEC','CLO')
							and (tbNaturezaOperacao.CodigoTipoOperacao = 3 or tbNaturezaOperacao.CodigoTipoOperacao = 98)	-- só venda tkt 104361
							--and tbLinhaProduto.TipoLinhaProduto in (0,1,2) -- tem que aparecer todos os tipos de Linha Produto 208993
							and tbLinhaProduto.RecapagemLinhaProduto = 'F'
						) 
						or 
						(	tbItemDocumento.TipoRegistroItemDocto	= 'MOB'	)
					)
			)
		
		
		OR
			------------------------------------------------------------------------------------------
			---- DEVOLUÇÕES
			------------------------------------------------------------------------------------------
			(	(tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'E' and tbNaturezaOperacao.CodigoTipoOperacao = 7)
				
				and	(	(	
							tbDocumentoFT.OrigemDocumentoFT = 'OS' 
							and tbOROS.ChassiVeiculoOS is not null
							and tbOROS.ChassiVeiculoOS <> ''
						)
						or 
						(	
							tbDocumentoFT.OrigemDocumentoFT in ('FT','TK') 
							and tbItemDocumento.TipoRegistroItemDocto <> 'MOB'
						)
					)
				
				and	(	(	
							tbItemDocumento.TipoRegistroItemDocto in ('PEC','CLO')
							--and tbLinhaProduto.TipoLinhaProduto in (0,1,2) -- tem que aparecer todos os tipos de Linha Produto 208993
							and tbLinhaProduto.RecapagemLinhaProduto = 'F'
						) 
						or 
						(	tbItemDocumento.TipoRegistroItemDocto	= 'MOB'	)
					)
			)
		
		
		)


		----------------------------- Mover Vendedor Default caso a pesquisa principal não retorne
		update @Faturamento 
		set codigo_vendedor = (Select top 1 CodigoRepresentante  
								from tbRepresentantePedido repped  (nolock)
								where repped.CodigoEmpresa = @CodigoEmpresa 
								and repped.CodigoLocal = @CodigoLocal )
		where (coalesce(codigo_vendedor, '') = '' OR codigo_vendedor IS NULL or isnumeric(codigo_vendedor) <> 1)
		


		---------------------------------------------------------------- Excluir Clientes Inválidos
		--delete from @Faturamento where cpf_cnpj like '%ISENT%'
		
		--conta_concessionario, codigo_venda,
		--		data_nota_fiscal, nome_cliente, tipo_pessoa, cpf_cnpj, cep, cidade, uf, ddd, telefone, vin, modelo,
		--		ano_modelo, placa_veiculo, 	qtde_venda,  codigo_vendedor, classificacao_peca, descricao_peca
		--		canal_venda, codigo_ibge_cidade	
				
		insert into @Faturamento_Agrup(numero_nota_fiscal, numero_peca, qtde_venda , valor_venda )
		select numero_nota_fiscal, numero_peca, sum(qtde_venda), sum (valor_venda)
		from @Faturamento
		group by numero_nota_fiscal, numero_peca
		--order by numero_nota_fiscal, numero_peca
		
		
		insert into @FaturamentoFinal
		select distinct Fat.conta_concessionario,
				 Fat.numero_nota_fiscal,
				 Fat.codigo_venda, 	
				 Fat.data_nota_fiscal,
				 Fat.nome_cliente,
				 Fat.tipo_pessoa,
				 Fat.cpf_cnpj,
				 Fat.cep,
				 Fat.cidade, 
				 Fat.uf,
				 Fat.ddd, 
				 Fat.telefone,
				 Fat.vin,
				 Fat.modelo,
				 Fat.ano_modelo,
				 Fat.placa_veiculo,
				 Fat.numero_peca,
				 FatAgrup.qtde_venda,
				 FatAgrup.valor_venda,
				 Fat.codigo_vendedor,
				 Fat.classificacao_peca,
				 Fat.descricao_peca,
				 Fat.canal_venda,
				 Fat.codigo_ibge_cidade
		from @Faturamento as Fat
		inner join @Faturamento_Agrup as FatAgrup on
		Fat.numero_nota_fiscal =  FatAgrup.numero_nota_fiscal and
		Fat.numero_peca = FatAgrup.numero_peca 
		--order by convert(bigint, Fat.numero_nota_fiscal), linha
		
		--select * from @Faturamento
		
		
		select LinhaTexto =		ltrim(rtrim(coalesce(conta_concessionario, ' '))) + ';' +
								ltrim(rtrim(coalesce(numero_nota_fiscal, ' '))) + ';' +
								ltrim(rtrim(coalesce(codigo_venda, ' '))) + ';' +
								ltrim(rtrim(coalesce(data_nota_fiscal, ' '))) + ';' +
								ltrim(rtrim(coalesce(nome_cliente, ' '))) + ';' +
								ltrim(rtrim(coalesce(tipo_pessoa, ' '))) + ';' +
								ltrim(rtrim(coalesce(cpf_cnpj, ' '))) + ';' +
								ltrim(rtrim(coalesce(cep, ' '))) + ';' +
								ltrim(rtrim(coalesce(cidade, ' '))) + ';' +
								ltrim(rtrim(coalesce(uf, ' '))) + ';' +
								ltrim(rtrim(coalesce(ddd, ' '))) + ';' +
								ltrim(rtrim(coalesce(telefone, ' '))) + ';' +
								ltrim(rtrim(coalesce(vin, ' '))) + ';' +
								ltrim(rtrim(coalesce(modelo, ' '))) + ';' +
								ltrim(rtrim(coalesce(ano_modelo, ' '))) + ';' +
								ltrim(rtrim(coalesce(placa_veiculo, ' '))) + ';' +
								ltrim(rtrim(coalesce(numero_peca, ' '))) + ';' +
								ltrim(rtrim(coalesce(qtde_venda, ' '))) + ';' +
								ltrim(rtrim(replace(coalesce(valor_venda, ' '),'.',','))) + ';' +
								ltrim(rtrim(coalesce(codigo_vendedor, ' '))) + ';' +
								ltrim(rtrim(coalesce(classificacao_peca, ' '))) + ';' +
								ltrim(rtrim(coalesce(descricao_peca, ' '))) + ';' +
								ltrim(rtrim(coalesce(canal_venda, ' '))) + ';' +
								ltrim(rtrim(coalesce(case when codigo_ibge_cidade = '9999999'   -- alteração ewerton 269989 
									then ' '
									 else codigo_ibge_cidade
								end ,' ')))   


		from @FaturamentoFinal 
		----where cpf_cnpj <> 'ISENTO'
		order by convert(bigint, numero_nota_fiscal), linha
		


END



---------------------------------------------------------------------------------------------------
-- CLIENTES ou CONTATOS ou VENDEDORES
---------------------------------------------------------------------------------------------------
IF @Arquivo = 'CLIENTES' or @Arquivo = 'CONTATOS' or @Arquivo = 'CARTEIRA' BEGIN

	------------------------------------------------------------------------- Gerar linha cabeçalho
	insert into @Clientes
	select   'CodigoCliFor', 'ctcli_concessao', 'cpf_cnpj', 'tipo_pessoa', 'codigo_externo', 'canal', 'nome', 'nome_fantasia'
			, 'tipo_logradouro', 'logradouro', 'numero', 'complemento', 'cep', 'cidade', 'uf'
			, 'telefone_principal', 'telefone_secundario', 'celular', 'fax', 'email', 'rg', 'inscricao_estadual'
			, 'ramo_atividade', 'contribuinte_icms', 'produtor_rural'
			, 'nome_contato', 'cargo_contato', 'telefone_contato', 'celular_contato', 'nextel_contato', 'email_contato'
	
	
	-------------------------------------------------------------- Gerar linha detalhe de @Clientes
	insert into @Clientes
	select 	  CodigoCliFor = cf.CodigoCliFor
			, ctcli_concessao = l.ContaConcessao
			, cpf_cnpj = case	when cf.TipoCliFor = 'J' then right('00000000000000' + ltrim(rtrim(cfj.CGCJuridica)), 14)
								when cf.TipoCliFor = 'F' then right('00000000000' + ltrim(rtrim(cff.CPFFisica)), 11)
								else 'ISENTO'
						 end
			, tipo_pessoa = cf.TipoCliFor
			, codigo_externo = '???'
			, canal = '???'
			, nome = cf.NomeCliFor
			, nome_fantasia = isnull(isnull(cf.NomeUsualCliFor, cf.AbreviaturaCliFor),cf.NomeCliFor)
			, tipo_logradouro = ''
			, logradouro = cf.RuaCliFor
			, numero = cf.NumeroEndCliFor
			, complemento = cf.ComplementoEndCliFor
			, cep = cf.CEPCliFor
			, cidade = cf.MunicipioCliFor
			, uf = cf.UFCliFor			
			, telefone_principal = '(' + isnull(convert(varchar(4), convert(numeric(4), cf.DDDTelefoneCliFor)), '') + ')' + replace(isnull(cf.TelefoneCliFor, ''), '-', '')
			, telefone_secundario = ''
			, celular = replace('(' + isnull(convert(varchar(4), convert(numeric(4), cf.DDDCelularCliFor)), '') + ')' + replace(isnull(cf.CelularCliFor, ''), '-',''), '-','')
			, fax = replace('(' + isnull(convert(varchar(4), convert(numeric(4), cf.DDDFaxCliFor)), '') + ')' + replace(isnull(cf.FaxCliFor, ''), '-',''), '-','')
			, email = isnull(isnull(cf.EmailCliFor, cf.EmailNFe), '')
			, rg = isnull(cff.RGFisica, '')
			, inscricao_estadual = isnull(cfj.InscricaoEstadualJuridica,'')
			, ramo_atividade = isnull(case when cf.TipoCliFor = 'F' then atv_cff.DescricaoAtividade when cf.TipoCliFor = 'J' then atv_cff.DescricaoAtividade end, '')
			, contribuinte_icms = case when cc.ContribuinteICMS = 'V' then 'S' else 'N' end
			, produtor_rural = case when cf.InscrEstadualProdutorRural is null or ltrim(rtrim(cf.InscrEstadualProdutorRural)) = '' then 'N' else 'S' end
	
			, nome_contato = isnull(cf.NomeContatoCliFor, cf.NomeCliFor)
			, cargo_contato = coalesce(cf.FuncaoContatoCliFor, '')
			, telefone_contato = '(' + isnull(convert(varchar(4), convert(numeric(4), cf.DDDTelefoneCliFor)), '') + ')' + replace(isnull(cf.TelefoneCliFor, ''), '-', '')
			, celular_contato = replace('(' + isnull(convert(varchar(4), convert(numeric(4), cf.DDDCelularCliFor)), '') + ')' + replace(isnull(cf.CelularCliFor, ''), '-',''), '-','')
			, nextel_contato = ''
			, email_contato = isnull(isnull(cf.EmailCliFor, cf.EmailNFe), '')
	
	from tbEmpresa e with (nolock)
	inner join tbLocal l with (nolock) on e.CodigoEmpresa = l.CodigoEmpresa
	inner join tbCliFor cf with (nolock) on cf.CodigoEmpresa = e.CodigoEmpresa
	left join tbClienteComplementar cc with (nolock) on cc.CodigoEmpresa = cf.CodigoEmpresa and cc.CodigoCliFor = cf.CodigoCliFor
	left join tbCliForFisica cff with (nolock) on cff.CodigoEmpresa = cf.CodigoEmpresa and cff.CodigoCliFor = cf.CodigoCliFor
	left join tbCliForJuridica cfj with (nolock) on cfj.CodigoEmpresa = cf.CodigoEmpresa and cfj.CodigoCliFor = cf.CodigoCliFor
	left join tbAtividade atv_cff with (nolock) on atv_cff.CodigoAtividade = cff.CodigoAtividade
	left join tbAtividade atv_cfj with (nolock) on atv_cfj.CodigoAtividade = cfj.CodigoAtividade
	where cf.ClienteEventual = 'F'
	and cf.CodigoEmpresa = @CodigoEmpresa
	and l.CodigoEmpresa = @CodigoEmpresa
	and l.CodigoLocal = @CodigoLocal
	and cf.ClassificacaoCliFor in ('C', 'A')

	-------------------------------------------------------------------- Excluir Clientes Inválidos
	--select count(*) from @Clientes where cpf_cnpj like '%ISENT%'

	delete from @Clientes where cpf_cnpj like '%ISENT%'

	--select count(*) from @Clientes where cpf_cnpj like '%ISENT%'

	
	---------------------------- Processar @Clientes, campos codigo_externo = '???' e canal = '???'
	while exists (select * from @Clientes where codigo_externo = '???' or canal = '???') begin
		
		select @codigo_externo = '', @canal = '', @canal1 = ''

		-------------------------------------- Pesquisa o 1º Cliente para pesquisa do Representante
		select	top 1 @linha = linha, @CodigoCliFor = CodigoCliFor from @Clientes where codigo_externo = '???' or canal = '???'		
		
		-------------------------------------------------------------------- Pegar Vendedor e Canal
		select	top 1 
				  @codigo_externo = isnull(cdoc.CodigoRepresentante, docrec.CodigoRepresentante)
				, @canal =	case	when tbCentroCustoSistema.Sistema = 'BALCÃO' then 'BALCAO'
									when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' then 'TELEPECAS'
									when dft.OrigemDocumentoFT = 'FT' then 'BALCAO' 
									when dft.OrigemDocumentoFT = 'TK' then 'TELEPECAS' 
									else '' end 
				, @Quantidade = COUNT(*)		
		from tbDocumentoFT dft with (nolock)		
		left join tbCentroCustoSistema with (nolock) on 
			tbCentroCustoSistema.CodigoEmpresa = dft.CodigoEmpresa and
			tbCentroCustoSistema.CentroCusto = dft.CentroCusto
		left join tbComissaoDocumento cdoc with (nolock) 
			on cdoc.CodigoEmpresa = dft.CodigoEmpresa and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento 
			and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento and cdoc.CodigoCliFor = dft.CodigoCliFor 
			and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
		left join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
			and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
			and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
			and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
		where dft.CodigoEmpresa = @CodigoEmpresa
		and dft.CodigoLocal = @CodigoLocal 
		and dft.EntradaSaidaDocumento in ('E','S') 
		and dft.TipoLancamentoMovimentacao <> 11	
		and dft.OrigemDocumentoFT in ('FT', 'TK')
		and dft.CodigoCliFor = convert(numeric(14), @CodigoCliFor)
		and isnull(cdoc.CodigoRepresentante, docrec.CodigoRepresentante) is not null
		group by isnull(cdoc.CodigoRepresentante, docrec.CodigoRepresentante), dft.OrigemDocumentoFT, tbCentroCustoSistema.Sistema --, cdoc.CodigoRepresentante, docrec.CodigoRepresentante
		order by 2 desc		
		
		
		---- Verificar se o Cliente / Vendedor esta em outro canal... para concatenar um novo canal
		select	top 1 
				@canal1 =	case	when tbCentroCustoSistema.Sistema = 'BALCÃO' then 'BALCAO'
									when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' then 'TELEPECAS'
									when dft.OrigemDocumentoFT = 'FT' then 'BALCAO' 
									when dft.OrigemDocumentoFT = 'TK' then 'TELEPECAS' 
									else '' end 
		from tbDocumentoFT dft with (nolock)
		left join tbCentroCustoSistema with (nolock) on 
			tbCentroCustoSistema.CodigoEmpresa = dft.CodigoEmpresa and
			tbCentroCustoSistema.CentroCusto = dft.CentroCusto
		left join tbComissaoDocumento cdoc with (nolock) 
			on cdoc.CodigoEmpresa = dft.CodigoEmpresa and cdoc.CodigoLocal = dft.CodigoLocal and cdoc.EntradaSaidaDocumento = dft.EntradaSaidaDocumento 
			and cdoc.NumeroDocumento = dft.NumeroDocumento and cdoc.DataDocumento = dft.DataDocumento and cdoc.CodigoCliFor = dft.CodigoCliFor 
			and cdoc.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
			and cdoc.CodigoRepresentante = convert(int, @codigo_externo)			
		left join tbDoctoReceberRepresentante docrec with (nolock) on docrec.CodigoEmpresa = dft.CodigoEmpresa 
			and docrec.CodigoLocal = dft.CodigoLocal and docrec.EntradaSaidaDocumento = dft.EntradaSaidaDocumento
			and docrec.NumeroDocumento = dft.NumeroDocumento and docrec.DataDocumento = dft.DataDocumento 
			and docrec.CodigoCliFor = dft.CodigoCliFor and docrec.TipoLancamentoMovimentacao = dft.TipoLancamentoMovimentacao
			and docrec.CodigoRepresentante = convert(int, @codigo_externo)			
		where dft.CodigoEmpresa = @CodigoEmpresa
		and dft.CodigoLocal = @CodigoLocal 
		and dft.EntradaSaidaDocumento in ('E','S') 
		and dft.TipoLancamentoMovimentacao <> 11	
		and dft.OrigemDocumentoFT <> case when @canal = 'BALCAO' then 'FT' when @canal = 'TELEPECAS' then 'TK' end
		and dft.CodigoCliFor = convert(numeric(14), @CodigoCliFor)		
		
		----------------------------------------------------------------------- Preparar o canal...
		if @canal1 <> '' select @canal = ltrim(rtrim(@canal)) + ',' + ltrim(rtrim(@canal1))		
		
		------------------------- Atualizar @codigo_externo (vendedor) e canal (BALCAO / TELEPECAS)
		update @Clientes 
		set codigo_externo = coalesce(@codigo_externo, ''), canal = coalesce(@canal, '') 
		where linha = @linha 
		
	end
	
	
	----------------------------------------------------------------------------- Retorno do select
	IF @Arquivo = 'CLIENTES' BEGIN
		select LinhaTexto =		ltrim(rtrim(isnull(ctcli_concessao, ''))) + ';' +
								ltrim(rtrim(isnull(cpf_cnpj, ''))) + ';' +
								ltrim(rtrim(isnull(tipo_pessoa, ''))) + ';' +
								ltrim(rtrim(isnull(codigo_externo, ''))) + ';' +			
								ltrim(rtrim(isnull(canal, ''))) + ';' +
								ltrim(rtrim(isnull(nome, ''))) + ';' +
								ltrim(rtrim(isnull(nome_fantasia, ''))) + ';' +
								ltrim(rtrim(isnull(tipo_logradouro, ''))) + ';' +
								ltrim(rtrim(isnull(logradouro, ''))) + ';' +
								ltrim(rtrim(isnull(numero, ''))) + ';' +
								ltrim(rtrim(isnull(complemento, ''))) + ';' +
								ltrim(rtrim(isnull(cep, ''))) + ';' +
								ltrim(rtrim(isnull(cidade, ''))) + ';' +
								ltrim(rtrim(isnull(uf, ''))) + ';' +
								ltrim(rtrim(isnull(telefone_principal, ''))) + ';' +
								ltrim(rtrim(isnull(telefone_secundario, ''))) + ';' +
								ltrim(rtrim(isnull(celular, ''))) + ';' +
								ltrim(rtrim(isnull(fax, ''))) + ';' +
								ltrim(rtrim(isnull(email, ''))) + ';' +
								ltrim(rtrim(isnull(rg, ''))) + ';' +
								ltrim(rtrim(isnull(inscricao_estadual, ''))) + ';' +
								ltrim(rtrim(isnull(ramo_atividade, ''))) + ';' +
								ltrim(rtrim(isnull(contribuinte_icms, ''))) + ';' +
								ltrim(rtrim(isnull(produtor_rural, ''))) + ';'
		from @Clientes 
		order by linha
	END
	
	----------------------------------------------------------------------------- Retorno do select
	IF @Arquivo = 'CONTATOS' BEGIN
		update @Clientes 
		set tipo_pessoa = 'tipo_pessoa_cliente', nome_contato = 'nome', cargo_contato = 'cargo', telefone_contato = 'telefone', celular_contato = 'celular', nextel_contato = 'nextel', email_contato = 'email'
		where linha = 1
		
		select LinhaTexto =		ltrim(rtrim(isnull(ctcli_concessao, ''))) + ';' +
								ltrim(rtrim(isnull(cpf_cnpj, ''))) + ';' +
								ltrim(rtrim(isnull(tipo_pessoa, ''))) + ';' +
								ltrim(rtrim(isnull(canal, ''))) + ';' +
								ltrim(rtrim(isnull(nome_contato, ''))) + ';' +
								ltrim(rtrim(isnull(cargo_contato, ''))) + ';' +
								ltrim(rtrim(isnull(telefone_contato, ''))) + ';' +
								ltrim(rtrim(isnull(celular_contato, ''))) + ';' +
								ltrim(rtrim(isnull(nextel_contato, ''))) + ';' +
								ltrim(rtrim(isnull(email_contato, ''))) + ';'
		from @Clientes 
		order by linha

	END
	
	----------------------------------------------------------------------------- Retorno do select
	IF @Arquivo = 'CARTEIRA' BEGIN
		select LinhaTexto =		ltrim(rtrim(isnull(codigo_externo, ''))) + ';' +
								ltrim(rtrim(isnull(cpf_cnpj, ''))) + ';'
		from @Clientes 
		where ltrim(rtrim(isnull(codigo_externo, ''))) <> ''
		order by linha
	END

END

set nocount off



go
grant execute on dbo.whDPMAXPecas to SQLUsers


