*
* Grabación Dispensa Insumos Oncológicos / Trazabilidad
*
Dimension vd[8]

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

Select mwktragtin
*Go Top
*Scan All

	vd[1] = Alltrim(mwktragtin.ldispof)
	vd[2] = mwktragtin.ltrazado
	vd[3] = Alltrim(mwktragtin.lgtin)
	vd[4] = Alltrim(mwktragtin.lserie)
	vd[5] = Ctot(mwktragtin.ldisdes)
	vd[6] = Ctot(mwktragtin.ldishas)
	vd[7] = Alltrim(mwktragtin.lobser)
	vd[8] = Alltrim(mwktragtin.lenfer)

	mret = SQLExec(mcon1,"INSERT INTO TabTraLogDis (TLD_nropof, TLD_Tipo, TLD_gtin, TLD_serie, TLD_transcod, TLD_fecinid, "+;
		"TLD_fecfind, TLD_observa,TLD_usuario, TLD_fecmov, TLD_enfer)"+;
		" values "+;
		"(?vd[1], ?vd[2], ?vd[3], ?vd[4], 0, ?vd[5], ?vd[6], ?vd[7], ?muse, ?mfec, ?vd[8])")

	If mret < 0
		MTABLA = "LOG DISPENSA/TRAZABILIDAD DE INSUMOS HDO"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

*Endscan

Release vd
Return .T.
