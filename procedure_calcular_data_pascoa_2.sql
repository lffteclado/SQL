 DECLARE @ano AS INT = 2022
 DECLARE @DATA AS DATETIME
 DECLARE @MES AS INT
 DECLARE @DIA AS INT
 DECLARE @A AS INT
 DECLARE @B AS INT
 DECLARE @C AS INT
 DECLARE @D AS INT
 DECLARE @E AS INT
 DECLARE @F AS INT
 DECLARE @G AS INT
 DECLARE @H AS INT
 DECLARE @I AS INT
 DECLARE @K AS INT
 DECLARE @L AS INT
 DECLARE @M AS INT
 SET @A = @ANO%19
 SET @B = @ANO/100
 SET @C = @ANO%100
 SET @D = @B/4
 SET @E = @B%4
 SET @F = (@B+8)/25
 SET @G = (@B-@F+1)/3
 SET @H = (19*@A+@B-@D-@G+15)%30
 SET @I = @C/4
 SET @K = @C%4
 SET @L = (32+2*@E+2*@I-@H-@K)%7
 SET @M = (@A+11*@H+22*@L)/451
 SET @MES = (@H+@L-7*@M+114)/31
 SET @DIA = ((@H+@L-7*@M+114)%31)+1
 SET @DATA = CAST((LTRIM(RTRIM(CAST(@ANO AS CHAR)))) + '-' + 
 (LTRIM(RTRIM(CAST(@MES AS CHAR)))) + '-' + 
 (LTRIM(RTRIM(CAST(@DIA AS CHAR)))) AS DATETIME)

 select @DATA

 SELECT DATEADD(DAY, -2, @DATA);