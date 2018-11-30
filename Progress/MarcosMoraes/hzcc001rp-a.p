/******************************************************************************
* PROGRAMA - hzcc001rp-a.p
* OBJETIVO - Importacao de solicita‡Æo de compras do SGT para o EMS
* AUTOR    - Bruno Hallais - BHFS
* DATA     - Out/2010
* ASSUNTO  - Lˆ as integracoes PENDENTES do processo "REC-SOLIC-COMPRA", 
             valida as informacoes de solicita‡Æo de compras e as cria/altera no EMS.
*****************************************************************************/
{include/i-prgvrs.i hzcc001rp-a 2.04.00.001}.

def new global shared var l-especial as logical no-undo.

def input  parameter p_num_log_integracao as char.
def output parameter p-erro               as logical initial no.

/* Defini‡äes de saida de relat¢rio */
{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST empresa NO-LOCK
     WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.

ASSIGN c-programa     = "HZCC001"
       c-versao       = "2.04"
       c-revisao      = ".00.001"
       c-titulo-relat = "Importa‡Æo de Solicita‡Æo de Compras do SGT"
       c-sistema      = "Interface SGT/EMS"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE "".

DEFINE TEMP-TABLE tt-requisicao NO-UNDO LIKE requisicao.
DEFINE TEMP-TABLE tt-it-requisicao NO-UNDO LIKE it-requisicao.

def temp-table tt-erros-geral no-undo
       field identif-msg           as char    format "x(60)"
       field num-sequencia-erro    as integer format "999"
       field cod-erro              as integer format "99999"   
       field des-erro              as char    format "x(60)"
       field cod-maq-origem        as integer format "999"
       field num-processo          as integer format "999999999".

def temp-table tt-versao-integr no-undo
       field cod-versao-integracao as integer format "999"
       field ind-origem-msg        as integer format  "99".


def temp-table tt-ordem-compra no-undo like ordem-compra
    field l-split           as   logical                    initial no
    field cod-maq-origem-mp as   integer format "999"       initial 0
    field num-processo      as   integer format ">>>>>>>>9" initial 0
    field num-sequencia     as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto    as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem-mp
                                num-processo
                                num-sequencia.

def temp-table tt-prazo-compra no-undo like prazo-compra
    field cod-maq-origem    as   integer format "999"       initial 0
    field num-processo      as   integer format ">>>>>>>>9" initial 0
    field num-sequencia     as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto    as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.


def temp-table tt-cotacao-item no-undo like cotacao-item
    field cod-maq-origem    as integer format "999"         initial 0
    field num-processo      as integer format ">>>>>>>>9"   initial 0
    field num-sequencia     as integer format ">>>>>9"      initial 0
    field ind-tipo-movto    as integer format "99"          initial 1
    INDEX ch-codigo IS PRIMARY cod-maq-origem
                               num-processo
                               num-sequencia.

def temp-table tt-matriz-rat-med no-undo like matriz-rat-med
    field cod-maq-origem    as integer format "999"         initial 0
    field num-processo      as integer format ">>>>>>>>9"   initial 0
    field num-sequencia     as integer format ">>>>>9"      initial 0
    field ind-tipo-movto    as integer format "99"          initial 1
    INDEX ch-codigo IS PRIMARY cod-maq-origem
                               num-processo
                               num-sequencia.

def temp-table tt-desp-cotacao-item no-undo /*like desp-cotacao-item*/
    field cod-maq-origem    as integer format "999"         initial 0
    field num-processo      as integer format ">>>>>>>>9"   initial 0
    field num-sequencia     as integer format ">>>>>9"      initial 0
    field ind-tipo-movto    as integer format "99"          initial 1
    INDEX ch-codigo IS PRIMARY cod-maq-origem
                               num-processo
                               num-sequencia.

def var h-acomp  as handle no-undo.    
def VAR c-transacao-global as char no-undo.
def var i-cont as integer no-undo.
def var i-cont-erro as integer no-undo.
def var i-cont-ant as integer no-undo.
def var p-ordem as integer no-undo.

DEF VAR i-nr-requisicao AS INTEGER.
DEF VAR i-num-id-documento AS INTEGER.
  DEF VAR i-seq-sc AS INT.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHAR NO-UNDO.


DEF VAR i-cont-ordem AS INT.



&IF DEFINED(EXCLUDE-NumOC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION NumOC Procedure 
FUNCTION NumOC RETURNS INTEGER
  ( l-ord-mul AS logical ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
     DEFINE VARIABLE l-resposta AS LOGICAL    NO-UNDO.
     DEFINE VARIABLE p-ordem    AS INTEGER    NO-UNDO.
     DEFINE VARIABLE i-seq1     AS INTEGER    NO-UNDO.
     DEFINE VARIABLE i-ord-aux  AS INTEGER    NO-UNDO.

     FOR first param-compra FIELDS (prim-ord-man ult-ord-man prox-ord-aut) NO-LOCK:
     END.

     FIND FIRST param-global NO-LOCK NO-ERROR.
    
     assign l-resposta = no
            p-ordem = 1.

     FOR LAST ordem-compra FIELDS (numero-ordem ) WHERE
              ordem-compra.numero-ordem >= param-compra.prim-ord-man
          and ordem-compra.numero-ordem <= param-compra.ult-ord-man NO-LOCK:
         ASSIGN p-ordem = int(entry(1,string(ordem-compra.numero-ordem, ">>>>>>>9,99"),".")) .
     END.

     do  while NOT (l-resposta):
        if  l-ord-mul then
            FOR FIRST ordem-compra FIELDS (numero-ordem) where
                 ordem-compra.numero-ordem = (p-ordem * 100 + i-seq1) NO-LOCK:
            END.
        else
            FOR LAST ordem-compra  FIELDS (numero-ordem) where
                     ordem-compra.numero-ordem >= (p-ordem * 100) and
                     ordem-compra.numero-ordem <= (p-ordem * 100 + 99) NO-LOCK: 
            END.
        if  avail ordem-compra then do:
            if  l-ord-mul AND (i-seq1 > 1 or i-seq1 = 0) THEN DO:
                assign i-seq1 = i-seq1 + 1.
                IF i-seq1 > 99 THEN
                   ASSIGN i-seq1 = 0
                          p-ordem = p-ordem + 1.
            END.
            if  not l-ord-mul or (i-seq1 > 99) then
                assign i-seq1  = 0
                       p-ordem = p-ordem + 1.
        end.
        else
            assign l-resposta = YES
                   p-ordem = (p-ordem * 100) + i-seq1.
     end.

     assign i-ord-aux = p-ordem.
     if avail param-global and 
        param-global.modulo-bh then do:
        FOR last his-ord-compra FIELDS (numero-ordem) where
                 his-ord-compra.numero-ordem <= param-compra.ult-ord-man * 100 NO-LOCK:
            if his-ord-compra.numero-ordem > p-ordem then
               assign i-ord-aux = truncate(his-ord-compra.numero-ordem / 100,0) + 1.
        END.

        /*** Usado para bancos historicos ***/
        /*** Valida o ultimo numero da ordem de compra ***/
        if i-ord-aux >= p-ordem then   
            assign p-ordem = (if i-ord-aux > param-compra.ult-ord-man
                              or i-ord-aux < param-compra.prim-ord-man
                                   then param-compra.prox-ord-aut 
                                   else i-ord-aux).
     end.
  RETURN p-ordem.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

FOR EACH tt-erros-geral.
    DELETE tt-erros-geral.
END.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input "Iniciando processo de importacao").

/* inicio processamento ******************************************************************/

find first ht_log_integracao 
     where ht_log_integracao.num_log_integracao = p_num_log_integracao EXCLUSIVE-LOCK NO-ERROR.

find first ht_tt_rec_solic_compra
     where ht_tt_rec_solic_compra.nr_solicitacao_SGT = INT(ht_log_integracao.cod_chave_integracao) EXCLUSIVE-LOCK no-error.
if avail ht_log_integracao and 
   avail ht_tt_rec_solic_compra then do:
/*     MESSAGE ht_log_integracao.NUM_LOG_INTEGRACAO SKIP */
/*             ht_tt_rec_solic_compra.nr_solicitacao_SGT SKIP */
/*             ht_tt_rec_solic_compra.eh_debito_direto VIEW-AS ALERT-BOX. */
   
    IF ht_tt_rec_solic_compra.eh_debito_direto = "D" THEN /*Item ‚ do tipo controle de d‚bito direto*/
        RUN pi-gera-solic-compra.
    ELSE IF ht_tt_rec_solic_compra.eh_debito_direto = "I" THEN /*Item ‚ do tipo controle total*/
        RUN pi-gera-ordem-compra.
    ELSE
        run gera_tt_erro(input "Tipo de controle da solicitacao de compra " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " nÆo ‚ 'D' nem 'I'. Verifique o campo ht_tt_rec_solic_compra.eh_debito_direto.").
END.
ELSE DO:
    if not avail ht_log_integracao then 
        run gera_tt_erro(input "Registro de integracao " + p_num_log_integracao + " nao encontrado.").
        
    if not avail ht_tt_rec_solic_compra then
        run gera_tt_erro(input "Registro de informacoes complementares ht_tt_rec_solic_compra nao encontrado.").
end.      

run pi-finalizar in h-acomp.

/* if p-erro then RETURN "NOK". */
/*    */
/* RETURN "OK". */

PROCEDURE pi-gera-ordem-compra.    
/*     message "REC-SOLIC-COMPRA" SKIP */
/*             ht_log_integracao.NUM_LOG_INTEGRACAO SKIP */
/*             ht_log_integracao.cod_chave_integracao VIEW-AS ALERT-BOX. */
    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    for each tt-prazo-compra:
        delete tt-prazo-compra.
    end.

    FOR EACH tt-versao-integr:
        DELETE tt-versao-integr.
    END.

    ASSIGN i-cont = 0.
    FOR EACH ht_tt_rec_solic_compra_item 
       WHERE ht_tt_rec_solic_compra_item.NUM_LOG_INTEGRACAO = ht_log_integracao.NUM_LOG_INTEGRACAO
         AND ht_tt_rec_solic_compra_item.quantidade         > 0
    BREAK BY ht_tt_rec_solic_compra_item.it_codigo
          BY ht_tt_rec_solic_compra_item.data_entrega:
          
        RUN pi-acompanhar in h-acomp(input "Importando ordem de compras: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
          
        FIND FIRST ht_tt_rec_solic_compra EXCLUSIVE-LOCK
             WHERE ht_tt_rec_solic_compra.NUM_LOG_INTEGRACAO = ht_log_integracao.NUM_LOG_INTEGRACAO NO-ERROR.

/*         message "Solic enviada: ht_tt_rec_solic_compra" SKIP(1) */
/*                 ht_tt_rec_solic_compra.num_log_integracao SKIP */
/*                 ht_tt_rec_solic_compra.nr_solicitacao_EMS SKIP */
/*                 ht_tt_rec_solic_compra.nr_solicitacao_SGT  SKIP */
/*                 ht_tt_rec_solic_compra.cd_filial  SKIP */
/*                 ht_tt_rec_solic_compra.data_requisicao SKIP */
/*                 ht_tt_rec_solic_compra.eh_debito_direto  SKIP */
/*                 ht_tt_rec_solic_compra.local_entrega  SKIP */
/*                 ht_tt_rec_solic_compra.narrativa  SKIP */
/*                 ht_tt_rec_solic_compra.usuar_requis VIEW-AS ALERT-BOX. */
        
        ASSIGN p-erro = NO.
        FIND FIRST ht-solic-compra-sgt NO-LOCK
             WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT NO-ERROR.
        IF AVAIL ht-solic-compra-sgt THEN DO:
            run gera_tt_erro(input "Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " j  foi integrada.").
            ASSIGN p-erro = YES.
        END.

        RUN valida-itens-ordem-compra.
        
/*         MESSAGE "AVAIL ht-solic-compra-sgt: " AVAIL ht-solic-compra-sgt SKIP */
/*                 "ERRO? " p-erro VIEW-AS ALERT-BOX. */

        IF NOT p-erro THEN DO:
            IF FIRST-OF(ht_tt_rec_solic_compra_item.it_codigo) THEN DO:

                FOR FIRST item FIELDS (it-codigo deposito-pad cod-comprado cd-planejado tp-desp-padrao un) WHERE
                          item.it-codigo = ht_tt_rec_solic_compra_item.it_codigo NO-LOCK: 
                END.
                
                IF AVAIL item THEN
                    FIND FIRST familia NO-LOCK WHERE familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

                FIND LAST ordem-compra NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN
                    ASSIGN p-ordem = ordem-compra.numero-ordem + 100.

                /* MESSAGE "Ordem a criar: " p-ordem view-as alert-box. */
                    
/*                 ASSIGN p-ordem = NumOC(NO). /*A fun‡Æo NumOC recebe campo l¢gico como parƒmetro. Testei com YES e o valor nÆo foi satisfat¢rio. Com NO, o valor veio como sendo o menor n£mero de ordem de compra dispon¡vel. Se precisar buscar o £ltimo n£mero dispon¡vel dentro da faixa de ordem manual, ‚ s¢ eliminar a chamada da fun‡Æo e criar outra para este fim*/ */
/*    */
/*                 MESSAGE "ORdem a criar: " p-ordem view-as alert-box. */
/*                 i-cont-ordem = 0. */
/*                 REPEAT: */
/*                     FIND FIRST ordem-compra NO-LOCK */
/*                          WHERE ordem-compra.numero-ordem = p-ordem NO-ERROR. */
/*                     IF AVAIL ordem-compra THEN DO: */
/*                         ASSIGN i-cont-ordem = i-cont-ordem + 100 */
/*                                p-ordem      = p-ordem + i-cont-ordem. /*A fun‡Æo NumOC recebe campo l¢gico como parƒmetro. Testei com YES e o valor nÆo foi satisfat¢rio. Com NO, o valor veio como sendo o menor n£mero de ordem de compra dispon¡vel. Se precisar buscar o £ltimo n£mero dispon¡vel dentro da faixa de ordem manual, ‚ s¢ eliminar a chamada da fun‡Æo e criar outra para este fim*/ */
/*    */
/*                         MESSAGE "Pr¢xima ordem: " p-ordem view-as alert-box. */
/*                     END. */
/*                     ELSE DO: */
/*                         FIND FIRST tt-ordem-compra WHERE tt-ordem-compra.numero-ordem = p-ordem NO-LOCK NO-ERROR. */
/*                         IF AVAIL tt-ordem-compra THEN DO: */
/*                             ASSIGN i-cont-ordem = i-cont-ordem + 100 */
/*                                    p-ordem = p-ordem + i-cont-ordem. /*A fun‡Æo NumOC recebe campo l¢gico como parƒmetro. Testei com YES e o valor nÆo foi satisfat¢rio. Com NO, o valor veio como sendo o menor n£mero de ordem de compra dispon¡vel. Se precisar buscar o £ltimo n£mero dispon¡vel dentro da faixa de ordem manual, ‚ s¢ eliminar a chamada da fun‡Æo e criar outra para este fim*/ */
/*    */
/*                             MESSAGE "Pr¢xima ordem: " p-ordem view-as alert-box. */
/*                         END. */
/*                         ELSE LEAVE. */
/*                     END. */
/*                 END. */
                
/*                 message "Ordem criada: " p-ordem view-as alert-box. */

                CREATE tt-ordem-compra.
                ASSIGN tt-ordem-compra.numero-ordem   = p-ordem 
                       tt-ordem-compra.it-codigo      = ht_tt_rec_solic_compra_item.it_codigo
                       tt-ordem-compra.cod-refer      = ""
                       tt-ordem-compra.cod-estabel    = ht_tt_rec_solic_compra.cd_filial
                       tt-ordem-compra.dep-almoxar    = item.deposito-pad
                       tt-ordem-compra.impr-ficha     = YES
                       tt-ordem-compra.natureza       = 1 /*Compra*/
                       tt-ordem-compra.situacao       = 1 /*NÆo confirmada*/
                       tt-ordem-compra.origem         = 1 /*Compra*/
                       tt-ordem-compra.ordem-servic   = 0
                       tt-ordem-compra.op-codigo      = 0
                       tt-ordem-compra.cod-comprado   = IF AVAIL familia THEN familia.cod-comprado ELSE IF AVAIL item THEN item.cod-comprado ELSE "LUCIA"
                       tt-ordem-compra.requisitante   = ht_tt_rec_solic_compra.usuar_requis
                       tt-ordem-compra.narrativa      = ht_tt_rec_solic_compra.narrativa
                       tt-ordem-compra.usuario        = c-seg-usuario
                       tt-ordem-compra.data-atualiz   = TODAY
                       tt-ordem-compra.hora-atualiz   = string(time,"hh:mm:ss")
                       tt-ordem-compra.data-emissao   = TODAY
                       tt-ordem-compra.tp-despesa     = item.tp-desp-padrao
                       tt-ordem-compra.qt-solic       = ht_tt_rec_solic_compra_item.quantidade
                       tt-ordem-compra.ind-tipo-movto = 1 /* inclui */
                       tt-ordem-compra.l-split        = NO.
            END.
            
/*             MESSAGE "Ordem Criada" skip */
/*                     "numero-ordem  " tt-ordem-compra.numero-ordem   SKIP */
/*                     "it-codigo     " tt-ordem-compra.it-codigo      SKIP */
/*                     "cod-refer     " tt-ordem-compra.cod-refer      SKIP */
/*                     "cod-estabel   " tt-ordem-compra.cod-estabel    SKIP */
/*                     "dep-almoxar   " tt-ordem-compra.dep-almoxar    SKIP */
/*                     "impr-ficha    " tt-ordem-compra.impr-ficha     SKIP */
/*                     "natureza      " tt-ordem-compra.natureza       SKIP */
/*                     "situacao      " tt-ordem-compra.situacao       SKIP */
/*                     "origem        " tt-ordem-compra.origem         SKIP */
/*                     "ordem-servic  " tt-ordem-compra.ordem-servic   SKIP */
/*                     "op-codigo     " tt-ordem-compra.op-codigo      SKIP */
/*                     "cod-comprado  " tt-ordem-compra.cod-comprado   SKIP */
/*                     "requisitante  " tt-ordem-compra.requisitante   SKIP */
/*                     "narrativa     " tt-ordem-compra.narrativa      SKIP */
/*                     "usuario       " tt-ordem-compra.usuario        SKIP */
/*                     "data-atualiz  " tt-ordem-compra.data-atualiz   SKIP */
/*                     "hora-atualiz  " tt-ordem-compra.hora-atualiz   SKIP */
/*                     "data-emissao  " tt-ordem-compra.data-emissao   SKIP */
/*                     "tp-despesa    " tt-ordem-compra.tp-despesa     SKIP */
/*                     "qt-solic      " tt-ordem-compra.qt-solic       SKIP */
/*                     "ind-tipo-movto" tt-ordem-compra.ind-tipo-movto SKIP */
/*                     "l-split       " tt-ordem-compra.l-split        VIEW-AS ALERT-BOX. */

/*             IF FIRST-OF(ht_tt_rec_solic_compra_item.data_entrega) THEN DO: */
        /*--------------------------- Prazo-Compra ----------------------------------*/
            create tt-prazo-compra.
            assign i-cont                       = i-cont + 1
                   tt-prazo-compra.parcela      = i-cont
                   tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem  
                   tt-prazo-compra.it-codigo    = tt-ordem-compra.it-codigo
                   tt-prazo-compra.cod-refer    = tt-ordem-compra.cod-refer
                   tt-prazo-compra.natureza     = tt-ordem-compra.natureza
                   tt-prazo-compra.quantidade   = ht_tt_rec_solic_compra_item.quantidade
                   tt-prazo-compra.quantid-orig = ht_tt_rec_solic_compra_item.quantidade
                   tt-prazo-compra.quant-saldo  = ht_tt_rec_solic_compra_item.quantidade
                   tt-prazo-compra.qtd-sal-forn = ht_tt_rec_solic_compra_item.quantidade
                   tt-prazo-compra.qtd-do-forn  = ht_tt_rec_solic_compra_item.quantidade
                   tt-prazo-compra.cod-alter    = no
                   tt-prazo-compra.data-entrega = ht_tt_rec_solic_compra_item.data_entrega
                   tt-prazo-compra.data-orig    = ht_tt_rec_solic_compra_item.data_entrega
                   tt-prazo-compra.un           = ht_tt_rec_solic_compra_item.un
                   tt-prazo-compra.pedido-clien = ""
                   tt-prazo-compra.nr-sequencia = 0
                   tt-prazo-compra.nome-abrev   = ""
                   tt-prazo-compra.nr-entrega   = 0.
                    
                   
            IF NOT FIRST-OF(ht_tt_rec_solic_compra_item.it_codigo) THEN
                ASSIGN tt-ordem-compra.qt-solic     = tt-ordem-compra.qt-solic + ht_tt_rec_solic_compra_item.quantidade.
            
/*             END. */
        
            IF LAST-OF(ht_tt_rec_solic_compra_item.it_codigo) THEN DO:
                create tt-versao-integr.
                assign tt-versao-integr.cod-versao-integracao = 001
                       tt-versao-integr.ind-origem-msg = 01.                
                
                message "gerando api" view-as alert-box.
                
                run ccp/ccapi302.p (input  table tt-versao-integr,
                                    output table tt-erros-geral,
                                    input  table tt-ordem-compra,
                                    input  table tt-prazo-compra,        
                                    input  table tt-cotacao-item,
                                    input  table tt-matriz-rat-med,
                                    input  c-transacao-global).            
            
                for each tt-erros-geral:
                    run gera_tt_erro(input "Solic. Compra SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item: " + tt-ordem-compra.it-codigo + " - O.C. a ser criada: " + STRING(tt-ordem-compra.numero-ordem) + ". Erro de API: " + STRING(tt-erros-geral.cod-erro) + " - " + tt-erros-geral.des-erro).
                
                    FOR EACH ht-solic-compra-sgt EXCLUSIVE-LOCK
                       WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT.
                        DELETE ht-solic-compra-sgt.
                    END.
                    
                    /* MESSAGE "Solic. Compra SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item: " + tt-ordem-compra.it-codigo + " - O.C. a ser criada: " + STRING(tt-ordem-compra.numero-ordem) + ". Erro de API: " + STRING(tt-erros-geral.cod-erro) + " - " + tt-erros-geral.des-erro VIEW-AS ALERT-BOX. */
                end.
                
/*                 MESSAGE "DEU ERRO? " CAN-FIND(FIRST tt-erros-geral NO-LOCK) SKIP */
/*                         tt-ordem-compra.numero-ordem VIEW-AS ALERT-BOX. */
                
                
                IF NOT CAN-FIND(FIRST tt-erros-geral NO-LOCK) THEN DO:
                    ASSIGN ht_tt_rec_solic_compra.nr_solicitacao_EMS = tt-ordem-compra.numero-ordem.

                    ASSIGN ht_log_integracao.fl_reintegrar = 0. /*0 = NÆo deve ser visto pelo SGT para ser reintegrado, 1 = Deve ser reintegrado*/
                    
                    FIND FIRST ht-solic-compra-sgt EXCLUSIVE-LOCK
                         WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT NO-ERROR.

/*                     MESSAGE "ht_tt_rec_solic_compra.nr_solicitacao_EMS: " ht_tt_rec_solic_compra.nr_solicitacao_EMS SKIP */
/*                             "Reintegrar? " ht_log_integracao.fl_reintegrar = 1 SKIP */
/*                             "Achou link de integra‡Æo? " CAN-FIND (FIRST ht-solic-compra-sgt NO-LOCK */
/*                                                                    WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT) */
/*                     VIEW-AS ALERT-BOX. */
                    
                    IF NOT AVAIL ht-solic-compra-sgt THEN
                        CREATE ht-solic-compra-sgt.
                        
                    ASSIGN ht-solic-compra-sgt.data_requisicao    = ht_tt_rec_solic_compra.data_requisicao
                           ht-solic-compra-sgt.nr_solicitacao_EMS = ht_tt_rec_solic_compra.nr_solicitacao_EMS 
                           ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT
                           ht-solic-compra-sgt.cd_filial          = ht_tt_rec_solic_compra.cd_filial
                           ht-solic-compra-sgt.usuar_requis       = ht_tt_rec_solic_compra.usuar_requis.
                END.

/*                 FOR first param-compra FIELDS (prox-ord-aut) exclusive-lock: */
/*    */
/*                 END. */

/*                 FIND FIRST tt-ordem-compra. */
/*                 FIND FIRST tt-prazo-compra. */

/*                 ASSIGN p-ordem    = tt-ordem-compra.numero-ordem */
/*                        p-parcela  = tt-prazo-compra.parcela */
/*                        param-compra.prox-ord-aut = p-ordem + 1. */
            END. /*IF LAST-OF(ht_tt_rec_solic_compra_item.it_codigo)*/
        END. /*IF NOT p-erro THEN*/
    END. /*FOR EACH ht_tt_rec_solic_compra_item*/
END PROCEDURE.

PROCEDURE pi-gera-solic-compra.
                
    run valida-solic-compras.
    
    if not p-erro then do:
        FIND FIRST param-compra exclusive-lock NO-ERROR.
        IF AVAIL param-compra THEN DO:
            RUN pi-numera-requis.
    
            find last requisicao no-lock no-error. 
            if avail requisicao then
                assign /*i-nr-requisicao = requisicao.nr-requisicao + 1*/
                       i-num-id-documento = requisicao.num-id-documento + 1.
    
            create tt-requisicao.
            assign tt-requisicao.cod-estabel       = ht_tt_rec_solic_compra.cd_filial /*Verificar se o o estabelecimento ser  fixo ou pegar  o estabelecimento principal da empresa*/
                   tt-requisicao.dt-requisicao     = ht_tt_rec_solic_compra.data_requisicao
                   tt-requisicao.loc-entrega       = ht_tt_rec_solic_compra.local_entrega
                   tt-requisicao.nome-abrev        = ht_tt_rec_solic_compra.usuar_requis
                   tt-requisicao.narrativa         = ht_tt_rec_solic_compra.narrativa
                   tt-requisicao.nr-requisicao     = i-nr-requisicao
                   tt-requisicao.num-id-documento  = i-num-id-documento
                   tt-requisicao.estado            = 1 /*Aprovada*/
                   tt-requisicao.situacao          = 1 /*Aberta*/
                   tt-requisicao.tp-requis         = 2 /*Solicita‡Æo de compras*/
                   tt-requisicao.nome-aprov        = "" /*tt-requisicao.nome-aprov*/
/*                    tt-requisicao.ct-codigo         = ht_tt_rec_solic_compra_item.cd_conta_contabil */
/*                    tt-requisicao.sc-codigo         = ht_tt_rec_solic_compra_item.cd_centro_custo */
                   /*tt-requisicao.impressa          = tt-requisicao.impressa*/
                .
    
            ASSIGN ht_tt_rec_solic_compra.nr_solicitacao_EMS = i-nr-requisicao.

/*             message "H  item para importar?" can-find (first ht_tt_rec_solic_compra_item no-lock                                */
/*                WHERE ht_tt_rec_solic_compra_item.NUM_LOG_INTEGRACAO = ht_log_integracao.NUM_LOG_INTEGRACAO                      */
/*                  AND ht_tt_rec_solic_compra_item.quantidade          > 0) skip                                                  */
/*                      "H  item ou nÆo?!!!" can-find (first ht_tt_rec_solic_compra_item no-lock                                   */
/*                WHERE ht_tt_rec_solic_compra_item.NUM_LOG_INTEGRACAO = ht_log_integracao.NUM_LOG_INTEGRACAO)  view-as alert-box. */

    
            ASSIGN i-seq-sc = 0. 
            FOR EACH ht_tt_rec_solic_compra_item 
               WHERE ht_tt_rec_solic_compra_item.NUM_LOG_INTEGRACAO = ht_log_integracao.NUM_LOG_INTEGRACAO
                 AND ht_tt_rec_solic_compra_item.quantidade          > 0
            BREAK BY ht_tt_rec_solic_compra_item.it_codigo:
    
                IF FIRST-OF(ht_tt_rec_solic_compra_item.it_codigo) THEN
                    ASSIGN p-erro = NO.
    
                RUN valida-itens-solic-compras.

/*                 message ht_tt_rec_solic_compra_item.it_codigo skip */
/*                         "H  erro? " p-erro view-as alert-box.      */
                
                IF NOT p-erro THEN DO:
    
                    assign i-seq-sc = i-seq-sc + 1. 
    
                    find first item NO-LOCK 
                         WHERE item.it-codigo =  ht_tt_rec_solic_compra_item.it_codigo no-error.
        
                    FIND FIRST natureza-despesa NO-LOCK 
                         WHERE natureza-despesa.nat-despesa = ITEM.nat-despesa NO-ERROR.
        
                    FIND FIRST usuar-mater NO-LOCK 
                         WHERE usuar-mater.cod-usuario = ht_tt_rec_solic_compra.usuar_requis NO-ERROR.
                         
/*                     message "Vai criar item da solicita‡Æo" view-as alert-box. */
        
                    CREATE tt-it-requisicao.
                    ASSIGN tt-it-requisicao.cod-depos            = tt-it-requisicao.cod-depos
                           tt-it-requisicao.cod-estabel          = ht_tt_rec_solic_compra.cd_filial                         
                           tt-it-requisicao.cod-localiz          = tt-it-requisicao.cod-localiz                                      
                           tt-it-requisicao.cod-refer            = ""                                                                
                           tt-it-requisicao.conta-contabil       = string(ht_tt_rec_solic_compra_item.cd_conta_contabil) + string(ht_tt_rec_solic_compra_item.cd_centro_custo) /* string(natureza-despesa.ct-codigo) + string(usuar-mater.sc-codigo) */
                           tt-it-requisicao.ct-codigo            = /* natureza-despesa.ct-codigo */ ht_tt_rec_solic_compra_item.cd_conta_contabil
                           tt-it-requisicao.dt-entrega           = ht_tt_rec_solic_compra_item.data_entrega                          
                           tt-it-requisicao.ep-codigo            = 0
                           tt-it-requisicao.estado               = 1
                           tt-it-requisicao.it-codigo            = ht_tt_rec_solic_compra_item.it_codigo
                           tt-it-requisicao.narrativa            = ht_tt_rec_solic_compra.narrativa
                           tt-it-requisicao.nome-abrev           = ht_tt_rec_solic_compra.usuar_requis
                           tt-it-requisicao.nome-aprov           = ""
                           tt-it-requisicao.nr-requisicao        = ht_tt_rec_solic_compra.nr_solicitacao_EMS
                           tt-it-requisicao.num-ord-inv          = 0
                           tt-it-requisicao.numero-ordem         = 0
                           tt-it-requisicao.preco-unit           = 0
                           tt-it-requisicao.prioridade-aprov     = 0
                           tt-it-requisicao.qt-a-atender         = ht_tt_rec_solic_compra_item.quantidade
                           tt-it-requisicao.qt-a-devolver        = 0
                           tt-it-requisicao.qt-atendida          = 0
                           tt-it-requisicao.qt-devolvida         = 0
                           tt-it-requisicao.qt-requisitada       = ht_tt_rec_solic_compra_item.quantidade
                           tt-it-requisicao.sc-codigo            = /* usuar-mater.sc-codigo */ ht_tt_rec_solic_compra_item.cd_centro_custo
                           tt-it-requisicao.seq-planej           = 0
                           tt-it-requisicao.sequencia            = i-seq-sc
                           tt-it-requisicao.situacao             = 1
                           tt-it-requisicao.un                   = ht_tt_rec_solic_compra_item.un
                           tt-it-requisicao.val-item             = 0
                           tt-it-requisicao.char-1               = "" /*SUBSTRING(it-requisicao.char-1,1,1) = Afeta Qualidade? Y ou N*/
                           tt-it-requisicao.char-2               = "". /*SUBSTRING(it-requisicao.char-2,1,12) = C¢digo de utiliza‡Æo da tela de cadastro de itens da requisi‡Æo (CD1406a1-v01.w)*/
                           

/*                     message "CRIADO item da solicita‡Æo" view-as alert-box. */
        

                END.
                ELSE DO:
                    FOR EACH tt-requisicao EXCLUSIVE-LOCK
                       WHERE tt-requisicao.nr-requisicao = i-nr-requisicao.
                      DELETE tt-requisicao.
                    END.

                    FOR EACH tt-it-requisicao EXCLUSIVE-LOCK
                       WHERE tt-it-requisicao.nr-requisicao = i-nr-requisicao.
                      DELETE tt-it-requisicao.
                    END.
                    
                    FOR EACH ht-solic-compra-sgt EXCLUSIVE-LOCK
                       WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT.
                        DELETE ht-solic-compra-sgt.
                    END.
                END.
            END.
        END.
    END. /*if not p-erro*/
    
    FOR EACH tt-requisicao NO-LOCK BREAK BY tt-requisicao.nr-requisicao:

        FIND FIRST ht-solic-compra-sgt NO-LOCK
             WHERE ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT NO-ERROR.
        IF NOT AVAIL ht-solic-compra-sgt THEN DO:
            CREATE ht-solic-compra-sgt.
            ASSIGN ht-solic-compra-sgt.data_requisicao    = ht_tt_rec_solic_compra.data_requisicao  
                   ht-solic-compra-sgt.nr_solicitacao_EMS = tt-requisicao.nr-requisicao 
                   ht-solic-compra-sgt.nr_solicitacao_SGT = ht_tt_rec_solic_compra.nr_solicitacao_SGT 
                   ht-solic-compra-sgt.cd_filial          = ht_tt_rec_solic_compra.cd_filial
                   ht-solic-compra-sgt.usuar_requis       = ht_tt_rec_solic_compra.usuar_requis.

            CREATE requisicao.
            ASSIGN requisicao.cod-estabel       = tt-requisicao.cod-estabel     
                   requisicao.dt-requisicao     = tt-requisicao.dt-requisicao   
                   requisicao.loc-entrega       = tt-requisicao.loc-entrega     
                   requisicao.nome-abrev        = tt-requisicao.nome-abrev      
                   requisicao.narrativa         = tt-requisicao.narrativa       
                   requisicao.nr-requisicao     = tt-requisicao.nr-requisicao   
                   requisicao.num-id-documento  = tt-requisicao.num-id-documento
                   requisicao.estado            = tt-requisicao.estado          
                   requisicao.situacao          = tt-requisicao.situacao        
                   requisicao.tp-requis         = tt-requisicao.tp-requis       
                   requisicao.nome-aprov        = tt-requisicao.nome-aprov      
                   requisicao.ct-codigo         = tt-requisicao.ct-codigo
                   requisicao.sc-codigo         = tt-requisicao.sc-codigo
        /*            requisicao.impressa          = tt-requisicao.impressa  */
            .
    
                                  
            ASSIGN ht_tt_rec_solic_compra.nr_solicitacao_EMS = tt-requisicao.nr-requisicao.
            
            FOR EACH tt-it-requisicao NO-LOCK
               WHERE tt-it-requisicao.nr-requisicao = tt-requisicao.nr-requisicao.
               
               run pi-acompanhar in h-acomp(input "Importando solicitacao de compras: " + STRING(tt-requisicao.nr-requisicao)).
         
               CREATE it-requisicao.
               ASSIGN it-requisicao.cod-depos           = tt-it-requisicao.cod-depos
                      it-requisicao.cod-estabel         = tt-it-requisicao.cod-estabel     
                      it-requisicao.cod-localiz         = tt-it-requisicao.cod-localiz     
                      it-requisicao.cod-refer           = tt-it-requisicao.cod-refer       
                      it-requisicao.conta-contabil      = tt-it-requisicao.conta-contabil  
                      it-requisicao.ct-codigo           = tt-it-requisicao.ct-codigo       
                      it-requisicao.dt-entrega          = tt-it-requisicao.dt-entrega      
                      it-requisicao.ep-codigo           = tt-it-requisicao.ep-codigo       
                      it-requisicao.estado              = tt-it-requisicao.estado          
                      it-requisicao.it-codigo           = tt-it-requisicao.it-codigo       
                      it-requisicao.narrativa           = tt-it-requisicao.narrativa       
                      it-requisicao.nome-abrev          = tt-it-requisicao.nome-abrev      
                      it-requisicao.nome-aprov          = tt-it-requisicao.nome-aprov      
                      it-requisicao.nr-requisicao       = tt-it-requisicao.nr-requisicao   
                      it-requisicao.num-ord-inv         = tt-it-requisicao.num-ord-inv     
                      it-requisicao.numero-ordem        = tt-it-requisicao.numero-ordem    
                      it-requisicao.preco-unit          = tt-it-requisicao.preco-unit      
                      it-requisicao.prioridade-aprov    = tt-it-requisicao.prioridade-aprov
                      it-requisicao.qt-a-atender        = tt-it-requisicao.qt-a-atender    
                      it-requisicao.qt-a-devolver       = tt-it-requisicao.qt-a-devolver   
                      it-requisicao.qt-atendida         = tt-it-requisicao.qt-atendida     
                      it-requisicao.qt-devolvida        = tt-it-requisicao.qt-devolvida    
                      it-requisicao.qt-requisitada      = tt-it-requisicao.qt-requisitada  
                      it-requisicao.sc-codigo           = tt-it-requisicao.sc-codigo       
                      it-requisicao.seq-planej          = tt-it-requisicao.seq-planej      
                      it-requisicao.sequencia           = tt-it-requisicao.sequencia       
                      it-requisicao.situacao            = tt-it-requisicao.situacao        
                      it-requisicao.un                  = tt-it-requisicao.un              
                      it-requisicao.val-item            = tt-it-requisicao.val-item        
                      it-requisicao.char-1              = tt-it-requisicao.char-1          
                      it-requisicao.char-2              = tt-it-requisicao.char-2
                    .
                    
                ASSIGN ht_log_integracao.fl_reintegrar = 0. /*0 = NÆo deve ser visto pelo SGT para ser reintegrado, 1 = Deve ser reintegrado*/
            END.
        END.
        ELSE DO:
            run gera_tt_erro(input "Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " j  foi integrada.").
        END.
    END.
END PROCEDURE.

PROCEDURE pi-numera-requis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-global NO-LOCK NO-ERROR.

    if l-especial = no then do:
        find last requisicao use-index requisicao 
             where requisicao.nr-requisicao >= param-compra.prim-solic-man
             and   requisicao.nr-requisicao <= param-compra.ult-solic-man no-lock no-error.
        IF AVAIL requisicao THEN DO:
            IF  requisicao.nr-requisicao >= 999999 OR requisicao.nr-requisicao = param-compra.ult-solic-man THEN DO:
                ASSIGN i-cont = param-compra.prim-solic-man.
                REPEAT:
                     IF CAN-FIND(requisicao WHERE
                               requisicao.nr-requisicao = i-cont) THEN DO:
                         ASSIGN  i-cont = i-cont + 1.
                         NEXT.
                     END.
                     ASSIGN i-nr-requisicao = i-cont.
                     LEAVE.    
                END. 
            END.
            ELSE
                ASSIGN i-nr-requisicao = IF AVAIL requisicao THEN (requisicao.nr-requisicao + 1)
                                                             ELSE param-compra.prim-solic-man.
        END.
        ELSE
            ASSIGN i-nr-requisicao = param-compra.prim-solic-man.
    end.
    else do:
        find last requisicao use-index requisicao
             where requisicao.nr-requisicao >= param-compra.prim-solic-esp
             and   requisicao.nr-requisicao <= param-compra.ult-solic-esp no-lock no-error.
        IF  requisicao.nr-requisicao >= 999999 OR requisicao.nr-requisicao = param-compra.ult-solic-esp THEN DO:
            ASSIGN i-cont = param-compra.prim-solic-esp.
            REPEAT:
                 IF CAN-FIND(requisicao WHERE
                           requisicao.nr-requisicao = i-cont) THEN DO:
                     ASSIGN  i-cont = i-cont + 1.
                     NEXT.
                 END.
                 ASSIGN i-nr-requisicao = i-cont.
                 LEAVE.    
            END. 
        END.
        ELSE
            assign i-nr-requisicao = if avail requisicao then (requisicao.nr-requisicao + 1)
                                                         else prim-solic-esp.
    END.

    /* verifica se a requisicao se encontra em BH */
    if param-global.modulo-bh then do:
        find last his-requisicao no-lock no-error.
        if avail his-requisicao and 
           his-requisicao.nr-requisicao >= i-nr-requisicao then
            assign i-nr-requisicao = his-requisicao.nr-requisicao + 1.
    end.


/*     assign requisicao.nr-requisicao:screen-value in frame {&frame-name} = string(i-nr-requisicao) */
/*            l-erro-requisicao = no.                                                                */


/*     if i-nr-requisicao < param-compra.prim-solic-man or      */
/*        i-nr-requisicao > param-compra.ult-solic-man then do: */
/*         run utp/ut-msgs.p (input "show",                     */
/*                            input 863,                        */
/*                            input return-value).              */
/*         return 'adm-error'.                                  */
/*     end.                                                     */
END PROCEDURE.


procedure valida-solic-compras:
   
    IF ht_tt_rec_solic_compra.cd_filial = "" then 
        run gera_tt_erro(input "SC: Codigo do estabelecimento nao informado." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
    ELSE DO:
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = ht_tt_rec_solic_compra.cd_filial NO-ERROR.
        IF NOT AVAIL estabelec THEN
            run gera_tt_erro(input "SC: Codigo do estabelecimento " + ht_tt_rec_solic_compra.cd_filial + " nao existe no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
    END.

    IF ht_tt_rec_solic_compra.data_requisicao = ? THEN
            run gera_tt_erro(input "Data da requisicao nao foi preenchida.").
    ELSE IF ht_tt_rec_solic_compra.data_requisicao > TODAY THEN
            run gera_tt_erro(input "SC: Data da requisicao" + STRING(ht_tt_rec_solic_compra.data_requisicao,"99/99/9999") + "e maior que hoje." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).

    IF ht_tt_rec_solic_compra.usuar_requis = "" THEN
            run gera_tt_erro(input "SC: Usuario da requisicao nao foi preenchido.").
    ELSE DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = ht_tt_rec_solic_compra.usuar_requis NO-ERROR.
        IF NOT AVAIL usuar_mestre THEN
            run gera_tt_erro(input "SC: Usuario da requisicao " + ht_tt_rec_solic_compra.usuar_requis + " nao existe." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
    END.
end procedure. /* valida-item */ 

PROCEDURE valida-itens-ordem-compra.
    IF ht_tt_rec_solic_compra_item.it_codigo = "" THEN
       run gera_tt_erro(input "IOC: Codigo do item " + ht_tt_rec_solic_compra_item.it_codigo + " nao informado." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
    ELSE DO:
        FIND FIRST item NO-LOCK
             WHERE ITEM.it-codigo = ht_tt_rec_solic_compra_item.it_codigo NO-ERROR.
        IF AVAIL item THEN DO:
            IF item.cod-obsoleto <> 1 THEN 
                run gera_tt_erro(input "IOC: Item " + ht_tt_rec_solic_compra_item.it_codigo + " nao esta ativo no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
        
            IF ITEM.tipo-contr <> 2 THEN /*Total*/
                run gera_tt_erro(input "IOC: O item " + ht_tt_rec_solic_compra_item.it_codigo + " nao e tipo de controle debito direto." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
        
            IF item.un <> ht_tt_rec_solic_compra_item.un THEN /*UN*/
                run gera_tt_erro(input "IOC: Unidade de medida recebida (" + ht_tt_rec_solic_compra_item.un + ") nao e igual a unidade de medida do item (" + item.un + ")." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).
        END.
        ELSE DO:
               run gera_tt_erro(input "IOC: Codigo do item " + ht_tt_rec_solic_compra_item.it_codigo + " nao encontrado no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).
        END.
    END.

    if ht_tt_rec_solic_compra_item.un = "" then 
       run gera_tt_erro(input "IOC: Unidade de medida nao informada." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).

    find first mgcad.tab-unidade where tab-unidade.un = ht_tt_rec_solic_compra_item.un no-lock no-error.
    if not available tab-unidade then do:
       run gera_tt_erro(input "IOC: Unidade de medida " + ht_tt_rec_solic_compra_item.un + " nao existe." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).
    end.

END PROCEDURE.

PROCEDURE valida-itens-solic-compras.
    IF ht_tt_rec_solic_compra_item.it_codigo = "" THEN
       run gera_tt_erro(input "ISC: Codigo do item " + ht_tt_rec_solic_compra_item.it_codigo + " nao informado." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
    ELSE DO:
        FIND FIRST item NO-LOCK
             WHERE ITEM.it-codigo = ht_tt_rec_solic_compra_item.it_codigo NO-ERROR.
        IF AVAIL item THEN DO:
            IF item.cod-obsoleto <> 1 THEN 
                run gera_tt_erro(input "ISC: Item " + ht_tt_rec_solic_compra_item.it_codigo + " nao esta ativo no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).

            IF ITEM.tipo-contr <> 4 THEN /*D‚bito Direto*/
                run gera_tt_erro(input "ISC: O item " + ht_tt_rec_solic_compra_item.it_codigo + " nao e tipo de controle debito direto." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
        
            IF item.un <> ht_tt_rec_solic_compra_item.un THEN /*D‚bito Direto*/
                run gera_tt_erro(input "ISC: Unidade de medida recebida (" + ht_tt_rec_solic_compra_item.un + ") nao e igual a unidade de medida do item (" + item.un + ")." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).
           
           FIND FIRST natureza-despesa NO-LOCK 
                WHERE natureza-despesa.nat-despesa = ITEM.nat-despesa NO-ERROR.
           IF NOT AVAIL natureza-despesa THEN DO:
       
              run gera_tt_erro(input "ISC: Natureza de despesa " + STRING(ITEM.nat-despesa) + " do item " + ht_tt_rec_solic_compra_item.it_codigo + " nao encontrado. Verifique o cadastro do item no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).    
           END.
        END.
        ELSE DO:
               run gera_tt_erro(input "ISC: Codigo do item " + ht_tt_rec_solic_compra_item.it_codigo + " nao encontrado no EMS." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT)).
        END.
    END.            
    
    if ht_tt_rec_solic_compra_item.un = "" then 
       run gera_tt_erro(input "ISC: Unidade de medida nao informada." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).
       
    find first mgcad.tab-unidade where tab-unidade.un = ht_tt_rec_solic_compra_item.un no-lock no-error.
    if not available tab-unidade then do:
       run gera_tt_erro(input "ISC: Unidade de medida " + ht_tt_rec_solic_compra_item.un + " nao existe." + " Solicita‡Æo SGT: " + STRING(ht_tt_rec_solic_compra.nr_solicitacao_SGT) + " - Item " + ht_tt_rec_solic_compra_item.it_codigo).    
    end.
END PROCEDURE.

procedure gera_tt_erro:
   def input param p-msg as char.
   
   assign p-erro = yes.
   RUN hzp/hzapi002.p (BUFFER ht_log_integracao,
                       INPUT 6,
                       INPUT p-msg).

   IF NOT p-msg MATCHES "*j  foi integrada." THEN
       ASSIGN ht_log_integracao.fl_reintegrar = 1. /*1 = Deve ser reintegrado*/
   
end procedure. /* gera_tt_erro */


