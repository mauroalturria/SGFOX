Parameters tnRegistra

*!*	 
lcSql = ''
ldNullDate = Ctod("")

*Text To lcSql Noshow Textmerge Pretext 7
lcSql = "Select TabVacCal.CV_Dosis, TabVacCal.CV_Edad, TabVacCal.CV_EdadH, TabVacCal.CV_Observa, TabVacCal.Id as IdCal, " + ;
		"TabVacunas.Id as IdVac, TabVacunas.Vac_descripcion,TabVacunas.VAC_Codprest, TabVacunas.Vac_pasiva,  " + ;
		"TabVacunas.Vac_Previene, TabVacunas.Vac_Sigla,  " + ;
		"TabVacReg.Id as IdRegVac2, " + ;
		"TabVacReg.Var_Cal, TabVacReg.Var_CodAmbito, " + ;
		"TabVacReg.Var_CodMed, TabVacReg.Var_FecPasiva,  " + ;
		"TabVacReg.Var_FechaApli , TabVacReg.Var_FechaHora, " + ;
		"TabVacReg.Var_NroReg, TabVacReg.Var_Obs, TabVacReg.Var_Vacuna, " + ;
		"nvl(TabVacReg.Var_lote,'                   ') as Var_lote,NVL(TabVacReg.Var_Vto,000000) as Var_Vto,NVL(TabVacReg.Var_ubicacion,0) as Var_ubicacion " +;
		"from TabVacunas " + ;
		"Inner join TabVacCal on CV_Vacuna = TabVacunas.Id " + ;
		"Left join TabVacReg on TabVacunas.Id = TabVacReg.VAR_Vacuna and  " + ;
		"	TabVacCal.Id = TabVacReg.VAR_Cal and  " + ;
		"	var_NroReg = ?tnRegistra and var_FecPasiva = '1900-01-01' " + ;
		"Order by CV_Edad, VAC_Descripcion, CV_Dosis, Var_FechaApli "


*Endtext 

If !prg_ejecutosql(lcSql, "mwkRegVac")
	Return .F.
Endif

