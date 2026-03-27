Parameters tnOpcion, tcWhere, tcCursor

*!*	tnOpcion = 2
*!*	tcWhere = ''
*!*	*!*	Set Step On

If Vartype(tcCursor)  # "C"
	tcCursor = 'mwkMedQuir'
Endif  

USE IN SELECT(tcCursor)
Do Case
	Case tnOpcion = 1
		lcSql = "Select * from TabQuiroProf " + tcWhere 

	Case tnOpcion = 2
		lcSql = "Select TIPOMEDQUIR.TIP_descriptprof  , TabQuiroProf.Id as IdQP, " + ;
			"Nvl(TQF_IdQuiroProto,0) as TQF_IdQuiroProto, " + ;
			"Nvl(TQF_CodMed,0 ) As TQF_CodMed, " + ;
			"TIPOMEDQUIR.TIP_codtipoprofes as TQF_Tipo, " + ;
			"TQF_FecAlta, TQF_CodigoVax, TQF_FecPasiva, TQF_VaxPasiva, " + ;
			"Nvl(TQF_nombre,'') as TQF_nombre, " + ;
			"Nvl(TQF_Matricula, '') as TQF_Matricula, TabEstados.Id as TQF_Estados, Nvl(TabQuiroProf.TQF_Obs,'') as TQF_Obs " + ;
			"from TIPOMEDQUIR  " + ;
			"Inner join TabEstados ON TIPOMEDQUIR.TIP_codtipoprofes = TabEstados.SubEstado  AND Propietario = 22 AND TIPO = 10 " + ;
			"Left join TabQuiroProf on TIPOMEDQUIR.TIP_codtipoprofes = TabQuiroProf.TQF_Tipo and " + ;
				" TQF_FecPasiva = '1900-01-01' and TQF_Estados = TabEstados.Id " + tcWhere  

	Otherwise

Endcase 

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
