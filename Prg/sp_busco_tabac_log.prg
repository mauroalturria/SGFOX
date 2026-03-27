Lparameters Pmid,mcursor,mbusco,mfbusco
If Vartype(mcursor)#"C"
	mcursor = "mwkprevobs"
Endif
If Vartype(mbusco)#"C"
	mbusco= ""
Endif
If Vartype(mfbusco)#"C"
	mfbusco= ""
Endif

If Vartype(Pmid)= "N"
	mbusco = "Where APL_IdAutPrev = ?Pmid "
Else
	mbusco = "Where APL_IdAutPrev in ("+Pmid+") "+mbusco
Endif

mRet = SQLExec(mcon1,"select TabAutPrevLog.*,tabusuario.idusuario,tabusuario.nomape,tabestados.descrip"+;
	" from  TabAutPrevLog " + ;
	"left join tabusuario on TabAutPrevLog.APL_Operador  = tabusuario.codigovax " + ;
	"left join tabestados on (TabAutPrevLog.APL_Estado  = tabestados.subestado and tabestados.propietario = 28) " + ;
	mbusco,"mwkobsautp")

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE AUTORIZACIONES ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
******************
mfecpas = Ctod("01/01/1900")
mRet = SQLExec(mcon1, "SELECT CodAmbito, PA_idAutprevia, PA_idPresu,PA_idTabautpre, PA_tipopac"+;
	" FROM  Zabpresuaut  Where PA_idTabautpre in ("+ Transf(Pmid) +")  and PA_fechapas = ?mfecpas ", "mwkPresaut")
If Used("mwkPresaut")
	If Reccount("mwkPresaut")>0
		midpresu  = mwkPresaut.PA_idPresu
		Do sp_busco_detpresu  With midpresu
		If Reccount('mwkDetEstado')>0


			Select * From mwkobsautp Union All Select midpresu As Id, UltEstado As APL_Estado,fecha As APL_FecHora, ;
				midpresu As APL_IdAutPrev,observaciones As APL_Observaciones, codigovax As APL_Operador,idusuario, usuario As nomape;
				,estado As Descrip From mwkDetEstado Into Cursor mwkresultado 

			Select * From mwkresultado &mfbusco Into Cursor &mcursor
		Else
			Select * From mwkobsautp &mfbusco Into Cursor &mcursor
		Endif
	Else
		Select * From mwkobsautp &mfbusco Into Cursor &mcursor
	Endif
Else
	Select * From mwkobsautp &mfbusco Into Cursor &mcursor
Endif
