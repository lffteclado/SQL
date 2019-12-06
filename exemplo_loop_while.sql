declare @V_EXTERNO int =  (select count(*) from tb_procedimento where id in (29167905, 29167899))
declare @V_INTERNO int =  (select count(*) from tb_procedimento where id in (29192510 ,29192504 ,29167905, 29167899))

BEGIN
    WHILE @V_EXTERNO < 21   
    BEGIN
        print 'Contador externo: ' + cast(@V_EXTERNO as varchar(10));
        WHILE @V_INTERNO < 6        
        BEGIN
             print 'Contador interno: ' + cast(@V_INTERNO as varchar(10));
             SET @V_INTERNO = @V_INTERNO + 1;
        END;
       SET @V_EXTERNO = @V_EXTERNO + 1;
       SET @V_INTERNO = 1;
    END;
END;