Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- =============================================
-- Author:      <Alexandre Vilela>
-- Create date: <01/04/2015>
-- Description: <Retorna relacionamentos>
-- =============================================
CREATE PROCEDURE [dbo].[ConsultaRelacionamentos]

                 @Tabela varchar(60),
                 @id varchar (20)
AS
BEGIN
    SET NOCOUNT ON;

DECLARE @NOME_TABELA VARCHAR(255)
DECLARE @NOME_COLUNA VARCHAR(255)
DECLARE @COMANDO1 VARCHAR(MAX)
DECLARE @COUNT_VINCULO INT = 0
DECLARE @SQL VARCHAR(MA
X)

DECLARE @TABELA1
  TABLE ([NOME_TABELA]          [varchar](100),
         [NOME_COLUNA]          [varchar](100),
         [TOTAL_RELACIONAMENTO] [INT]
        )

DECLARE CURSOR_FK
CURSOR FOR (SELECT KCU1.TABLE_NAME,
                   KCU1.COLUMN_NAME

              FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
              JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU1    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG
                                                              AND KCU1.CONS
TRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA
                                                              AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
              JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2    ON KCU2.CONSTRAINT_CATALOG = RC.UNIQUE_CONSTRAI
NT_CATALOG
                                                              AND KCU2.CONSTRAINT_SCHEMA = RC.UNIQUE_CONSTRAINT_SCHEMA
                                                              AND KCU2.CONSTRAINT_NAME = RC.UNIQUE_CONSTRAINT_NAME
          
                                                    AND KCU2.ORDINAL_POSITION = KCU1.ORDINAL_POSITION
              JOIN sys.foreign_keys FK                         ON FK.NAME = KCU1.CONSTRAINT_NAME
             WHERE kcu2.TABLE_NAME = @tabela)
OPEN CURSO
R_FK
FETCH NEXT FROM CURSOR_FK INTO @nome_tabela, @nome_coluna
WHILE @@FETCH_STATUS = 0
BEGIN

    DECLARE @quantidadeCampoRegistroAtivo int

    SELECT @quantidadeCampoRegistroAtivo = count(*) FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME 
= UPPER(@nome_tabela)
            AND  COLUMN_NAME = UPPER('registro_ativo')

    IF(@quantidadeCampoRegistroAtivo > 0)
    BEGIN

    SET @SQL = 'select ''' + @nome_tabela + ''' AS NOME_TABELA, '''
                         + @nome_coluna + ''' AS NOME_CO
LUNA, '
                         + 'count (*) as TOTAL_RELACIONAMENTO from ' + @nome_tabela + ' where ' + @nome_tabela + '.' + @nome_coluna + ' = ' + @id + ' and ' + @nome_tabela + '.' +'registro_ativo = 1'
    END

    IF(@quantidadeCampoRegistroAtivo = 
0)
    BEGIN

    SET @SQL = 'select ''' + @nome_tabela + ''' AS NOME_TABELA, '''
                         + @nome_coluna + ''' AS NOME_COLUNA, '
                         + 'count (*) as TOTAL_RELACIONAMENTO from ' + @nome_tabela + ' where ' + @nome_tabel
a + '.' + @nome_coluna + ' = ' + @id
    END
  PRINT @SQL
  INSERT INTO @TABELA1
  EXEC(@SQL)

FETCH NEXT FROM CURSOR_FK INTO @nome_tabela, @nome_coluna
END

CLOSE CURSOR_FK
DEALLOCATE CURSOR_FK

SELECT * FROM @TABELA1


END



