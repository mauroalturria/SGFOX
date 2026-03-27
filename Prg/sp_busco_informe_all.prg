**** Busco log de informes en un rango de fechas
Lparameters mFechades,mFechahas,mopcion,mwhere
mcfechad = prg_dtoc(mFechades)
mcfechah = prg_dtoc(mFechahas)
Do Case
Case mopcion = 1
	** AGREGADO POR SOLER MAURO , 10/12/2014
	If At("Cod",mwhere) > 0
		mwhere1 = Stuff(mwhere,At("Cod",mwhere) ,0,"a.")
		mwhere1 = Stuff(mwhere1,At("Tipo",mwhere1),0,"a.")
	Else
		If At("Tipo",mwhere) > 0
			mwhere1 = Stuff(mwhere,At("Tipo",mwhere),0,"a.")
		Endif
	Endif

	mret = SQLExec(mcon1,"select a.nroprotocolo,a.nrovale,Informeslog.Usuario,Fechalog, "+;
		" tabestados.descrip, idusuario, IdInforme,"+;
		" a.FechaAprobacion,a.FechaInforme, a.FechaRecepcion, " +;
		" max(TipoLog) as TipoLog ,SER_descripserv,prestadores.nombre as profesional " +;
		" from informes a"+;
		" inner join informes b  on a.nrovale  = b.nrovale "+;
		" inner join Servicios   on Servicios.SER_codserv = a.CodServVale "+;
		" inner join Informeslog on IdInforme = a.ID "+;
		" inner join tabestados  on TipoLog = tabestados.estado and propietario = 10  "+;
		" inner join tabusuario  on tabusuario.codigovax = Informeslog.Usuario " +;
		" INNER join prestadores on  a.CODMEDFIRMA = prestadores.id " +;
		" where a.fechainforme <= b.fechainforme "+;
		" and a.fechainforme between ?mcfechad  and ?mcfechah "+;
		"" + mwhere1+;
		" group by a.nrovale"+;
		" having {fn month(min(a.fechainforme))} = {fn month(b.fechainforme)}"+;
		" order by a.nrovale asc","mwkinfominimo")
	If mret < 0
				=Aerror(eros)
					Messagebox(eros(3))
		Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "VALIDACION")
	*	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	If Reccount('mwkinfominimo') <= 0
		Messagebox("NO HAY DATOS" ,64,"SISTEMAS")
		Return .F.
	Endif

	Create Cursor mwkvalrelacmin(nrovaleoriginal Int,nrovalerelacionado Int)

	Select mwkinfominimo
	Go Top
	Scan All
		lnproto  = ' '
		lnproto1 = ' '
		mproto   = Alltrim(Str( mwkinfominimo.nrovale))
		lnproto  = lnproto  + Iif(Empty(lnproto) ," and  nrovaleoriginal    in( " + mproto,',' + mproto)
		lnproto  = lnproto + ')'
		lnproto1 = lnproto1 + Iif(Empty(lnproto1 ) ," or nrovalerelacionado    in( " + mproto,',' + mproto)
		lnproto1 = lnproto1+  ')'
		mret = SQLExec(mcon1,"SELECT nrovaleoriginal,nrovalerelacionado "+;
			" from TabValeRelacion "+;
			" where  fecpasiva = '1900-01-01' " + lnproto +  lnproto1  ,"mwkvalrelacminaux")
		If mret < 0
			*!*				=Aerror(eros)
			*!*				Messagebox(eros(3))
			Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "VALIDACION")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkvalrelacmin
		Append From Dbf("mwkvalrelacminaux")
		Use In mwkvalrelacminaux

	Endscan

	If Reccount('mwkvalrelacmin') > 0
		Select * From mwkinfominimo;
			left Join mwkvalrelacmin On nrovaleoriginal = nrovale Or nrovalerelacionado = nrovale;
			into Cursor mwkinfominimo2

		Use In mwkinfominimo

		Select * From mwkinfominimo2;
			INTO Cursor mwkinfominimo3

		Select mwkinfominimo2
		Go Top
		Scan For !Isnull(mwkinfominimo2.nrovaleoriginal)
			lnvalori = nrovaleoriginal
			lnvalrel = nrovalerelacionado
			lnvale   =   nrovale
			lcproto  = nroprotocolo
			Use Dbf('mwkinfominimo3') In 0 Again Alias mwkinfominimo3aux
			If lnvale = lnvalori
				Insert Into mwkinfominimo3aux (nroprotocolo,nrovale) Values (lcproto,lnvalrel)
			Else
				Insert Into mwkinfominimo3aux (nroprotocolo,nrovale) Values (lcproto,lnvalori)
			Endif

			Select * From mwkinfominimo3aux;
				INTO Cursor mwkinfominimo3
			Use In mwkinfominimo3aux
		Endscan

		Select * From mwkinfominimo3;
			GROUP By nrovale,nroprotocolo ;
			ORDER By nroprotocolo Asc;
			INTO Cursor mwkinfominimo

		Use In mwkinfominimo3
		Use In mwkinfominimo2
	Endif

	Use In mwkvalrelacmin
	lnflag = 0

	Select mwkinfominimo
	Go Top
	Scan All
		mproto  = Alltrim(Str(mwkinfominimo.nrovale))
		*!*			mret = SQLExec(mcon1,"Select val_codvaleasist as vale,Informeslog.Usuario, NroProtocolo,Fechalog,"+;
		*!*				" tabestados.descrip, idusuario, IdInforme,"+;
		*!*				" SER_descripserv, Val_FechaSolicitud as FechaVale, "+;
		*!*				" Informes.FechaAprobacion,Informes.FechaInforme, Informes.FechaRecepcion, " +;
		*!*				" max(TipoLog) as TipoLog " +;
		*!*				" FROM ValesAsist " +;
		*!*				" left  join Informes   on  Informes.CodPun = ValesAsist.VAL_CODPUN "+;
		*!*				" left  join Servicios on Servicios.SER_codserv = Informes.CodServVale "+;
		*!*				" left  join Informeslog on IdInforme = Informes.ID "+;
		*!*				" left  join tabestados  on TipoLog = tabestados.estado and propietario = 10  "+;
		*!*				" left  join tabusuario on tabusuario.codigovax = Informeslog.Usuario " +;
		*!*				" where val_codvaleasist = ?mproto" +;
		*!*				" group by ValesAsist.val_codvaleasist "+;
		*!*				" order by val_codvaleasist asc","mwkinfoaux")

		mret = SQLExec(mcon1,"Select val_codvaleasist as vale, Val_FechaSolicitud as FechaVale "+;
			" FROM ValesAsist " +;
			" where val_codvaleasist = ?mproto" +;
			" group by ValesAsist.val_codvaleasist "+;
			" order by val_codvaleasist asc","mwkinfoaux")

		If mret < 0
			*!*				=Aerror(eros)
			*!*				Messagebox(eros(3))
			Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "VALIDACION")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		If lnflag = 0
			Select * From mwkinfoaux;
				INTO Cursor mwkinfo
		Else
			If Used('mwkinfo')
				Use Dbf('mwkinfo') In 0 Again Alias mwkinfo1
				Use In mwkinfo

				Select mwkinfo1
				Append From Dbf("mwkinfoaux")

				Select * From mwkinfo1;
					INTO Cursor mwkinfo

				Use In mwkinfo1
			Endif

		Endif
		lnflag = lnflag + 1
		Use In mwkinfoaux
	Endscan

	Select * From mwkinfominimo;
		INNER Join mwkinfo On nrovale = vale;
		INTO Cursor mwkinfo1

	Use In mwkinfo
	Use In mwkinfominimo

	Select * From mwkinfo1;
		GROUP By nrovale,nroprotocolo ;
		ORDER By nroprotocolo Asc;
		INTO Cursor mwkinfo
	Use In mwkinfo1
	
