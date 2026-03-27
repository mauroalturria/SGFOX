Parameters ptipoTurno,phoraH,phoraD,mfecdes,mfechas,mcodmed,mcambio,mbuscad

If mxambito >1
	mccpoamb = " codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
If Vartype(mbuscad )<>"C"
	mbuscad =''
Endif
ptipoTurno = Iif(Empty(ptipoTurno),"",ptipoTurno)
mret = SQLExec(mcon1,"update turnos set tipoturno = ?mcambio  where &mccpoamb hhmmTur >= ?phoraD and hhmmTur <= ?phoraH " +;
	" and fechatur >= ?mfecdes and fechatur <= ?mfechas and codmed = ?mcodmed  " + ptipoTurno + mbuscad )

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_turno_generados2'
	Cancel
Endif
