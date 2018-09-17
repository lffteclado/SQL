DROP PROCEDURE dbo.spADependente
GO
CREATE PROCEDURE dbo.spADependente
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @TipoColaborador char(1) ,
   @NumeroRegistro numeric(8) ,
   @SequenciaDependente numeric(2) = 0,
   @NomeDependente char(70) ,
   @SexoDependente char(1) ,
   @GrauParentesco numeric(2) = Null,
   @DataNascimentoDependente datetime ,
   @DependenteSalarioFamilia char(1) = 'F',
   @ControleVacinacao char(1) = 'N',
   @DependenteInvalido char(1) = 'F',
   @DependenteIRRF char(1) = 'F',
   @DependenteUniversitario char(1) = 'F',
   @DependenteAssistenciaMedica char(1) = 'F',
   @DataBaixaAssistencia datetime = Null,
   @ValorSalarioFamiliaLiberar money = 0,
   @CPFDependente char(14) = null,
   @DependenteOdontologica char(1) = 'F',
   @DataBaixaOdontologica datetime = null
AS 
UPDATE tbDependente
SET
   NomeDependente = @NomeDependente,
   SexoDependente = @SexoDependente,
   GrauParentesco = @GrauParentesco,
   DataNascimentoDependente = @DataNascimentoDependente,
   DependenteSalarioFamilia = @DependenteSalarioFamilia,
   ControleVacinacao = @ControleVacinacao,
   DependenteInvalido = @DependenteInvalido,
   DependenteIRRF = @DependenteIRRF,
   DependenteUniversitario = @DependenteUniversitario,
   DependenteAssistenciaMedica = @DependenteAssistenciaMedica,
   DataBaixaAssistencia = @DataBaixaAssistencia,
   ValorSalarioFamiliaLiberar = @ValorSalarioFamiliaLiberar,
   CPFDependente = @CPFDependente,
   DependenteOdontologica = @DependenteOdontologica,
   DataBaixaOdontologica = @DataBaixaOdontologica
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   TipoColaborador = @TipoColaborador AND
   NumeroRegistro = @NumeroRegistro AND
   SequenciaDependente = @SequenciaDependente 