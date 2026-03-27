Lparameters lcHCE,lnest,ctuclave
Local lShowInfhos
Local lOk
Local nUbicacion

Private miURL,cnav

lOk = .F.
cnav = ""

&& PRUEBAS
*lcHCE = "52922/14"
*lcHCE = "529221-4"
*lcHCE = "5292214"
lnest = Iif(Vartype(lnest)#"N",0,lnest)
Do Case
Case Occurs("/",lcHCE) > 0
	lcResu = Alltrim(Strtran(lcHCE,"/",""))
	lnLen = Len(lcResu)
	lcResu = Substr(lcResu,1,lnLen-1) + "-" + Substr(lcResu,lnLen)

Case Occurs("-",lcHCE) > 0
	lcResu = Alltrim(lcHCE)

Otherwise
	lcResu = Alltrim(lcHCE)
	lnLen = Len(lcResu)
	If lnLen>2
		lcResu = Substr(lcResu,1,lnLen-1) + "-" + Substr(lcResu,lnLen)
	Else
		lcResu =''
	Endif

Endcase
If !Used('mwkDatos')
	Do sp_busco_datos
Endif

*Set Step On

** --------------- Nuevo
lShowInfhos = .T.

sp_busco_estados(57, " and tipo = 25", "mwkHabHisPlexus")

** --------------- Seleccionamos el centro medico
nUbicacion = mxambito

If mxambito = 1

	If TYPE("mxcentromedico") = "N" and mxcentromedico = 2
		nUbicacion = 2
	Endif

Endif

** --------------- Recorremos el cursor de TabEstados
If Used("mwkHabHisPlexus")
	Select mwkHabHisPlexus
	Go Top

	Scan All

		If mwkHabHisPlexus.estado = 1 &&And mwkHabHisPlexus.subestado = nUbicacion

			mret = SQLExec(mcon1,"select Reg_TipoDocumento,Reg_numdocumento from Registracio where REG_nrohclinica = ?lcHCE","mwkPlexusInfhos")

			If mret < 0
				Messagebox("ERROR EN LA LECTURA DE PACIENTES REGISTRADOS",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				lOk = .F.
			Else

				cnav = ""
				lOk = .T.
				Select mwkPlexusInfhos
				Go Top

				Do Form frmlaboselector With tuclave,mwkPlexusInfhos.Reg_TipoDocumento,mwkPlexusInfhos.Reg_numdocumento,lcResu To lShowInfhos
				Exit

			Endif
		Endif

		Select mwkHabHisPlexus

	Endscan

	Use In Select("mwkHabHisPlexus")
Endif

* --------------------------- Viene usando el His, en caso de que no esté habilitado Plexus
* --------------------------- Marcelo Torres, 06/01/2024. Soporte para PDF Infhos. En caso de no estar habilitado, viene por aquí. 
If !lOk .Or. lShowInfhos

	Do sp_busco_estados With 7, 'and tipo = 98 order by estado ',"mwkacclabo"
	Select mwkacclabo
	Go Top
	lnuevo = .F.
	newurl=''
	ltodos = .T.

	Scan
		If estado = 0
			lnuevo = Alltrim(mwkexe.nomexe)$Alltrim(mwkacclabo.Descrip)
			ltodos = .F.
		Else
			newurl = newurl+Alltrim(Descrip)
		Endif
	Endscan

	If lnuevo  Or ltodos
		miURL = Alltrim(newurl )
	Else
		miURL = Alltrim(Iif(Type('mwkDatos.URLLab')="U","http://172.16.1.248/CSP/LABCSP/pedidosini.csp",mwkDatos.URLLab))
	Endif
	cnav = Alltrim(miURL)+"?usuario="+ctuclave+Iif(Len(lcHCE)>2,"&historia="+Alltrim(lcResu)+;
		"&pacverif="+Iif(lnest = 0,"N","S"),"")

Endif

Return cnav


** --------------- Anterior
*!*	Do sp_busco_estados With 7, 'and tipo = 98 order by estado ',"mwkacclabo"
*!*	Select mwkacclabo
*!*	Go Top
*!*	lnuevo = .F.
*!*	newurl=''
*!*	ltodos = .T.

*!*	Scan
*!*		If estado = 0
*!*			lnuevo = Alltrim(mwkexe.nomexe)$Alltrim(mwkacclabo.Descrip)
*!*			ltodos = .F.
*!*		Else
*!*			newurl = newurl+Alltrim(Descrip)
*!*		Endif
*!*	Endscan

*!*	If lnuevo  Or ltodos
*!*		miURL = Alltrim(newurl )
*!*	Else
*!*		miURL = Alltrim(Iif(Type('mwkDatos.URLLab')="U","http://172.16.1.248/CSP/LABCSP/pedidosini.csp",mwkDatos.URLLab))
*!*	Endif
*!*	cnav = Alltrim(miURL)+"?usuario="+ctuclave+Iif(Len(lcHCE)>2,"&historia="+Alltrim(lcResu)+;
*!*		"&pacverif="+Iif(lnest = 0,"N","S"),"")

*!*	Return cnav
