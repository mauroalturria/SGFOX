****
** cambio de ps a turno normal
** MOdificado 14/10/03 por claudia Antoniow
****

Parameter mfecha, vr_codesp,vr_tipo,vr_tiponuevo,vr_busca
If Vartype(vr_tipo)<>"N"
	vr_tipo =  5
ENDIF
If Vartype(vr_tiponuevo)<>"N"
	vr_tiponuevo = 0
ENDIF

If Vartype(vr_busca)<>"C"
	vr_busca = ''
ENDIF
mfechoy  = sp_busco_fecha_serv("DD")

mfiltra = " and  fechatur between ?mfechoy  and ?mfecha "+ vr_busca 

mtexto = 'Turnos '+TRANSFORM(vr_tipo)+' del ' + Dtoc(mfecha)
If mxambito >1
	mccpoamb = " and codambito = ?mxambito "
Else
	mccpoamb = ''
Endif
mfechoy = sp_busco_fecha_serv("DD")
If vr_codesp = ''
	mret = SQLExec(mcon1, "select count(tipoturno) as total from turnos " + ;
		"where afiliado <=1  &mccpoamb and tipoturno = " + Transform(vr_tipo)+mfiltra , "mwkveops")


	mret = SQLExec(mcon1, "update turnos set tipoturno  = ?vr_tiponuevo, observa = ?mtexto " + ;
		" where afiliado <=1  &mccpoamb and tipoturno =" + Transform(vr_tipo)+mfiltra)

Else
	mret = SQLExec(mcon1, "select count(tipoturno) as total from turnos " + ;
		" where afiliado<=1 &mccpoamb  and tipoturno =  " + Transform(vr_tipo)+;
		" and fechatur = ?mfecha and codmed in (select codmed "+;
		" From medpresta where codesp = ?vr_codesp "+  mccpoamb +;
		"   group by codmed )", "mwkveops")


	If mret < 0
		mret=0
		Do prg_cancelo
	Else
		mret = SQLExec(mcon1, "update turnos set tipoturno  = ?vr_tiponuevo, observa = ?mtexto " + ;
			" where afiliado<=1 &mccpoamb and tipoturno = " + Transform(vr_tipo)+mfiltra+;
			" and fechatur = ?mfecha and codmed in ( select codmed "+;
			" From medpresta where codesp = ?vr_codesp "+  mccpoamb+;
			" group by codmed )")

	Endif

Endif

