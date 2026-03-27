*******
* grabo observaciones de vales
*******
lparameters mopcion,mcodpun,mcodigovax,mcodigomed
midusua = mwkusuario.idusuario
mfecmov = sp_busco_fecha_serv('DT')
do case
	case mopcion = 1
		mret = sqlexec(mcon1," SELECT ID "+;
			" from TabValObs where TVO_Codpun=?mcodpun"+;
			" and TVO_Subestado < 11","mwkvalobs")  && saque esto  and TVO_Subestado >=0 
		if mret < 0
			messagebox("ERROR EN BUSQUEDA, MAESTRO DE VALES OBS/ESTADOS",16,"Validacion")
		else
			if reccount('mwkvalobs') = 0
				msubest = 1
				mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
					"TVO_Fechamov,TVO_SubEstado) "+;
					"values (?mcodigovax,?mcodpun,?mfecmov,?msubest)")
			else
				mid = mwkvalobs.id
				mret = sqlexec(mcon1,"select * from TabValObs where id = ?mid","mwkvalobsm")
	
				msubest = iif(mwkvalobsm.TVO_subestado<10,mwkvalobsm.TVO_subestado+1,10)
				mret = sqlexec(mcon1,"update TabValObs set "+;
					"TVO_Fechamov = ?mfecmov,"+;
					"TVO_Subestado = ?msubest"+;
					" where TVO_Codpun = ?mcodpun and TVO_Subestado < 11")
			endif
		endif

	case mopcion = 2
		mevoluc = "Operador : "+midusua+", "+ttoc(mfecmov)+"- REIMPRESION "
		msubest = 0
		mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
			"TVO_Obser,TVO_Fechamov,TVO_SubEstado) "+;
			"values (?mcodigovax, ?mcodpun, ?mevoluc, ?mfecmov ,?msubest)")

	case mopcion = 3 && Controla si existe
		mret = sqlexec(mcon1," SELECT ID , TVO_Codigovax , TVO_Codmed , TVO_Codpun , TVO_FechaEstudio , "+;
			" TVO_Fechamov , TVO_Obser , TVO_SubEstado "+;
			" from TabValObs where TVO_Codpun=?mcodpun"+;
			" and TVO_Subestado < 11 ","mwkvalobs")
	case mopcion = 4 &&& omite impresion porque ya se habia impreso
		mevoluc = "OMITE IMPRESION"
		msubest = 0
		mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
			"TVO_Obser,TVO_Fechamov,TVO_SubEstado) "+;
			"values (?mcodigovax, ?mcodpun, ?mevoluc, ?mfecmov ,?msubest)")
endcase
if mret < 0
	=aerr(eros)
	messagebox(eros(3)+ "ERROR EN VALES OBS/ESTADOS",48,"Validacion")
	return
endif
