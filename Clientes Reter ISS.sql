select tbCF.CodigoCliFor,
       tbCF.NomeCliFor,
       tbCF.MunicipioCliFor,
       tbCF.UFCliFor,
       tbCF.CondicaoRetencaoISS,
       tbCL.CodigoLocal,
       tbCL.CondicaoRetencaoISS
from tbCliFor tbCF
        inner join tbCliForLocal tbCL on
        tbCF.CodigoCliFor = tbCL.CodigoCliFor
where tbCF.ClienteAtivo = 'V' and (tbCF.CondicaoRetencaoISS = 'V' or tbCL.CondicaoRetencaoISS = 'V') order by tbCF.MunicipioCliFor