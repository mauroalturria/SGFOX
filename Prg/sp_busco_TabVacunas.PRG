Parameters tcWhere

*!*	 
lcSql = ''
ldFecNull = Ctod("01/01/1900")

*Text To lcSql Noshow Textmerge Pretext 7
lcSql = "Select TabVacunas.*,  TabVacCal.Id  as IdCal,CV_Dosis  " + ;
		"from TabVacunas " + ;
		"inner join TabVacCal on CV_Vacuna = TabVacunas.Id " + ;
		"Where VAC_Pasiva = ?ldFecNull " + tcWhere + " " + ;
		"Group by TabVacunas.Id " + ;
		"Order by VAC_Descripcion "


*Endtext 

If !prg_ejecutosql(lcSql, "mwkVacunas")
	Return .F.
Endif

