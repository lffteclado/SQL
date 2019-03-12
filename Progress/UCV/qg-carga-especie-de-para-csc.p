def var c-linha as char no-undo.

input from value("C:\tmp\de-para.txt") no-convert.

repeat:

    import unformatted c-linha.
    
    if not can-find(first estabelecimento 
                    where estabelecimento.cod_estab = entry(1,c-linha,";")) then next.
    
    find first es_de_para_edifact exclusive-lock
         where es_de_para_edifact.tp_de_para  = "Especie"
           and es_de_para_edifact.cod_empresa = entry(1,c-linha,";")
           and es_de_para_edifact.desc_de     = entry(2,c-linha,";") no-error.
    if not avail es_de_para_edifact then do:
        create es_de_para_edifact.
        assign es_de_para_edifact.tp_de_para  = "Especie"
               es_de_para_edifact.cod_empresa = entry(1,c-linha,";")
               es_de_para_edifact.desc_de     = entry(2,c-linha,";").
    end.
    assign es_de_para_edifact.desc_para = entry(3,c-linha,";").

end.

input close.
