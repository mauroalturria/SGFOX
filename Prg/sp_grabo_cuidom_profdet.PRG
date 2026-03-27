*
* Actualizacion Cuidados Domiciliarios Profesionales Asignados detalle
*
Lparameters mtipo

muser = Alltrim(mwkusuario.idusuario)
mfnul = Ctod("01/01/1900")
mfhoy = sp_busco_fecha_serv('DT')

Do Case
Case mtipo = "A"

	midpro = mwkagendaN.lidprocab
	mfecha = mwkagendaN.lfecha
	mhoras = mwkagendaN.lhora

	mret = SQLExec(mcon1,"insert into TabCuiDomPagend"+;
		"(TPA_idprocab, TPA_fecha, TPA_hora, TPA_pasivado, TPA_usuario, TPA_fecmov)"+;
		" values "+;
		"(?midpro, ?mfecha, ?mhoras, ?mfnul, ?muser, ?mfhoy)")

** Case mtipo = "M"
	**mwkagenda (lfecha, ldia, lhora, lid, lidprocab, lestado);
	
Case mtipo = "B"

	mfnul = sp_busco_fecha_serv('DD')
	mlidp = mwkagendaN.lid

	mret = SQLExec(mcon1,"update TabCuiDomPagend set "+;
		" TPA_pasivado = ?mfnul, TPA_usuario = ?muser, TPA_fecmov = ?mfhoy"+;
		" where id = ?mlidp")

Endcase

If mret  < 0
	mtabla = "C.D. ASIGNACION DE PROFESIONALES - AGENDA DETALLE"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + mtabla + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
