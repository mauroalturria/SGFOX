*!*	sp_actualizo_Tabquiromate
Parameters tnopcion,mid,mpedido,mcant,mfechacx,mnroreg,midusu,mxmateprovee, mxmateok,mxmateobs,mxproveedor,tcCurDat
If Vartype(tcCurDat)<>"C"
	tcCurDat=''
Endif
If Vartype(mid)<>"N"
	mid = 0
Endif
If Vartype(mnroreg)<>"N"
	mnroreg = Null
Endif
lcSql =''

*!*	mret = SQLExec(mcon1, "select top 1 * from  Tabquiromaterial ","mwkctrqm")
*!*	Select mwkctrqm
*!*	lcSql = ''
*!*	If  Empty(Field('qm_accionesfc'))
*!*		Return
*!*	Else
Do Case
Case tnopcion=1
	cbuscaid = " QM_idAutprevias = ?mid "
Case Inlist(tnopcion,2,3)
	cbuscaid = " QM_idTabautprevias = ?mid "
Case tnopcion=5 &&
	cbuscaid =  " QM_idquiro = ?mid "
Case Inlist(tnopcion,4,6) && actualizo por id
	cbuscaid =  " id = ?mid "
Otherwise
	cbuscaid =  " id = ?mid "
Endcase
mret = SQLExec(mcon1, "select * from  Tabquiromaterial where "+cbuscaid ,"mwkctrqm")
If Vartype(mxproveedor)<>"C"
	mxproveedor = ''
Endif
cactual = ''
If  Vartype(mnroreg)='N'
	cactual = ", QM_Nroregistrac = ?mnroreg "
Endif
tnfechah = sp_busco_fecha_serv("DT")
tnpasivado = Ttod(tnfechah )
If Vartype(midusu)<>"N"
	midusu = Iif( Used('mwkusuarios'),mwkusuarios.Id ,mwkusuario.Id )
Endif
mfecnul = Ctod("01/01/1900")
Do Case
Case tnopcion = 1  &&& internados
	If Reccount("mwkctrqm")= 0
		lcSql = "Insert into Tabquiromaterial" + ;
			" ( QM_accionesFC, QM_cantidadDevFC, QM_cantidadDevQF, QM_cantidadSol,QM_codinsumo,QM_Nroregistrac,QM_materialOK,QM_provistox, "+;
			" QM_codproveedor, QM_fechaAccionFC,QM_fechaCX, QM_fechaDevFC,QM_fechaDevQF, QM_fechaFarma,"+;
			" QM_fecpasiva, QM_idAutprevias,QM_idTabautprevias, QM_idquiro,QM_lote, QM_lugarDev,"+;
			" QM_lugarOrigen, QM_material, QM_proveedor, QM_remito, QM_usuarioIngreso,QM_usuarioAccion, QM_usuarioFarma,QM_vencim)"+;
			" Values " + ;
			" ('' ,0 , 0,?mcant,0,?mnroreg ,0,0,'',?mfecnul,?mfechacx,?mfecnul,?mfecnul,?mfecnul"+;
			",?mfecnul,?mid,0,0,'','',0,?mpedido,?mxproveedor,'',?midusu ,0,0,?mfecnul) "
	Else
	Endif
Case tnopcion = 2	 &&& ambulatorio
	If Reccount("mwkctrqm")= 0
		lcSql = "Insert into Tabquiromaterial" + ;
			" ( QM_accionesFC, QM_cantidadDevFC, QM_cantidadDevQF, QM_cantidadSol,QM_codinsumo,QM_Nroregistrac,QM_materialOK,QM_provistox, "+;
			" QM_codproveedor, QM_fechaAccionFC,QM_fechaCX, QM_fechaDevFC,QM_fechaDevQF, QM_fechaFarma,"+;
			" QM_fecpasiva, QM_idAutprevias,QM_idTabautprevias, QM_idquiro,QM_lote, QM_lugarDev,"+;
			" QM_lugarOrigen, QM_material, QM_proveedor, QM_remito, QM_usuarioAccion, QM_usuarioFarma,QM_vencim)"+;
			" Values " + ;
			" ('' ,0 , 0,?mcant,0,?mnroreg ,0,0,'',?mfecnul,?mfechacx,?mfecnul,?mfecnul,?mfecnul"+;
			",?mfecnul,0,?mid,0,'','',0,?mpedido,?mxproveedor,'',?midusu ,0,?mfecnul) "
	Else
	Endif
