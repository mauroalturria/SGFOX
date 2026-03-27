*
* Informe de Prestaciones.
*
Lparameters mdesde, mhasta, mlista

If Vartype(mdesde) <> "D"
	mdesde = sp_busco_fecha_serv("DD")
Endif

If Vartype(mhasta) <> "D"
	mhasta = sp_busco_fecha_serv("DD")
Endif

If Vartype(mlista) <> "N"
	mlista = 0
Endif

mfnull = Ctod("01/01/1900")

*!*	mwhere = " and TCP_desde >= ?mdesde"

*!*	If mlista = 1 && Finalizado
*!*		mfhoy  = sp_busco_fecha_serv("DD")
*!*		mwhere = mwhere + " and TCP_hasta <= ?mfhoy "
*!*	Else
*!*		mwhere = mwhere + " and TCP_hasta <= ?mhasta "
*!*	ENDIF

*!*	mwhere = mwhere + " and TCP_cantidad > 0 "

If mlista = 1 && Finalizado
*   and TCP_cantidad > 0 
	mfhoy  = sp_busco_fecha_serv("DD")
	mwhere = " and TCP_desde >= ?mdesde and TCP_hasta <= ?mfhoy "
ELSE
	mwhere = " and TCP_desde >= ?mdesde and TCP_hasta <= ?mhasta "
Endif

Use In Select("mwkinfo")

*!*	TCS_estado=1,"SOLICITADO   "
*!*	TCS_estado=2,"ACTIVO       "
*!*	TCS_estado=3,"PENDIENTE    "
*!*	TCS_estado=4,"REINTERNACION"
*!*	TCS_estado=5,"OBITO        "
*!*	TCS_estado=6,"FINALIZADO   "
*!*	TCS_estado=7,"ANULADO      ","SOLICITADO   "

*Set Step On

nfnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"SELECT TCP_idsolic, TCP_desde, TCP_hasta, TCS_nroregistrac->REG_nombrepac as paciente,"+;
	" tabestados.descrip as prestacion, TCP_otrapre, TCP_cantidad,"+;
	" TCP_frecuencia,TCP_observa,TCP_idprest,TCS_estado,"+;
	" preregistra.nombre as lnombre, TabCuiDomSoli.TCS_entidad, TabCDPresta.TCP_ImpoPre, ENT_descrient"+;
	" from TabCuiDomPres"+;
	" join TabCuiDomSoli on TabCuiDomSoli.id = TabCuiDomPres.TCP_idsolic and TCS_estado in(1,2,3,4)"+;
	" join tabestados on propietario=5 and estado=1 and tipo=0 and subestado = TCP_idprest"+;
	" left join entidades on entidades.ENT_codent = TabCuiDomSoli.TCS_entidad"+;
	" left join preregistra on preregistra.id =  TabCuiDomSoli.TCS_nroregistrac "+;
	" left join TabCDPresta on TabCDPresta.TCP_CodEnt = TabCuiDomSoli.TCS_entidad "+;
	" and TabCDPresta.TCP_CodPre = TabCuiDomPres.TCP_idprest and TabCDPresta.TCP_pasivado = ?mfnull"+;
	" where TabCuiDomPres.TCP_pasivado = ?mfnull" + mwhere + " order by TCP_idsolic","mwkinfo")
	
*	" left join TabCDPresta on TabCDPresta.TCP_CodEnt = 876 "+;	
	
*	" left join TabCDPresta on TabCDPresta.TCP_CodEnt = TabCuiDomSoli.TCS_entidad "+;

*!*	mret = SQLExec(mcon1,"SELECT TCP_idsolic, TCP_desde, TCP_hasta, TCS_nroregistrac->REG_nombrepac as paciente,"+;
*!*		" tabestados.descrip as prestacion, TCP_otrapre, TCP_cantidad,"+;
*!*		" TCP_frecuencia,TCP_observa,TCP_idprest,TCS_estado,"+;
*!*		" preregistra.nombre as lnombre, TabCuiDomSoli.TCS_entidad, TabCDPresta.TCP_ImpoPre, ENT_descrient"+;
*!*		" from TabCuiDomPres"+;
*!*		" join TabCuiDomSoli on TabCuiDomSoli.id = TabCuiDomPres.TCP_idsolic and TCS_estado in(1,2,3,4,5,6)"+;
*!*		" join tabestados on propietario=5 and estado=1 and tipo=0 and subestado = TCP_idprest"+;
*!*		" left join entidades on entidades.ENT_codent = TabCuiDomSoli.TCS_entidad"+;
*!*		" left join preregistra on preregistra.id =  TabCuiDomSoli.TCS_nroregistrac "+;
*!*		" left join TabCDPresta on TabCDPresta.TCP_CodEnt = TabCuiDomSoli.TCS_entidad "+;
*!*		" and TabCDPresta.TCP_CodPre = TabCuiDomPres.TCP_idprest and TabCDPresta.TCP_pasivado = ?mfnull"+;
*!*		" where TabCuiDomPres.TCP_pasivado = ?mfnull" + mwhere + " order by TCP_idsolic","mwkinfo")

* 	" left join TabCDPresta on TabCDPresta.TCP_CodEnt = 876 "+;
*!*		" left join TabCDPresta on TabCDPresta.TCP_CodEnt = TabCuiDomSoli.TCS_entidad "+;


If mret  < 0
	MTABLA = "CONSULTA DE CUIDADOS DOMICILIARIOS PRESTACIONES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select TCP_idsolic, TCP_desde, TCP_hasta, Iif(Isnull(paciente), lnombre, paciente) As paciente, prestacion,;
	TCP_otrapre, TCP_cantidad, TCP_frecuencia, TCP_observa, TCP_idprest, TCS_estado, ;
	TCS_entidad, Nvl(TCP_ImpoPre,0000.00) As limporte, ENT_descrient ;
	FROM mwkinfo ;
	INTO Cursor mwkinfo

Return .T.
