OUTPUT TO "C:\TEMP\LISTA_ITENS.TXT".
FOR EACH item:
    DISP it-codigo descricao-1 fm-codigo ge-codigo nat-despesa tp-desp-padrao WITH WIDTH 300.
    CASE substring(char-2,212,1):
    WHEN '1' THEN
        DISP "Materia Prima".
    WHEN '' THEN
        DISP "Nao Informado".
    WHEN '0' THEN
        DISP "Mercadoria para revenda".
    WHEN '2' THEN
        DISP "Embalagem".
    WHEN '3' THEN
        DISP "Produto em Processo".
    WHEN '4' THEN
        DISP "Produto Acabado".
    WHEN '5' THEN
        DISP "Subproduto".
    WHEN '6' THEN
        DISP "Produto Intermediario".
    WHEN '7' THEN
        DISP "Material de Uso e Consumo".
    WHEN '8' THEN
        DISP "Ativo Imobilizado".
    WHEN '9' THEN
        DISP "Serviaos".
    WHEN 'a' THEN
        DISP "Outros Insumos".
    WHEN 'b' THEN
        DISP "Outras".
    END CASE.
END.
MESSAGE "FIM" VIEW-AS ALERT-BOX.
OUTPUT CLOSE.
