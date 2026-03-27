*
* Farmacia obtención de ID Preparación VP // Estado de la preparación 1= en Preparación 2= Finalizado 3= Cancelado
*
Lparameters mform, mtipo, midpre

midusua  = MWKUSUARIO.idusuario
mfechor  = sp_busco_fecha_serv('DT')
mretorno = .F.

If Vartype(midpre) <> "N"
	midpre = 0
Endif

Do Case
Case mtipo = 'A' && Apertura de Nro. de preparación *TVC_FinPre

	If Used("mwkfarm49C")
		If Reccount("mwkfarm49C") > 0

			mret = SQLExec(mcon1,"INSERT INTO TabFarmVPCabe (TVC_usuario, TVC_IniPre, TVC_Estado) VALUES (?midusua, ?mfechor, 1)")
			If mret < 0
				mltabla = "VP Preparación registro"
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif

			Use In Select("mwkidpre")
			mret = SQLExec(mcon1,"select * from TabFarmVPCabe where TVC_usuario = ?midusua and TVC_IniPre = ?mfechor and TVC_Estado=1","mwkidpre")
			If mret < 0
				mltabla = "VP Preparación consulta de Identificador "
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif

			If Used("mwkidpre")
				If Reccount("mwkidpre") > 0
					midpre = mwkidpre.Id
				Endif
			Endif
			Use In Select("mwkidpre")

			If midpre = 0
				Return .F.
			Endif

			Select mwkfarm49C
			Go Top
			Scan All
				mvale = Int(Val(mwkfarm49C._lvale))
				mret  = SQLExec(mcon1,"insert into TabFarmVPDet (TVD_IdPre, TVD_Vale, TVD_EstEntrega) values (?midpre, ?mvale, '')")
				If mret < 0
					mltabla = "VP Registro del detalle de Preparación"
					Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif
			Endscan
			mform.lidpre = midpre
			mretorno = .T.

		Endif
	Endif

Case mtipo = 'C' && Consulta Preparacion

	Use In Select("mwkconpre")
	mret = SQLExec(mcon1,"select * from TabFarmVPCabe where ID = ?midpre","mwkconpre")

	If mret < 0
		mltabla = "CONSULTA DE PREPARACION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
	mretorno = .T.

Case mtipo = 'B' && Baja de Preparacion

	mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 3 where ID = ?midpre")
	If mret < 0
		mltabla = "ACTUALIZACION VP CABECERA de PREPARACION -CANCELACION-"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	mret   = SQLExec(mcon1,"update TabFarmVPDet set TVD_EstEntrega = 'N' where TVD_IdPre = ?midpre")
	If mret < 0
		mltabla = "ACTUALIZACION VP DETALLE de PREPARACION -CANCELACION-"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
	mretorno = .T.

Case mtipo = 'F' && Finaliza Preparacion

	mbusca = mform.lidpre
	mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 2 where ID = ?mbusca")
	If mret < 0
		mltabla = "ACTUALIZACION VP CABECERA de PREPARACION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	mbusca1 = mform.lidpre
	Select mwkvpcache
	Go Top
	Scan All
		mbusca2 = mwkvpcache.vale
		mestado = Iif(mwkvpcache.pide = 0 And mwkvpcache.entrega = 0, "N", Iif(mwkvpcache.pide = mwkvpcache.entrega, "T", "P"))
		mret    = SQLExec(mcon1,"update TabFarmVPDet set TVD_EstEntrega = ?mestado where TVD_IdPre = ?mbusca1 and TVD_Vale = ?mbusca2")
		If mret < 0
			mltabla = "ACTUALIZACION VP DETALLE de PREPARACION"
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif
	Endscan
	mretorno = .T.

Endcase

Return mretorno
