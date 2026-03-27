*!*	GRUPO=ID;HC;Fecha;Hora;Tecnico;Grupo;Rh;Genotipo;Du;GenotipoKell
*!*	GRUPO=1025;444444-4;01/09/2015;13:10;Maria;A;+;;-;

*!*  mcon1 = sqlconn("172.16.1.190")
*!*	set step on

lcDir = Alltrim(FILETOSTR("c:\Qepd1a1\Exe\htimport.ini"))
lcDirSel = lcDir + "EH_PacEstudios*.txt"
lnCant = Adir(laFiles, lcDirSel)
lcDirFin = lcDir + "salida\"

If !Directory(lcDirFin)
	Md (lcDirFin)
Endif 

For lnArchi = 1 To lnCant
	If !proc1Archi(lcDir, lafiles(lnArchi,1))
		Messagebox("Archivo " + lcDir + lafiles(lnArchi,1),16,"ERROR")
	Else
		Rename (lcDir + lafiles(lnArchi,1)) To (lcDirFin + lafiles(lnArchi,1))	
	Endif 
Next 

*!*------------------------------------------------------------------------------------------------------------------------------
Function proc1Archi
Parameters tcDir, tcFile
*!*------------------------------------------------------------------------------------------------------------------------------
Create Cursor HTGRUPO (TIPOID c(20), HC c(30), FECHA1 c(20) , HORA1 c(20), TECNICO c(40), ;
	campo1 c(80), campo2 c(80), campo3 c(80), campo4 c(80), campo5 c(80), campo6 c(80), ;
	campo7 c(80), campo8 c(80), campo9 c(80), campo10 c(80), campo11 c(80), campo12 c(80), ;
	campo13 c(80), campo14 c(80), campo15 c(80), campo16 c(80), campo17 c(80), campo18 c(80))

Select HTGRUPO
Append From (tcDir + tcFile) Type Delimited With Character ";"

*Set Step On

Select *, ctot(fecha1 + " " + Padl(Alltrim(hora1),8,"0")) as fechahora, ;
Ctod(fecha1) as fecha, Ttoc(ctot(fecha1 + " " + Padl(Alltrim(hora1),8,"0")),2) as hora ;
From HTGRUPO ;
Where !Empty(HC) ;
Into Cursor HTGRUPO

lbResu = .f.
Do While .T.
	If !Grupo()
		Exit
	Endif
	If !Anticuerpos()
		Exit
	Endif

	If !CoombsDirecta()
		Exit
	Endif

	If !tranfusiones()
		Exit
	Endif
	
	lbResu = .t.
	Exit
Enddo

Return (lbResu)
*!*------------------------------------------------------------------------------------------------------------------------------
Function tranfusiones
*!*------------------------------------------------------------------------------------------------------------------------------

Select * ;
	From HTGRUPO ;
	Where Left(TIPOID,5) = 'TRANS' ;
	Into Cursor mwkScan

Select mwkScan
Scan All

	lnId = Val(Substr(TIPOID,7))
	lcHora = Alltrim(mwkScan.HORA)
