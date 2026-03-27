*
* Actualizacion Cuidados Domiciliarios Profesionales Asignados cabecera
*
Lparameters mtipo

*SET STEP ON

muser = Alltrim(mwkusuario.idusuario)
mfnul = Ctod("01/01/1900")
mfhoy = sp_busco_fecha_serv('DT')

If mtipo = "A"

	midso = mwkcuidom.lid
	mpres = mwkProAsig.lprofid

	mret = SQLExec(mcon1,"insert into TabCuiDomPasig "+;
		"(TCA_idsolic, TCA_idprofe, TCA_pasivado, TCA_usuario, TCA_fecmov)"+;
		" values "+;
		"(?midso, ?mpres, ?mfnul, ?muser, ?mfhoy)")

	If mret > 0
		Use In Select("mwkidpro")
		mret = SQLExec(mcon1,"select id as lid from TabCuiDomPasig"+;
			" where TCA_usuario = ?muser"+;
			" and TCA_fecmov =?mfhoy"+;
			" and TCA_idprofe = ?mpres","mwkidpro")
	Endif

Else

	mfnul = sp_busco_fecha_serv('DD')
	mlidp = mwkProAsig.lidAsig

	mret = SQLExec(mcon1,"update TabCuiDomPasig set "+;
		" TCA_pasivado = ?mfnul , TCA_usuario = ?muser, TCA_fecmov = ?mfhoy"+;
		" where id = ?mlidp")

Endif

If mret  < 0
	mtabla = "Cuidados Domiciliarios Asignación de Profesionales - Cabecera Agenda"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + mtabla + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
