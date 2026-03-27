*
* Grabacion prestaciones profesionales
*
Lparameters mform
mretorno = .T.

With mform

	Dimension vd[4]

	If .ltipo = "A" Or .ltipo = "M"
		vd[1] = .txtfecha.Value
		vd[2] = .txtprestacion.Value
		vd[3] = .txtcantidad.Value
		vd[4] = .txtvalor.Value
	Else
		mlid  = .lidreg
	Endif

	muser = mwkusuario.idusuario
	mfhoy = sp_busco_fecha_serv('DT')

	Do Case

	Case .ltipo = "A"

		mpre  = .lidpre
		mfnul = Ctod("01/01/1900")
		mret  = SQLExec(mcon1,"insert into "+;
			"TabCuiDomPreRea (TPR_idprestad,TPR_feccar,TPR_tipopre,TPR_cantidad,"+;
			"TPR_valor,TPR_fecmov,TPR_usuario,TPR_pasivado)"+;
			" values "+;
			"(?mpre, ?vd[1], ?vd[2], ?vd[3], ?vd[4], ?mfhoy, ?muser, ?mfnul)")

	Case .ltipo = "M"

		mlid  = .lidreg
		mret  = SQLExec(mcon1,"UPDATE TabCuiDomPreRea set "+;
			"TPR_feccar   = ?vd[1],"+;
			"TPR_tipopre  = ?vd[2],"+;
			"TPR_cantidad = ?vd[3],"+;
			"TPR_valor    = ?vd[4],"+;
			"TPR_fecmov   = ?mfhoy,"+;
			"TPR_usuario  = ?muser "+;
			"where id = ?mlid")

	Case .ltipo = "B"

		mfpas = sp_busco_fecha_serv('DD')

	Case .ltipo = "R"

		mfpas = Ctod("01/01/1900")

	Endcase

	If .ltipo = "B" Or .ltipo = "R"
	
		mret  = SQLExec(mcon1,"UPDATE TabCuiDomPreRea set "+;
			"TPR_pasivado = ?mfpas,"+;
			"TPR_fecmov   = ?mfhoy,"+;
			"TPR_usuario  = ?muser "+;
			"where id = ?mlid")
	
	Endif

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS PROFESIONAL PRESTACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		mretorno = .F.
	Endif
	Release vd

Endwith
Return mretorno