*	lcHora = Padl(Alltrim(mwkScan.HORA),5,"0") + ":00"

	lcHC = Alltrim(mwkScan.HC)
	ldFecha = mwkScan.FECHA
	lcTecnico = Alltrim(mwkScan.Tecnico)
	
	lcAux1 = Val(Strtran(Alltrim(mwkScan.campo1),".",","))
	lcAux2 = Val(Strtran(Alltrim(mwkScan.campo2),".",","))
	lcAux3 = Alltrim(mwkScan.campo3)
	lcAux4 = Alltrim(mwkScan.campo4)
	lcAux5 = Alltrim(mwkScan.campo5)
	lcAux6 = Alltrim(mwkScan.campo6)
	lcAux7 = Alltrim(mwkScan.campo7)
	lcAux8 = Alltrim(mwkScan.campo8)
	lcAux9 = Alltrim(mwkScan.campo9)

	lcAux10 = Alltrim(mwkScan.campo10)
	lcAux11 = Alltrim(mwkScan.campo11)
	lcAux12 = Alltrim(mwkScan.campo12)

	TEXT To lcsql Textmerge Noshow Pretext 7
		Select * From TabHTTransfusiones Where HTT_HC = ?Alltrim(mwkScan.HC) And HTT_Fecha = ?mwkScan.FECHA  And HTT_Hora = ?lcHora
	ENDTEXT

	If SQLExec(mcon1,lcSql,"mwkExiste")<=0
		Messagebox("LECTURA",16,"ERROR")
		Return .F.
	Endif

	Select mwkExiste
	If Reccount("mwkExiste") = 0
		TEXT To lcsql Textmerge Noshow Pretext 7
			Insert into TabHTTransfusiones (HTT_IDEXT, HTT_HC, HTT_Fecha, HTT_Hora,
			HTT_Tecnico, HTT_Hto, HTT_Hb, HTT_CaracterTx, HTT_Unidad, HTT_Producto,
			HTT_Volumen, HTT_Irr, HTT_Lav, HTT_Fil,
			HTT_ProfIndica, HTT_ProfRealiza, HTT_Servicio)
			Values (?lnId, ?lcHC , ?ldFecha , ?lcHora,
			?lcTecnico, ?lcAux1 , ?lcAux2, ?lcAux3, ?lcAux4, ?lcAux5,
			?lcAux6, ?lcAux7, ?lcAux8, ?lcAux9,
			?lcAux10, ?lcAux11, ?lcAux12)
		ENDTEXT
	Else
		TEXT To lcsql Textmerge Noshow Pretext 7
			update TabHTTransfusiones Set HTT_IDEXT = ?lnId,
			HTT_HC = ?lcHC,
			HTT_Fecha = ?ldFecha,
			HTT_Hora = ?lcHora,
			HTT_Tecnico = ?lcTecnico,
			HTT_Hto = ?lcAux1,
			HTT_Hb = ?lcAux2,
			HTT_CaracterTx = ?lcAux3,
			HTT_Unidad = ?lcAux4,
			HTT_Producto = ?lcAux5,
			HTT_Volumen = ?lcAux6,
			HTT_Irr = ?lcAux7,
			HTT_Lav = ?lcAux8,
			HTT_Fil = ?lcAux9,
			HTT_ProfIndica = ?lcAux10,
			HTT_ProfRealiza = ?lcAux11,
			HTT_Servicio = ?lcAux12
			Where HTT_HC = ?lcHC And HTT_Fecha = ?ldFecha  And HTT_Hora = ?lcHora
		ENDTEXT
	Endif

	If SQLExec(mcon1,lcSql,"mwkI")<=0
		Messagebox("AL GUARDAR",16,"ERROR")
		Return .F.
	Endif

	Select mwkScan
Endscan
Use In Select("mwkScan")
Use In Select("mwkExiste")

*!*------------------------------------------------------------------------------------------------------------------------------
Function CoombsDirecta
*!*------------------------------------------------------------------------------------------------------------------------------

Select * ;
	From HTGRUPO ;
	Where Left(TIPOID,5) = 'COOMB' ;
	Into Cursor mwkScan

Select mwkScan
Scan All

	lnId = Val(Substr(TIPOID,7))
