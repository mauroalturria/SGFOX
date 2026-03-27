*
* Actualizo datos del retiro/recepción del estudio, maestro TabValObs
*
Lparameters mcodvax,mcodpun,mfechamod,mlobserv,mlcodigo,mlestado

If Used("mwkauxiprot")
	Use In mwkauxiprot
Endif
musuarioID  = mwkusuario.Id
mret = SQLExec(mcon1,"select * from TabValObs where TVO_codpun=?mcodpun","mwkauxiprot")
If mret > 0
	If Reccount("mwkauxiprot")=0
		mret = SQLExec(mcon1,"insert into TabValObs (TVO_codigovax,TVO_codpun,TVO_fechamov,TVO_obser,TVO_subestado)"+;
		" values (?mcodvax,?mcodpun,?mfechamod,?mlobserv,?mlcodigo)")
	Else
*!*		mobs = mwkauxiprot.TVO_obser+chr(10)+
		mret = SQLExec(mcon1,"update TabValObs set"+;
		" TVO_codigovax=?mcodvax,TVO_fechamov=?mfechamod,"+;
		" TVO_obser=?mlobserv"+;
		" where TVO_codpun=?mcodpun")
	Endif
	If mret < 0
		Messagebox('NO SE GUARDARON LOS DATOS'+Chr(10)+'AVISE A SISTEMAS', 16, 'ERROR')
	Endif
Else
	Messagebox('EN CONSULTA DE OBSERV. DE VALES '+Chr(10)+'AVISE A SISTEMAS', 16, 'ERROR')
Endif
mret = SQLExec(mcon1,"insert into Zabtflog(TFO_codpun , TFO_estado , TFO_fecestado , TFO_obser , TFO_usuarioid)"+;
" values ( ?mcodpun,?mlestado,?mfechamod,?mlobserv,?musuarioID )")
If mret < 0
	Messagebox('NO SE GUARDARON LOS DATOS'+Chr(10)+'AVISE A SISTEMAS', 16, 'ERROR')
Endif
