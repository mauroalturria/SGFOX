*
* Actualizacion de Observaciones - Estados ( Monitor1 )
*

lparameters mtipmov,mcodigo,mcodpun,mobserv,mfecmov,msubestado,mevoluc,mmed,mfecest

do sp_busco_monitor1_valobs with mcodpun
if mtipmov <3
	mtipmov = iif(reccount('mwkvalobsm') = 0,1,2)
endif
mid = mwkvalobsm.id
do case
	case mtipmov = 1 && Alta
		mret = sqlexec(mcon1,"select id from TabValObs"+;
			" where TVO_Codpun = ?mcodpun and TVO_subestado > 20 and TVO_subestado <> 179","mwkvalobsm")
		if reccount("mwkvalobsm")= 0
			mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
				"TVO_Obser,TVO_Fechamov,TVO_SubEstado,TVO_evolucion,TVO_Codmed, "+;
				"TVO_FechaEstudio ) "+;
				"values (?mcodigo,?mcodpun,?mobserv,?mfecmov,?msubestado,?mevoluc ,?mmed, "+;
				"?mfecest)")
		else
			mtipmov = 2
			mid = mwkvalobsm.id
			mret = sqlexec(mcon1,"select * from TabValObs where id = ?mid","mwkvalobsm")
			mevoluc = alltrim(nvl(mwkvalobsm.TVO_evolucion,'')) +;
				iif(!empty(mwkvalobsm.TVO_evolucion), chr(10),'')+ mevoluc
			mret=sqlexec(mcon1,"update TabValObs set TVO_Obser=?mobserv,TVO_SubEstado=?msubestado,"+;
				"TVO_Fechamov=?mfecmov, TVO_evolucion=?mevoluc, TVO_Codmed = ?mmed, "+;
				"TVO_FechaEstudio= ?mfecest "+;
				"where id =?mid")
		endif
	case mtipmov = 2 && Modifica
		mret = sqlexec(mcon1,"select * from TabValObs where id = ?mid","mwkvalobsm")
		mevoluc = alltrim(nvl(mwkvalobsm.TVO_evolucion,'')) +;
			iif(!empty(mwkvalobsm.TVO_evolucion), chr(10),'')+ mevoluc
		mret=sqlexec(mcon1,"update TabValObs set TVO_Obser=?mobserv,TVO_SubEstado=?msubestado,"+;
			"TVO_Fechamov=?mfecmov, TVO_evolucion=?mevoluc, TVO_Codmed = ?mmed, "+;
			"TVO_FechaEstudio= ?mfecest "+;
			"where id =?mid")
	case mtipmov = 3 && Modifica Observacion
		mret = sqlexec(mcon1,"select * from TabValObs where id = ?mid","mwkvalobsm")
		mevoluc = alltrim(nvl(mwkvalobsm.TVO_evolucion,'')) +;
			iif(!empty(mwkvalobsm.TVO_evolucion), chr(10),'')+ mevoluc
		mret=sqlexec(mcon1,"update TabValObs set TVO_Obser=?mobserv,"+;
			"TVO_Fechamov=?mfecmov, TVO_evolucion=?mevoluc "+;
			"where id =?mid")
	case mtipmov = 4 && graba datos reimpresion de placa
		mret = sqlexec(mcon1,"select * from TabValObs where TVO_Codpun = ?mcodpun and TVO_subestado > 10 and TVO_subestado < 19","mwkvalobsm")
		if reccount("mwkvalobsm")= 0
			mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
				"TVO_Obser,TVO_Fechamov,TVO_SubEstado,TVO_evolucion,TVO_Codmed, "+;
				"TVO_FechaEstudio ) "+;
				"values (?mcodigo,?mcodpun,?mobserv,?mfecmov,?msubestado ,?mevoluc ,?mmed, "+;
				"?mfecest)")
		else
			mid = mwkvalobsm.id
			mevoluc = alltrim(nvl(mwkvalobsm.TVO_evolucion,'')) +;
				iif(!empty(mwkvalobsm.TVO_evolucion), " CV:"+ transf(mwkvalobsm.TVO_Codigovax)+;
				" EAnt: "+transf(mwkvalobsm.TVO_SubEstado) + " - " + ttoc(mwkvalobsm.TVO_Fechamov)+chr(10),'')
			mret=sqlexec(mcon1,"update TabValObs set TVO_Obser=?mobserv,TVO_SubEstado=?msubestado,"+;
				"TVO_Fechamov=?mfecmov, TVO_evolucion=?mevoluc, TVO_Codmed = ?mmed, "+;
				"TVO_FechaEstudio= ?mfecest "+;
				"where id =?mid")
		endif
endcase
if mret < 0
	messagebox("ERROR EN LA GRABACION"+chr(10)+;
		"MAESTRO DE VALES OBS/ESTADOS",48,"Validacion")
	return
endif
