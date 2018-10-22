  
alter PROCEDURE dbo.whCEMovimentacaoEstoqueDIMS  
  
/*INICIO_CABEC_PROC  
-------------------------------------------------------------------------------------------------------------------------  
 EMPRESA......: T-Systems do Brasil  
 PROJETO......: CE - Controle de Estoques  
 AUTOR........: Carlos JSC  
 DATA.........: 27/02/2012  
 UTILIZADO EM : CE - DIMS  
 OBJETIVO.....: Listar os registros de movimentacao de estoque da tbItemDocumento e os  
    registros de transferencia da tbRegistroMovtoEstoque de acordo com os   
    parametros, para geração   
  
delete tbItemDocumentoDIMS  
go  
whCEMovimentacaoEstoqueDIMS 1608,0,'2013-12-23','2013-12-23',2  
  
select * from tbEncomenda where DataEncomenda = '2013-12-23'  
select * from tbProduto where CodigoEmpresa = 1608  
select * from tbItemDocumento where DataDocumento between  '2013-12-16' and '2013-12-16'  
  
EXECUTE whCEMovimentacaoEstoqueDIMS @CodigoEmpresa = 1608,@CodigoLocal = 0,@DataInicial = '2012-12-14',@DataFinal = '2012-12-15',@TipoEnvio = 2  

EXECUTE whCEMovimentacaoEstoqueDIMS @CodigoEmpresa = 3140,@CodigoLocal = 0,@DataInicial = '2018-04-17',@DataFinal = '2018-04-18',@TipoEnvio = 2
  
-------------------------------------------------------------------------------------------------------------------------  
FIM_CABEC_PROC*/  
 @CodigoEmpresa   dtInteiro04,  
 @CodigoLocal    dtInteiro04,  
 @DataInicial   datetime,  
 @DataFinal    datetime,  
 @TipoEnvio    int  
  
AS   
  
----SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
----- Variaveis do Cursor ----------2-----------------------------------------------------  
DECLARE @auxErroMensagem  varchar(255)  
DECLARE @CSN     numeric(13)  
DECLARE @ContaConcessao   char(8)  
-----------------------------------------------------------------------------------------  
DECLARE @ExisteMovtoDiario  char(1)  
  
SELECT @ExisteMovtoDiario = 'F'  
------------------------------------------------------------  
  
DECLARE @DataAtual char(30)  
SELECT @DataAtual = convert(char(10),@DataFinal,104) + '-' + left(convert(char(30),GETDATE(),114),8)  
---select @DataFinal = '2012-10-15'  
---select @DataAtual = '15.10.2012-21:10:35'  
  
DECLARE @DataAnterior5Anos datetime  
SELECT @DataAnterior5Anos = convert(char(10),dateadd (YEAR, -5,GETDATE()),120)  
  
DECLARE @DataUltimos12Meses datetime  
SELECT @DataUltimos12Meses = convert(char(10),dateadd (YEAR, -1,GETDATE()),120)  
   
----- Identifica o codigo do almoxarifado de produção -----------------------------------  
DECLARE @CodigoAlmoxarifado  char(6)  
SELECT @CodigoAlmoxarifado = min(CodigoAlmoxarifado)  
         from tbAlmoxarifado  with (NOLOCK)  
          where CodigoEmpresa = @CodigoEmpresa  
          and   CodigoLocal   = @CodigoLocal  
          and   TipoAlmoxarifadoConsumo is null  
          and   ProducaoAlmoxarifado = 'V'  
-----------------------------------------------------------------------------------------  
select @ContaConcessao = ContaConcessao  
  from tbLocal  with (NOLOCK)  
  where CodigoEmpresa = @CodigoEmpresa  
  and   CodigoLocal = @CodigoLocal  
-----------------------------------------------------------------------------------------  
             
 ----- Limpa a temporaria  
 truncate table rtLinhaDIMSAux  
 truncate table rtMovimentacaoEstoqueDIMS     
 ----- Verifica esta sendo solicitado geração de carga inicial e caso já exista uma carga gerada anteriormente,   
 ----- Não permitir gerar outra novamente.  
   
 if @TipoEnvio = 1 and exists (select 1 from tbProtocoloDIMS  with (NOLOCK)  
           where tbProtocoloDIMS.CodigoEmpresa  = @CodigoEmpresa  
           and   tbProtocoloDIMS.CodigoLocal  = @CodigoLocal  
           and   tbProtocoloDIMS.EnvioRecebimento = 'E'  
           and   tbProtocoloDIMS.EDIProcesso  = 750  
           and   tbProtocoloDIMS.TipoEnvio   = 1)   
 begin  
  SELECT @auxErroMensagem = 'Carga Inicial já Enviada Anteriormente em (' +  
         (select convert(char(10),DataProtocolo,103) from tbProtocoloDIMS  with (NOLOCK)  
           where tbProtocoloDIMS.CodigoEmpresa  = @CodigoEmpresa  
           and   tbProtocoloDIMS.CodigoLocal  = @CodigoLocal  
           and   tbProtocoloDIMS.EnvioRecebimento = 'E'             and   tbProtocoloDIMS.EDIProcesso  = 750  
           and   tbProtocoloDIMS.TipoEnvio   = 1) +  
     '), operação não pode ser realizada novamente!!!'  
  GOTO ERROR  
 end  
  
 ----- Verifica se já existe uma carga diaria gerada anteriormente para a data atual  
 ----- caso exista não permitir nova geração.  
   
 if @TipoEnvio <> 1 and exists (select 1 from tbProtocoloDIMS   with (NOLOCK)  
           where tbProtocoloDIMS.CodigoEmpresa  = @CodigoEmpresa  
           and   tbProtocoloDIMS.CodigoLocal  = @CodigoLocal  
           and   tbProtocoloDIMS.EnvioRecebimento = 'E'  
           and   tbProtocoloDIMS.EDIProcesso  = 750  
           and   tbProtocoloDIMS.TipoEnvio   in (2,3)  
           and   convert(char(10),tbProtocoloDIMS.DataProtocolo,120) = convert(char(10),@DataAtual,120))   
      
 begin  
  SELECT @auxErroMensagem = 'Carga Movimento Diario já Gerada Anteriormente em (' +  
         (select convert(char(10),max(DataProtocolo),103) from tbProtocoloDIMS  with (NOLOCK)  
              where tbProtocoloDIMS.CodigoEmpresa  = @CodigoEmpresa  
              and   tbProtocoloDIMS.CodigoLocal  = @CodigoLocal  
              and   tbProtocoloDIMS.EnvioRecebimento = 'E'  
              and   tbProtocoloDIMS.EDIProcesso  = 750  
              and   tbProtocoloDIMS.TipoEnvio   in (2,3)) +  
     '), operação não pode ser realizada novamente!!!'  
  GOTO ERROR  
 end  
  
