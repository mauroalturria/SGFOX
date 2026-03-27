*
* Actualizacion Maestros Cabecera/Detalle Recepcion de Materiales
*

If used("mwkcabeact")
	Select mwkcabeact
	Go Top
	Scan all
		md1 = mwkcabeact.cnr_stamp
		md2 = mwkcabeact.cnr_stkstamp
		md3 = mwkcabeact.cnr_stkerror
		md4 = mwkcabeact.cnr_stkerrds
		md5 = mwkcabeact.cnr_transtk
		mid = mwkcabeact.lid

		mret = sqlexec(mcon1,"update TabMovCab set TMC_fecini = ?md1,	TMC_fechas = ?md2,"+;
			" TMC_cerror = ?md3, TMC_errds = ?md4, TMC_transacc = ?md5"+;
			" where id = ?mid")

		If mret < 0
			Messagebox("ERROR EN ACTUALIZACION DE MOVIMIENTO DE RECEPCION CABECERA",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
		
*!*     Ctrl. de Error ocurrido, al interactuar c/funciones Silvia

		If Len(alltrim(md5)) = 0

			msgerr = "CONFORME: " + Alltrim(Str(mid)) + Chr(10) +;
				"ERROR: " + Alltrim(Str(md3)) + " - " + Alltrim(md4) + Chr(10) +;
				"AVISE A SISTEMAS"

			Messagebox(	msgerr, 16, "ERROR")
		Endif

	Endscan
Endif

If used("mwkdetaact")
	Select mwkdetaact
	Scan all
		md1 = mwkdetaact.cnrd_stamp
		md2 = mwkdetaact.cnrd_stkstamp
		md3 = mwkdetaact.cnrd_stkerror
		md4 = mwkdetaact.cnrd_stkerrds
		mid = mwkdetaact.lid

		mret = sqlexec(mcon1,"update TabMovDet set "+;
			"TMD_fecini = ?md1, TMD_fechas = ?md2, TMD_cerror = ?md3, TMD_errds = ?md4"+;
			" where id = ?mid")

		If mret < 0
			Messagebox("ERROR EN ACTUALIZACION DE MOVIMIENTO DE RECEPCION DETALLE",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endscan
Endif

Return .T.
