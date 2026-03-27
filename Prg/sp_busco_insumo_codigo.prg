****************************
* Busco insumos por codigo *
****************************
Lparameters mctexto, mgrupo, mpasivo, mqbus

If Vartype(mqbus) <> "C"
	mqbus = ''
Endif

If Vartype(mgrupo) <> "C"
	mgrupo = " in ('D','O','A','C') "
Endif

If Vartype(mpasivo) <> "N"
	mpasivo = " and ins_fechapasivo is null "
Else
	mpasivo = ""
Endif

If mqbus = 'T'

*!*		mret = SQLExec(mcon1,"SELECT * FROM insumos where "+;
*!*			" INS_codinsumo = ?mctexto "+ mpasivo ,"mwkinsumo")

	mret = SQLExec( mcon1,"SELECT a.*, c.TUPR_codigo " +;
		"FROM " +;
		"insumos as a " +;
		"left join tabmedicamentos as b on a.INS_codpuntero = b.TM_insumo " +;
		"left join tabuniprescripcion as c on b.TM_uniprescripcion = c.ID " +;
		"where "+;
		"INS_codinsumo = ?mctexto "+ mpasivo ,"mwkinsumo")

Else

	mret = SQLExec(mcon1,"SELECT * FROM insumos where ins_grupo "+ mgrupo +;
		" AND INS_codinsumo = ?mctexto "+ mpasivo ,"mwkinsumo")

Endif

If mret < 1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
