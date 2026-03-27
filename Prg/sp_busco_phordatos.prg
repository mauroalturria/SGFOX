***
***  busqueda de los datos para las planillas
***
Use In Select('mwkpent')
Use In Select('mwkpesp')
Use In Select('mwkpmed')
Use In Select('mwkppres')
Use In Select("mwkespecag")
Use In Select("mwkpser")
Use In Select("mwkentexc")
opcion = 2
If Used('mwkexe')
	If mwkexe.nomexe = "PISOS"
		opcion = 1
	Endif
Endif
If opcion = 1
	mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ent_turnoshabilit, ent_fecpas " + ;
		" from entidades ", "mwkpent")
	If Used('mwkmedicoint')
		Select * From mwkmedicoint Into Cursor mwkpMed
	Else
		mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores " + ;
			"", "mwkpMed" )
	Endif
	mret=SQLExec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,Pre_retiroestudios "+;
		",pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  "+;
		',PRE_EdadDesde, PRE_EdadHasta,PRE_duracion '+;
		" FROM prestacions  " + ;
		"WHERE pre_fechapasiva is Null  ","Mwkppres")

	mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
		" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

	mret=SQLExec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
		" WHERE ESP_descripcion is not Null " ,"MWKpesp")

	mret = SQLExec(mcon1,"select ser_codserv, ser_descripserv from servicios ","mwkpser")

	mfecpas = Ctod('01/01/1900')
	mret = SQLExec(mcon1, "select codent, tipoturno,fecpasiva from entidexclu " + ;
		"where id <100000 and fecpasiva = ?mfecpas and tpopac = 'INT' " , "mwkentexc")
Else
	mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ent_turnoshabilit, ent_fecpas " + ;
		" from entidades ", "mwkpent")

	mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores " + ;
		"WHERE dambula = 1 and id > 1 ", "mwkpMed" )

	mret=SQLExec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona,PRE_CargaQuirofano  "+;
		" FROM prestacions  " + ;
		"WHERE PRE_agendaturnos='S' ","Mwkppres")

	mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
		" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

	mret=SQLExec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
		" WHERE ESP_descripcion is not Null " ,"MWKpesp")

	mret = SQLExec(mcon1,"select ser_codserv, ser_descripserv from servicios ","mwkpser")

	mfecpas = Ctod('01/01/1900')
	mret = SQLExec(mcon1, "select codent, tipoturno,fecpasiva from entidexclu " + ;
		"where id <100000 and fecpasiva = ?mfecpas and tipoturno = 7 and tpopac = 'AMB' " , "mwkentexc")
Endif