*	lcHora = Padl(Alltrim(mwkScan.HORA),5,"0") + ":00"
	lcHora = Alltrim(mwkScan.HORA)

	lcHC = Alltrim(mwkScan.HC)
	ldFecha = mwkScan.FECHA
	lcTecnico = Alltrim(mwkScan.Tecnico)

	lcAux1 = Alltrim(mwkScan.campo1)
	lcAux2 = Alltrim(mwkScan.campo2)
	lcAux3 = Alltrim(mwkScan.campo3)
	lcAux4 = Alltrim(mwkScan.campo4)
	lcAux5 = Alltrim(mwkScan.campo5)
	lcAux6 = Alltrim(mwkScan.campo6)
	lcAux7 = Alltrim(mwkScan.campo7)
	lcAux8 = Alltrim(mwkScan.campo8)
	lcAux9 = Alltrim(mwkScan.campo9)

	TEXT To lcsql Textmerge Noshow Pretext 7
		Select * From TabHTCoombsDirecta Where HTC_HC = ?Alltrim(mwkScan.HC) And HTC_Fecha = ?mwkScan.FECHA  And HTC_Hora = ?lcHora
	ENDTEXT

	If SQLExec(mcon1,lcSql,"mwkExiste")<=0
		Messagebox("DE LECTURA",16,"ERROR")
		Return .F.
	Endif

	Select mwkExiste
	If Reccount("mwkExiste") = 0
		TEXT To lcsql Textmerge Noshow Pretext 7
			Insert into TabHTCoombsDirecta (HTC_IDEXT, HTC_HC, HTC_Fecha, HTC_Hora,
			HTC_Tecnico, HTC_Poli, HTC_PoliCC, HTC_IgG, HTC_IgGCC, HTC_C3d,
			HTC_C3dCC, HTC_Igm, HTC_IgmCC, HTC_Observ)
			Values (?lnId, ?lcHC , ?ldFecha , ?lcHora,
			?mwkScan.Tecnico, ?lcAux1 , ?lcAux2, ?lcAux3, ?lcAux4, ?lcAux5,
			?lcAux6, ?lcAux7, ?lcAux8, ?lcAux9)
		ENDTEXT
	Else
		TEXT To lcsql Textmerge Noshow Pretext 7
			update TabHTCoombsDirecta Set HTC_IDEXT = ?lnId,
			HTC_HC = ?lcHC ,
			HTC_Fecha = ?ldFecha,
			HTC_Hora = ?lcHora,
			HTC_Tecnico = ?lcTecnico ,
			HTC_Poli = ?lcAux1,
			HTC_PoliCC = ?lcAux2,
			HTC_IgG = ?lcAux3,
			HTC_IgGCC = ?lcAux4,
			HTC_C3d = ?lcAux5,
			HTC_C3dCC = ?lcAux6,
			HTC_Igm = ?lcAux7,
			HTC_IgmCC = ?lcAux8,
			HTC_Observ = ?lcAux9
			Where HTC_HC = ?lcHC And HTC_Fecha = ?ldFecha And HTC_Hora = ?lcHora
		ENDTEXT
	Endif

	If SQLExec(mcon1,lcSql,"mwkI")<=0
		Messagebox("AL GUARDAR",16,"ERROR")
		Return .F.
	Endif

	Select mwkScan
Endscan
Use In Select("mwkScan")
Use In Select("mwkExiste")

*!*------------------------------------------------------------------------------------------------------------------------------
Function Anticuerpos
*!*------------------------------------------------------------------------------------------------------------------------------
Select * ;
	From HTGRUPO ;
	Where Left(TIPOID,5) = 'ANTIC' ;
	Into Cursor mwkScan

Select mwkScan
Scan All

	lnId = Val(Substr(TIPOID,7))
*	lcHora = Padl(Alltrim(mwkScan.HORA),5,"0") + ":00"
	lcHora = Alltrim(mwkScan.HORA)

	lcHC = Alltrim(mwkScan.HC)
	ldFecha = mwkScan.FECHA
	lcTecnico = Alltrim(mwkScan.Tecnico)

	lcAux1 = Alltrim(mwkScan.campo1)
	lcAux2 = Alltrim(mwkScan.campo2)
	lcAux3 = Alltrim(mwkScan.campo3)
	lcAux4 = Alltrim(mwkScan.campo4)
	lcAux5 = Alltrim(mwkScan.campo5)

	TEXT To lcsql Textmerge Noshow Pretext 7
		Select * From TabHTAnticuerpos Where HTA_HC = ?Alltrim(mwkScan.HC) And HTA_Fecha = ?mwkScan.FECHA  And HTA_Hora = ?lcHora
	ENDTEXT

	If SQLExec(mcon1,lcSql,"mwkExiste")<=0
		Messagebox("DE LECTURA",16,"ERROR")
		Return .F.
	Endif

	Select mwkExiste
	If Reccount("mwkExiste") = 0
		TEXT To lcsql Textmerge Noshow Pretext 7
			Insert into TabHTAnticuerpos (HTA_IDEXT, HTA_HC, HTA_Fecha, HTA_Hora,
			HTA_Tecnico, HTA_Ant, HTA_Ant1, HTA_Ant2, HTA_Ant3, HTA_Obs)
			Values (?lnId, ?lcHC  , ?ldFecha , ?lcHora,
			?lcTecnico , ?lcAux1, ?lcAux2, ?lcAux3, ?lcAux4, ?lcAux5)
		ENDTEXT
	Else
		TEXT To lcsql Textmerge Noshow Pretext 7
			update TabHTAnticuerpos Set HTA_IDEXT = ?lnId,
			HTA_HC = ?lcHC,
			HTA_Fecha = ?ldFecha ,
			HTA_Hora = ?lcHora,
			HTA_Tecnico = ?lcTecnico ,
			HTA_Ant = ?lcAux1,
			HTA_Ant1 = ?lcAux2,
			HTA_Ant2 = ?lcAux3,
			HTA_Ant3 = ?lcAux4,
			HTA_Obs = ?lcAux5
			Where HTA_HC = ?lcHC  And HTA_Fecha = ?ldFecha And HTA_Hora = ?lcHora
		ENDTEXT
	Endif

	If SQLExec(mcon1,lcSql,"mwkI")<=0
		Messagebox("AL GUARDAR",16,"ERROR")
		Return .F.
	Endif

	Select mwkScan