Case mopcion = 2
	mret = SQLExec(mcon1," select nroprotocolo,nrovale,fechainforme,pac_nombrepaciente,"+;
		"pre_descriprest, VAL_tipopaciente,estadoinforme,val_fechasolicitud,Tabestados.Descrip    " + ;
		",Informes.FechaAprobacion, Informes.FechaInforme, Informes.FechaRecepcion " +;
		",PRE_retiroestudios ,prestadores.nombre,SER_descripserv " +;
		" FROM informes,prestacions,valesasist,pacientes,Tabestados,Servicios, prestadores  " + ;
		" where pre_codprest = codprest and val_codpun = codpun  and "+;
		" Tabestados.propietario = 10 and Tabestados.tipo = 1 and Tabestados.estado = estadoinforme and "+;
		" Servicios.SER_codserv = Informes.CodServVale and " + ;
		" Prestadores.ID = Informes.CodMedFirma and Informes.EstadoInforme < 5 and "+;
		" fechainforme>= ?mcfechad and fechainforme< ?mcfechah and " + ;
		" pac_codadmision  = val_codadmision " + mwhere  ,"mwkinfo")
Case mopcion = 3 && AGREGADO PARA infor12a
	mret = SQLExec(mcon1," select nroprotocolo, nrovale, " + ;
		"fechainforme, pac_nombrepaciente, " + ;
		"pre_descriprest, VAL_tipopaciente, " + ;
		"estadoinforme, val_fechasolicitud, Tabestados.Descrip, " + ;
		"Informes.FechaAprobacion, Informes.FechaInforme, Informes.FechaRecepcion, " +;
		"PRE_retiroestudios ,prestadores.nombre, SER_descripserv, " +;
		"pac_codhci ,VAL_cama, VAL_habitacion, VAL_codsector, SECTORES.SEC_descripsec " + ;
		"FROM informes " + ;
		"Inner join Prestadores on Prestadores.ID = Informes.CodMedFirma " + ;
		"Inner join valesasist on val_codpun = Informes.codpun " + ;
		"Inner join pacientes on pac_codadmision = valesasist.val_codadmision " + ;
		"Inner join Tabestados on Tabestados.estado = Informes.estadoinforme " + ;
		"Inner join Servicios on Servicios.SER_codserv = Informes.CodServVale " + ;
		"Inner join prestacions on pre_codprest = Informes.codprest " + ;
		"Inner join Sectores on sec_codsector = VAL_codsector " + ;
		"where Tabestados.propietario = 10 and " + ;
		"Tabestados.tipo = 1 and "+;
		"Informes.EstadoInforme < 4 and "+;
		"FechaRecepcion>= ?mcfechad and FechaRecepcion< ?mcfechah " + ;
		" " + mwhere + " " ,"mwkinfo")
Endcase
If mret < 0
	=Aerror(eros)
	Messagebox(eros(3))
	*!*		Messagebox("ERROR AL BUSCAR LOS DATOS", 48, "VALIDACION")
	*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
