sp_helptext spPRubricaESocial

 SELECT * FROM tbRubricaESocial (NOLOCK)
   WHERE 
      CodigoEmpresa = 930 AND
      CodigoRubrica = 1000


SELECT ev.CodigoEvento, 
	   ev.DescricaoEvento,
	   ru.CodigoRubrica,
	   ru.DescricaoTipoRubrica,
	   ev.BaseInssESocial,
	   ev.BaseIrrfESocial,
	   ev.BaseFgtsESocial,
	   ev.BaseSindicalESocial
		FROM tbEvento ev
inner join tbRubricaESocial ru
on ev.CodigoRubricaESocial = ru.CodigoRubrica



sp_helptext spPEvento
