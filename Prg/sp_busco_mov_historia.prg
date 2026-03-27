*********************************************************************************
* BUSCA Movimientos de la historia                                                    *
*********************************************************************************
Lparameters mbusco,mbusco2,lhist

If Type('mbusco2') # "C"
	mbusco2 = ''
Endif
If Type('lhist') # "N"
	lhist= 0
Endif
If lhist = 1
	mret = SQLExec(mcon1,"select TabHCHisct.*, nombre , ESP_descripcion " + ;
		" from especialid,TabHCHisct "+;
		" left outer join prestadores on TabHCHisct.hcm_codmed = prestadores.id "+;
		" where hcm_registrac = ?mbusco &mbusco2 and trim(hcm_codesp) = trim(ESP_codesp)" +;
		" " , "mwkmovhist01" )

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Endif
	mret = SQLExec(mcon1,"select TabHCMovct.*, nombre , ESP_descripcion " + ;
		" from especialid ,TabHCMovct "+;
		" left outer join prestadores on TabHCMovct .hcm_codmed = prestadores.id "+;
		" where hcm_registrac = ?mbusco &mbusco2 and trim(hcm_codesp) = trim(ESP_codesp)" +;
		" " , "mwkmovhist02" )

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Endif
	If Reccount("mwkmovhist01")>0 And Reccount("mwkmovhist02")>0
		Select * From mwkmovhist01;
			union Select * From mwkmovhist02 ;
			into Cursor mwkmovhist11
	Else
		If Reccount("mwkmovhist01")>0
			Select * From mwkmovhist01;
				into Cursor mwkmovhist11
		Else
			Select * From mwkmovhist02;
				into Cursor mwkmovhist11
		Endif
	Endif


Else
	mret = SQLExec(mcon1,"select TabHCMovct.*, nombre , ESP_descripcion " + ;
		" from  especialid,TabHCMovct"+;
		" left outer join prestadores on TabHCMovct.hcm_codmed = prestadores.id "+;
		" where hcm_registrac = ?mbusco &mbusco2 and trim(hcm_codesp) = trim(ESP_codesp)" +;
		" " , "mwkmovhist11" )

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Endif

Endif

Select *,'C/T' As tipo,Space(50) As hcm_retira, nombre As hcm_descMed, ESP_descripcion As hcm_descEsp ;
	, Iif(hcm_origen=0,"ARCH","CONS") As desde ;
	from mwkmovhist11 Where !Isnull(hcm_registrac) ;
	into Cursor mwkmovhist01

mret = SQLExec(mcon1,"select * from TabHCMovst "  + ;
	"where hcm_registrac = ?mbusco " + mbusco2 , "mwkmovhist22" )

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
Endif

Select *,'S/T' As tipo, Iif(hcm_origen=0,"ARCH","CONS") As desde ;
	from mwkmovhist22 Where !Isnull(hcm_registrac) ;
	into Cursor mwkmovhist02

*-------- Arreglo 20110228
lnLen = Len(mwkmovhist01.hcm_descEsp)

Select hcm_fechatur, desde, hcm_descMed, ;
	hcm_fechaingr, tipo, hcm_descEsp, ;
	hcm_retira, hcm_usuario, hcm_codesp, ;
	hcm_codmed ;
	from mwkmovhist01 ;
	union ;
	select hcm_fechatur, desde, hcm_descMed, ;
	hcm_fechaingr, tipo, Left(hcm_descEsp + Space(lnLen), lnLen) As hcm_descEsp, ;
	hcm_retira, hcm_usuario, hcm_codesp, ;
	hcm_codmed ;
	from mwkmovhist02 ;
	into Cursor mwkmovhist1

If Used('mwkmovhist01')
	Use In mwkmovhist01
Endif
If Used('mwkmovhist02')
	Use In mwkmovhist02
Endif
If Used('mwkmovhist11')
	Use In mwkmovhist11
Endif
If Used('mwkmovhist22')
	Use In mwkmovhist22
Endif