Case tnopcion = 3 &&actualiza fecha de cirugia
	midusu = Iif( Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
	lcSql = "Update Tabquiromaterial " + ;
		" Set  FecHorDbUpd = ?tnfechah  ,UserDbAdd = ?midusu,QM_fechaCX = ?mfechacx  " +cactual + ;
		" Where  "+cbuscaid
Case tnopcion = 4 &&da de baja

	lcSql = "Update Tabquiromaterial " + ;
		" Set QM_fecpasiva = ?tnpasivado,FecHorDbUpd = ?tnfechah  ,UserDbAdd = ?midusu  " + ;
		" Where   "+cbuscaid
Case tnopcion = 5	 &&& quirofano
*	If Reccount("mwkctrqm")= 0
	lcSql = "Insert into Tabquiromaterial" + ;
		" ( QM_accionesFC, QM_cantidadDevFC, QM_cantidadDevQF, QM_cantidadSol,QM_codinsumo,QM_Nroregistrac,QM_materialOK,QM_provistox, "+;
		" QM_codproveedor, QM_fechaAccionFC,QM_fechaCX, QM_fechaDevFC,QM_fechaDevQF, QM_fechaFarma,"+;
		" QM_fecpasiva, QM_idAutprevias,QM_idTabautprevias, QM_idquiro,QM_lote, QM_lugarDev,"+;
		" QM_lugarOrigen, QM_material, QM_proveedor, QM_remito, QM_usuarioAccion, QM_usuarioFarma,QM_vencim)"+;
		" Values " + ;
		" ('' ,0 , 0,?mcant,0,?mnroreg ,0,0,'',?mfecnul,?mfechacx,?mfecnul,?mfecnul,?mfecnul"+;
		",?mfecnul,0,0,?mid,'','',0,?mpedido,?mxproveedor,'',?midusu ,0,?mfecnul) "
*!*			Else
*!*			Endif
Case tnopcion = 6 &&actualiza

	lcSql = "Update Tabquiromaterial " + ;
		" Set QM_materialOK = ?mxmateok,QM_provistox = ?mxmateprovee ,QM_accionesFC = ?mxmateobs ,FecHorDbUpd = ?tnfechah  ,UserDbAdd = ?midusu  " + ;
		" Where   "+cbuscaid
Case tnopcion = 7 &&inserta desde cursor
	If !Empty(tcCurDat)
		lcSql = "Insert into Tabquiromaterial" + ;
			" ( QM_accionesFC, QM_cantidadDevFC, QM_cantidadDevQF, QM_cantidadSol,QM_codinsumo,QM_Nroregistrac,QM_materialOK,QM_provistox, "+;
			" QM_codproveedor, QM_fechaAccionFC,QM_fechaCX, QM_fechaDevFC,QM_fechaDevQF, QM_fechaFarma,"+;
			" QM_fecpasiva, QM_idAutprevias,QM_idTabautprevias, QM_idquiro,QM_lote, QM_lugarDev,"+;
			" QM_lugarOrigen, QM_material, QM_proveedor, QM_remito, QM_usuarioAccion, QM_usuarioFarma,QM_vencim)"+;
			" Values " + ;
			" (?&tcCurDat..QM_accionesFC, ?&tcCurDat..QM_cantidadDevFC, ?&tcCurDat..QM_cantidadDevQF, ?&tcCurDat..QM_cantidadSol,?&tcCurDat..QM_codinsumo,?&tcCurDat..QM_Nroregistrac"+;
			",?&tcCurDat..QM_materialOK,?&tcCurDat..QM_provistox, "+;
			" ?&tcCurDat..QM_codproveedor, ?&tcCurDat..QM_fechaAccionFC,?&tcCurDat..QM_fechaCX, ?&tcCurDat..QM_fechaDevFC,?&tcCurDat..QM_fechaDevQF, ?&tcCurDat..QM_fechaFarma,"+;
			" ?mfecnul , ?&tcCurDat..QM_idAutprevias,?&tcCurDat..QM_idTabautprevias, ?&tcCurDat..QM_idquiro,?&tcCurDat..QM_lote, ?&tcCurDat..QM_lugarDev,"+;
			" ?&tcCurDat..QM_lugarOrigen, ?&tcCurDat..QM_material, ?&tcCurDat..QM_proveedor, ?&tcCurDat..QM_remito, ?&tcCurDat..QM_usuarioAccion, ?&tcCurDat..QM_usuarioFarma,?&tcCurDat..QM_vencim)"
	Endif
Case tnopcion = 8 && UPDATE CON CURSOR
	If !Empty(tcCurDat)
		Select (tcCurDat)
		Scan
			mid = Id
			lcSql = "update Tabquiromaterial set " + ;
				"  QM_accionesFC = ?&tcCurDat..QM_accionesFC , QM_cantidadDevFC =?&tcCurDat..QM_cantidadDevFC"+;
				", QM_cantidadDevQF = ?&tcCurDat..QM_cantidadDevQF, QM_cantidadSol =?&tcCurDat..QM_cantidadSol,QM_codinsumo=?&tcCurDat..QM_codinsumo"+;
				", QM_Nroregistrac=?&tcCurDat..QM_Nroregistrac ,QM_provistox= ?&tcCurDat..QM_provistox   "+;
				", QM_codproveedor=?&tcCurDat..QM_codproveedor, QM_fechaAccionFC = ?&tcCurDat..QM_fechaAccionFC,QM_fechaCX = ?&tcCurDat..QM_fechaCX  "+;
				", QM_fechaDevFC = ?&tcCurDat..QM_fechaDevFC,QM_fechaDevQF = ?&tcCurDat..QM_fechaDevQF, QM_fechaFarma= ?&tcCurDat..QM_fechaFarma "+;
				", QM_lote = ?&tcCurDat..QM_lote, QM_lugarDev= ?&tcCurDat..QM_lugarDev "+;
				", QM_lugarOrigen = ?&tcCurDat..QM_lugarOrigen, QM_material= ?&tcCurDat..QM_material , QM_proveedor= ?&tcCurDat..QM_proveedor"+;
				", QM_remito = ?&tcCurDat..QM_remito, QM_usuarioAccion= ?&tcCurDat..QM_usuarioAccion,QM_materialOK  =?&tcCurDat..QM_materialOK "+;
				", QM_usuarioFarma= ?&tcCurDat..QM_usuarioFarma,QM_vencim = ?&tcCurDat..QM_vencim where id = ?mid"

			mret = SQLExec(mcon1,lcSql )
		Endscan
	Endif
Otherwise

Endcase
If !Empty(lcSql)
	mret = SQLExec(mcon1,lcSql  )
	If mret <= 0
		Do log_errores With Error(), Message(), lcSql  ,Transform(tnopcion )+"-"+Transform(mid)+ Program(), Lineno()
		mresp = .F.
		Return .F.
	Endif
Endif
*!*	Endif
