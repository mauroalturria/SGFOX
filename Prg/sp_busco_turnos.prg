****
**** Utilizado par a la busqueda de turnos
****
Lparameters lsolopasados, tbnoshowmsg

If Type('lsolopasados') # "N"
	lsolopasados = 0
Endif
lsinambito = (Vartype(tbnoshowmsg)="L")
mret = 0
mmes1 = Month(mfecturno)
mano1 = Year(mfecturno)
mfecpas = Ctod('01/01/1900')
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

If Used('mwktope')
	Select mwktope
	Use
Endif

If Used('mwkconta')
	Select mwkconta
	Use
Endif

If Used('mwkveop')
	Select mwkveop
	Use
Endif
*=esc_log("FQ TURNOS TOPE - " + mwktabambito.Ambito)
milinea = 60
mierr = 'spbuscoturno'
mret = SQLExec(mcon1, "select * from turnostopes where codprest = ?mid_presta", "mwkveop")
mret = SQLExec(mcon1, "select tipoturno as ttno,abreviatura,grupo,liberable  from tabtipoturno ", "mwkttdesc")

If !Eof('mwkveop')
	If Val(Transform(mcafiliado)) > 0
		mret = SQLExec(mcon1, "select count(afiliado) as cantid, tope ,sum(confirmado) as pres " + ;
			"from turnos, turnostopes as tt " + ;
			"where &mccpoamb  turnos.codreserva<>'' and turnos.codprest = tt.codprest and " + ;
			"datepart(yy,turnos.fechatur) = ?mano1 and " + ;
			"afiliado = ?mcafiliado and turnos.codprest in " + ;
			"(select codprest from turnostopes " + ;
			"where agrupado in " + ;
			"(select agrupado from turnostopes where codprest = ?mid_presta)) " + ;
			"group by afiliado" , "mwktope1")
		If  mret >=0
			mret = SQLExec(mcon1, "select count(afiliado) as cantid, tope ,sum(confirmado) as pres " + ;
				"from turnoshis, turnostopes as tt " + ;
				"where &mccpoamb  turnoshis.codreserva<>'' and turnoshis.codprest = tt.codprest and " + ;
				"datepart(yy,turnoshis.fechatur) = ?mano1 and " + ;
				"afiliado = ?mcafiliado and turnoshis.codprest in " + ;
				"(select codprest from turnostopes " + ;
				"where agrupado in " + ;
				"(select agrupado from turnostopes where codprest = ?mid_presta)) " + ;
				"group by afiliado", "mwktope2")
		Endif
		If  mret <0
			Select 1 As cantid, 25 as tope,1 As Pres ;
				from mwkusuario Into Cursor mwktope
		Else
			Select * From mwktope1 ;
				union All ;
				select * From mwktope2 ;
				into Cursor mwktope3

			Select Sum(cantid) As cantid, tope,Sum(Pres) As Pres ;
				from mwktope3 Into Cursor mwktope
		Endif
*!*			if mwktope.cantid > 0 and lsolopasados = 0
*!*				mcantidad 	= str(mwktope.cantid, 2)
*!*				mtope		= str(mwktope.tope, 2)
*!*				mensa		= "YA TIENE TOMADOS "  + mcantidad + " TURNOS  - TOPE: " + MTOPE
*!*				messagebox("&mensa", 48,"Validacion")
*!*			else
		If mwktope.cantid > 0 And mwktope.tope >0 && muestro siempre que haya tope xloq saco esto -->> mwktope.cantid > mwktope.tope and
			mcantidad 	= Str(mwktope.cantid, 2)
			mtope		= Str(mwktope.tope, 2)
			mpres		= Str(mwktope.Pres, 2)
			mensa		= "YA TIENE TOMADOS "  + mcantidad + " TURNOS  - TOPE: " + mtope +Chr(13)+;
				" presentes: " +mpres
			Messagebox(mensa, 48,"Validacion")
		Endif

*!*			endif
	Endif

Endif
milinea =61
mier ='sqlpedido'
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
*do prg_cancelo
Else
	If lsolopasados = 0
		Do sql_pedido With tbnoshowmsg
	Endif

*	=esc_log("FIN sql_pedido - " + mwktabambito.Ambito)

	If mid_presta > 0
		mret = SQLExec(mcon1, "select descrip from turnosprepara " + ;
			"where codpres = ?mid_presta and fecbaja = ?mfecpas", "mwkprepara")
	Endif
	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
* do prg_cancelo
	Else
		If Used('mwkturnos')
			Select mwkturnos
			lbcampo = Type("myAmbi") <> 'U'

			msql = "select nombre as medico,PADR(abreviatura,2) as tipoturno,  " + ;
				" left(ttoc(horatur,2), 5) as hora, " + ;
				" fechatur as fecha, " + ;
				" iif(diasem = 2, 'Lun', iif(diasem = 3, 'Mar', " + ;
				" iif(diasem = 4, 'Mie', iif(diasem = 5, 'Jue', " + ;
				" iif(diasem = 6, 'Vie', iif(diasem = 7, 'Sab', 'Dom')))))) as dia,"+;
				" IIF(AT('LIMA',sala)>0,'CL',IIF(AT('CP',sala)>0,'CC','  ')) as cm, " + ;
				" left(ttoc(horadesde,2), 5) as desde,reservados,liberable, " + ;
				" left(ttoc(horahasta,2), 5) as hasta, id, sala, codmed, diasem, fechatur, horatur, codesp, fechagenera " + ;
				iif(lbcampo,", Myambi" , ", mxambito as Myambi") +;
				" from mwkturnos " + ;
				" where  hhmmtur >= hhmmdes and hhmmtur < hhmmhas and " + ;
				" fechatur >= fecvigend and fechatur < fecvigenh " + ;
				" order by fechatur, horatur, medico, tipoturno  into cursor mwkturnos2"
&& IIF(lsinambito,'',iif(lbcampo,", Myambi" , ", mxambito as Myambi")) le saco el sinambito

		Endif

	Endif
Endif