Endscan
Use In Select("mwkScan")
Use In Select("mwkExiste")
*!*------------------------------------------------------------------------------------------------------------------------------
Function Grupo
*!*------------------------------------------------------------------------------------------------------------------------------
Select * ;
	From HTGRUPO ;
	Where Left(TIPOID,5) = 'GRUPO' ;
	Into Cursor mwkScan

Select mwkScan
Scan All

	lnId = Val(Substr(TIPOID,7))
*	lcHora = Padl(Alltrim(mwkScan.HORA),5,"0") + ":00"
	lcHora = Alltrim(mwkScan.HORA)

	lcGrupo = Alltrim(mwkScan.campo1)
	lcRH = Alltrim(mwkScan.campo2)
	lcGenotipo = Alltrim(mwkScan.campo3)
	lcDu = Alltrim(mwkScan.campo4)
	lcGenotipoKell = Alltrim(mwkScan.campo5)
	
	lcHC = Alltrim(mwkScan.HC)
	ldFecha = mwkScan.FECHA
	lcTecnico = Alltrim(mwkScan.Tecnico)

	lcsql = "Select * From TabHTGrupo Where HTG_HC = ?lcHC And HTG_Fecha = ?ldFecha  And HTG_Hora = ?lcHora"

	If SQLExec(mcon1,lcSql,"mwkExiste")<=0
		Messagebox("DE LECTURA",16,"ERROR")
		Return .F.
	Endif

	Select mwkExiste
	If Reccount("mwkExiste") = 0
		lcsql = "Insert into TabHTGrupo (HTG_IDEXT, HTG_HC, HTG_Fecha, HTG_Hora, " + ;
			" HTG_Tecnico, HTG_Grupo, HTG_Rh, HTG_Genotipo, HTG_Du, HTG_GenotipoKell) " + ;
			" Values (?lnId, ?lcHC  , ?ldFecha  , ?lcHora , " + ;
			" ?lcTecnico, ?lcGrupo, ?lcRH, ?lcGenotipo, ?lcDu, ?lcGenotipoKell  ) "
	Else
		lcsql = "update TabHTGrupo Set HTG_IDEXT = ?lnId, " + ;
			"HTG_HC = ?lcHC , " + ;
			"HTG_Fecha = ?ldFecha , " + ;
			"HTG_Hora = ?lcHora, " + ;
			"HTG_Tecnico = ?lcTecnico, " + ;
			"HTG_Grupo = ?lcGrupo, " + ;
			"HTG_Rh = ?lcRH, " + ;
			"HTG_Genotipo = ?lcGenotipo, " + ;
			"HTG_Du = ?lcDu, " + ;
			"HTG_GenotipoKell = ?lcGenotipoKell " + ;
			"Where HTG_HC = ?lcHC  And HTG_Fecha = ?ldFecha And HTG_Hora = ?lcHora " 
	Endif

	If SQLExec(mcon1,lcSql,"mwkI")<=0
		Messagebox("AL GUARDAR",16,"ERROR")
		Return .F.
	Endif

	Select mwkScan
Endscan
Use In Select("mwkScan")
Use In Select("mwkExiste")