/*  
 -----------------------------------------------------------------------------------------------------------------------------   
 Tipo de Registro 1  
 Se Tipo de Envio for igual a 1, sera enviada carga inicial contendo somente Dados do Produtos (STL)  
 Saldo atual de estoque (BES)  
   
 As VENDAS e TRANSFERENCIAS para Filiais que geraram demanda, movimentação correspondente aos ultimos 12 meses (FLM).  
 FLO e FLK também.  
   
 Tipo de Registro 2  
 Serão enviados todas as TAG'S  
   
 Tipo de Registro 3  
 Serão enviados todas as TAG'S e se tratado como se for um movimento mensal.  
 -----------------------------------------------------------------------------------------------------------------------------    
*/  
  
 ----- Se o pedido for 2-movto diario então a data de inicio devera se de 1 mes antes da data atual  
 ----- para que possam ser processadas as entradas que ficaram pendentes de captação ou foram captadas  
 ----- parcialmente.  
   
 if @TipoEnvio = 2 or @TipoEnvio = 3  begin  
  select @DataInicial = convert(char(10),dateadd (month, -1,@DataFinal),120)  
 end  
 --- Atualização dos itens das encomendas onde os itens recebidos são diferentes dos itens solicitados.  
 update tbEncomenda   
  set QuantidadeEntregueEncomenda =   
   (select sum(QtdeLancamentoItemDocto)  
     from tbConfdataItem   with (NOLOCK)  
     inner join tbItemDocumento  with (NOLOCK)  
        on tbItemDocumento.CodigoEmpresa = tbConfdataItem.CodigoEmpresa  
        and tbItemDocumento.CodigoLocal = tbConfdataItem.CodigoLocal  
        and tbItemDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal   
        and tbItemDocumento.EntradaSaidaDocumento = 'E'  
        and tbItemDocumento.CodigoCliFor = 59104273001443  
        and tbItemDocumento.CodigoProduto = tbConfdataItem.ProdutoAtendido  
        and tbItemDocumento.TipoLancamentoMovimentacao = 1  
      where tbConfdataItem.CodigoEmpresa = tbEncomenda.CodigoEmpresa  
      and   tbConfdataItem.CodigoLocal = tbEncomenda.CodigoLocal   
      and   tbConfdataItem.CodigoProdutoSolicitado = tbEncomenda.CodigoProduto  
      and   tbConfdataItem.CodigoProdutoSolicitado <> tbConfdataItem.ProdutoAtendido  
      and   tbConfdataItem.QuantidadeAtendida <> 0  
      and   tbConfdataItem.NumeroPedidoOriginal = tbEncomenda.NumeroDocumentoEncomenda)  
 where CodigoEmpresa = @CodigoEmpresa  
 and CodigoLocal = @CodigoLocal  
 and (QuantidadePedidaEncomenda - QuantidadeEntregueEncomenda ) <> 0  
 and (select sum(QuantidadeSolicitada) from tbConfdataItem   with (NOLOCK)  
    where tbConfdataItem.CodigoEmpresa = tbEncomenda.CodigoEmpresa  
    and tbConfdataItem.CodigoLocal = tbEncomenda.CodigoLocal   
    and tbConfdataItem.CodigoProdutoSolicitado = tbEncomenda.CodigoProduto  
    and tbConfdataItem.CodigoProdutoSolicitado <> tbConfdataItem.ProdutoAtendido  
    and tbConfdataItem.NumeroPedidoOriginal = tbEncomenda.NumeroDocumentoEncomenda  
    and tbConfdataItem.QuantidadeAtendida <> 0  
    and exists (select 1 from tbItemDocumento  with (NOLOCK)  
         where tbItemDocumento.CodigoEmpresa = tbConfdataItem.CodigoEmpresa  
         and tbItemDocumento.CodigoLocal = tbConfdataItem.CodigoLocal  
         and tbItemDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal   
         and tbItemDocumento.EntradaSaidaDocumento = 'E'  
         and tbItemDocumento.CodigoCliFor = 59104273001443   
         and tbItemDocumento.CodigoProduto = tbConfdataItem.ProdutoAtendido )) is not null  
 and (select sum(QtdeLancamentoItemDocto)  
     from tbConfdataItem   with (NOLOCK)  
     inner join tbItemDocumento  with (NOLOCK)  
        on tbItemDocumento.CodigoEmpresa = tbConfdataItem.CodigoEmpresa  
        and tbItemDocumento.CodigoLocal = tbConfdataItem.CodigoLocal  
        and tbItemDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal   
        and tbItemDocumento.EntradaSaidaDocumento = 'E'  
        and tbItemDocumento.CodigoCliFor = 59104273001443   
        and tbItemDocumento.CodigoProduto = tbConfdataItem.ProdutoAtendido  
        and tbItemDocumento.TipoLancamentoMovimentacao = 1  
     where tbConfdataItem.CodigoEmpresa = tbEncomenda.CodigoEmpresa  
     and tbConfdataItem.CodigoLocal = tbEncomenda.CodigoLocal   
     and tbConfdataItem.CodigoProdutoSolicitado = tbEncomenda.CodigoProduto  
     and tbConfdataItem.CodigoProdutoSolicitado <> tbConfdataItem.ProdutoAtendido  
     and tbConfdataItem.QuantidadeAtendida <> 0  
     and tbConfdataItem.NumeroPedidoOriginal = tbEncomenda.NumeroDocumentoEncomenda) <> QuantidadeEntregueEncomenda   
 ---- Ajustar quantidade recebida a maior  
 update tbEncomenda   
  set QuantidadeEntregueEncomenda = QuantidadePedidaEncomenda  
  where CodigoEmpresa = @CodigoEmpresa  
  and   CodigoLocal = @CodigoLocal  
  and   QuantidadeEntregueEncomenda > QuantidadePedidaEncomenda    
    
 --- Gerar arquivo remporario com registros selecionados.  
 INSERT rtMovimentacaoEstoqueDIMS   
   (  CodigoEmpresa,  
     CodigoLocal,  
     EntradaSaidaDocumento,  
     NumeroDocumento,  
     DataDocumento,  
     CodigoCliFor,  
     TipoLancamentoMovimentacao,  
     SequenciaItemDocumento,  
     NumeroDocumento_Devolucao,  
     DataDocumento_Devolucao,  
     SequenciaItemDocumento_Devolucao,  
     CodigoLinha,   
     CodigoProdutoOriginal,  
     CodigoProduto,   
     QtdeLancamentoItemDocto,   
     ValorLancamentoItemDocto,   
     CustoLancamentoItemDocto,  
     CentroCusto,  
     CodigoTipoMovimentacao,  
     CodigoTipoOperacao,  
     OrigemDocumento,  
     Garantia,  
     CPF_CNPJ,  
     ContaConcessao,  
     ContaConcessaoDestino,  
     GeraDemandaTipoMovimentacao,  
     RemanufaturadoLinhaProduto,  
     CondicaoNFCancelada,  
     Carcaca_Remanufatura,  
     NumeroEncomenda,  
     ItemEncomenda,  
     CodigoProdutoSolicitado,   
     QtdeSaldoEncomenda,  
     PedidoEmergencia,  
     NumeroPedido,  
     SequenciaPedido,  
     CodigoAtividade,  
     ClassificacaoAtividade,    
     TimesTamp)  
       
 SELECT CodigoEmpresa = id.CodigoEmpresa,  
     CodigoLocal = id.CodigoLocal,  
     EntradaSaidaDocumento = CASE WHEN id.TipoLancamentoMovimentacao = 11   
             THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                THEN 'S'  
               ELSE 'E'   
               END)  
             ELSE id.EntradaSaidaDocumento  
             END,       
     NumeroDocumento = id.NumeroDocumento,  
     DataDocumento = id.DataDocumento,  
     CodigoCliFor = id.CodigoCliFor,  
     TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao,  
     SequenciaItemDocumento  = id.SequenciaItemDocumento,  
     NumeroDocumento_Devolucao = coalesce(case when pdc.NotaFiscalOriginal is null and id.EntradaSaidaDocumento = 'E'  
           then (select max(tbPedidoDevolucaoVenda.NotaFiscalOriginal)  
               from tbPedidoDevolucaoVenda   with (NOLOCK)  
               where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
               and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
               and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
               and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
               and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 else coalesce(pdc.NotaFiscalOriginal,id.NumeroDocumento)  
                 end,id.NumeroDocumento),  
     DataDocumento_Devolucao = coalesce(case when pdc.DataEmissaoNFOriginal is null and id.EntradaSaidaDocumento = 'E'  
           then (select max(tbPedidoDevolucaoVenda.DataEmissaoNfOriginal)  
               from tbPedidoDevolucaoVenda   with (NOLOCK)  
               where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
               and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
               and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
               and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
               and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 else coalesce(pdc.DataEmissaoNFOriginal,id.DataDocumento)  
                 end,id.DataDocumento),  
     SequenciaItemDocumento_Devolucao = coalesce(case when (select min(ipdc.ItemNotaFiscalOriginalItemPed) from tbItemPedido ipdc  with (NOLOCK)  
                 where ipdc.CodigoEmpresa = df.CodigoEmpresa  
                 AND ipdc.CodigoLocal  = df.CodigoLocal  
                 AND ipdc.CentroCusto  = df.CentroCusto  
                 AND ipdc.NumeroPedido  = do.NumeroPedidoDocumento  
                 AND ipdc.SequenciaPedido = do.NumeroSequenciaPedidoDocumento  
                 and ipdc.CodigoProduto      = id.CodigoProduto) is null  
             then (select min(tbItemDocumento.SequenciaItemDocumento)  
                 from tbItemDocumento  with (NOLOCK)  
                 where tbItemDocumento.CodigoEmpresa = id.CodigoEmpresa  
                 and   tbItemDocumento.CodigoLocal = id.CodigoLocal  
                 and   tbItemDocumento.EntradaSaidaDocumento = 'S'  
                 and   tbItemDocumento.CodigoProduto = id.CodigoProduto  
                 and   tbItemDocumento.CodigoCliFor = id.CodigoCliFor  
                 and   tbItemDocumento.NumeroDocumento = (select max(tbPedidoDevolucaoVenda.NotaFiscalOriginal)  
                              from tbPedidoDevolucaoVenda   with (NOLOCK)  
                              where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
                              and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
                              and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
                              and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
                              and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 and   tbItemDocumento.DataDocumento = (select max(tbPedidoDevolucaoVenda.DataEmissaoNfOriginal)  
                              from tbPedidoDevolucaoVenda   with (NOLOCK)  
                              where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
                              and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
                              and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
                              and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
                              and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento))  
             else coalesce((select min(ipdc.ItemNotaFiscalOriginalItemPed) from tbItemPedido ipdc  with (NOLOCK)  
                   where ipdc.CodigoEmpresa = df.CodigoEmpresa  
                   AND ipdc.CodigoLocal  = df.CodigoLocal  
                   AND ipdc.CentroCusto  = df.CentroCusto  
                   AND ipdc.NumeroPedido  = do.NumeroPedidoDocumento  
                   AND ipdc.SequenciaPedido = do.NumeroSequenciaPedidoDocumento  
                   and ipdc.CodigoProduto      = id.CodigoProduto), id.SequenciaItemDocumento)  
             end, id.SequenciaItemDocumento),   
     CodigoLinha = coalesce(pf.CodigoLinhaProduto,0),  
     CodigoProdutoOriginal = coalesce(id.CodigoProduto,''),  
     CodigoProduto = COALESCE(case when left(id.CodigoProduto,1) = 'A' OR left(id.CodigoProduto,1) = 'H' OR left(id.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(id.CodigoProduto))) = 11 or len(rtrim(ltrim(id.CodigoProduto))) = 15 or len(rtrim(ltrim(id.CodigoProduto))) = 19   
               then left(id.CodigoProduto,1) + '  ' + substring(id.CodigoProduto,2,29)  
               else id.CodigoProduto  
               end  
           else id.CodigoProduto  
           end,id.CodigoProduto),                
     QtdeLancamentoItemDocto = coalesce(id.QtdeLancamentoItemDocto,0),  
     ValorLancamentoItemDocto = coalesce(id.ValorContabilItemDocto,0),  
     CustoLancamentoItemDocto = CASE WHEN id.QtdeLancamentoItemDocto = 0   
            THEN CASE WHEN id.ValorContabilItemDocto = 0   
                THEN 0  
                ELSE id.CustoLancamentoItemDocto  
                END  
             ELSE (id.CustoLancamentoItemDocto * id.QtdeLancamentoItemDocto)  
             END,  
     CentroCusto = coalesce(df.CentroCusto,0),  
     CodigoTipoMovimentacao = coalesce(nop.CodigoTipoMovimentacao,0),  
     CodigoTipoOperacao = coalesce(nop.CodigoTipoOperacao,0),  
     OrigemDocumento = coalesce(df.OrigemDocumentoFT,''),  
     Garantia = coalesce(case when df.OrigemDocumentoFT <> 'OS'  
           then 'F'  
           else case when tbCIT.GarantiaCIT = 'V'   
            then 'V'  
            else 'F'  
            end  
           end,'F'),  
   CPF_CNPJ = coalesce(case when cf.TipoCliFor = 'F'  
       then case when cff.CPFFisica <> 'ISENTO'  
           then case when len(rtrim(ltrim(cff.CPFFisica)))>9  
               then left(rtrim(ltrim(cff.CPFFisica)),9)  
               else rtrim(ltrim(cff.CPFFisica))  
               end  
           else case when len(cff.CodigoCliFor)>9  
               then left(convert(char(15),cff.CodigoCliFor),9)  
               else convert(char(9),cff.CodigoCliFor)  
               end  
           end  
       else case when cfj.CGCJuridica <> 'ISENTO'  
           then case when len(rtrim(ltrim(cfj.CGCJuridica))) > 8  
            then left(rtrim(ltrim(cfj.CGCJuridica)),8)  
            else rtrim(ltrim(cfj.CGCJuridica))  
            end            
           else case when len(cfj.CodigoCliFor)>8  
               then left(convert(char(15),cfj.CodigoCliFor),8)  
               else convert(char(8),cfj.CodigoCliFor)  
               end  
           end  
       end,0),  
   ContaConcessao = coalesce(tbLocal.ContaConcessao,''),  
   ContaConcessaoDestino = coalesce(case when cfj.CGCJuridica <> 'ISENTO'  
              then coalesce((SELECT MAX(locd.ContaConcessao)   
                   from tbLocal locd  with (NOLOCK)  
                   where locd.CodigoEmpresa = id.CodigoEmpresa   
                   and   locd.CodigoCliFor = coalesce(cfj.CGCJuridica,cf.CodigoCliFor)),'')  
              else ''  
              end,''),  
   GeraDemandaTipoMovimentacao = coalesce(tbTipoMovimentacaoEstoque.GeraDemandaTipoMovimentacao,'F'),  
   RemanufaturadoLinhaProduto = coalesce(lp.RemanufaturadoLinhaProduto,'F'),  
   CondicaoNFCancelada = coalesce(do.CondicaoNFCancelada,'F'),  
   Carcaca_Remanufatura = case when substring(id.CodigoProduto,12,4) = '0030'  
                               then 'V'  
                               else 'F'  
                               end,  
   NumeroEncomenda = coalesce((select max(NumeroPedidoOriginal) from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                     on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                     and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                     and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                     and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                     and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                     and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                     and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                     and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                     ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
                   and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
                and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
                and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
                and   tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
                and   tbConfdataItem.CodigoFornecedor = tbFornecedorComplementar.ContaFornecedorDIMS  
                   ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
                   ),''),  
   ItemEncomenda = coalesce((select max(ItemPedidoCliente) from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                     on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                     and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                     and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                     and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                     and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                     and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                     and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                     and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                     ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
                and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
                and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
                and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
                and   tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
                and   tbConfdataItem.CodigoFornecedor = tbFornecedorComplementar.ContaFornecedorDIMS  
                ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
                ),0),  
       CodigoProdutoSolicitado = coalesce((select case when left(min(tbConfdataItem.CodigoProdutoSolicitado),1) = 'A' OR left(min(tbConfdataItem.CodigoProdutoSolicitado),1) = 'H' OR left(min(tbConfdataItem.CodigoProdutoSolicitado),1) = 'W'  
                then CASE when len(rtrim(ltrim(min(tbConfdataItem.CodigoProdutoSolicitado)))) = 11 or len(rtrim(ltrim(min(tbConfdataItem.CodigoProdutoSolicitado)))) = 15 or len(rtrim(ltrim(min(tbConfdataItem.CodigoProdutoSolicitado)))) = 19   
                    then left(min(tbConfdataItem.CodigoProdutoSolicitado),1) + '  ' + substring(min(tbConfdataItem.CodigoProdutoSolicitado),2,29)  
                    else min(tbConfdataItem.CodigoProdutoSolicitado)  
                    end  
                else min(tbConfdataItem.CodigoProdutoSolicitado)  
                end  
           from tbConfdataItem   with (NOLOCK)  
            left join tbEncomendaDocumento  with (NOLOCK)  
                on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
           where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
           and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
           and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
           ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento             
           and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto),case when left(id.CodigoProduto,1) = 'A' OR left(id.CodigoProduto,1) = 'H' OR left(id.CodigoProduto,1) = 'W'  
                           then CASE when len(rtrim(ltrim(id.CodigoProduto))) = 11 or len(rtrim(ltrim(id.CodigoProduto))) = 15 or len(rtrim(ltrim(id.CodigoProduto))) = 19   
                               then left(id.CodigoProduto,1) + '  ' + substring(id.CodigoProduto,2,29)  
                               else id.CodigoProduto  
                               end  
                           else id.CodigoProduto  
                           end,id.CodigoProduto),  
   QtdeSaldoEncomenda = 0,  
   PedidoEmergencia = coalesce((select case when min(CodigoAgrupamentoPedido) = 'EM'  
                                            then 'V'  
                                            else 'F'  
                                            end   
                                            from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                 on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                 and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                 and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                 and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                 and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                 and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                 and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                 and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                 ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal                    
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
              and  tbConfdataItem.CodigoLocal = id.CodigoLocal  
              and  tbConfdataItem.NotaFiscal = id.NumeroDocumento  
              and  tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
              and  tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
              ---and  tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
              ),'F'),  
   NumeroPedido  = do.NumeroPedidoDocumento,  
   SequenciaPedido = do.NumeroSequenciaPedidoDocumento,  
   CodigoAtividade = coalesce(cfj.CodigoAtividade,0),  
   ClassificacaoAtividade = coalesce(tbAtividade.ClassificacaoMEF,0),  
   TimesTamap = id.timestamp  
       
 FROM tbItemDocumento id    with (NOLOCK)  
   
  INNER JOIN tbLocal with (NOLOCK)  
   ON  tbLocal.CodigoEmpresa         = id.CodigoEmpresa   
   AND tbLocal.CodigoLocal    = id.CodigoLocal  
  
  INNER JOIN tbProdutoFT pf  with (NOLOCK)  
   ON  id.CodigoEmpresa     = pf.CodigoEmpresa   
   AND id.CodigoProduto     = pf.CodigoProduto  
     
  INNER JOIN tbLinhaProduto lp  with (NOLOCK)  
   ON  lp.CodigoEmpresa     = pf.CodigoEmpresa  
   AND lp.CodigoLinhaProduto    = pf.CodigoLinhaProduto  
  
  INNER JOIN tbProduto pr  with (NOLOCK)  
   ON  id.CodigoEmpresa     = pr.CodigoEmpresa   
   AND id.CodigoProduto     = pr.CodigoProduto  
  
  INNER JOIN tbDocumento do with (NOLOCK)   
   ON  id.CodigoEmpresa       = do.CodigoEmpresa   
   AND id.CodigoLocal        = do.CodigoLocal  
            AND id.NumeroDocumento         = do.NumeroDocumento  
   AND id.EntradaSaidaDocumento     = do.EntradaSaidaDocumento  
   AND id.DataDocumento       = do.DataDocumento  
   AND id.CodigoCliFor       = do.CodigoCliFor  
   AND id.TipoLancamentoMovimentacao  = do.TipoLancamentoMovimentacao  
  
  LEFT JOIN tbDocumentoFT df with (NOLOCK)   
   ON  df.CodigoEmpresa       = id.CodigoEmpresa   
    AND df.CodigoLocal        = id.CodigoLocal  
            AND df.NumeroDocumento       = id.NumeroDocumento  
   AND df.EntradaSaidaDocumento   = id.EntradaSaidaDocumento  
   AND df.DataDocumento       = id.DataDocumento  
   AND df.CodigoCliFor       = id.CodigoCliFor  
   AND df.TipoLancamentoMovimentacao  = id.TipoLancamentoMovimentacao  
  
        LEFT JOIN tbPedidoOS pd  with (NOLOCK)  
   ON pd.CodigoEmpresa    = df.CodigoEmpresa  
   AND pd.CodigoLocal     = df.CodigoLocal  
   AND pd.CentroCusto     = df.CentroCusto  
   AND pd.NumeroPedido     = do.NumeroPedidoDocumento  
   AND pd.SequenciaPedido    = do.NumeroSequenciaPedidoDocumento  
  
        LEFT JOIN tbPedidoComplementar pdc  with (NOLOCK)  
   ON pdc.CodigoEmpresa    = df.CodigoEmpresa  
   AND pdc.CodigoLocal     = df.CodigoLocal  
   AND pdc.CentroCusto     = df.CentroCusto  
   AND pdc.NumeroPedido    = do.NumeroPedidoDocumento  
   AND pdc.SequenciaPedido    = do.NumeroSequenciaPedidoDocumento  
     
  LEFT JOIN tbCIT  with (NOLOCK)   
   ON  tbCIT.CodigoEmpresa    = id.CodigoEmpresa  
   and tbCIT.CodigoCIT        = pd.CodigoCIT  
     
  INNER JOIN tbCliFor cf  with (NOLOCK)  
   ON  cf.CodigoEmpresa     = id.CodigoEmpresa  
   AND cf.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbCliForFisica cff  with (NOLOCK)  
   ON  cff.CodigoEmpresa     = id.CodigoEmpresa  
   AND cff.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbCliForJuridica cfj  with (NOLOCK)  
   ON  cfj.CodigoEmpresa     = id.CodigoEmpresa  
   AND cfj.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbFornecedorComplementar  with (NOLOCK)  
   ON  tbFornecedorComplementar.CodigoEmpresa  = id.CodigoEmpresa  
   AND tbFornecedorComplementar.CodigoCliFor   = id.CodigoCliFor  
  
  INNER JOIN tbNaturezaOperacao nop  with (NOLOCK)  
   ON  nop.CodigoEmpresa          = id.CodigoEmpresa   
   AND nop.CodigoNaturezaOperacao   = id.CodigoNaturezaOperacao  
  
  INNER JOIN tbTipoMovimentacaoEstoque with (NOLOCK)  
   ON tbTipoMovimentacaoEstoque.CodigoEmpresa         = id.CodigoEmpresa   
   AND tbTipoMovimentacaoEstoque.CodigoTipoMovimentacao  = nop.CodigoTipoMovimentacao  
     
  INNER JOIN tbParametroDIMS with (NOLOCK)  
   ON tbParametroDIMS.CodigoEmpresa  = id.CodigoEmpresa   
   AND tbParametroDIMS.CodigoLocal  = id.CodigoLocal  
     
  LEFT JOIN tbAtividade  with (NOLOCK)  
   on tbAtividade.CodigoAtividade  = cfj.CodigoAtividade  
  
 WHERE id.CodigoEmpresa      = @CodigoEmpresa  
  AND id.CodigoLocal       = @CodigoLocal  
  AND (id.DataDocumento      BETWEEN @DataInicial AND @DataFinal)  
     AND ((@TipoEnvio <> 1 and id.DataDocumento >= tbParametroDIMS.DataInicioUtilizacaoDIMS) or (@TipoEnvio = 1))  
  AND id.TipoLancamentoMovimentacao  != 13  
  ----and ((@TipoEnvio = 1 and id.EntradaSaidaDocumento = 'S') or (@TipoEnvio = 2) or (@TipoEnvio = 3))  
  AND ( (lp.TipoLinhaProduto in (0,1,2)) or (lp.GeraMovtoDIMS = 'V'))  
  AND lp.RecapagemLinhaProduto = 'F'  
  
  and not exists (select 1 from tbItemDocumentoDIMS  with (NOLOCK)  
        where tbItemDocumentoDIMS.CodigoEmpresa       = id.CodigoEmpresa   
        AND   tbItemDocumentoDIMS.CodigoLocal        = id.CodigoLocal  
        AND   tbItemDocumentoDIMS.EntradaSaidaDocumento   = CASE WHEN id.TipoLancamentoMovimentacao = 11   
                       THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                             THEN 'S'  
                            ELSE 'E'   
                            END)  
                       ELSE id.EntradaSaidaDocumento  
                       END  
        AND   tbItemDocumentoDIMS.NumeroDocumento         = id.NumeroDocumento  
        AND   tbItemDocumentoDIMS.DataDocumento       = id.DataDocumento  
        AND   tbItemDocumentoDIMS.CodigoCliFor        = id.CodigoCliFor  
        AND   (tbItemDocumentoDIMS.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao OR tbItemDocumentoDIMS.TipoLancamentoMovimentacao = 13)  
        AND   tbItemDocumentoDIMS.SequenciaItemDocumento  = id.SequenciaItemDocumento)  
  
  and not exists (select 1 from tbItemDocumentoDIMS  with (NOLOCK)  
        where tbItemDocumentoDIMS.CodigoEmpresa       = id.CodigoEmpresa   
        AND   tbItemDocumentoDIMS.CodigoLocal        = id.CodigoLocal  
        AND   tbItemDocumentoDIMS.EntradaSaidaDocumento   = CASE WHEN id.TipoLancamentoMovimentacao = 11   
                       THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                             THEN 'S'  
                            ELSE 'E'   
                            END)  
                       ELSE id.EntradaSaidaDocumento  
                       END  
        AND   tbItemDocumentoDIMS.NumeroDocumento         = id.NumeroDocumento  
        AND   tbItemDocumentoDIMS.DataDocumento       = id.DataDocumento  
        AND   tbItemDocumentoDIMS.CodigoCliFor        = id.CodigoCliFor  
        AND   tbItemDocumentoDIMS.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
        AND   tbItemDocumentoDIMS.SequenciaItemDocumento  = 0)  

		
 --- Verificar documentos pendentes de atualização NFDocumento  
 --- Gerar arquivo remporario com registros selecionados.  
 INSERT rtMovimentacaoEstoqueDIMS   
   (  CodigoEmpresa,  
     CodigoLocal,  
     EntradaSaidaDocumento,  
     NumeroDocumento,  
     DataDocumento,  
     CodigoCliFor,  
     TipoLancamentoMovimentacao,  
     SequenciaItemDocumento,  
     NumeroDocumento_Devolucao,  
     DataDocumento_Devolucao,  
     SequenciaItemDocumento_Devolucao,  
     CodigoLinha,   
     CodigoProdutoOriginal,  
     CodigoProduto,   
     QtdeLancamentoItemDocto,   
     ValorLancamentoItemDocto,   
     CustoLancamentoItemDocto,  
     CentroCusto,  
     CodigoTipoMovimentacao,  
     CodigoTipoOperacao,  
     OrigemDocumento,  
     Garantia,  
     CPF_CNPJ,  
     ContaConcessao,  
     ContaConcessaoDestino,  
     GeraDemandaTipoMovimentacao,  
     RemanufaturadoLinhaProduto,  
     CondicaoNFCancelada,  
     Carcaca_Remanufatura,  
     NumeroEncomenda,  
     ItemEncomenda,  
     CodigoProdutoSolicitado,   
     QtdeSaldoEncomenda,  
     PedidoEmergencia,  
     NumeroPedido,  
     SequenciaPedido,  
     CodigoAtividade,  
     ClassificacaoAtividade,       
     TimesTamp)  
       
 SELECT CodigoEmpresa = id.CodigoEmpresa,  
     CodigoLocal = id.CodigoLocal,  
     EntradaSaidaDocumento = CASE WHEN id.TipoLancamentoMovimentacao = 11   
             THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                THEN 'S'  
               ELSE 'E'   
               END)  
             ELSE id.EntradaSaidaDocumento  
             END,       
     NumeroDocumento = id.NumeroDocumento,  
     DataDocumento = id.DataDocumento,  
     CodigoCliFor = id.CodigoCliFor,  
     TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao,  
     SequenciaItemDocumento  = id.SequenciaItemDocumento,  
     NumeroDocumento_Devolucao = coalesce(case when pdc.NotaFiscalOriginal is null and id.EntradaSaidaDocumento = 'E'  
           then (select max(tbPedidoDevolucaoVenda.NotaFiscalOriginal)  
               from tbPedidoDevolucaoVenda   with (NOLOCK)  
               where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
               and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
               and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
               and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
               and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 else coalesce(pdc.NotaFiscalOriginal,id.NumeroDocumento)  
                 end,id.NumeroDocumento),  
     DataDocumento_Devolucao = coalesce(case when pdc.DataEmissaoNFOriginal is null and id.EntradaSaidaDocumento = 'E'  
           then (select max(tbPedidoDevolucaoVenda.DataEmissaoNfOriginal)  
               from tbPedidoDevolucaoVenda   with (NOLOCK)  
               where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
               and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
               and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
               and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
               and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 else coalesce(pdc.DataEmissaoNFOriginal,id.DataDocumento)  
                 end,id.DataDocumento),  
     SequenciaItemDocumento_Devolucao = coalesce(case when (select min(ipdc.ItemNotaFiscalOriginalItemPed) from tbItemPedido ipdc  with (NOLOCK)  
                 where ipdc.CodigoEmpresa = df.CodigoEmpresa  
                 AND ipdc.CodigoLocal  = df.CodigoLocal  
                 AND ipdc.CentroCusto  = df.CentroCusto  
                 AND ipdc.NumeroPedido  = do.NumeroPedidoDocumento  
                 AND ipdc.SequenciaPedido = do.NumeroSequenciaPedidoDocumento  
                 and ipdc.CodigoProduto      = id.CodigoProduto) is null  
             then (select min(tbItemDocumento.SequenciaItemDocumento)  
                 from tbItemDocumento  with (NOLOCK)  
                 where tbItemDocumento.CodigoEmpresa = id.CodigoEmpresa  
                 and   tbItemDocumento.CodigoLocal = id.CodigoLocal  
                 and   tbItemDocumento.EntradaSaidaDocumento = 'S'  
                 and   tbItemDocumento.CodigoProduto = id.CodigoProduto  
                 and   tbItemDocumento.CodigoCliFor = id.CodigoCliFor  
                 and   tbItemDocumento.NumeroDocumento = (select tbPedidoDevolucaoVenda.NotaFiscalOriginal  
                              from tbPedidoDevolucaoVenda   with (NOLOCK)  
                              where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
                              and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
                              and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
                              and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
                              and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento)  
                 and   tbItemDocumento.DataDocumento = (select tbPedidoDevolucaoVenda.DataEmissaoNfOriginal  
                              from tbPedidoDevolucaoVenda   with (NOLOCK)  
                              where tbPedidoDevolucaoVenda.CodigoEmpresa = id.CodigoEmpresa  
                              and   tbPedidoDevolucaoVenda.CodigoLocal = id.CodigoLocal  
                              and   tbPedidoDevolucaoVenda.CentroCusto = df.CentroCusto  
                              and   tbPedidoDevolucaoVenda.NumeroPedido = do.NumeroPedidoDocumento  
                              and   tbPedidoDevolucaoVenda.SequenciaPedido = do.NumeroSequenciaPedidoDocumento))  
             else coalesce((select min(ipdc.ItemNotaFiscalOriginalItemPed) from tbItemPedido ipdc  with (NOLOCK)  
                   where ipdc.CodigoEmpresa = df.CodigoEmpresa  
                   AND ipdc.CodigoLocal  = df.CodigoLocal  
                   AND ipdc.CentroCusto  = df.CentroCusto  
                   AND ipdc.NumeroPedido  = do.NumeroPedidoDocumento  
                   AND ipdc.SequenciaPedido = do.NumeroSequenciaPedidoDocumento  
                   and ipdc.CodigoProduto      = id.CodigoProduto), id.SequenciaItemDocumento)  
             end, id.SequenciaItemDocumento),   
     CodigoLinha = pf.CodigoLinhaProduto,  
     CodigoProdutoOriginal = id.CodigoProduto,  
     CodigoProduto = COALESCE(case when left(id.CodigoProduto,1) = 'A' OR left(id.CodigoProduto,1) = 'H' OR left(id.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(id.CodigoProduto))) = 11 or len(rtrim(ltrim(id.CodigoProduto))) = 15 or len(rtrim(ltrim(id.CodigoProduto))) = 19   
               then left(id.CodigoProduto,1) + '  ' + substring(id.CodigoProduto,2,29)  
               else id.CodigoProduto  
               end  
           else id.CodigoProduto  
           end,id.CodigoProduto),                
     QtdeLancamentoItemDocto = id.QtdeLancamentoItemDocto,  
     ValorLancamentoItemDocto = id.ValorContabilItemDocto,  
     CustoLancamentoItemDocto = CASE WHEN id.QtdeLancamentoItemDocto = 0   
            THEN CASE WHEN id.ValorContabilItemDocto = 0   
                THEN 0  
                ELSE id.CustoLancamentoItemDocto  
                END  
             ELSE (id.CustoLancamentoItemDocto * id.QtdeLancamentoItemDocto)  
             END,  
     CentroCusto = coalesce(df.CentroCusto,0),  
     CodigoTipoMovimentacao = nop.CodigoTipoMovimentacao,  
     CodigoTipoOperacao = nop.CodigoTipoOperacao,  
     OrigemDocumento = df.OrigemDocumentoFT,  
     Garantia = case when df.OrigemDocumentoFT <> 'OS'  
         then 'F'  
         else case when tbCIT.GarantiaCIT = 'V'   
             then 'V'  
             else 'F'  
             end  
         end,  
   CPF_CNPJ = case when cf.TipoCliFor = 'F'  
       then case when cff.CPFFisica <> 'ISENTO'  
           then case when len(rtrim(ltrim(cff.CPFFisica)))>9  
               then left(rtrim(ltrim(cff.CPFFisica)),9)  
               else rtrim(ltrim(cff.CPFFisica))  
               end  
           else case when len(cff.CodigoCliFor)>9  
               then left(convert(char(15),cff.CodigoCliFor),9)  
               else convert(char(9),cff.CodigoCliFor)  
               end  
           end  
       else case when cfj.CGCJuridica <> 'ISENTO'  
           then case when len(rtrim(ltrim(cfj.CGCJuridica))) > 8  
            then left(rtrim(ltrim(cfj.CGCJuridica)),8)  
            else rtrim(ltrim(cfj.CGCJuridica))  
            end            
           else case when len(cfj.CodigoCliFor)>8  
               then left(convert(char(15),cfj.CodigoCliFor),8)  
               else convert(char(8),cfj.CodigoCliFor)  
               end  
           end  
       end,  
   ContaConcessao = tbLocal.ContaConcessao,  
   ContaConcessaoDestino = case when cfj.CGCJuridica <> 'ISENTO'  
              then coalesce((SELECT MAX(locd.ContaConcessao)   
                from tbLocal locd  with (NOLOCK)  
                where locd.CodigoEmpresa = id.CodigoEmpresa   
                and   locd.CodigoCliFor = coalesce(cfj.CGCJuridica,cf.CodigoCliFor)),'')  
           else ''  
           end,  
   GeraDemandaTipoMovimentacao = tbTipoMovimentacaoEstoque.GeraDemandaTipoMovimentacao,  
   RemanufaturadoLinhaProduto = lp.RemanufaturadoLinhaProduto,  
   CondicaoNFCancelada = do.CondicaoNFCancelada,  
   Carcaca_Remanufatura = case when substring(id.CodigoProduto,12,4) = '0030'  
                               then 'V'  
                               else 'F'  
                               end,  
   NumeroEncomenda = coalesce((select max(NumeroPedidoOriginal) from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                     on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                     and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                     and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                     and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                     and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                     and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                     and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                     and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                     ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
                   and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
                and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
                and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
                and   tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
                and   tbConfdataItem.CodigoFornecedor = tbFornecedorComplementar.ContaFornecedorDIMS  
                   ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
                   ),''),  
   ItemEncomenda = coalesce((select max(ItemPedidoCliente) from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                     on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                     and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                     and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                     and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                     and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                     and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                     and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                     and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                     ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
                and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
                and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
                and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
                and   tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
                and   tbConfdataItem.CodigoFornecedor = tbFornecedorComplementar.ContaFornecedorDIMS  
                ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
                ),0),  
       CodigoProdutoSolicitado = coalesce((select case when left(tbConfdataItem.CodigoProdutoSolicitado,1) = 'A' OR left(tbConfdataItem.CodigoProdutoSolicitado,1) = 'H' OR left(tbConfdataItem.CodigoProdutoSolicitado,1) = 'W'  
                then CASE when len(rtrim(ltrim(tbConfdataItem.CodigoProdutoSolicitado))) = 11 or len(rtrim(ltrim(tbConfdataItem.CodigoProdutoSolicitado))) = 15 or len(rtrim(ltrim(tbConfdataItem.CodigoProdutoSolicitado))) = 19   
                    then left(tbConfdataItem.CodigoProdutoSolicitado,1) + '  ' + substring(tbConfdataItem.CodigoProdutoSolicitado,2,29)  
                    else tbConfdataItem.CodigoProdutoSolicitado  
                    end  
                else tbConfdataItem.CodigoProdutoSolicitado  
                end  
           from tbConfdataItem   with (NOLOCK)  
            left join tbEncomendaDocumento  with (NOLOCK)  
                on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal  
           where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
           and   tbConfdataItem.CodigoLocal = id.CodigoLocal  
           and   tbConfdataItem.NotaFiscal = id.NumeroDocumento  
           ---and   tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento             
           and   tbConfdataItem.ProdutoAtendido = id.CodigoProduto),case when left(id.CodigoProduto,1) = 'A' OR left(id.CodigoProduto,1) = 'H' OR left(id.CodigoProduto,1) = 'W'  
                           then CASE when len(rtrim(ltrim(id.CodigoProduto))) = 11 or len(rtrim(ltrim(id.CodigoProduto))) = 15 or len(rtrim(ltrim(id.CodigoProduto))) = 19   
                               then left(id.CodigoProduto,1) + '  ' + substring(id.CodigoProduto,2,29)  
                               else id.CodigoProduto  
                               end  
                           else id.CodigoProduto  
                           end,id.CodigoProduto),  
   QtdeSaldoEncomenda = 0,  
   PedidoEmergencia = coalesce((select case when CodigoAgrupamentoPedido = 'EM'  
                                            then 'V'  
                                            else 'F'  
                                            end   
                                            from tbConfdataItem   with (NOLOCK)  
                 left join tbEncomendaDocumento  with (NOLOCK)  
                 on  tbEncomendaDocumento.CodigoEmpresa = id.CodigoEmpresa                 
                 and tbEncomendaDocumento.CodigoLocal = id.CodigoLocal                 
                 and tbEncomendaDocumento.CodigoProduto = id.CodigoProduto  
                 and tbEncomendaDocumento.NumeroDocumentoEncomenda = tbConfdataItem.NumeroPedidoOriginal  
                 and tbEncomendaDocumento.NumeroDocumento = tbConfdataItem.NotaFiscal  
                 and tbEncomendaDocumento.DataDocumento = id.DataDocumento  
                 and tbEncomendaDocumento.CodigoCliFor = id.CodigoCliFor  
                 and tbEncomendaDocumento.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
                 ---and tbEncomendaDocumento.SequenciaItemDocumento = tbConfdataItem.ItemNotaFiscal                    
                where tbConfdataItem.CodigoEmpresa = id.CodigoEmpresa  
              and  tbConfdataItem.CodigoLocal = id.CodigoLocal  
              and  tbConfdataItem.NotaFiscal = id.NumeroDocumento  
              and  tbConfdataItem.ProdutoAtendido = id.CodigoProduto  
              and  tbConfdataItem.QuantidadeAtendida = id.QtdeLancamentoItemDocto  
              ---and  tbConfdataItem.ItemNotaFiscal =  id.SequenciaItemDocumento  
              ),'F'),  
   NumeroPedido  = do.NumeroPedidoDocumento,  
   SequenciaPedido = do.NumeroSequenciaPedidoDocumento,  
   CodigoAtividade = coalesce(cfj.CodigoAtividade,0),  
   ClassificacaoAtividade = coalesce(tbAtividade.ClassificacaoMEF,0),  
   TimesTamap = id.timestamp  
       
 FROM NFItemDocumento id   with (NOLOCK)  
   
  INNER JOIN tbLocal with (NOLOCK)  
   ON  tbLocal.CodigoEmpresa         = id.CodigoEmpresa   
   AND tbLocal.CodigoLocal    = id.CodigoLocal  
  
  INNER JOIN tbProdutoFT pf  with (NOLOCK)  
   ON  id.CodigoEmpresa     = pf.CodigoEmpresa   
   AND id.CodigoProduto     = pf.CodigoProduto  
     
  INNER JOIN tbLinhaProduto lp  with (NOLOCK)  
   ON  lp.CodigoEmpresa         = pf.CodigoEmpresa  
   AND lp.CodigoLinhaProduto    = pf.CodigoLinhaProduto  
  
  INNER JOIN tbProduto pr  with (NOLOCK)  
   ON  id.CodigoEmpresa     = pr.CodigoEmpresa   
   AND id.CodigoProduto     = pr.CodigoProduto  
  
  INNER JOIN NFDocumento do  with (NOLOCK)  
   ON  id.CodigoEmpresa       = do.CodigoEmpresa   
   AND id.CodigoLocal        = do.CodigoLocal  
            AND id.NumeroDocumento         = do.NumeroDocumento  
   AND id.EntradaSaidaDocumento     = do.EntradaSaidaDocumento  
   AND id.DataDocumento       = do.DataDocumento  
   AND id.CodigoCliFor       = do.CodigoCliFor  
   AND id.TipoLancamentoMovimentacao  = do.TipoLancamentoMovimentacao  
  
  LEFT JOIN NFDocumentoFT df  with (NOLOCK)  
   ON  df.CodigoEmpresa       = id.CodigoEmpresa   
    AND df.CodigoLocal        = id.CodigoLocal  
            AND df.NumeroDocumento       = id.NumeroDocumento  
   AND df.EntradaSaidaDocumento   = id.EntradaSaidaDocumento  
   AND df.DataDocumento       = id.DataDocumento  
   AND df.CodigoCliFor       = id.CodigoCliFor  
   AND df.TipoLancamentoMovimentacao  = id.TipoLancamentoMovimentacao  
  
        LEFT JOIN tbPedidoOS pd  with (NOLOCK)  
   ON pd.CodigoEmpresa    = df.CodigoEmpresa  
   AND pd.CodigoLocal     = df.CodigoLocal  
   AND pd.CentroCusto     = df.CentroCusto  
   AND pd.NumeroPedido     = do.NumeroPedidoDocumento  
   AND pd.SequenciaPedido    = do.NumeroSequenciaPedidoDocumento  
  
        LEFT JOIN tbPedido with (NOLOCK)  
   ON tbPedido.CodigoEmpresa   = df.CodigoEmpresa  
   AND tbPedido.CodigoLocal   = df.CodigoLocal  
   AND tbPedido.CentroCusto   = df.CentroCusto  
   AND tbPedido.NumeroPedido   = do.NumeroPedidoDocumento  
   AND tbPedido.SequenciaPedido  = do.NumeroSequenciaPedidoDocumento  
  
        LEFT JOIN tbPedidoComplementar pdc  with (NOLOCK)  
   ON pdc.CodigoEmpresa    = df.CodigoEmpresa  
   AND pdc.CodigoLocal     = df.CodigoLocal  
   AND pdc.CentroCusto     = df.CentroCusto  
   AND pdc.NumeroPedido    = do.NumeroPedidoDocumento  
   AND pdc.SequenciaPedido    = do.NumeroSequenciaPedidoDocumento  
     
  LEFT JOIN tbCIT   with (NOLOCK)  
   ON  tbCIT.CodigoEmpresa    = id.CodigoEmpresa  
   and tbCIT.CodigoCIT        = pd.CodigoCIT  
     
  INNER JOIN tbCliFor cf  with (NOLOCK)  
   ON  cf.CodigoEmpresa     = id.CodigoEmpresa  
   AND cf.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbCliForFisica cff  with (NOLOCK)  
   ON  cff.CodigoEmpresa     = id.CodigoEmpresa  
   AND cff.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbCliForJuridica cfj  with (NOLOCK)  
   ON  cfj.CodigoEmpresa     = id.CodigoEmpresa  
   AND cfj.CodigoCliFor      = id.CodigoCliFor  
  
  LEFT JOIN tbFornecedorComplementar  with (NOLOCK)  
   ON  tbFornecedorComplementar.CodigoEmpresa  = id.CodigoEmpresa  
   AND tbFornecedorComplementar.CodigoCliFor   = id.CodigoCliFor  
  
  INNER JOIN tbNaturezaOperacao nop  with (NOLOCK)  
   ON  nop.CodigoEmpresa          = id.CodigoEmpresa   
   AND nop.CodigoNaturezaOperacao   = id.CodigoNaturezaOperacao  
  
  INNER JOIN tbTipoMovimentacaoEstoque  with (NOLOCK)  
   ON tbTipoMovimentacaoEstoque.CodigoEmpresa         = id.CodigoEmpresa   
   AND tbTipoMovimentacaoEstoque.CodigoTipoMovimentacao  = nop.CodigoTipoMovimentacao  
     
  INNER JOIN tbParametroDIMS with (NOLOCK)  
   ON tbParametroDIMS.CodigoEmpresa  = id.CodigoEmpresa   
   AND tbParametroDIMS.CodigoLocal  = id.CodigoLocal  
     
  LEFT JOIN tbAtividade with (NOLOCK)  
   on tbAtividade.CodigoAtividade  = cfj.CodigoAtividade  
         
 WHERE id.CodigoEmpresa     = @CodigoEmpresa  
 AND id.CodigoLocal       = @CodigoLocal  
 AND (id.DataDocumento      BETWEEN @DataInicial AND @DataFinal)  
    AND ((@TipoEnvio <> 1 and id.DataDocumento >= tbParametroDIMS.DataInicioUtilizacaoDIMS) or (@TipoEnvio = 1))  
 AND id.TipoLancamentoMovimentacao  = 13  
  ---and ((@TipoEnvio = 1 and id.EntradaSaidaDocumento = 'S') or (@TipoEnvio = 2) or (@TipoEnvio = 3))  
  AND ( (lp.TipoLinhaProduto in (0,1,2)) or (lp.GeraMovtoDIMS = 'V'))  
  AND lp.RecapagemLinhaProduto = 'F'  
  and tbPedido.AtualizadoEstoquePed = 'V'  
  
 and not exists (select 1 from tbItemDocumentoDIMS  with (NOLOCK)  
       where tbItemDocumentoDIMS.CodigoEmpresa       = id.CodigoEmpresa   
       AND   tbItemDocumentoDIMS.CodigoLocal        = id.CodigoLocal  
       AND   tbItemDocumentoDIMS.EntradaSaidaDocumento   = CASE WHEN id.TipoLancamentoMovimentacao = 11   
                      THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                            THEN 'S'  
                           ELSE 'E'   
                           END)  
                      ELSE id.EntradaSaidaDocumento  
                      END  
       AND   tbItemDocumentoDIMS.NumeroDocumento         = id.NumeroDocumento  
       AND   tbItemDocumentoDIMS.DataDocumento       = id.DataDocumento  
       AND   tbItemDocumentoDIMS.CodigoCliFor        = id.CodigoCliFor  
       AND   tbItemDocumentoDIMS.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
       AND   tbItemDocumentoDIMS.SequenciaItemDocumento  = id.SequenciaItemDocumento)  
         
 and not exists (select 1 from tbItemDocumentoDIMS  with (NOLOCK)  
       where tbItemDocumentoDIMS.CodigoEmpresa       = id.CodigoEmpresa   
       AND   tbItemDocumentoDIMS.CodigoLocal        = id.CodigoLocal  
       AND   tbItemDocumentoDIMS.EntradaSaidaDocumento   = CASE WHEN id.TipoLancamentoMovimentacao = 11   
                      THEN (CASE WHEN id.EntradaSaidaDocumento = 'E'   
                            THEN 'S'  
                           ELSE 'E'   
                           END)  
                      ELSE id.EntradaSaidaDocumento  
                      END  
       AND   tbItemDocumentoDIMS.NumeroDocumento         = id.NumeroDocumento  
       AND   tbItemDocumentoDIMS.DataDocumento       = id.DataDocumento  
       AND   tbItemDocumentoDIMS.CodigoCliFor        = id.CodigoCliFor  
       AND   tbItemDocumentoDIMS.TipoLancamentoMovimentacao = id.TipoLancamentoMovimentacao  
       AND   tbItemDocumentoDIMS.SequenciaItemDocumento  = 0)  
  
 ---- Acumular quandade pendente do item na encomenda para pedidos não dims   
  update rtMovimentacaoEstoqueDIMS  
   set QtdeSaldoEncomenda = coalesce((select sum((pcp.QuantidadePedidaEncomenda - pcp.QuantidadeEntregueEncomenda))  
              from tbEncomenda pcp   with (NOLOCK)  
              where pcp.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa   
              and   pcp.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
              and   pcp.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
              and   pcp.NumeroDocumentoEncomenda = rtMovimentacaoEstoqueDIMS.NumeroEncomenda  
              and   (pcp.QuantidadePedidaEncomenda - pcp.QuantidadeEntregueEncomenda)<>0  
              and   pcp.PedidoCompraDIMS = 'F'),QtdeSaldoEncomenda)  
  
 where rtMovimentacaoEstoqueDIMS.CodigoEmpresa = @CodigoEmpresa  
 and   rtMovimentacaoEstoqueDIMS.CodigoLocal = @CodigoLocal  
 and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
 and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 1  
 ---- Acumular quandade pendente do item pelo Conf Data para os pedidos DIMS  
 update rtMovimentacaoEstoqueDIMS  
   set QtdeSaldoEncomenda = coalesce((select sum(tbConfdataItem.QuantidadePendenteBO)  
              from tbConfdataItem    with (NOLOCK)  
              where tbConfdataItem.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa   
              and   tbConfdataItem.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
              and   tbConfdataItem.ProdutoAtendido = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
              and   tbConfdataItem.NumeroPedidoOriginal = rtMovimentacaoEstoqueDIMS.NumeroEncomenda  
              and   tbConfdataItem.QuantidadePendenteBO <> 0  
              ---and   tbConfdataItem.ItemNotaFiscal = rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
              ),QtdeSaldoEncomenda)  
  
 where rtMovimentacaoEstoqueDIMS.CodigoEmpresa = @CodigoEmpresa  
 and   rtMovimentacaoEstoqueDIMS.CodigoLocal = @CodigoLocal  
 and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
 and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 1  
 and   rtMovimentacaoEstoqueDIMS.QtdeSaldoEncomenda = 0  
  
 update rtMovimentacaoEstoqueDIMS  
  set NumeroEncomenda = '0',  
      ItemEncomenda = 0  
 where rtMovimentacaoEstoqueDIMS.NumeroEncomenda = ''  
 and   CodigoEmpresa = @CodigoEmpresa  
 and   CodigoLocal   = @CodigoLocal  
 ---------------------------------------------------------------------------------------------  
 ---- Verificar se existe numero de encomenda para a entrada por compra.  
 ---- caso não exista o numero da encomenda, excluir do registro da tabela temporaria  
 ---- para que o mesmo nao seja processado, ate que exista um numero de encomenda valido.  
 ---- Este processo devera orcorrer somente para as compras na montadora (MBBras)   
 ---- Somente para Tipo de Registro Movtimento Diario.  
 --===========================================================================================  
   
 if @TipoEnvio = 2  
 begin  
  delete rtMovimentacaoEstoqueDIMS  
    where CodigoEmpresa = @CodigoEmpresa  
    and   CodigoLocal   = @CodigoLocal  
    and   NumeroEncomenda = '0'  
    and   EntradaSaidaDocumento = 'E'  
    and   TipoLancamentoMovimentacao = 1  
    and   CodigoTipoOperacao = 1  
    and   ClassificacaoAtividade = 0    ---- Montadora  
 end  
      
 SELECT @ExisteMovtoDiario = 'F'  
 IF EXISTS (select 1 from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
     where  CodigoEmpresa = @CodigoEmpresa  
     and    CodigoLocal   = @CodigoLocal)   
  SELECT @ExisteMovtoDiario = 'V'  
      
 ---------------------------------------------------------------------------------------------  
    
 ---- Inicio gereção do arquivo XML  
 if (exists (select 1 from rtMovimentacaoEstoqueDIMS  with (NOLOCK)) or @TipoEnvio = 1) OR (not exists (select 1 from rtMovimentacaoEstoqueDIMS  with (NOLOCK)) or @TipoEnvio = 21)   
 begin  
  
  --- Contador CSN  
  SELECT @CSN = coalesce((select (UltimoNumeroCSN + 1 )   
          from tbParametroDIMS  with (NOLOCK)  
          where CodigoEmpresa = @CodigoEmpresa  
          and   CodigoLocal   = @CodigoLocal),1)  
  if @CSN > 999999999999  
   SELECT @CSN = 1  
  
  --- (1) DTD  
  ---insert rtLinhaDIMSAux select '<?xml version=' + '''' + '1.0' + '''' + ' encoding=' + '''' + 'ISO-8859-1' + '''' + '?>' ,0,''  
  insert rtLinhaDIMSAux select '<?xml version="1.0" encoding="UTF-8"?>',0,'','','',0,0 where not exists( select 1 from rtLinhaDIMSAux where LinhaXML = '<?xml version="1.0" encoding="UTF-8"?>')  
  insert rtLinhaDIMSAux select '<!DOCTYPE Dims SYSTEM "../../../resource/dims_import.dtd">',1,'','','',0,0 where not exists( select 1 from rtLinhaDIMSAux where LinhaXML = '<!DOCTYPE Dims SYSTEM "../../../resource/dims_import.dtd">')  
    
  ----insert rtLinhaDIMSAux select '<!DOCTYPE Dims SYSTEM "../../../resource/dims_import.dtd">'   
    
  --- (2) Start-Tag  
  insert rtLinhaDIMSAux select '<Dims>' ,2,'','','',0,0 where not exists( select 1 from rtLinhaDIMSAux where LinhaXML = '<Dims>')  
    
  --- (3) INI-Element (fix information to be included in every file)  
  insert rtLinhaDIMSAux   
  select '<INI>'   
   + '<MAN>01</MAN>'  
   + '<LOR>0</LOR>'  
   + '<RNU>0</RNU>'  
   + '<KNU>0</KNU>'  
   + '<ID2>0</ID2>'  
   + '<ID3>0</ID3>'  
   + '<ID4>0</ID4>'  
   + '<ID5>0</ID5>'  
   + '<ISY>200000000099</ISY>'   
   + '<SDA>28800</SDA>'  
   + '<MDA>14400</MDA>'  
   + '<RTE></RTE>'  
   + '<FTE></FTE>'  
   + '<STE></STE>'  
   + '<MEN>0,00</MEN>'  
   + '<MEI>1</MEI>'  
   + '<ALL>0</ALL>'  
   + '<ZP1>1</ZP1>'  
   + '<ZP2>1</ZP2>'  
   + '<ZP3>1</ZP3>'  
   + '<ZP4>0</ZP4>'  
   + '<ZP5>1</ZP5>'  
   + '<SY1>0</SY1>'  
   + '<SY2>0</SY2>'  
   + '<KAL>0</KAL>'  
   + '<LOS>0</LOS>'  
   + '<EKO>0,00</EKO>'  
   + '</INI>',3,'','INI','',0,0  
  where not exists( select 1 from rtLinhaDIMSAux where   
   LinhaXML = '<INI>'   
   + '<MAN>01</MAN>'  
   + '<LOR>0</LOR>'  
   + '<RNU>0</RNU>'  
   + '<KNU>0</KNU>'  
   + '<ID2>0</ID2>'  
   + '<ID3>0</ID3>'  
   + '<ID4>0</ID4>'  
   + '<ID5>0</ID5>'  
   + '<ISY>200000000099</ISY>'   
   + '<SDA>28800</SDA>'  
   + '<MDA>14400</MDA>'  
   + '<RTE></RTE>'  
   + '<FTE></FTE>'  
   + '<STE></STE>'  
   + '<MEN>0,00</MEN>'  
   + '<MEI>1</MEI>'  
   + '<ALL>0</ALL>'  
   + '<ZP1>1</ZP1>'  
   + '<ZP2>1</ZP2>'  
   + '<ZP3>1</ZP3>'  
   + '<ZP4>0</ZP4>'  
   + '<ZP5>1</ZP5>'  
   + '<SY1>0</SY1>'  
   + '<SY2>0</SY2>'  
   + '<KAL>0</KAL>'  
   + '<LOS>0</LOS>'  
   + '<EKO>0,00</EKO>'  
   + '</INI>')  
    
  --- (4) BIN-Element (detailed structure see 1.2)  
  insert rtLinhaDIMSAux   
  select '<BIN>'   
   + '<BDA>' +rtrim(ltrim( @DataAtual)) + '</BDA>'  
   + '<VER>2.0</VER>'  
   + '<TYP>' + rtrim(ltrim(@TipoEnvio)) + '</TYP>'  
   + '<CSN>' + rtrim(ltrim(convert(char(12),@CSN))) + '</CSN>'  
   + '<LSN>' + rtrim(ltrim(convert(char(12),COALESCE((select UltimoNumeroCSN from tbParametroDIMS  with (NOLOCK)  
                where CodigoEmpresa = @CodigoEmpresa  
                and   CodigoLocal   = @CodigoLocal),0)))) + '</LSN>'  
   + '<DMS-VERS>' + rtrim(ltrim(convert(char(10),replace(( select max(VersaoSetup)   
                 from tbControleVersaoSetup  with (NOLOCK)  
                 where tbControleVersaoSetup.DataInstalacaoSetup =   
                      (select max(cv.DataInstalacaoSetup)   
                        from tbControleVersaoSetup cv  with (NOLOCK))),'.','')))) + '</DMS-VERS>'  
   + '<DMS>DealerPlus</DMS>'  
   + '</BIN>' ,4, '','BIN','',0,0  
   where not exists(select 1 from rtLinhaDIMSAux where SiglaTAG = 'BIN' and Sequencia = 4)   
    
  ---- Se for Carga Inicial ou Sincronismo enviar os Dados do Produto de Part Master Data Elements  
  if @TipoEnvio = 1 or @TipoEnvio = 3  
  begin  
  
   ---- Inclusão de informações referentes ao registro (BES) -   - Estoque Disponivel.  

   insert rtLinhaDIMSAux   
   select '<BES>' +   
          '<BBC>R20</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(LEFT(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(psdp.Disponivel,0))),10),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R20',2,coalesce(psdp.Disponivel,0)  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoDisponivelProduto psdp   with (NOLOCK)  
      on psdp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and psdp.CodigoLocal = @CodigoLocal  
       and psdp.CodigoProduto = tbProduto.CodigoProduto   
        
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND tbLinhaProduto.RecapagemLinhaProduto = 'F'  
     
   ---- Inclusão de informações referentes ao registro (BES) - R21 - Estoque Reservado para quem não teve movimentação.  
     
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R21</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
             else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(17,2),coalesce(pspp.EstoqueProcesso,0))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R21',3,coalesce(pspp.EstoqueProcesso,0)  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoProcessoProdutoDIMS pspp   with (NOLOCK)  
      on pspp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pspp.CodigoLocal = @CodigoLocal  
       and pspp.CodigoProduto = tbProduto.CodigoProduto   
        
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND tbLinhaProduto.RecapagemLinhaProduto = 'F'  
     
   --AND pspp.EstoqueProcesso <> 0  
     
   ---- Inclusão de informações referentes ao registro (BES) - R22 - Pedidos Pendentes.  
     
   insert rtLinhaDIMSAux   
   select '<BES>' +   
          '<BBC>R22</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0)))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R22',4,sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0))  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join tbEncomenda pcp   with (NOLOCK)  
      on pcp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcp.CodigoLocal = @CodigoLocal  
       and pcp.CodigoProduto = tbProduto.CodigoProduto   
       AND pcp.PedidoCompraDIMS = 'F'  
      AND   coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0) <> 0  
        
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
    
   group by tbProduto.CodigoEmpresa,  
      tbProduto.CodigoProduto,  
      tbLocal.ContaConcessao  
  
   ---- Inclusão de informações referentes ao registro (STL).  
   insert rtLinhaDIMSAux   
   select DISTINCT '<STL>' +   
          '<SBC>R70</SBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(COALESCE(tbLocal.ContaConcessao,'0'))) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<LAR>' + case when (SELECT count(tbLocacaoProduto.CodigoProduto)  
          FROM  tbLocacaoProduto   with (NOLOCK)  
          WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
          AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
          AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
          AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto) > 0   
          then '1'  
          else '2'  
          end + '</LAR>' +  
       '<LO1>' + ltrim(rtrim(convert(char(8),coalesce((SELECT MIN(CodigoLocacao) --- Locação 1 do produto.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')))) + '</LO1>' +  
       '<LO2>' + ltrim(rtrim(convert(char(8),case when (SELECT count(CodigoLocacao)  --- caso tenha mais de uma locação colocar aki.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto)>1  
             then coalesce((SELECT MAX(CodigoLocacao)   
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')  
             else ''  
             end)))  + '</LO2>' +  
       '<TAR>' + case when tbLinhaProduto.PneuLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 7 --- Pneus  
                      then '4'  
                      else case when tbLinhaProduto.CombustivelLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 6 --- Combustiveis/Lubrificantes  
           then '5'  
           else ''  
           end  
                      end + '</TAR>' +  
       '<BLP>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,2),coalesce(tbProdutoFT.PrecoReposicaoIndiceProduto,0))),' ',''),'.',',') + '</BLP>' + --- Preço de Lista MBB  
       '<DAK>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,4),coalesce(pcmp.CustoMedioUnitario,0))),' ',''),'.',',') + '</DAK>' + --- Preço de Custo  
       '<NPR>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,2),coalesce((select prvd.ValorTabelaPreco from vwMaxPrecoVenda prvd  with (NOLOCK)  
                        where prvd.CodigoEmpresa = tbProduto.CodigoEmpresa   
                        and prvd.CodigoProduto = tbProduto.CodigoProduto),0))),' ',''),'.',',') + '</NPR>' + --- Preço Liquido  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFonteFornecimento.CodigoFornecedorFabricante,'')))) + '</LIE>' +  
       '<ABE>' + '</ABE>' +  
       '<BEN>' + LEFT(dbo.fnRemoveSpecialCharacter(tbProduto.DescricaoProduto),25) + '</BEN>' +   
       '<RGR></RGR>' +  
       '<VP1>' + rtrim(ltrim(left(convert(char(10),tbProdutoFT.EmbalagemComercialProduto),7))) + '</VP1>' +  
       '<BVE>' + dbo.fnRemoveSpecialCharacter(LEFT(COALESCE(tbProdutoFT.EspecificacoesTecnicasProduto,''),25)) + '</BVE>' +  
       case when @TipoEnvio = 1  
            then '<ADA>' + rtrim(ltrim(convert(char(10),tbProdutoFT.DataCadastroProduto,104) + '-' + left(convert(char(30),tbProdutoFT.DataCadastroProduto,114),8))) + '</ADA>' +  
        replace(case when tbPlanejamentoProduto.DataUltimaVenda is not null  
            then '<DLA>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaVenda,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaVenda,114),8))) + '</DLA>'  
            else '<DLA>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'S'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLA>'  
          end, '<DLA>-</DLA>', '<DLA></DLA>') +  
        replace(case when tbPlanejamentoProduto.DataUltimaCompra is not null  
            then '<DLZ>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaCompra,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaCompra,114),8))) + '</DLZ>'   
            else '<DLZ>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'E'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLZ>'  
             end , '<DLZ>-</DLZ>', '<DLZ></DLZ>')  
            else ''   
           end +  
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '</STL>',90,tbProduto.CodigoProduto,'STL','R70' ,5,0  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
  
    left join tbPlanejamentoProduto   with (NOLOCK)  
      on tbPlanejamentoProduto.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and tbPlanejamentoProduto.CodigoLocal = @CodigoLocal  
       and tbPlanejamentoProduto.CodigoProduto = tbProduto.CodigoProduto   
  
    inner join  tbFonteFornecimento   with (NOLOCK)       
      on tbFonteFornecimento.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbFonteFornecimento.CodigoFonteFornecimento = tbProdutoFT.CodigoFonteFornecimento      
      
    left join vwCustoMedioProdutoAtual pcmp   with (NOLOCK)  
      on pcmp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcmp.CodigoLocal = @CodigoLocal  
       and pcmp.CodigoProduto = tbProduto.CodigoProduto   
  
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND tbLinhaProduto.RecapagemLinhaProduto = 'F'  
  
  end  
  
  ---- Enviar as para tipos de registros 1 e 2 somente  
    
  if @TipoEnvio = 1 OR @TipoEnvio = 2 or @TipoEnvio = 3  
  begin  
     ---- Inclusão de informações referentes ao registro (FLM - R41A/R31A - with order number (Workshop)) - (Oficina / não garantia).  
    
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when GeraDemandaTipoMovimentacao = 'V'  
          then 'R41A'  
          else 'R31A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),rtMovimentacaoEstoqueDIMS.CPF_CNPJ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal,'FLM',case when GeraDemandaTipoMovimentacao = 'V'  
                        then 'R41A'  
                        else 'R31A'  
                        end,1,0  
         
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.OrigemDocumento = 'OS'  
   and   rtMovimentacaoEstoqueDIMS.Garantia = 'F'  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao not in (15,17,93,98) --- Vendas de Produtos Refugos / Acerto Inventario / Vendas Produtos Recompra Fabrica   
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
      
   ---- Inclusão de informações referentes ao registro (FLM - R42A/R32A - with order number (Sales Counter)) - (Telemarketing/Faturamento).  
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when GeraDemandaTipoMovimentacao = 'V'  
          then 'R42A'  
          else 'R32A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),rtMovimentacaoEstoqueDIMS.CPF_CNPJ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
             then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
             else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLM',case when GeraDemandaTipoMovimentacao = 'V'  
                         then 'R42A'  
                         else 'R32A'  
                         end ,1,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.OrigemDocumento in ('TK','FT')  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao not in (5,14,7,15,17,93,98) --- Vendas de Produtos Refugos / Acerto Inventario / Vendas Produtos Recompra Fabrica -- CAC 145473 -- > não enviar tb remessa de produtos de terceiros e próprios   
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''   
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
     
   ---- Inclusão de informações referentes ao registro (FLM - R43A/R33A - number (Branch Company)) - (Faturamento).  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when GeraDemandaTipoMovimentacao = 'V'  
          then 'R43A'  
          else 'R33A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +   
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14), rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
             then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
             else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLM',case when GeraDemandaTipoMovimentacao = 'V'  
                           then 'R43A'  
                           else 'R33A'  
                           end ,1,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.OrigemDocumento in ('FT','TK','OS')  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao not in (15,17,93,98) --- Vendas de Produtos Refugos / Acerto Inventario / Vendas Produtos Recompra Fabrica   
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino <> ''   
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
     
   ---- Inclusão de informações referentes ao registro (FLM - R44A/R34A - with order number (Warranty)) - (Oficina / Garantia).  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when GeraDemandaTipoMovimentacao = 'V'  
          then 'R44A'  
          else 'R34A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +      '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),rtMovimentacaoEstoqueDIMS.CPF_CNPJ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
             then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
             else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLM', case when GeraDemandaTipoMovimentacao = 'V'  
                        then 'R44A'  
                        else 'R34A'  
                        end ,1,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.OrigemDocumento = 'OS'  
   and   rtMovimentacaoEstoqueDIMS.Garantia = 'V'  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao not in (15,17,93,98) --- Vendas de Produtos Refugos / Acerto Inventario / Vendas Produtos Recompra Fabrica   
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
  
   ---- Inclusão de informações referentes ao registro (FLM - R03A) - Venda de Produtos para Remanufatura (carcaça).  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       case when rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 98  
         then '<FBC>R03A</FBC>'   
         else case when rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao in (3,17)  
          then '<FBC>R32A</FBC>'   
          else case when rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 9  
           then '<FBC>R33A</FBC>'  
           end  
          end  
         end +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''   
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
             then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
             else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal,'FLM','R03A',1,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao in (3,17,9,98) --- Vendas de Produtos Refugos / Acerto Inventario / Vendas Produtos Recompra Fabrica   
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   (rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'V' or rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'V')  
     
   ---- Inclusão de informações referentes ao registro (FLM - R48A/R38A) - (Vendas Perdida FT/TK).  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when tbMotivoVendaPerdida.AtualizaFrequenciaVenda = 'V'  
          then 'R48A'  
          else 'R38A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbVendaPerdida.CodigoProduto,1) = 'A' OR left(tbVendaPerdida.CodigoProduto,1) = 'H' OR left(tbVendaPerdida.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbVendaPerdida.CodigoProduto))) = 11 or len(rtrim(ltrim(tbVendaPerdida.CodigoProduto))) = 15 or len(rtrim(ltrim(tbVendaPerdida.CodigoProduto))) = 19   
               then left(tbVendaPerdida.CodigoProduto,1) + '  ' + substring(tbVendaPerdida.CodigoProduto,2,29)  
               else tbVendaPerdida.CodigoProduto  
               end  
           else tbVendaPerdida.CodigoProduto  
           end,tbVendaPerdida.CodigoProduto)))) + '</RNU>' +                
       '<ISY>80</ISY>' +  
       '<KNU>' + case when cf.CodigoCliFor is null  
                      then '0'  
                      else rtrim(ltrim(CONVERT(CHAR(14),case when cf.TipoCliFor = 'F'  
                then case when cff.CPFFisica <> 'ISENTO'  
                    then case when len(rtrim(ltrim(cff.CPFFisica)))>9  
                     then left(rtrim(ltrim(cff.CPFFisica)),9)  
                     else rtrim(ltrim(cff.CPFFisica))  
                     end  
                    else case when len(cff.CodigoCliFor)>9  
                     then left(convert(char(15),cff.CodigoCliFor),9)  
                     else convert(char(9),cff.CodigoCliFor)  
                     end  
                    end  
                else case when cfj.CGCJuridica <> 'ISENTO'  
                    then case when len(rtrim(ltrim(cfj.CGCJuridica))) > 8  
                     then left(rtrim(ltrim(cfj.CGCJuridica)),8)  
                     else rtrim(ltrim(cfj.CGCJuridica))  
                     end            
                    else case when len(cfj.CodigoCliFor)>8  
                     then left(convert(char(15),cfj.CodigoCliFor),8)  
                     else convert(char(8),cfj.CodigoCliFor)  
                     end  
                    end  
                end)))   
         end + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),COALESCE(tbVendaPerdida.NumeroPedido,0)))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),COALESCE(tbVendaPerdida.SequenciaPedido,0)))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),tbVendaPerdida.DataVendaPerdida,104) + '-' + left(convert(char(30),tbVendaPerdida.DataVendaPerdida,114),8))) + '</RTE>' +  
       '<MEN>' + rtrim(ltrim(REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(tbVendaPerdida.QuantidadeVendaPerdida,0) * (-1))),' ',''),'.',','))) + '</MEN>' +  
       '</FLM>'  ,90,tbVendaPerdida.CodigoProduto, 'FLM',case when tbMotivoVendaPerdida.AtualizaFrequenciaVenda = 'V'  
                     then 'R38A'  
                     else 'R48A'  
                     end,1,0  
         
   from tbVendaPerdida  with (NOLOCK)  
     
   inner join tbLocal  with (NOLOCK)  
     on  tbLocal.CodigoEmpresa = tbVendaPerdida.CodigoEmpresa   
     and tbLocal.CodigoLocal  = tbVendaPerdida.CodigoLocal   
       
   inner join tbMotivoVendaPerdida  with (NOLOCK)  
     on  tbMotivoVendaPerdida.CodigoEmpresa  = tbVendaPerdida.CodigoEmpresa   
     and tbMotivoVendaPerdida.MotivoVendaPerdida = tbVendaPerdida.MotivoVendaPerdida   
       
   LEFT JOIN tbCliFor cf    with (NOLOCK)  
    ON  cf.CodigoEmpresa     = tbVendaPerdida.CodigoEmpresa  
    AND cf.CodigoCliFor      = tbVendaPerdida.CodigoCliFor  
  
   LEFT JOIN tbProdutoFT pf    with (NOLOCK)  
    ON  pf.CodigoEmpresa     = tbVendaPerdida.CodigoEmpresa   
    AND pf.CodigoProduto     = tbVendaPerdida.CodigoProduto  
  
   INNER JOIN tbLinhaProduto lp    with (NOLOCK)  
    ON  lp.CodigoEmpresa         = pf.CodigoEmpresa  
    AND lp.CodigoLinhaProduto    = pf.CodigoLinhaProduto  
     
   LEFT JOIN tbCliForFisica cff   with (NOLOCK)   
    ON cff.CodigoEmpresa     = tbVendaPerdida.CodigoEmpresa  
    AND cff.CodigoCliFor      = tbVendaPerdida.CodigoCliFor  
  
   LEFT JOIN tbCliForJuridica cfj   with (NOLOCK)   
    ON cfj.CodigoEmpresa     = tbVendaPerdida.CodigoEmpresa  
    AND cfj.CodigoCliFor      = tbVendaPerdida.CodigoCliFor  
       
   where tbVendaPerdida.CodigoEmpresa   = @CodigoEmpresa  
   AND   tbVendaPerdida.CodigoLocal   = @CodigoLocal  
   AND   tbMotivoVendaPerdida.GerarDIMS    = 'V'   
   AND   tbVendaPerdida.DataEnvioDIMS  is null  
   AND   convert(char(10),tbVendaPerdida.DataVendaPerdida,120)  BETWEEN @DataInicial AND @DataFinal   
   AND   ((lp.TipoLinhaProduto    in (0,1,2)) or (lp.GeraMovtoDIMS = 'V'))  
  
   ---- Inclusão de informações referentes ao registro (FLM - R48A/R38A) - (Vendas Perdida Oficina).  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>' + case when tbMotivoVendaPerdida.AtualizaFrequenciaVenda = 'V'  
          then 'R48A'  
          else 'R38A'  
          end + '</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbVendaPerdidaOS.CodigoProduto,1) = 'A' OR left(tbVendaPerdidaOS.CodigoProduto,1) = 'H' OR left(tbVendaPerdidaOS.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbVendaPerdidaOS.CodigoProduto))) = 11 or len(rtrim(ltrim(tbVendaPerdidaOS.CodigoProduto))) = 15 or len(rtrim(ltrim(tbVendaPerdidaOS.CodigoProduto))) = 19   
               then left(tbVendaPerdidaOS.CodigoProduto,1) + '  ' + substring(tbVendaPerdidaOS.CodigoProduto,2,29)  
               else tbVendaPerdidaOS.CodigoProduto  
               end  
           else tbVendaPerdidaOS.CodigoProduto  
           end,tbVendaPerdidaOS.CodigoProduto)))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + case when cf.CodigoCliFor is null  
                      then '0'  
                      else rtrim(ltrim(CONVERT(CHAR(14),case when cf.TipoCliFor = 'F'  
               then case when cff.CPFFisica <> 'ISENTO'  
                   then case when len(rtrim(ltrim(cff.CPFFisica)))>9  
                    then left(rtrim(ltrim(cff.CPFFisica)),9)  
                    else rtrim(ltrim(cff.CPFFisica))  
                    end  
                   else case when len(cff.CodigoCliFor)>9  
                    then left(convert(char(15),cff.CodigoCliFor),9)  
                    else convert(char(9),cff.CodigoCliFor)  
                    end  
                   end  
               else case when cfj.CGCJuridica <> 'ISENTO'  
                   then case when len(rtrim(ltrim(cfj.CGCJuridica))) > 8  
                    then left(rtrim(ltrim(cfj.CGCJuridica)),8)  
                    else rtrim(ltrim(cfj.CGCJuridica))  
                    end            
                   else case when len(cfj.CodigoCliFor)>8  
                    then left(convert(char(15),cfj.CodigoCliFor),8)  
                    else convert(char(8),cfj.CodigoCliFor)  
                    end  
                   end  
               end)))   
         end + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),COALESCE(tbVendaPerdidaOS.NumeroOROS,0)))) + '</ANU>' +  
       '<APN>1</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),tbVendaPerdidaOS.DataVendaPerdidaOS,104) + '-' + left(convert(char(30),tbVendaPerdidaOS.DataVendaPerdidaOS,114),8))) + '</RTE>' +  
       '<MEN>' + rtrim(ltrim(REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(tbVendaPerdidaOS.QtdeVendaPerdidaOS,0) * (-1))),' ',''),'.',','))) + '</MEN>' +  
       '</FLM>'  ,90,tbVendaPerdidaOS.CodigoProduto, 'FLM',case when tbMotivoVendaPerdida.AtualizaFrequenciaVenda = 'V'  
                    then 'R48A'  
                    else 'R38A'  
                    end,1,0  
         
   from tbVendaPerdidaOS  with (NOLOCK)  
     
   inner join tbLocal  with (NOLOCK)  
     on  tbLocal.CodigoEmpresa = tbVendaPerdidaOS.CodigoEmpresa   
     and tbLocal.CodigoLocal  = tbVendaPerdidaOS.CodigoLocal   
       
   inner join tbMotivoVendaPerdida  with (NOLOCK)  
     on  tbMotivoVendaPerdida.CodigoEmpresa  = tbVendaPerdidaOS.CodigoEmpresa   
     and tbMotivoVendaPerdida.MotivoVendaPerdida = tbVendaPerdidaOS.MotivoVendaPerdida   
  
   INNER JOIN tbProdutoFT pf   with (NOLOCK)   
    ON  pf.CodigoEmpresa     = tbVendaPerdidaOS.CodigoEmpresa   
    AND pf.CodigoProduto     = tbVendaPerdidaOS.CodigoProduto  
  
   INNER JOIN tbLinhaProduto lp    with (NOLOCK)  
    ON  lp.CodigoEmpresa         = pf.CodigoEmpresa  
    AND lp.CodigoLinhaProduto    = pf.CodigoLinhaProduto  
           
   LEFT JOIN tbCliFor cf    with (NOLOCK)  
    ON cf.CodigoEmpresa     = tbVendaPerdidaOS.CodigoEmpresa  
    AND cf.CodigoCliFor      = tbVendaPerdidaOS.CodigoCliFor  
  
   LEFT JOIN tbCliForFisica cff   with (NOLOCK)   
    ON cff.CodigoEmpresa     = tbVendaPerdidaOS.CodigoEmpresa  
    AND cff.CodigoCliFor      = tbVendaPerdidaOS.CodigoCliFor  
  
   LEFT JOIN tbCliForJuridica cfj    with (NOLOCK)  
    ON cfj.CodigoEmpresa     = tbVendaPerdidaOS.CodigoEmpresa  
    AND cfj.CodigoCliFor      = tbVendaPerdidaOS.CodigoCliFor  
       
   where tbVendaPerdidaOS.CodigoEmpresa     = @CodigoEmpresa  
   AND   tbVendaPerdidaOS.CodigoLocal      = @CodigoLocal  
   AND   tbMotivoVendaPerdida.GerarDIMS    = 'V'  
   AND   tbVendaPerdidaOS.DataEnvioDIMS    is null  
   AND   convert(char(10),tbVendaPerdidaOS.DataVendaPerdidaOS,120) BETWEEN @DataInicial AND @DataFinal   
   AND ( (lp.TipoLinhaProduto in (0,1,2)) or (lp.GeraMovtoDIMS = 'V'))  
     
   ---- Inclusão de informações referentes ao registro (WEI - R40Z - Recebimento de Produtos   
   
   insert rtLinhaDIMSAux   
   select '<WEI>' +   
       '<WBC>R40Z</WBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProdutoSolicitado))) + '</RNU>' +         
       '<RNG>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProduto))) + '</RNG>' +  
       '<ISY>80</ISY>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10), case when CodigoTipoOperacao = 1  
                     then case when rtrim(ltrim(rtMovimentacaoEstoqueDIMS.NumeroEncomenda)) <> '0'  
                   then rtMovimentacaoEstoqueDIMS.NumeroEncomenda  
                   else convert(char(12),rtMovimentacaoEstoqueDIMS.NumeroDocumento)  
                   end  
                  else convert(char(12),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao)  
                  end ))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10), case when CodigoTipoOperacao = 1  
                     then case when rtrim(ltrim(rtMovimentacaoEstoqueDIMS.NumeroEncomenda)) <> '0'  
                   then rtMovimentacaoEstoqueDIMS.ItemEncomenda  
                   else rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                   end  
                     else rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                     end ))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                    then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                    else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                    end,0))),' ',''),'.',',') + '</MEN>' +  
       -----'<MOF>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),QtdeSaldoEncomenda)),' ',''),'.',',') + '</MOF>' +  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFornecedorComplementar.ContaFornecedorDIMS,'')))) + '</LIE>' +  
       '</WEI>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'WEI','R40Z',0 ,0      
  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
     
     left join tbFornecedorComplementar  with (NOLOCK)  
        on  tbFornecedorComplementar.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa   
        and tbFornecedorComplementar.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
             
   where rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
   and   rtMovimentacaoEstoqueDIMS.PedidoEmergencia <> 'V'  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao in (1,9) --- somente para entrada por compra e ou transferencia.  
   AND   (rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao <> 0 and rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao = rtMovimentacaoEstoqueDIMS.NumeroDocumento)  
     
   ---- Inclusão de informações referentes ao registro (WEI - R41Z - Recebimento de Produtos para Remanufatura(Carcaça)  
   ---- Somente compras identificadas como emergencia.  
     
   insert rtLinhaDIMSAux   
   select '<WEI>' +   
       '<WBC>R41Z</WBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProdutoSolicitado))) + '</RNU>' +         
       '<RNG>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProduto))) + '</RNG>' +  
       '<ISY>80</ISY>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10), case when CodigoTipoOperacao = 1  
                     then case when rtrim(ltrim(rtMovimentacaoEstoqueDIMS.NumeroEncomenda)) <> '0'  
                   then rtMovimentacaoEstoqueDIMS.NumeroEncomenda  
                   else convert(char(12),rtMovimentacaoEstoqueDIMS.NumeroDocumento)  
                   end  
                  else convert(char(12),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao)  
                  end ))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10), case when CodigoTipoOperacao = 1  
                     then case when rtrim(ltrim(rtMovimentacaoEstoqueDIMS.NumeroEncomenda)) <> '0'  
                   then rtMovimentacaoEstoqueDIMS.ItemEncomenda  
                   else rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                   end  
                     else rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                     end ))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                    then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                    else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                    end,0))),' ',''),'.',',') + '</MEN>' +  
       ---'<MOF>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),QtdeSaldoEncomenda)),' ',''),'.',',') + '</MOF>' +  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFornecedorComplementar.ContaFornecedorDIMS,'')))) + '</LIE>' +  
       '</WEI>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'WEI', 'R41Z' ,0 ,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
     left join tbFornecedorComplementar  with (NOLOCK)  
        on  tbFornecedorComplementar.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa   
        and tbFornecedorComplementar.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
            
   where rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
   ----AND   rtMovimentacaoEstoqueDIMS.GeraDemandaTipoMovimentacao = 'V'  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   (rtMovimentacaoEstoqueDIMS.PedidoEmergencia = 'V' or rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'V' or rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'V')  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao in (1,5,9) --- somente para entrada por compra e ou transferencia.  
     
     
   ---- Inclusão de informações referentes ao registro (FLO - R10 - without order number) - (Acerto de Inventário).  
   
   insert rtLinhaDIMSAux   
   select '<FLO>' +   
       '<FBC>R10</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''   
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                end ))) + '</KNU>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                    then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                    else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                    end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLO>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLO','R10' ,0 ,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.TipoLancamentoMovimentacao = 5  --- Acerto de Inventario  
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 93  --- Acerto de Inventario  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
  
  end  
  
  ---- Somente para tipo de movimentação diaria.  
  if @TipoEnvio = 2   
  begin  
    
   ---- Inclusão de informações referentes ao registro (BES) - R21 - Estoque Reservado.  
     
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R21</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),left(rtMovimentacaoEstoqueDIMS.CodigoProduto,30)))) + '</RNU>' +  
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(pspp.EstoqueProcesso,0))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'BES','R21',3,coalesce(pspp.EstoqueProcesso,0)  
  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
       
    inner join tbProduto with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbProduto.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoProcessoProdutoDIMS pspp   with (NOLOCK)  
      on pspp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pspp.CodigoLocal = @CodigoLocal  
       and pspp.CodigoProduto = tbProduto.CodigoProduto   
  
   ---- Inclusão de informações referentes ao registro (BES) - R21 - Estoque Reservado.  
     
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R21</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(40),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(pspp.EstoqueProcesso,0))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto, 'BES','R21',3,coalesce(pspp.EstoqueProcesso,0)  
  
   from tbProduto  with (NOLOCK)  
       
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoProcessoProdutoDIMS pspp   with (NOLOCK)  
      on pspp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pspp.CodigoLocal = @CodigoLocal  
       and pspp.CodigoProduto = tbProduto.CodigoProduto   
     WHERE tbProduto.CodigoEmpresa = @CodigoEmpresa   
     AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
    AND tbLinhaProduto.RecapagemLinhaProduto = 'F'  
     AND   NOT EXISTS (select 1 from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
            where rtMovimentacaoEstoqueDIMS.CodigoEmpresa = tbProduto.CodigoEmpresa  
            and   rtMovimentacaoEstoqueDIMS.CodigoLocal = @CodigoLocal  
            and   rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal = tbProduto.CodigoProduto)  
     AND @ExisteMovtoDiario = 'V'  
     
   ---- Inclusão de informações referentes ao registro (BES) - R20 - Estoque Disponivel.  
   
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R20</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),left(rtMovimentacaoEstoqueDIMS.CodigoProduto,30)))) + '</RNU>' +         
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(LEFT(CONVERT(CHAR(30),convert(numeric(17,2),coalesce(psdp.Disponivel,0))),10),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'BES','R20',2,coalesce(psdp.Disponivel,0)  
  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
       
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbProduto.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
        
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoDisponivelProduto psdp   with (NOLOCK)  
      on psdp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and psdp.CodigoLocal = @CodigoLocal  
       and psdp.CodigoProduto = tbProduto.CodigoProduto   
   where ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
  
  end  
    
  ---- Somente para tipo de movimentação de Sincronismo.  
  if @TipoEnvio = 3  
  begin  
    
   ---- Inclusão de informações referentes ao registro (BES) - R21 - Estoque Reservado.  
  
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R21</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),left(rtMovimentacaoEstoqueDIMS.CodigoProduto,30)))) + '</RNU>' +  
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(pspp.EstoqueProcesso,0))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'BES','R21',3,coalesce(pspp.EstoqueProcesso,0)  
  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
       
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbProduto.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoProcessoProdutoDIMS pspp   with (NOLOCK)  
      on pspp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pspp.CodigoLocal = @CodigoLocal  
       and pspp.CodigoProduto = tbProduto.CodigoProduto  
   where tbProduto.CodigoEmpresa = @CodigoEmpresa   
   AND ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND tbLinhaProduto.RecapagemLinhaProduto = 'F'  
    AND   NOT EXISTS (select 1 from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
            where rtMovimentacaoEstoqueDIMS.CodigoEmpresa = tbProduto.CodigoEmpresa  
            and   rtMovimentacaoEstoqueDIMS.CodigoLocal = @CodigoLocal  
            and   rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal = tbProduto.CodigoProduto)   
  
   ---- Inclusão de informações referentes ao registro (BES) - R21 - Estoque Reservado.  
     
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R21</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(pspp.EstoqueProcesso,0))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto, 'BES','R21',3,coalesce(pspp.EstoqueProcesso,0)  
  
   from tbProduto  with (NOLOCK)  
       
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoProcessoProdutoDIMS pspp   with (NOLOCK)  
      on pspp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pspp.CodigoLocal = @CodigoLocal  
       and pspp.CodigoProduto = tbProduto.CodigoProduto   
     WHERE tbProduto.CodigoEmpresa = @CodigoEmpresa  
     AND ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
       AND tbLinhaProduto.RecapagemLinhaProduto = 'F'   
    AND   not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
            where rtLinhaDIMSAux.SiglaTAG = 'BES'  
            and   rtLinhaDIMSAux.ConteudoTAG = 'R21'  
            and   rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto )  
    AND @ExisteMovtoDiario = 'V'  
       
              
   ---- Inclusão de informações referentes ao registro (BES) - R20 - Estoque Disponivel.  
   insert rtLinhaDIMSAux   
   select distinct '<BES>' +   
          '<BBC>R20</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),left(rtMovimentacaoEstoqueDIMS.CodigoProduto,30)))) + '</RNU>' +         
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(LEFT(CONVERT(CHAR(30),convert(numeric(17,2),coalesce(psdp.Disponivel,0))),10),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'BES','R20',2,coalesce(psdp.Disponivel,0)  
  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
       
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbProduto.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
        
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoDisponivelProduto psdp   with (NOLOCK)  
      on psdp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and psdp.CodigoLocal = @CodigoLocal  
       and psdp.CodigoProduto = tbProduto.CodigoProduto   
    where ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
  
  end  
    
  if @TipoEnvio = 1 or @TipoEnvio = 2 or @TipoEnvio = 3  
  begin  
   ---- Inclusão de informações referentes ao registro (FLM - R35A - with order number) - (Vendas de Produtos Refugos).  
   ---- FLM BOOKING CODE R35A (SUCATEAMENTO)  
   
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>R35A</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                    then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                    else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                    end,0))),' ',''),'.',',') + '</MEN>' +         
       '</FLM>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLM','R35A' ,1,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 17  --- Vendas de Produtos Refugos.  
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
     
   ---- Inclusão de informações referentes ao registro (FLO - R10 - without order number) - (Produtos Refugos).   
   
   insert rtLinhaDIMSAux   
   select '<FLO>' +   
       '<FBC>R10</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(@ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'A' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'H' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 11 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 15 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 19   
               then left(tbRegistroMovtoEstoque.CodigoProduto,1) + '  ' + substring(tbRegistroMovtoEstoque.CodigoProduto,2,29)  
               else tbRegistroMovtoEstoque.CodigoProduto  
               end  
           else tbRegistroMovtoEstoque.CodigoProduto  
           end,tbRegistroMovtoEstoque.CodigoProduto)))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),@ContaConcessao ))) + '</KNU>' +  
       '<RTE>' +rtrim(ltrim(convert(char(10), tbRegistroMovtoEstoque.DataMovtoEstoque,104)+ '-' + left(convert(char(30),tbRegistroMovtoEstoque.timestamp,114),8))) + '</RTE>' +   
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque = 'S'  
             then tbRegistroMovtoEstoque.QuantidadeMovtoEstoque * (-1)  
             else tbRegistroMovtoEstoque.QuantidadeMovtoEstoque   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLO>' ,90,tbRegistroMovtoEstoque.CodigoProduto, 'FLO','R10' ,0 ,0  
     
   from tbRegistroMovtoEstoque  with (NOLOCK)  
      
      inner join tbAlmoxarifado   with (NOLOCK)  
       on  tbAlmoxarifado.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
       and tbAlmoxarifado.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
       and tbAlmoxarifado.CodigoAlmoxarifado = tbRegistroMovtoEstoque.CodigoAlmoxarifado  
     
   where tbRegistroMovtoEstoque.CodigoEmpresa = @CodigoEmpresa   
   and   tbRegistroMovtoEstoque.CodigoLocal = @CodigoLocal   
   and   tbRegistroMovtoEstoque.OrigemDocumentoMovtoEstoque IN (15,21)  --- Movimentação para Refugo.  
   and   tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque in ('S','E')  
   and   tbAlmoxarifado.ProducaoAlmoxarifado = 'V'  
   and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal  
   and   not exists (select 1 from tbRegistroMovtoEstoqueDIMS  with (NOLOCK)  
          where tbRegistroMovtoEstoqueDIMS.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
          and   tbRegistroMovtoEstoqueDIMS.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
          and   tbRegistroMovtoEstoqueDIMS.SequenciaMovtoEstoque = tbRegistroMovtoEstoque.SequenciaMovtoEstoque)  
     
   -------- Inclusão de informações referentes ao registro (FLO - R10 - Pedidos Reservados e Não Faturados) - (Produtos Refugos).   
   -------- Gera registro de devolução para o Estoque para fechar com a saida para o almox de refugo;  
   --------  #####  
     
   insert rtLinhaDIMSAux   
   select distinct '<FLO>' +   
       '<FBC>R10</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(@ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'A' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'H' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 11 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 15 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 19   
               then left(tbRegistroMovtoEstoque.CodigoProduto,1) + '  ' + substring(tbRegistroMovtoEstoque.CodigoProduto,2,29)  
               else tbRegistroMovtoEstoque.CodigoProduto  
               end  
           else tbRegistroMovtoEstoque.CodigoProduto  
           end,tbRegistroMovtoEstoque.CodigoProduto)))) + '</RNU>' +  
  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),@ContaConcessao ))) + '</KNU>' +  
       '<RTE>' +rtrim(ltrim(convert(char(10), tbRegistroMovtoEstoque.DataMovtoEstoque,104)+ '-' + left(convert(char(30),tbRegistroMovtoEstoque.timestamp,114),8))) + '</RTE>' +   
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque = 'S'  
             then tbRegistroMovtoEstoque.QuantidadeMovtoEstoque * (-1)  
             else tbRegistroMovtoEstoque.QuantidadeMovtoEstoque   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLO>' ,90,tbRegistroMovtoEstoque.CodigoProduto, 'FLO','R10' ,0,0   
     
   from tbRegistroMovtoEstoque  with (NOLOCK)  
      
      inner join tbAlmoxarifado   with (NOLOCK)  
       on  tbAlmoxarifado.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
       and tbAlmoxarifado.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
       and tbAlmoxarifado.CodigoAlmoxarifado = tbRegistroMovtoEstoque.CodigoAlmoxarifado  
         
   where tbRegistroMovtoEstoque.CodigoEmpresa = @CodigoEmpresa   
   and   tbRegistroMovtoEstoque.CodigoLocal = @CodigoLocal   
   and   tbRegistroMovtoEstoque.OrigemDocumentoMovtoEstoque in (7,21)  --- Movimentação para Refugo.     
   and   tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque = 'E'  
   and   tbAlmoxarifado.ProducaoAlmoxarifado = 'F'  
   and   tbAlmoxarifado.TipoAlmoxarifadoConsumo = 'V'  
   and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal  
   and   not exists (select 1 from tbRegistroMovtoEstoqueDIMS  with (NOLOCK)  
          where tbRegistroMovtoEstoqueDIMS.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
          and   tbRegistroMovtoEstoqueDIMS.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
          and   tbRegistroMovtoEstoqueDIMS.SequenciaMovtoEstoque = tbRegistroMovtoEstoque.SequenciaMovtoEstoque)  
   and   exists (select 1 from tbItemPedido  with (NOLOCK)  
         inner join tbNaturezaOperacao  with (NOLOCK)  
         on  tbItemPedido.CodigoEmpresa = tbNaturezaOperacao.CodigoEmpresa  
         and tbItemPedido.CodigoNaturezaOperacao = tbNaturezaOperacao.CodigoNaturezaOperacao  
         where tbRegistroMovtoEstoque.CodigoEmpresa = tbItemPedido.CodigoEmpresa  
         and   tbRegistroMovtoEstoque.CodigoLocal = tbItemPedido.CodigoLocal  
         and   tbRegistroMovtoEstoque.NumeroDocumentoMovtoEstoque = tbItemPedido.NumeroPedido  
         and   tbRegistroMovtoEstoque.CodigoProduto = tbItemPedido.CodigoProduto  
         and   tbRegistroMovtoEstoque.CodigoAlmoxarifado = tbItemPedido.CodigoAlmoxarifadoDestino  
         and   tbNaturezaOperacao.CodigoTipoOperacao not in(15))  
  
   ---- Inclusão de informações referentes ao registro (BES) - para   
   if (select count(tbRegistroMovtoEstoque.CodigoProduto) from tbRegistroMovtoEstoque  with (NOLOCK)  
      where tbRegistroMovtoEstoque.OrigemDocumentoMovtoEstoque in (15,21)  --- Vendas de Produtos Refugos.  
      and   tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque = 'S'  
      and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal) > 0  
   begin  

    insert rtLinhaDIMSAux   
    select distinct '<BES>' +   
        '<BBC>R20</BBC>' +   
        '<MAN>01</MAN>' +  
        '<LOR>' + rtrim(ltrim(@ContaConcessao)) + '</LOR>' +  
        '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'A' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'H' OR left(tbRegistroMovtoEstoque.CodigoProduto,1) = 'W'  
            then CASE when len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 11 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 15 or len(rtrim(ltrim(tbRegistroMovtoEstoque.CodigoProduto))) = 19   
                then left(tbRegistroMovtoEstoque.CodigoProduto,1) + '  ' + substring(tbRegistroMovtoEstoque.CodigoProduto,2,29)  
                else tbRegistroMovtoEstoque.CodigoProduto  
                end  
            else tbRegistroMovtoEstoque.CodigoProduto  
            end,tbRegistroMovtoEstoque.CodigoProduto)))) + '</RNU>' +  
        '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
        '<MEN>' + REPLACE(REPLACE(LEFT(CONVERT(CHAR(30),convert(numeric(17,2),coalesce(psdp.Disponivel,0))),10),' ',''),'.',',') + '</MEN>' + --- Quantidade  
        '</BES>',90,tbRegistroMovtoEstoque.CodigoProduto, 'BES','R20',2,coalesce(psdp.Disponivel,0)  
  
    from tbRegistroMovtoEstoque  with (NOLOCK)  
      
     inner join tbProdutoFT  with (NOLOCK)  
       on  tbProdutoFT.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
       and tbProdutoFT.CodigoProduto = tbRegistroMovtoEstoque.CodigoProduto  
       
     inner join tbLinhaProduto  with (NOLOCK)  
       on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
       and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto      
         
     left join vwSaldoDisponivelProduto psdp   with (NOLOCK)  
       on psdp.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa   
        and psdp.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
        and psdp.CodigoProduto = tbRegistroMovtoEstoque.CodigoProduto   
          
    where tbRegistroMovtoEstoque.CodigoEmpresa = @CodigoEmpresa   
    and   tbRegistroMovtoEstoque.CodigoLocal = @CodigoLocal   
    and   tbRegistroMovtoEstoque.OrigemDocumentoMovtoEstoque in (15,21)  --- Movimentação para Refugo.  
    and   tbRegistroMovtoEstoque.EntradaSaidaMovtoEstoque = 'S'  
    and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal   
    AND   ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
    and   not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
            where rtLinhaDIMSAux.SiglaTAG = 'BES'  
            and   rtLinhaDIMSAux.ConteudoTAG = 'R20'  
            and   rtLinhaDIMSAux.CodigoProduto = tbRegistroMovtoEstoque.CodigoProduto )  
   end  
     
   ---- Inclusão de informações referentes ao registro (FLM - R36A - with order number) - (Recompra Fabrica).  
  
   insert rtLinhaDIMSAux   
   select '<FLM>' +   
       '<FBC>R36A</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
          '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
             then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
             else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
             end,0))),' ',''),'.',',') + '</MEN>' +  
       '</FLM>' ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLM','R36A',1 ,0   
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
   where rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 98   --- Vendas de Produtos Recompra Fabrica.  
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.Carcaca_Remanufatura = 'F'  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
     
   ---- Inclusão de informações referentes ao registro (FLK - Sales Reversal Element (Cancelamento de Vendas).  
   ---- Notas fiscais de vendas canceladas e entradas por devolução de vendas (Oficina)  
   
   insert rtLinhaDIMSAux   
   select '<FLK>' +   
       '<FBC>R06Z</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento_Devolucao))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto)),' ',''),'.',',') + '</MEN>' +  
       '</FLK>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal,'FLK','R06Z',0 ,0  
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
    inner join tbDocumentoFT   with (NOLOCK)       
      on  tbDocumentoFT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbDocumentoFT.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
      and tbDocumentoFT.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
      and tbDocumentoFT.EntradaSaidaDocumento = case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
                    then 'S'  
                    else 'E'  
                    end  
      and tbDocumentoFT.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
      and tbDocumentoFT.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
      
    inner join tbCIT  with (NOLOCK)  
      on  tbCIT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbCIT.CodigoCIT = tbDocumentoFT.CodigoCIT  
        
   where rtMovimentacaoEstoqueDIMS.GeraDemandaTipoMovimentacao = 'V'  
   and   rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto <> 0  
   and   ((rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F' )  
    or (rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'V' ))  
      and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 7   
   and   tbDocumentoFT.OrigemDocumentoFT = 'OS'  
   and   tbCIT.GarantiaCIT = 'F'  
     
   ---- Inclusão de informações referentes ao registro (FLK - Sales Reversal Element (Cancelamento de Vendas).  
   ---- Notas fiscais de vendas canceladas e entradas por devolução de vendas (Faturamento/Tele)  
     
   insert rtLinhaDIMSAux ---------##### colocar regra para devolução da fabrica de carcaça entrar como R05Z  
   select '<FLK>' +   
       case when rtMovimentacaoEstoqueDIMS.ClassificacaoAtividade = 0      
      then '<FBC>R05Z</FBC>'   
      else '<FBC>R07Z</FBC>'   
      end +  
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento_Devolucao))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto)),' ',''),'.',',') + '</MEN>' +  
       '</FLK>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal,'FLK','R07Z',0 ,0   
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
    left join tbDocumentoFT   with (NOLOCK)       
      on  tbDocumentoFT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbDocumentoFT.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
      and tbDocumentoFT.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
      and tbDocumentoFT.EntradaSaidaDocumento = case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
                    then 'S'  
                    else 'E'  
                    end  
      and tbDocumentoFT.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
      and tbDocumentoFT.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
     
   where rtMovimentacaoEstoqueDIMS.GeraDemandaTipoMovimentacao = 'V'  
   and   rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto <> 0  
   and   ((rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F' )  
    or (rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'V' ))  
      and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 7   
   and   ((tbDocumentoFT.OrigemDocumentoFT in ('TK', 'FT'))   
     or ((tbDocumentoFT.OrigemDocumentoFT = null)  
      and ((rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F' ))))  
  
   ---- Inclusão de informações referentes ao registro (FLK - Sales Reversal Element (Cancelamento de Vendas).  
   ---- Notas fiscais de vendas canceladas e entradas por devolução de vendas (Remessa Filial)  
     
   insert rtLinhaDIMSAux   
   select '<FLK>' +   
       '<FBC>R08Z</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento_Devolucao))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto)),' ',''),'.',',') + '</MEN>' +  
       '</FLK>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLK','R08Z' ,0,0   
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
    inner join tbDocumentoFT   with (NOLOCK)       
      on  tbDocumentoFT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbDocumentoFT.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
      and tbDocumentoFT.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
      and tbDocumentoFT.EntradaSaidaDocumento = case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
                    then 'S'  
                    else 'E'  
                    end  
      and tbDocumentoFT.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
      and tbDocumentoFT.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
  
    inner join tbNaturezaOperacao  with (NOLOCK)  
      on tbNaturezaOperacao.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao  
  
   where rtMovimentacaoEstoqueDIMS.GeraDemandaTipoMovimentacao = 'V'  
   and   rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto <> 0  
   and   ((rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F' )  
    or (rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'V' ))  
      and   tbNaturezaOperacao.CodigoTipoOperacao = 9  
   and   tbDocumentoFT.OrigemDocumentoFT <> 'OS'  
   AND   rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao <> rtMovimentacaoEstoqueDIMS.NumeroDocumento  
     
   ---- Inclusão de informações referentes ao registro (FLK - Sales Reversal Element (Cancelamento de Vendas).  
   ---- Notas fiscais de vendas canceladas e entradas por devolução de vendas (Oficina-Garantia)  
     
   insert rtLinhaDIMSAux   
   select '<FLK>' +   
       '<FBC>R09Z</FBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),CodigoProduto))) + '</RNU>' +  
       '<ISY>80</ISY>' +  
       '<KNU>' + rtrim(ltrim(CONVERT(CHAR(14),case when rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino = ''  
                  then rtMovimentacaoEstoqueDIMS.CPF_CNPJ  
                   else rtMovimentacaoEstoqueDIMS.ContaConcessaoDestino  
                   end ))) + '</KNU>' +  
       '<ANU>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao))) + '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10),rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento_Devolucao))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto)),' ',''),'.',',') + '</MEN>' +  
       '</FLK>'  ,90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'FLK','R09Z',0 ,0    
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
    inner join tbDocumentoFT   with (NOLOCK)       
      on  tbDocumentoFT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbDocumentoFT.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
      and tbDocumentoFT.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
      and tbDocumentoFT.EntradaSaidaDocumento = case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E'  
                    then 'S'  
                    else 'E'  
                    end  
      and tbDocumentoFT.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
      and tbDocumentoFT.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
  
  
    inner join tbCIT  with (NOLOCK)  
      on  tbCIT.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
      and tbCIT.CodigoCIT = tbDocumentoFT.CodigoCIT  
           
   where rtMovimentacaoEstoqueDIMS.GeraDemandaTipoMovimentacao = 'V'  
   and   rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto <> 0  
   and   ((rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'E' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F' )  
    or (rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S' and rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'V' ))  
      and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 7   
   and   tbDocumentoFT.OrigemDocumentoFT = 'OS'  
   and   tbCIT.GarantiaCIT = 'V'    
     
   ---- Extorno de entradas de Compras, neste caso gerar somente para a Devolução de Compra.  --###  
  
   insert rtLinhaDIMSAux   
   select '<WEI>' +   
       '<WBC>' + case when coalesce((select case when min(TipoPedido) = 'EM'  
                                            then 'V'  
                                            else 'F'  
                                            end   
                                            from tbConfdataItem   with (NOLOCK)  
                where tbConfdataItem.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
                and   tbConfdataItem.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
                and   tbConfdataItem.NotaFiscal = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
                and   tbConfdataItem.ProdutoAtendido = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
                ---and   tbConfdataItem.ItemNotaFiscal = rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                ),'F') = 'F'  
          then 'R40R'  
          else 'R41R'  
          end + '</WBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProdutoSolicitado))) + '</RNU>' +         
       '<RNG>' + rtrim(ltrim(convert(char(30),rtMovimentacaoEstoqueDIMS.CodigoProduto))) + '</RNG>' +  
       '<ISY>80</ISY>' +    
       '<ANU>' + Rtrim(ltrim(CONVERT(CHAR(10), coalesce((select max(NumeroDocumentoEncomenda) from tbEncomendaDocumento   with (NOLOCK)  
                    where tbEncomendaDocumento.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
                    and   tbEncomendaDocumento.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
                    and   tbEncomendaDocumento.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
                    and   tbEncomendaDocumento.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
                    and   tbEncomendaDocumento.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
                    and   tbEncomendaDocumento.TipoLancamentoMovimentacao = 1),  
                    ---and   tbEncomendaDocumento.SequenciaItemDocumento = rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento),  
                  convert(char(12),rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao)  
                  ))))+ '</ANU>' +  
       '<APN>' + rtrim(ltrim(CONVERT(CHAR(10), coalesce((select max(SequenciaItemDocumento) from tbEncomendaDocumento   with (NOLOCK)  
                    where tbEncomendaDocumento.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
                    and   tbEncomendaDocumento.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
                    and   tbEncomendaDocumento.CodigoProduto = rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal  
                    and   tbEncomendaDocumento.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento_Devolucao  
                    and   tbEncomendaDocumento.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento_Devolucao  
                    and   tbEncomendaDocumento.TipoLancamentoMovimentacao = 1),  
                    ---and   tbEncomendaDocumento.SequenciaItemDocumento = rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento),  
                     rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento  
                     )))) + '</APN>' +  
       '<RTE>' + rtrim(ltrim(convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,104) + '-' + left(convert(char(30),rtMovimentacaoEstoqueDIMS.TimesTamp,114),8))) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),coalesce(case when rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'  
                    then rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto * (-1)  
                    else rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto   
                    end,0))),' ',''),'.',',') + '</MEN>' +  
       ---'<MOF>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),QtdeSaldoEncomenda)),' ',''),'.',',') + '</MOF>' +  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFornecedorComplementar.ContaFornecedorDIMS,'')))) + '</LIE>' +  
       '</WEI>',90,rtMovimentacaoEstoqueDIMS.CodigoProdutoOriginal, 'WEI',case when rtMovimentacaoEstoqueDIMS.PedidoEmergencia = 'F'   
                      then 'R40R'  
                      else 'R41R'  
                      end ,1 ,0   
            
   from rtMovimentacaoEstoqueDIMS  with (NOLOCK)  
  
     left join tbFornecedorComplementar  with (NOLOCK)  
        on  tbFornecedorComplementar.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa   
        and tbFornecedorComplementar.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
       
   where rtMovimentacaoEstoqueDIMS.QtdeLancamentoItemDocto <> 0  
   and   rtMovimentacaoEstoqueDIMS.CondicaoNFCancelada = 'F'  
   and   rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento = 'S'   
   and   rtMovimentacaoEstoqueDIMS.CodigoTipoOperacao = 7  
   and   rtMovimentacaoEstoqueDIMS.RemanufaturadoLinhaProduto = 'F'  
  
     
   ---- Inclusão de informações referentes ao registro (STL) para os produtos que não tiveram  
   ---- movimentação no periodo, mas que sofreram algum tipo de manutenção no cadatro.  
   
   insert rtLinhaDIMSAux   
   select DISTINCT '<STL>' +   
          '<SBC>R70</SBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(COALESCE(tbLocal.ContaConcessao,'0'))) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<LAR>' + case when (SELECT count(tbLocacaoProduto.CodigoProduto)  
          FROM  tbLocacaoProduto  with (NOLOCK)   
          WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
          AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
          AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
          AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto) > 0   
          then '1'  
          else '2'  
          end + '</LAR>' +  
       '<LO1>' + ltrim(rtrim(convert(char(8),coalesce((SELECT MIN(CodigoLocacao) --- Locação 1 do produto.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')))) + '</LO1>' +  
       '<LO2>' + ltrim(rtrim(convert(char(8),case when (SELECT count(CodigoLocacao)  --- caso tenha mais de uma locação colocar aki.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto)>1  
             then coalesce((SELECT MAX(CodigoLocacao)   
               FROM  tbLocacaoProduto   with (NOLOCK)  
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')  
             else ''  
             end)))  + '</LO2>' +  
       '<TAR>' + case when tbLinhaProduto.PneuLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 7 --- Pneus  
                      then '4'  
                      else case when tbLinhaProduto.CombustivelLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 6 --- Combustiveis/Lubrificantes  
           then '5'  
           else ''  
           end  
                      end + '</TAR>' +  
       '<BLP>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,2),coalesce(tbProdutoFT.PrecoReposicaoIndiceProduto,0))),' ',''),'.',',') + '</BLP>' + --- Preço de Lista MBB  
       '<DAK>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,4),coalesce(pcmp.CustoMedioUnitario,0))),' ',''),'.',',') + '</DAK>' + --- Preço de Custo 
	   --Ajuste para receber valores monetarios grandes 
       '<NPR>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(16,2),coalesce((select prvd.ValorTabelaPreco from vwMaxPrecoVenda prvd  with (NOLOCK)  
                        where prvd.CodigoEmpresa = tbProduto.CodigoEmpresa   
                        and prvd.CodigoProduto = tbProduto.CodigoProduto),0))),' ',''),'.',',') + '</NPR>' + --- Preço Liquido  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFonteFornecimento.CodigoFornecedorFabricante,'')))) + '</LIE>' +  
       '<ABE>' + '</ABE>' +  
       '<BEN>' + LEFT(dbo.fnRemoveSpecialCharacter(tbProduto.DescricaoProduto),25) + '</BEN>' +  
       '<RGR></RGR>' +  
       '<VP1>' + rtrim(ltrim(left(convert(char(10),tbProdutoFT.EmbalagemComercialProduto),7))) + '</VP1>' +  
       '<BVE>' + dbo.fnRemoveSpecialCharacter(LEFT(COALESCE(tbProdutoFT.EspecificacoesTecnicasProduto,''),25)) + '</BVE>' +  
       case when @TipoEnvio = 1  
            then '<ADA>' + rtrim(ltrim(convert(char(10),tbProdutoFT.DataCadastroProduto,104) + '-' + left(convert(char(30),tbProdutoFT.DataCadastroProduto,114),8))) + '</ADA>' +  
        replace(case when tbPlanejamentoProduto.DataUltimaVenda is not null  
            then '<DLA>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaVenda,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaVenda,114),8))) + '</DLA>'  
            else '<DLA>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'S'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLA>'  
          end, '<DLA>-</DLA>', '<DLA></DLA>') +  
        replace(case when tbPlanejamentoProduto.DataUltimaCompra is not null  
            then '<DLZ>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaCompra,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaCompra,114),8))) + '</DLZ>'   
            else '<DLZ>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'E'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLZ>'  
             end , '<DLZ>-</DLZ>', '<DLZ></DLZ>')  
            else ''   
           end +  
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '</STL>',90,tbProduto.CodigoProduto, 'STL','R70',5,0  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
  
    inner join  tbFonteFornecimento   with (NOLOCK)       
      on tbFonteFornecimento.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbFonteFornecimento.CodigoFonteFornecimento = tbProdutoFT.CodigoFonteFornecimento      
  
    left join tbPlanejamentoProduto   with (NOLOCK)  
      on tbPlanejamentoProduto.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and tbPlanejamentoProduto.CodigoLocal = @CodigoLocal  
       and tbPlanejamentoProduto.CodigoProduto = tbProduto.CodigoProduto   
         
    left join vwCustoMedioProdutoAtual pcmp   with (NOLOCK)  
      on pcmp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcmp.CodigoLocal = @CodigoLocal  
       and pcmp.CodigoProduto = tbProduto.CodigoProduto   
  
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
   and   ((CONVERT(CHAR(10),tbProduto.timestamp,120) between @DataInicial and @DataFinal)     
    or (CONVERT(CHAR(10),tbProdutoFT.timestamp,120) between @DataInicial and @DataFinal))  
   AND not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'STL'  
         and   rtLinhaDIMSAux.ConteudoTAG = 'R70')  
  

   ---- Inclusão de informações referentes ao registro (BES) - R20 - Estoque Disponivel para registros  
   ---- que tiveram registro 21 e não tem 20.     
     
   insert rtLinhaDIMSAux   
   select '<BES>' +   
          '<BBC>R20</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(LEFT(CONVERT(CHAR(20),convert(numeric(17,2),coalesce(psdp.Disponivel,0))),10),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R20',2,coalesce(psdp.Disponivel,0)  
  
   from rtLinhaDIMSAux  with (NOLOCK)  
     
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = @CodigoEmpresa  
      and tbProduto.CodigoProduto = rtLinhaDIMSAux.CodigoProduto  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join vwSaldoDisponivelProduto psdp   with (NOLOCK)  
      on psdp.CodigoEmpresa = tbProdutoFT.CodigoEmpresa   
       and psdp.CodigoLocal = @CodigoLocal  
       and psdp.CodigoProduto = tbProdutoFT.CodigoProduto   
        
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
   and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
   and   rtLinhaDIMSAux.ConteudoTAG IN ('R21','R22')  
   ---AND   @ExisteMovtoDiario = 'V'  
   and   not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProdutoFT.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
         and   rtLinhaDIMSAux.ConteudoTAG = 'R20')  
  
   ---- Inclusão de informações referentes ao registro (BES) - R22 - Pedidos Pendentes.  
   
   insert rtLinhaDIMSAux   
   select '<BES>' +   
          '<BBC>R22</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(20),convert(numeric(14,2),sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0)))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R22',4,sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0))  
  
   from rtLinhaDIMSAux  with (NOLOCK)  
  
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = @CodigoEmpresa  
      and tbProduto.CodigoProduto = rtLinhaDIMSAux.CodigoProduto  
        
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join tbEncomenda pcp   with (NOLOCK)  
      on pcp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcp.CodigoLocal = @CodigoLocal  
       and pcp.CodigoProduto = tbProduto.CodigoProduto   
      and pcp.PedidoCompraDIMS = 'F'  
           
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
   and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
   and   rtLinhaDIMSAux.ConteudoTAG IN ('R20')  
   ---AND   @ExisteMovtoDiario = 'V'  
   and   not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProdutoFT.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
         and   rtLinhaDIMSAux.ConteudoTAG = 'R22')     
  
   group by tbProduto.CodigoEmpresa,  
      tbProduto.CodigoProduto,  
      tbLocal.ContaConcessao  
  
   ---- Inclusão de informações referentes ao registro (BES) - R22 - Pedidos Pendentes.  
   
   insert rtLinhaDIMSAux   
   select '<BES>' +   
          '<BBC>R22</BBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(tbLocal.ContaConcessao)) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '<MEN>' + REPLACE(REPLACE(CONVERT(CHAR(10),convert(numeric(14,2),sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0)))),' ',''),'.',',') + '</MEN>' + --- Quantidade  
       '</BES>',90,tbProduto.CodigoProduto,'BES','R22',4,sum(coalesce(pcp.QuantidadePedidaEncomenda,0) - coalesce(pcp.QuantidadeEntregueEncomenda,0))  
  
   from rtLinhaDIMSAux  with (NOLOCK)  
  
    inner join tbProduto  with (NOLOCK)  
      on  tbProduto.CodigoEmpresa = @CodigoEmpresa  
      and tbProduto.CodigoProduto = rtLinhaDIMSAux.CodigoProduto  
        
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
      
    left join tbEncomenda pcp   with (NOLOCK)  
      on pcp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcp.CodigoLocal = @CodigoLocal  
       and pcp.CodigoProduto = tbProduto.CodigoProduto   
      and pcp.PedidoCompraDIMS = 'F'  
           
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
   and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
   and   rtLinhaDIMSAux.ConteudoTAG IN ('R21')  
   ---AND   @ExisteMovtoDiario = 'V'  
   and   not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProdutoFT.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'BES'  
         and   rtLinhaDIMSAux.ConteudoTAG = 'R22')     
  
   group by tbProduto.CodigoEmpresa,  
      tbProduto.CodigoProduto,  
      tbLocal.ContaConcessao        
   ---- Inclusão de informações referentes ao registro (STL) para os produtos que não tiveram  
   ---- movimentação no periodo e soferram alteraçoes de locação  
     
   insert rtLinhaDIMSAux   
   select distinct '<STL>' +   
          '<SBC>R70</SBC>' +   
       '<MAN>01</MAN>' +  
       '<LOR>' + rtrim(ltrim(COALESCE(tbLocal.ContaConcessao,'0'))) + '</LOR>' +  
       '<RNU>' + rtrim(ltrim(convert(char(30),COALESCE(case when left(tbProduto.CodigoProduto,1) = 'A' OR left(tbProduto.CodigoProduto,1) = 'H' OR left(tbProduto.CodigoProduto,1) = 'W'  
           then CASE when len(rtrim(ltrim(tbProduto.CodigoProduto))) = 11 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 15 or len(rtrim(ltrim(tbProduto.CodigoProduto))) = 19   
               then left(tbProduto.CodigoProduto,1) + '  ' + substring(tbProduto.CodigoProduto,2,29)  
               else tbProduto.CodigoProduto  
               end  
           else tbProduto.CodigoProduto  
           end,tbProduto.CodigoProduto)))) + '</RNU>' +                
       '<LAR>' + case when (SELECT count(tbLocacaoProduto.CodigoProduto)  
          FROM  tbLocacaoProduto  with (NOLOCK)   
          WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
          AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
          AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
          AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto) > 0   
          then '1'  
          else '2'  
          end + '</LAR>' +  
       '<LO1>' + ltrim(rtrim(convert(char(8),coalesce((SELECT MIN(CodigoLocacao) --- Locação 1 do produto.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')))) + '</LO1>' +  
       '<LO2>' + ltrim(rtrim(convert(char(8),case when (SELECT count(CodigoLocacao)  --- caso tenha mais de uma locação colocar aki.  
               FROM  tbLocacaoProduto  with (NOLOCK)   
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto)>1  
             then coalesce((SELECT MAX(CodigoLocacao)   
               FROM  tbLocacaoProduto   with (NOLOCK)  
               WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
               AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
               AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
               AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto),'')  
             else ''  
             end)))  + '</LO2>' +  
       '<TAR>' + case when tbLinhaProduto.PneuLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 7 --- Pneus  
                      then '4'  
                      else case when tbLinhaProduto.CombustivelLinhaProduto = 'V' or tbLinhaProduto.TipoLinhaProduto = 6 --- Combustiveis/Lubrificantes  
           then '5'  
           else ''  
           end  
                      end + '</TAR>' +  
       '<BLP>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,2),coalesce(tbProdutoFT.PrecoReposicaoIndiceProduto,0))),' ',''),'.',',') + '</BLP>' + --- Preço de Lista MBB  
       '<DAK>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,4),coalesce(pcmp.CustoMedioUnitario,0))),' ',''),'.',',') + '</DAK>' + --- Preço de Custo  
       '<NPR>' + REPLACE(REPLACE(CONVERT(CHAR(16),convert(numeric(14,2),coalesce((select prvd.ValorTabelaPreco from vwMaxPrecoVenda prvd  with (NOLOCK)  
                        where prvd.CodigoEmpresa = tbProduto.CodigoEmpresa   
                        and prvd.CodigoProduto = tbProduto.CodigoProduto),0))),' ',''),'.',',') + '</NPR>' + --- Preço Liquido  
       '<LIE>' + rtrim(ltrim(CONVERT(CHAR(8),coalesce(tbFonteFornecimento.CodigoFornecedorFabricante,'')))) + '</LIE>' +  
       '<ABE>' + '</ABE>' +  
       '<BEN>' + LEFT(dbo.fnRemoveSpecialCharacter(tbProduto.DescricaoProduto),25) + '</BEN>' +  
       '<RGR></RGR>' +  
       '<VP1>' + rtrim(ltrim(left(convert(char(10),tbProdutoFT.EmbalagemComercialProduto),7))) + '</VP1>' +  
       '<BVE>' + dbo.fnRemoveSpecialCharacter(LEFT(COALESCE(tbProdutoFT.EspecificacoesTecnicasProduto,''),25)) + '</BVE>' +  
       case when @TipoEnvio = 1  
            then '<ADA>' + rtrim(ltrim(convert(char(10),tbProdutoFT.DataCadastroProduto,104) + '-' + left(convert(char(30),tbProdutoFT.DataCadastroProduto,114),8))) + '</ADA>' +  
        replace(case when tbPlanejamentoProduto.DataUltimaVenda is not null  
            then '<DLA>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaVenda,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaVenda,114),8))) + '</DLA>'  
            else '<DLA>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'S'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLA>'  
          end, '<DLA>-</DLA>', '<DLA></DLA>') +  
        replace(case when tbPlanejamentoProduto.DataUltimaCompra is not null  
            then '<DLZ>' + rtrim(ltrim(convert(char(10),tbPlanejamentoProduto.DataUltimaCompra,104) + '-' + left(convert(char(30),tbPlanejamentoProduto.DataUltimaCompra,114),8))) + '</DLZ>'   
            else '<DLZ>' + coalesce((select (rtrim(ltrim(convert(char(10),max(tbItemDocumento.DataDocumento),104)))) + '-' + left(convert(char(30),max(tbItemDocumento.DataDocumento),114),8)   
                     from tbItemDocumento  with (NOLOCK)  
                     inner join tbNaturezaOperacao   with (NOLOCK)  
                       on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                       and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                     where tbItemDocumento.CodigoEmpresa = tbProduto.CodigoEmpresa  
                     and   tbItemDocumento.CodigoLocal = @CodigoLocal  
                     and   tbItemDocumento.EntradaSaidaDocumento = 'E'  
                     and   tbItemDocumento.CodigoProduto = tbProduto.CodigoProduto  
                     and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),'') + '</DLZ>'  
             end , '<DLZ>-</DLZ>', '<DLZ></DLZ>')  
            else ''   
           end +  
       '<RTE>' +rtrim(ltrim( @DataAtual)) + '</RTE>' +  
       '</STL>',90,tbProduto.CodigoProduto,'STL','R70',5,0  
  
   from tbProduto  with (NOLOCK)  
  
    inner join tbProdutoFT  with (NOLOCK)  
      on  tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa  
      and tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto  
      
    inner join tbLocal  with (NOLOCK)  
      on  tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa  
      AND tbLocal.CodigoLocal   = @CodigoLocal  
        
    inner join tbLinhaProduto  with (NOLOCK)  
      on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto  
  
    inner join  tbFonteFornecimento   with (NOLOCK)       
      on tbFonteFornecimento.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
      and tbFonteFornecimento.CodigoFonteFornecimento = tbProdutoFT.CodigoFonteFornecimento      
  
    left join tbPlanejamentoProduto   with (NOLOCK)  
      on tbPlanejamentoProduto.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and tbPlanejamentoProduto.CodigoLocal = @CodigoLocal  
       and tbPlanejamentoProduto.CodigoProduto = tbProduto.CodigoProduto   
         
    left join vwCustoMedioProdutoAtual pcmp   with (NOLOCK)  
      on pcmp.CodigoEmpresa = tbProduto.CodigoEmpresa   
       and pcmp.CodigoLocal = @CodigoLocal  
       and pcmp.CodigoProduto = tbProduto.CodigoProduto   
      
   where tbProduto.CodigoEmpresa = @CodigoEmpresa  
   AND ( (tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
   AND   tbLinhaProduto.RecapagemLinhaProduto = 'F'  
   and   ((exists (select 1 from tbLocacaoProduto   with (NOLOCK)  
          WHERE  tbLocacaoProduto.CodigoEmpresa   = tbProduto.CodigoEmpresa    
          AND  tbLocacaoProduto.CodigoLocal   = @CodigoLocal   
          AND     tbLocacaoProduto.CodigoAlmoxarifado = @CodigoAlmoxarifado   
          AND  tbLocacaoProduto.CodigoProduto   = tbProduto.CodigoProduto  
          and     convert(char(10),tbLocacaoProduto.Timestamp,120) BETWEEN @DataInicial AND @DataFinal))  
    or (exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'WEI'))  
    or (exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'FLO'))  
    or (exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'FLM'  
         and   rtLinhaDIMSAux.ConteudoTAG in ('R48A','R38A')))  
         )            
   AND not exists (select 1 from rtLinhaDIMSAux  with (NOLOCK)  
         where rtLinhaDIMSAux.CodigoProduto = tbProduto.CodigoProduto  
         and   rtLinhaDIMSAux.SiglaTAG = 'STL'  
         and   rtLinhaDIMSAux.ConteudoTAG = 'R70')  
  end  
  --- (2) End-Tag  
  
  insert rtLinhaDIMSAux select '</Dims>',97,'','DIM','',0,0 where not exists( select 1 from rtLinhaDIMSAux where LinhaXML = '</Dims>')  
  
  --- Incluir os registros da chave documento para serem atualizados no EDI como processado.  
  insert tbItemDocumentoDIMS  
  select rtMovimentacaoEstoqueDIMS.CodigoEmpresa,  
    rtMovimentacaoEstoqueDIMS.CodigoLocal,  
    rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento,  
    rtMovimentacaoEstoqueDIMS.NumeroDocumento,  
    convert(char(10),rtMovimentacaoEstoqueDIMS.DataDocumento,120),  
    rtMovimentacaoEstoqueDIMS.CodigoCliFor,  
    rtMovimentacaoEstoqueDIMS.TipoLancamentoMovimentacao,  
    rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento,  
    convert(datetime,convert(char(10),@DataAtual),105),  
    @CSN  
  from rtMovimentacaoEstoqueDIMS with (NOLOCK)        
  where not exists (select 1 from tbItemDocumentoDIMS  with (NOLOCK)  
         where tbItemDocumentoDIMS.CodigoEmpresa = rtMovimentacaoEstoqueDIMS.CodigoEmpresa  
         and   tbItemDocumentoDIMS.CodigoLocal = rtMovimentacaoEstoqueDIMS.CodigoLocal  
         and   tbItemDocumentoDIMS.EntradaSaidaDocumento = rtMovimentacaoEstoqueDIMS.EntradaSaidaDocumento  
         and   tbItemDocumentoDIMS.NumeroDocumento = rtMovimentacaoEstoqueDIMS.NumeroDocumento  
         and   tbItemDocumentoDIMS.DataDocumento = rtMovimentacaoEstoqueDIMS.DataDocumento  
         and   tbItemDocumentoDIMS.CodigoCliFor = rtMovimentacaoEstoqueDIMS.CodigoCliFor  
         and   tbItemDocumentoDIMS.TipoLancamentoMovimentacao = rtMovimentacaoEstoqueDIMS.TipoLancamentoMovimentacao  
         and   tbItemDocumentoDIMS.SequenciaItemDocumento = rtMovimentacaoEstoqueDIMS.SequenciaItemDocumento)  
     
  --- Incluir os Registros da chave da Registro Movto Estoque para não processar mais...  
  insert tbRegistroMovtoEstoqueDIMS  
  select tbRegistroMovtoEstoque.CodigoEmpresa,  
      tbRegistroMovtoEstoque.CodigoLocal,   
      tbRegistroMovtoEstoque.SequenciaMovtoEstoque,  
      convert(datetime,convert(char(10),@DataAtual),105)  
  from tbRegistroMovtoEstoque  with (NOLOCK)  
  where tbRegistroMovtoEstoque.CodigoEmpresa = @CodigoEmpresa   
  and   tbRegistroMovtoEstoque.CodigoLocal = @CodigoLocal   
  and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal   
  and   not exists (select 1 from tbRegistroMovtoEstoqueDIMS  with (NOLOCK)  
         where tbRegistroMovtoEstoqueDIMS.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
         and   tbRegistroMovtoEstoqueDIMS.CodigoLocal = tbRegistroMovtoEstoque.CodigoLocal  
         and   tbRegistroMovtoEstoqueDIMS.SequenciaMovtoEstoque = tbRegistroMovtoEstoque.SequenciaMovtoEstoque)  
           
  ----- Incluir o Registro referente ao CSN  
  insert rtLinhaDIMSAux   
   select 'REGCSN' + convert(char(13),right(10000000000000 + @CSN,13)), 100,'','REG','CSN',0,0  
      
 end  ----- if exists (select 1 from rtMovimentacaoEstoqueDIMS) or @TipoEnvio = 1 or @TipoEnvio = 3  
  
  
 ------------------------------------------------------------------------------------------------  
 ---  Exlcui registros que possuem produtos que não foram movimetados nos ultimos 5 anos e que tem   
 ---  o estoque zerado...  
 ---  Somente itens com data de cadastro nos ultimos 12 meses.  
  
 update tbPlanejamentoProduto   
 set tbPlanejamentoProduto.DataUltimaMovimentacao = coalesce((select max(tbItemDocumento.DataDocumento) from tbItemDocumento   with (NOLOCK)  
                   inner join tbNaturezaOperacao   with (NOLOCK)  
                     on  tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
                     and tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao  
                where tbItemDocumento.CodigoEmpresa = tbPlanejamentoProduto.CodigoEmpresa  
                and   tbItemDocumento.CodigoLocal = tbPlanejamentoProduto.CodigoLocal  
                and   tbItemDocumento.CodigoProduto = tbPlanejamentoProduto.CodigoProduto   
                and   tbNaturezaOperacao.CodigoTipoOperacao not in (2,4,6,8,13)),null)  
 where tbPlanejamentoProduto.CodigoEmpresa = @CodigoEmpresa   
 and   tbPlanejamentoProduto.CodigoLocal = @CodigoLocal   
 and   tbPlanejamentoProduto.DataUltimaMovimentacao is null  
  
 if @TipoEnvio = 1 OR @TipoEnvio = 3 begin  
  DELETE  rtLinhaDIMSAux   
   where rtLinhaDIMSAux.SiglaTAG in ('BES','STL')  
   and   not exists (select 1 from rtLinhaDIMSAux li  with (NOLOCK)  
         where li.SiglaTAG in ('WEI','FLM','FLK','FLO')  
         and   li.CodigoProduto = rtLinhaDIMSAux.CodigoProduto)  
   and   not exists (select 1 from tbPlanejamentoProduto  with (NOLOCK)  
         where tbPlanejamentoProduto.CodigoEmpresa = @CodigoEmpresa  
         and   tbPlanejamentoProduto.CodigoLocal = @CodigoLocal  
         and   tbPlanejamentoProduto.CodigoProduto = rtLinhaDIMSAux.CodigoProduto   
         and   tbPlanejamentoProduto.DataUltimaMovimentacao >= @DataAnterior5Anos)  
   and   not exists (select 1 from rtLinhaDIMSAux psdp   with (NOLOCK)  
         where psdp.SiglaTAG = 'BES'  
         and  psdp.ConteudoTAG = 'R20'  
         and  psdp.CodigoProduto = rtLinhaDIMSAux.CodigoProduto    
         and  psdp.Saldo <> 0)  
   and   not exists (select 1 from rtLinhaDIMSAux pspp   with (NOLOCK)  
         where pspp.SiglaTAG = 'BES'  
         and  pspp.ConteudoTAG = 'R21'  
         and  pspp.CodigoProduto = rtLinhaDIMSAux.CodigoProduto   
         and  pspp.Saldo <> 0)  
   and   not exists (select 1 from rtLinhaDIMSAux pcp   with (NOLOCK)  
         where pcp.SiglaTAG = 'BES'  
         and  pcp.ConteudoTAG = 'R22'  
         and  pcp.CodigoProduto = rtLinhaDIMSAux.CodigoProduto   
         AND  pcp.Saldo <> 0)  
   and   not exists (select 1 from tbProdutoFT    with (NOLOCK)  
         where tbProdutoFT.CodigoEmpresa = @CodigoEmpresa   
         and   tbProdutoFT.CodigoProduto = rtLinhaDIMSAux.CodigoProduto   
         and   tbProdutoFT.DataCadastroProduto >= @DataUltimos12Meses)  
 end  
  
 if @TipoEnvio = 2 begin  
   
  --DELETE  rtLinhaDIMSAux   
  -- where rtLinhaDIMSAux.SiglaTAG in ('BES','STL')  
  -- and   not exists (select 1 from rtLinhaDIMSAux li  with (NOLOCK)  
  --       where li.SiglaTAG in ('WEI','FLM','FLK','FLO')  
  --       and   li.CodigoProduto = rtLinhaDIMSAux.CodigoProduto)  
  
  delete from rtLinhaDIMSAux  where Sequencia in   
  (  
  select Sequencia from rtLinhaDIMSAux   with (NOLOCK)   
  where rtLinhaDIMSAux.SiglaTAG = 'BES'  
   and   not exists (select 1   
      from rtLinhaDIMSAux li with (NOLOCK)   
      where li.SiglaTAG in ('WEI','FLM','FLK','FLO')  
      and   li.CodigoProduto = rtLinhaDIMSAux.CodigoProduto)  
        
   and   (((select sum(Saldo)  
      from rtLinhaDIMSAux li with (NOLOCK)   
      where li.SiglaTAG in ('BES')  
      and   li.CodigoProduto = rtLinhaDIMSAux.CodigoProduto) = 0)  
      or    ((not exists (select 1 from tbRegistroMovtoEstoque  
             inner join tbProdutoFT  with (NOLOCK)  
               on  tbProdutoFT.CodigoEmpresa = tbRegistroMovtoEstoque.CodigoEmpresa  
               and tbProdutoFT.CodigoProduto = tbRegistroMovtoEstoque.CodigoProduto        
             inner join tbLinhaProduto  with (NOLOCK)  
               on tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa  
               and tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto        
               where tbRegistroMovtoEstoque.CodigoEmpresa = @CodigoEmpresa  
               and   tbRegistroMovtoEstoque.CodigoLocal = @CodigoLocal   
               and   tbRegistroMovtoEstoque.CodigoProduto = rtLinhaDIMSAux.CodigoProduto  
               and   tbRegistroMovtoEstoque.DataMovtoEstoque BETWEEN @DataInicial AND @DataFinal  
               AND   ((tbLinhaProduto.TipoLinhaProduto in (0,1,2)) or (tbLinhaProduto.GeraMovtoDIMS = 'V'))  
               AND   tbLinhaProduto.RecapagemLinhaProduto = 'F')))  
        and not exists (select 1 from tbEncomenda  
              where CodigoEmpresa = @CodigoEmpresa  
              and   CodigoLocal = @CodigoLocal   
              and   CodigoProduto = rtLinhaDIMSAux.CodigoProduto  
              and   PedidoCompraDIMS = 'F'  
              and   QuantidadePedidaEncomenda - QuantidadeEntregueEncomenda<>0))  
  )  
  
  delete from rtLinhaDIMSAux  where Sequencia in   
  (  
  select Sequencia from rtLinhaDIMSAux   with (NOLOCK)   
  where rtLinhaDIMSAux.SiglaTAG = 'STL'  
   and   not exists (select 1   
      from rtLinhaDIMSAux li with (NOLOCK)   
      where li.SiglaTAG in ('WEI','FLM','FLK','FLO')  
      and   li.CodigoProduto =rtLinhaDIMSAux.CodigoProduto)  
  )    
  
 end  
  
 -----------  Excluir Historico de Movimento DIMS XML (superior 7 dias)  
 delete tbMovimentoXMLDIMS      
            where CodigoEmpresa = @CodigoEmpresa  
            and   CodigoLocal = @CodigoLocal  
            and   convert(datetime,convert(char(12),DataMovimento),105) <= dateadd(d,-7,convert(datetime,convert(char(10),@DataAtual),105))  
  
 delete tbItemDocumentoDIMS   
   where CodigoEmpresa = @CodigoEmpresa  
   and CodigoLocal = @CodigoLocal  
   and convert(datetime,convert(char(12),DataProcessamentoDIMS),105) <= dateadd(d,-60,convert(datetime,convert(char(10),@DataAtual),105))  
     
 delete tbRegistroMovtoEstoqueDIMS   
   where CodigoEmpresa = @CodigoEmpresa  
   and CodigoLocal = @CodigoLocal   
   and convert(datetime,convert(char(12),DataProcessamentoDIMS),105) <= dateadd(d,-60,convert(datetime,convert(char(10),@DataAtual),105))  
  
 ------------------------------------------------------------------------------------------------  
 --- Devolve lista XML gerada -------------------------------------------------------------------  
 select rtrim(ltrim(LinhaXML)) as 'LinhaXML',  
   Linha,  
    CodigoProduto,  
    SequenciaProduto,  
    SiglaTAG,  
    ConteudoTAG,  
    Sequencia      
   --into #tmpLinhaDIMSAux  
   FROM rtLinhaDIMSAux   with (NOLOCK)  
   order by Linha,  
      CodigoProduto,  
      SequenciaProduto,  
      SiglaTAG,  
      ConteudoTAG  
   
 -- devolve da temporaria  
 --select LinhaXML FROM #tmpLinhaDIMSAux with (nolock)  
 --order by Linha,  
 --   Sequencia,  
 --   CodigoProduto,  
 --   SequenciaProduto,  
 --   SiglaTAG,  
 --   ConteudoTAG  
 ------------------------------------------------------------------------------------------------  
  
SET NOCOUNT OFF  
  
RETURN 0  
  
--- Controle erro  
ERROR:  
 RAISERROR (@auxErroMensagem,16,1)  
 ----RAISERROR 13000 @auxErroMensagem  
   
  