*!*	sp_grabo_tabSolPrac WITH 1,1,mcsolic ,mApv_protocolo ,codigo,cantidad,mApv_registracio ,	LEFT(	mApv_observaciones,50)
Parameters  mopcion,mASPcodestado,mASPcodmed,mASPprotocolo,mASPcodprest,mASPcantidad,mASPnroregistrac,;
	mASPobserva,mASPtipopac,maspid,mfechasol,xmnroorden,mCodTipoMuestra,mcodlado,mzona,mtipoprescripcion,midrubro
If Vartype(xmnroorden  )<>"N"
	xmnroorden  = Val(Transform(mASPprotocolo))
ENDIF
If  xmnroorden  = 0
	xmnroorden  = Val(Transform(mASPprotocolo))
ENDIF
If Vartype(mASPobserva)<>"C"
	mASPobserva= ''
Endif
If Vartype(mzona)<>"C"
	mzona= ''
ENDIF
If Vartype(mtipoprescripcion)<>"N"
	mtipoprescripcion = 3
ENDIF
If Vartype(midrubro)<>"N"
	midrubro = 0
Endif
mfechahora  = sp_busco_fecha_serv("DT")
mASPfechasol = Iif(Vartype(mfechasol)#"D",Ttod(mfechahora ),mfechasol)
If Vartype(mASPnroregistrac) <>"N"
	mASPnroregistrac=0
Endif
mASPobserva =Alltrim(mASPobserva)+ Iif(Empty(mzona),""," - Zona:"+Alltrim(mzona))
If Vartype(mASPcantidad) <>"N"
	mASPcantidad = 1
Endif
If Vartype(mcodlado) <>"N"
	mcodlado = 0
Endif
lcSql = ''
Do Case
Case mopcion = 1
	lcSql = "SELECT * FROM TabSolPract WHERE  ASP_codestado = 1 AND ASP_nroregistrac =?mASPnroregistrac and ASP_codprest = ?mASPcodprest "
	If  Prg_EjecutoSql(lcSql,'mwkctrsol',.F.)
		If Reccount('mwkctrsol')>0
			lcSql = "update TabSolPract set ASP_codestado = 2 "+;
				" where ASP_codprest = ?mASPcodprest and ASP_codestado = 1 AND  ASP_nroregistrac =?mASPnroregistrac "
			If !Prg_EjecutoSql(lcSql,'',.F.)
			Endif
		Endif
	Endif
	lcSql = "Insert into TabSolPract " + ;
		" (ASP_cantidad , ASP_codestado , ASP_codmed , ASP_codprest , ASP_fechasol , ASP_nroregistrac ,"+;
		" ASP_observa , ASP_protocolo,ASP_tipopac,codambito,ASP_nroorden, ASP_codmuestra, ASP_lateralidad, ASP_tipoPrescripcion,ASP_idrubro ) " + ;
		" Values " + ;
		" (?mASPcantidad,  ?mASPcodestado, ?mASPcodmed, ?mASPcodprest, ?mASPfechasol ,"+;
		"  ?mASPnroregistrac, ?mASPobserva,  ?mASPprotocolo, ?mASPtipopac,?mxambito,?xmnroorden, ?mCodTipoMuestra,?mcodlado,?mtipoprescripcion,?midrubro    ) "


Case mopcion = 2 &&baja o descuenta cantidad
	If maspid >0
		lcSql = "update TabSolPract set ASP_codestado = ?mASPcodestado,ASP_cantidad = ?mASPcantidad where id = ?maspid "
	Endif
	If mASPnroregistrac>0
		lcSql = "update TabSolPract set ASP_codestado = ?mASPcodestado,ASP_cantidad = ?mASPcantidad "+;
			" where ASP_codprest = ?mASPcodprest and ASP_nroregistrac =?mASPnroregistrac "
	Endif
Case mopcion = 3 &&actualiza fecha de solicitud
	If maspid >0
		lcSql = "update TabSolPract set ASP_fechasol = ?mASPfechasol   where id = ?maspid "
	Endif
	If mASPnroregistrac>0
		lcSql = "update TabSolPract set ASP_fechasol = ?mASPfechasol  "+;
			" where ASP_codprest = ?mASPcodprest and ASP_nroregistrac =?mASPnroregistrac "
	Endif

Otherwise
	lcSql =''
Endcase
If Empty(lcSql )
	Return .T.
Else
	If !Prg_EjecutoSql(lcSql,'',.F.)
		Return .F.
	Endif
Endif
