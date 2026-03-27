*!*	------------------------------------------------------------------------------
*!*	 Actualizacion de tabmensaje
*!*	 HAY MUCHOS DATOS QUE TIENEN QUE ESTAR DEFINIDOS ANTES
*!*	 VER LOS FORMULARIOS frmturno22 o frmturno98
*!*	------------------------------------------------------------------------------
Parameter mcual, mid, mfecha2, mweb, mturnos

mfecha1 = sp_busco_fecha_serv('DT')
mfecha2 = Iif(Empty(mfecha2) Or Isnull(mfecha2), Ctot('01/01/1900'), mfecha2)
musub	= '' && usuario que dio la baja


jj = Int(Len(Alltrim(mtexto))/250)+1
For i = 0 To jj
	clin = "linea" + Padl(i,3,"0")
	Public &clin
Next

maviso = prg_concat(Alltrim(mtexto))



mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif
If Vartype(mweb) # "C"
	mturnos = "N"
Endif
If Vartype(mturnos) # "N"
	mturnos = 1
Endif
mtur = Iif(mturnos = 1,"S","N")

If Vartype(mCodEnt) # "N"
	mCodEnt = 0
Endif

Do Case

	Case mcual = 1
		mret = SQLExec(mcon1,'insert into tabmensaje (codmed, codprest, codespm, fecalta, fecbaja, '+;
			'mensaje, usualta, usubaja, turnos, web, codservm &mcicpoamb)' + ;
			'values(?mcodmed, ?mcodpre, ?mcodesp, ?mfecha1, ?mfecha2, '+;
			   maviso + ' , trim(?midusu), ?musub, ?mtur, ?mweb, ?mncodserv &mvicpoamb )')


	Case mcual = 2
		mret = SQLExec(mcon1,'update tabmensaje ' + ;
			'set mensaje = ' + maviso + ' , usualta = ?midusu, fecalta = ?mfecha1, fecbaja = ?mfecha2, ' + ;
			'turnos = ?mtur, web = ?mweb '+;
			'where id = ?mid')

	Case mcual = 3
		mret = SQLExec(mcon1,'update tabmensaje ' + ;
			'set usubaja = ?midusu, fecbaja = ?mfecha1 ' + ;
			'where id = ?mid')

Endcase

If mret < 0
	Messagebox('ERROR EN LA ACTUALIZACION DE MENSAJES, AVISE EN SISTEMAS',16,'VALIDACION')
	Cancel
Endif
