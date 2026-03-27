*
* Lockeo de Registros VP - CRUD
*
Lparameters mtipo, mvale, midusua, mfechor

Local mFecHasta

Do Case
Case mtipo = 'A' && Alta

	mret = SQLExec(mcon1,"insert into TabFarmVPLock (TFV_vale, TFV_usuario, TFV_fecmov) values (?mvale, ?midusua, ?mfechor)")
	If mret < 0
		mltabla = "REGISTRO DE VP TOMADOS PARA CONFECCION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Case mtipo = 'C' && Consulta

	Use In Select("mwklock")
	mret = SQLExec(mcon1,"select * from TabFarmVPLock where TFV_vale = ?mvale","mwklock")
	If mret < 0
		mltabla = "VP REGISTROS LOCKEADOS"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Case mtipo = 'B' && Baja

	mret = SQLExec(mcon1,"delete from TabFarmVPLock where TFV_vale = ?mvale")
	If mret < 0
		mltabla = "UNLOCK DE VP TOMADOS PARA CONFECCION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Case mtipo = "D"  && consulta vales tomados sin preparacion

	mFecHasta = mfechor + 1
	
	mFechor = DTOS(mFecHor)
	mFecHasta = DTOS(mFecHasta)
	
	mFecHor = LEFT(mFecHor,4)+"-"+SUBSTR(mFecHor,5,2)+"-"+ RIGHT(mFecHor,2) + " 00:00:00"
	mFecHasta = LEFT(mFecHasta,4)+"-"+SUBSTR(mFecHasta,5,2)+"-"+ RIGHT(mFecHasta,2) + " 00:00:00"
	
	
*!*		mret = SQLExec(mcon1,"select a.* , b.tve_idpre "+;
*!*			"from TabFarmVPLock As a "+;
*!*			"left join TabFarmVPDetEnt as b on a.TFV_vale = b.TVE_Vale "+;
*!*			"where (a.TFV_fecmov >= ?mfechor And a.TFV_fecmov <= ?mFecHasta) And b.TVE_IdPre = Null ","mwkValTomado")

	mret = SQLExec(mcon1,"select a.* " +;
		"from TabFarmVPLock as a " +;
		"where a.TFV_vale not in (select b.tve_vale from TabFarmVPDetEnt as b ) and (a.TFV_fecmov >= ?mfechor And a.TFV_fecmov <= ?mFecHasta) ","mwkValTomado")

	If mret<=0
		Messagebox("ERROR EN LA LECTURA DE VALES TOMADOS.",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Case mtipo = 'M' && Consulta Multiple Cabecera & Detalle

	Use In Select("mwkctrlvp")

	mret = SQLExec(mcon1,"select * FROM TabFarmVPDet"+;
		" join TabFarmVPCabe on TabFarmVPCabe.ID = TabFarmVPDet.TVD_IdPre and TabFarmVPCabe.TVC_Estado <> 3"+;
		" where TabFarmVPDet.TVD_Vale = ?mvale","mwkctrlvp")

	If mret < 0
		mltabla = "VP CONSULTA EN CABECERA Y DETALLE"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endcase

Return .T.
