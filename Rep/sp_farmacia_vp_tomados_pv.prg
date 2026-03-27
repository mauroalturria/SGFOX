*
* Farmacia obtención de ID Preparación VP // Estado de la preparación 1= en Preparación 2= Finalizado 3= Cancelado
*
Lparameters mform, mtipo, midpre, mKardex, mExterno

Local lCierraTodo

midusua  = MWKUSUARIO.idusuario
mfechor  = sp_busco_fecha_serv('DT')
mretorno = .F.

If Vartype(midpre) <> "N"
	midpre = 0
Endif

If Vartype(mKardex) <> "N"
	mKardex = 0
Endif

If Vartype(mExterno) <> "N"
	mExterno = 0
Endif


Do Case
Case mtipo = 'A' && Apertura de Nro. de preparación *TVC_FinPre

	If Used("mwkfarm49C")
		If Reccount("mwkfarm49C") > 0

			mret = SQLExec(mcon1,"INSERT INTO TabFarmVPCabe (TVC_usuario, TVC_IniPre, TVC_Estado,TVC_EstadoKar,TVC_EstadoExt) VALUES (?midusua, ?mfechor, 1,?mKardex,?mExterno)")
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

	mret   = SQLExec(mcon1,"select * from TabFarmVPCabe where ID = ?mbusca","mwkFarmVPCabe")

***Set Step On

	Do Case

	Case Empty(mform.pPantalla)  &&Cerramos todo. Llama desde Emergencia (Marcelo Torres, 11/03/2020)

		mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 2, TVC_EstadoKar = 1, TVC_EstadoExt = 1 where ID = ?mbusca")


	Case mform.pPantalla = "E"  &&Externo

		lCierraTodo = .F.

		If Used("mwkDatosK")
			If Reccount("mwkDatosK") > 0
				If mwkFarmVPCabe.TVC_EstadoKar = 1  &&kardex finalizado
					lCierraTodo = .T.
				Endif
			Else  && Externo sin Kardex.
				lCierraTodo = .T.
			Endif
		Endif

		If lCierraTodo
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 2, TVC_EstadoExt = 1, TVC_EstadoKar = 1 where ID = ?mbusca")
		Else
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_EstadoExt = 1 where ID = ?mbusca")
		Endif


	Case mform.pPantalla = "K"  &&Kardex

		lCierraTodo = .F.

		If Used("mwkDatosE")
			If Reccount("mwkDatosE") > 0
				If mwkFarmVPCabe.TVC_EstadoExt = 1  &&kardex finalizado
					lCierraTodo = .T.
				Endif
			Else  && Kardex sin Externo.
				lCierraTodo = .T.
			Endif
		Endif

		If lCierraTodo
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 2, TVC_EstadoKar = 1, TVC_EstadoExt = 1 where ID = ?mbusca")
		Else
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_EstadoKar = 1 where ID = ?mbusca")
		Endif

	Endcase

**mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_FinPre = ?mfechor, TVC_Estado = 2 where ID = ?mbusca")
	If mret < 0
		mltabla = "ACTUALIZACION VP CABECERA de PREPARACION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif   

***  ---- Marcelo Torres, 19/10/2020 - Ahora lo hace en la clase Preparadores.
*!*		mbusca1 = mform.lidpre
*!*		If Used("mwkvpcache")  &&Marcelo Torres, 18/02/2020
*!*			Select mwkvpcache
*!*			Go Top
*!*			Scan All
*!*				mbusca2 = mwkvpcache.vale
*!*				mestado = Iif(mwkvpcache.pide = 0 And mwkvpcache.entrega = 0, "N", Iif(mwkvpcache.pide = mwkvpcache.entrega, "T", "P"))
*!*				mret    = SQLExec(mcon1,"update TabFarmVPDet set TVD_EstEntrega = ?mestado where TVD_IdPre = ?mbusca1 and TVD_Vale = ?mbusca2")
*!*				If mret < 0
*!*					mltabla = "ACTUALIZACION VP DETALLE de PREPARACION"
*!*					Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*					Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*					Return .F.
*!*				Endif
*!*			Endscan
*!*		Endif
	mretorno = .T.

Case mtipo = 'G'   &&Traemos preparaciones activas

**mfechor = mfechor - ((3600*24)*30)
	mfechor = mfechor - ((3600*24)*90)

**SET STEP ON

	Use In Select("mwkconpre")
