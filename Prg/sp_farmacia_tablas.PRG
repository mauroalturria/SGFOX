*
* Tablas Farmacia
*
Lparameters mtipo, mformula

Do case
Case mtipo = 0 or mtipo = 1
	If mtipo = 0
		If used("mwkentidad2")
			Use in mwkentidad2
		Endif
		mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_tipo,ENT_codagrup, ENT_nroprestadorexterno from entidades " + ;
			"where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
			"order by ENT_descrient", "mwkentidad2")
		If mret < 0
			Messagebox("EN LA GENERACION - AUXILIAR ENTIDADES, AVISAR A SISTEMAS",16, "ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif
	Endif
	If mtipo = 1
		If used("mwkinst")
			Use in mwkinst
		Endif
		mret = sqlexec(mcon1,"select TFI_descripcion, ID " +;
			"from TabFarmIns "+;
			"where TFI_fechapasivo is null", "mwkinst")
		If mret < 0
			Messagebox("EN LA GENERACION - AUXILIAR INSTITUCIONES, AVISAR A SISTEMAS",16, "ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif
	Endif

Case mtipo = 2
	If used("mwkTabEstados")
		Use in mwkTabEstados
	Endif
	mret = sqlexec(mcon1,"select * from tabestados where propietario = 30 and Estado = 1", "mwkTabEstados")
	If mret < 0
		Messagebox("EN LA GENERACION - AUXILIAR de ESTADOS, AVISAR A SISTEMAS",16, "ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Case mtipo = 3
	If used("mwkTabEstad2")
		Use in mwkTabEstad2
	Endif
	mret = sqlexec(mcon1,"select * from TabEstados where propietario = 30 and Estado = 2", "mwkTabEstad2")
	If mret < 0
		Messagebox("EN LA GENERACION - AUXILIAR de ESTADOS, AVISAR A SISTEMAS",16, "ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Case mtipo = 4
	If used("mwkMedicosall")
		Use in mwkMedicosall
	Endif

	mfectrl = sp_busco_fecha_serv('DD')
	mfecnul = ctod("01/01/1900")

	mret = sqlexec(mcon1,"Select id,nombre,matriculas from prestadores"+;
		" where id<100000"+;
		" and (fecpasivap=?mfecnul or fecpasivap > ?mfectrl)"+;
		" order by nombre","mwkMedicosall" )

	If mret < 0
		Messagebox("EN CONSULTA DE PROFESIONALES MEDICOS"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Case mtipo = 5
	If vartype(mformula)#"N"
		mformula = 0
	Endif
	If used("mwkesquemas")
		Use in mwkesquemas
	Endif

	mret = sqlexec(mcon1,"Select * from TabFarmEsq"+;
		" where TFE_formula = ?mformula"+;
		" order by TFE_esquema","mwkesquemas" )

	If mret < 0
		Messagebox("EN CONSULTA DE ESQUEMAS DE TRATAMIENTOS"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Case mtipo = 6 && Nuevo: Formulas para relacionar con esquemas
	If used("mwkformulas")
		Use in mwkformulas
	Endif
	mret = sqlexec(mcon1,"select * from tabestados where propietario = 31 and Estado = 2"+;
	" order by subestado", "mwkformulas")
	If mret < 0
		Messagebox("EN LA GENERACION - AUXILIAR de FORMULAS, AVISAR A SISTEMAS",16, "ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Endcase
Return .T.