IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('tri_cooperado'))
		BEGIN
			DROP TRIGGER [dbo].[tri_cooperado]
		END
	GO
CREATE TRIGGER [dbo].[tri_cooperado] ON [dbo].[tb_cooperado]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @action as char(1),
        @IndConRepNew as char(1),
		@IndConRepOld as char(1);
SET @action = 'I'; -- Set Action to Insert by default.
    IF EXISTS(SELECT * FROM DELETED)
    BEGIN
        SET @action = 
            CASE
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 'U' -- Set Action to Updated.
                ELSE 'D' -- Set Action to Deleted.       
            END
    END

IF @action = 'I'
BEGIN
	select @IndConRepNew=i.IndConRep from inserted i;
	select @IndConRepOld='N';
END
IF @action = 'U'
BEGIN
	select @IndConRepNew=i.IndConRep from inserted i;
	select @IndConRepOld=i.IndConRep from deleted i;
END
IF @action = 'D'
BEGIN
	select @IndConRepNew= 'N';
	select @IndConRepOld=i.IndConRep from deleted i;
END

IF @action = 'U'
BEGIN
	IF @IndConRepNew = 'S' AND @IndConRepOld = 'N'
	BEGIN
		SET @action = 'I';
	END
END

IF @IndConRepNew = 'S' OR @IndConRepOld = 'S'
BEGIN
	IF @action = 'D'
	BEGIN
		INSERT INTO data_sync_inss (CodPesCoo, CodPesEnt, DtaRec,
			  CNPJEmpRec,
			  NumRep,
			  dtsync,
			  "action",
			  "processado", 
			  "processadoSASC", 
			  NumSeq, 
			  "User"
			  )
			  select d.CodPesCoo, d.CodPesEnt, d.DtaRec, d.CNPJEmpRec, d.NumRep, getdate(), @action, 0,0, d.NumSeq, System_User from deleted d		  
	END ELSE
	BEGIN
		INSERT INTO data_sync_inss (CodPesCoo, CodPesEnt, DtaRec,
			CNPJEmpRec,
			NumRep,
			dtsync,
			"action",
			"processado", 
			"processadoSASC", 
			NumSeq,
			"User"
			)
			select d.CodPesCoo, d.CodPesEnt, d.DtaRec, d.CNPJEmpRec, d.NumRep, getdate(), @action, 0,case when d.codidesis=9 and @action='I' then 1 else 0 end, d.NumSeq, System_User from inserted d
		END
	END
END

GO

--ALTER TABLE [dbo].[tb_cooperado] ENABLE TRIGGER [tri_cooperado]
--GO