*!*		mret = SQLExec(mcon1,"select a.id, a.TVC_IniPre,a.TVC_FinPre,a.TVC_Estado, a.TVC_EstadoExt, a.TVC_EstadoKar," +;
*!*			"b.TVE_IdPre,b.TVE_Vale, b.TVE_insumocodigo, b.TVE_Soli, b.TVE_Entrega, b.TVE_TipoEnt, b.TVE_Sector, " +;
*!*			"b.TVE_ObsItem, b.TVE_Estado, NVL(b.TVE_Tipo,'') as TVE_tipo, c.ins_descriinsumo, " +;
*!*			"d.VAL_codvaleasist,d.VAL_fechasolicitud,d.VAL_horasolicitud, "+;
*!*			"d.VAL_URGENCIASERV,d.VAL_codadmision,d.val_codsector,d.VAL_codservvale,d.VAL_cama,d.VAL_habitacion, "+;
*!*			"d.VAL_tipopaciente,d.VAL_nroprotocolo,d.VAL_prestador,d.VAL_codpun,d.VAL_estado,f.Descrip , "+;
*!*			"d.VAL_fechaconforme ,d.VAL_horaconforme, d.VAL_OperadorConforme, " +;
*!*			"d.VAL_fechacargasoli, d.VAL_horacargasolic, d.VAL_Observaciones,d.VAL_medicosolicit, d.VAL_Lugar_Origen " +;
*!*			"from TabFarmVPCabe as a " +;
*!*			"left join TabFarmVPDetEnt as b on a.id = b.TVE_IdPre " +;
*!*			"left join Insumos as c on b.TVE_insumocodigo = c.ins_codinsumo " +;
*!*			"left join valesasist as D on b.TVE_Vale = d.val_codvaleasist " +;
*!*			"left join TabValObs as E on e.TVO_codpun = d.VAL_codpun " +;
*!*			"left join TabEstados as F on f.SubEstado = e.TVO_SubEstado and f.Propietario = 32 " +;
*!*			"left join prestadores as G on g.id = e.TVO_codmed " +;
*!*			"where NVL(a.TVC_Estado,0) < 2 and a.tvc_inipre >= ?mfechor","mwkconpre")

	mret = SQLExec(mcon1,"select a.id, a.TVC_IniPre,a.TVC_FinPre,a.TVC_Estado, a.TVC_EstadoExt, a.TVC_EstadoKar," +;
		"b.TVE_IdPre,b.TVE_Vale, b.TVE_insumocodigo, b.TVE_Soli, b.TVE_Entrega, b.TVE_TipoEnt, b.TVE_Sector, " +;
		"b.TVE_ObsItem, b.TVE_Estado, c.ins_descriinsumo, " +;
		"d.VAL_codvaleasist,d.VAL_fechasolicitud,d.VAL_horasolicitud, "+;
		"d.VAL_URGENCIASERV,d.VAL_codadmision,d.val_codsector,d.VAL_codservvale,d.VAL_cama,d.VAL_habitacion, "+;
		"d.VAL_tipopaciente,d.VAL_nroprotocolo,d.VAL_prestador,d.VAL_codpun,d.VAL_estado,f.Descrip , "+;
		"d.VAL_fechaconforme ,d.VAL_horaconforme, d.VAL_OperadorConforme, " +;
		"d.VAL_fechacargasoli, d.VAL_horacargasolic, d.VAL_Observaciones,d.VAL_medicosolicit, d.VAL_Lugar_Origen, " +;
		"nvl(a.TVC_ImpreExt,0) as TVC_ImpreExt, NVL(a.TVC_impreKar,0) as TVC_impreKar " +;
		"from TabFarmVPCabe as a " +;
		"left join TabFarmVPDetEnt as b on a.id = b.TVE_IdPre " +;
		"left join Insumos as c on b.TVE_insumocodigo = c.ins_codinsumo " +;
		"left join valesasist as D on b.TVE_Vale = d.val_codvaleasist " +;
		"left join TabValObs as E on e.TVO_codpun = d.VAL_codpun " +;
		"left join TabEstados as F on f.SubEstado = e.TVO_SubEstado and f.Propietario = 32 " +;
		"left join prestadores as G on g.id = e.TVO_codmed " +;
		"where (NVL(a.TVC_Estado,0) < 2 and (TVC_Proceso is null or NVL(a.TVC_Proceso,0) = 6)) and a.tvc_inipre >= ?mfechor and " +;
		"(a.tvc_EstadoExt is not null and a.tvc_EstadoKar is not null) ","mwkconpre1")


	If mret < 0
		mltabla = "CONSULTA DE PREPARACION"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Select *, Iif(sp_esExternoKardex_PV(TVE_insumocodigo)="S","E","K") As TVE_tipo ;
		FROM mwkconpre1 ;
		INTO Cursor mwkconpre

	mretorno = .T.

Case mtipo = 'H'  &&Marcelo Torres, 26/02/2020. Asegurarse de que venga midpre

	Select mwkfarm49C
	Go Top
	Scan All

		If Vartype(mwkfarm49C._lvale) = "C"
			mvale = Int(Val(mwkfarm49C._lvale))
		Else
			mvale = Int(mwkfarm49C._lvale)
		Endif

		mret  = SQLExec(mcon1,"insert into TabFarmVPDet (TVD_IdPre, TVD_Vale, TVD_EstEntrega) values (?midpre, ?mvale, '')")
		If mret < 0
			mltabla = "VP Registro del detalle de Preparación"
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif
	Endscan

	mretorno = .T.

Case mtipo = 'P'   && Marcelo Torres, 03/08/2020. Marca de Tickets impresos

	mbusca = midpre

	mret   = SQLExec(mcon1,"select * from TabFarmVPCabe where ID = ?mbusca","mwkFarmVPCabe")
	If mret < 0
		mltabla = "Consulta de Impresión de Tickets - CABECERA"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Go Top In "mwkFarmVPCabe"

	Do Case
	Case mKardex = 1  &&Kardex
		If NVL(mwkFarmVPCabe.TVC_ImpreKar,0) = 0
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_ImpreKar = 1 where ID = ?mbusca")
		Endif
	Case mExterno = 2  &&Externo
		If NVL(mwkFarmVPCabe.TVC_ImpreExt,0) = 0
			mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_ImpreExt = 1 where ID = ?mbusca")
		Endif
	Endcase

	If mret < 0
		mltabla = "GRABACION ESTADO - CABECERA " + Iif(mKardex = 1, "KARDEX","EXTERNO")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Case mtipo = "Q"

**mform, mtipo, midpre
	mbusca = midpre
	mProceso = mform.pProceso
	mret   = SQLExec(mcon1,"update TabFarmVPCabe set TVC_Proceso = ?mProceso where ID = ?mbusca")    
    
	If mret < 0
		mltabla = "GRABACION ESTADO DE PROCESO - CABECERA"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endcase

Use In Select("mwkFarmVPCabe")


Return mretorno
