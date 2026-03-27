Parameters tnOpcion, tnId, tnIdQuiroProto, tnCodMed, tnTipo, ttFecAlta, ;
tnCodigoVax, tdFecPasiva, tnVaxPasiva, tcNombre, tcMatricula, tnEstados, tcObs 

Do Case
	Case tnOpcion = 1
		lcSql = "Insert into TabQuiroProf " + ;
			"(TQF_IdQuiroProto, TQF_CodMed, TQF_Tipo, TQF_FecAlta, " + ;
			" TQF_CodigoVax, TQF_FecPasiva, TQF_VaxPasiva, TQF_Nombre, TQF_Matricula, TQF_Estados, TQF_Obs )" + ;
			" Values " + ;
			"(?tnIdQuiroProto, ?tnCodMed, ?tnTipo, ?ttFecAlta, " + ;
			" ?tnCodigoVax, ?tdFecPasiva, ?tnVaxPasiva, ?tcNombre, ?tcMatricula, ?tnEstados, ?tcObs )" 

	Case tnOpcion = 2
*!*			If tnCodMed > 0
*!*				tcNombre = ''
*!*				tcMatricula = ''
*!*			Endif 
	
		lcSql = "Update TabQuiroProf Set " + ;
			"TQF_IdQuiroProto = ?tnIdQuiroProto, " + ;
			"TQF_CodMed = ?tnCodMed, " + ;
			"TQF_Tipo = ?tnTipo, " + ;
			"TQF_FecAlta = ?ttFecAlta, " + ;
			"TQF_CodigoVax = ?tnCodigoVax, " + ;
			"TQF_FecPasiva = ?tdFecPasiva, " + ;
			"TQF_VaxPasiva = ?tnVaxPasiva, " + ;
			"TQF_Nombre = ?tcNombre, " + ;
			"TQF_Matricula = ?tcMatricula, " + ;
			"TQF_Estados  = ?tnEstados, " + ;
			"TQF_Obs  = ?tcObs " + ;
			"Where Id = ?tnId "

	Case tnOpcion = 3
	
		lcSql = "Update TabQuiroProf Set " + ;
			"TQF_FecPasiva = ?tdFecPasiva, " + ;
			"TQF_VaxPasiva = ?tnVaxPasiva " + ;
			"Where Id = ?tnId "

	Otherwise

Endcase 

if !Prg_EjecutoSql(lcSql,"",.f.)
	Return .f.
Endif  