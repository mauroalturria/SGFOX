Lparameters xmfecha ,xmfechah
*!*	Proceso de generacion transporte diario
*!*	-----------------------------------------------------------
mfecha = xmfecha
mfechah = xmfechah
mfecpas = Ctod("01/01/1900")
For tipolib = 2  To 3
	Do sp_busco_insumos_restringidos With tipolib ,"mwkinslibro"
	Select mwkinslibro
	Scan
		minsu = mwkinslibro.ins_codpuntero
		Wait Windows mwkinslibro.INS_descriinsumo Nowait
		mifechaini = xmfecha -1

		mret = SQLExec(mcon1, "select valesasist.VAL_codpun,VAL_codadmision ,VAL_codvaleasist,val_codsector,"+;
			" VAL_fechasolicitud ,IPR_receta,VAL_medicosolicit,PIA_codinsumo,valesasist.val_fhsolicitud ,Pia_cantsolicitada,"+;
			" CAST(valesasist.VAL_medicosolicit as CHAR(30)) as nombreC,VAL_fechaconforme, VAL_horaconforme "+;
			" from valesasist inner join presinsuvas on valesasist = pia_valesasist " + ;
			" inner join Zabinspsicoreceta on valesasist.VAL_codpun = IPR_valcodpun  "+;
			" where VAL_fechasolicitud >=?mifechaini  and PIA_codinsumo =?minsu  and  " + ;&&and val_codsector<>'EME'
		" val_estado = 3 and VAL_codservvale = 5410 ", "mwktodoins")
		Select * From mwktodoins ;
			WHERE  Pia_cantsolicitada>0  ;
			order By IPR_receta Into Cursor mwkvales  &&&mwkvalbol
		Select mwkvales && mwkvalbol
		Go Top

	mret = SQLExec(mcon1, "SELECT   IPR_insumo, IPR_receta, IPR_tipoEgreso,IPR_valcodpun, FechaHoraConforme,CantConformada   "+;
			" FROM  Zabinspsicoreceta ,Tabinsumosprogramacion,Tabbolsasprogramacion,Tabquirofano     "+;
			" WHERE  Zabinspsicoreceta.IPR_valcodpun = Tabbolsasprogramacion.ID and IPR_insumo = Tabinsumosprogramacion.CodInsumo "+;
			" and   Tabinsumosprogramacion.IdTabBolsasProgramacion = Tabbolsasprogramacion.ID  "+;
			" and  IdTabQuirofano = Tabquirofano.ID and IPR_insumo= ?minsu  AND  FechaHoraConforme>= ?mifechaini "+;
			" ","mwkbolsas01")
		Select * From mwkbolsas01 Where  CantConformada >0 Order By IPR_receta Into Cursor mwkbolsas

		mret = SQLExec(mcon1, "SELECT IPR_insumo, IPR_receta, IPR_tipoEgreso, IPRM_cantidad,IPRM_fecha "+;
			" FROM Zabinspsicoreceta INNER JOIN Zabinspsicorecman ON IPR_valcodpun = Zabinspsicorecman.ID "+;
			" WHERE   IPR_insumo= ?minsu  AND  IPRM_fecha >= ?mifechaini  ","mwkrecman01")
		Select * From mwkrecman01 Order By IPRM_fecha ,IPR_receta Into Cursor mwkrecman

		mret = SQLExec(mcon1, "SELECT ID, IP_cantidad, IP_fecha, IP_insumo, tipoMov FROM Zabinspsico"+;
			" WHERE  IP_insumo= ?minsu and IP_fecpasiva = ?mfecpas and IP_fecha>= ?mfecha  ","mwkingreso")
		Select * From mwkingreso Order By IP_insumo,tipoMov ,IP_fecha Into Cursor mwkingre
		Select * From mwkingre Where tipoMov =-9 Group By IP_insumo,tipoMov Into Cursor mwkulttras

		msaldo = mwkulttras.IP_cantidad

		mifecha = Ttod(mwkulttras.IP_fecha)
		dias = xmfechah - mifecha
		For i= 1 To dias
			midia = mifecha + i
			mdant = midia -1
			Select Sum(Pia_cantsolicitada) As salida,* From mwkvales   Where  val_fechaconforme  = mdant Into Cursor sale
			Select Sum(CantConformada) As salida,* From mwkbolsas Where  Ttod(FechaHoraConforme)  = mdant Into Cursor saleb
			Select Sum(IPRM_cantidad) As salida,* From mwkrecman Where IPRM_fecha  = mdant Into Cursor salerm

			Select Sum(IP_cantidad) As entrada,* From mwkingreso;
				WHERE  Ttod(IP_fecha) = mdant Into Cursor entra  && And tipomov>-1
			transp = entra.entrada -sale.salida-saleb.salida-salerm.salida
			mdet = "Transporte del día:"+Transform(mdant)
			mret = SQLExec(mcon1,"INSERT INTO ZabinsPsico ( IP_Cantidad , IP_Drogueria , IP_Fecha , IP_FecPasiva , IP_Insumo , TipoMov , IP_ValeMSAL ) "+;
				" VALUES ( ?transp ,?mdet ,?midia, ?mfecpas , ?minsu , -9 ,0)")

			mret = SQLExec(mcon1, "SELECT ID, IP_cantidad, IP_fecha, IP_insumo, tipoMov FROM Zabinspsico"+;
				" WHERE  IP_insumo= ?minsu and IP_fecpasiva = ?mfecpas and IP_fecha>= ?mfecha  ","mwkingreso")
			Select * From mwkingreso Order By IP_insumo,tipoMov ,IP_fecha Into Cursor mwkingre
			Select * From mwkingre Where tipoMov =-9 Group By IP_insumo,tipoMov Into Cursor mwkulttras
			*mifecha = Ttod(mwkulttras.IP_fecha)
		Next
		Select mwkinslibro
	Endscan
Next tipolib
