Lparameters xmfecha ,xmfechah
*!*	Proceso de generacion de · receta
*!*	-----------------------------------------------------------
Do sp_busco_estados With 7,' and tipo = 14 ','mwkestHabPixis'&&
msechab =''
mfechaconf = Ctot(Alltrim(mwkfechaini.Descrip))
mfechor = mfechaconf

If mwkestHabPixis.estado > 0
	If mwkestHabPixis.estado = 1
		Select mwkestHabPixis
		msechab = ' inlist(mwkvalbol.val_codsector'
		Scan
			msechab = msechab +","+ mwkestHabPixis.Descrip
		Endscan
		msechab = msechab +")"

	Endif

Endif

mfecha = xmfecha
mfechah = xmfechah
mret = SQLExec(mcon1, "select tpm_itemid FROM Grifols.TabPyxisMovimDet "+;
	"  where tpm_dateinsert>=?mfecha group by tpm_itemid", "mwkgrifols")
For tipolib = 2  To 3
	Do sp_busco_insumos_restringidos With tipolib ,"mwkinslibro"
	Select ins_codpuntero,ins_codinsumo  From mwkgrifols,mwkinslibro Where Alltrim(tpm_itemid)=ins_codinsumo Into Cursor mwkgrifol
	Select mwkinslibro
	Scan
		minsumo = mwkinslibro.ins_codpuntero
		Wait Windows mwkinslibro.INS_descriinsumo Nowait
		mret = SQLExec(mcon1, "select IPN_ultimaReceta,IPN_usubloq FROM Zabinspsiconro "+;
			" where IPN_insumo =?minsumo ", "mwknrorec")
		If Reccount('mwknrorec')=0
			mret = SQLExec(mcon1, "insert into Zabinspsiconro (IPN_insumo,IPN_ultimaReceta,IPN_usubloq)"+;
				" values ( ?minsumo,0,146) ")
			minro = 0
		Else
			If mwknrorec.IPN_usubloq =0
				mret = SQLExec(mcon1, "update Zabinspsiconro set IPN_usubloq = 146 where IPN_insumo =?minsumo ")
				minro = mwknrorec.IPN_ultimaReceta
			Else
				midusua     = "CARMENA"
				Do sp_insert_tabctrlerr With mwkinslibro.INS_descriinsumo, "RECETAS BLOQUEADAS"	, midusua, "GENERA_RECETA"

				Insert Into mwkrecetas(insumo,nroreceta ,vale ,bolsa ,motivo ) ;
					values (mwkinslibro.INS_descriinsumo,0,0,0,"RECETAS BLOQUEADAS")
				Loop
			Endif
		Endif
		mifechaini = xmfecha -1
		
			mret = SQLExec(mcon1, "select valesasist.VAL_codpun,VAL_codadmision ,VAL_codvaleasist,val_codsector,"+;
				" VAL_fechasolicitud ,IPR_receta,VAL_medicosolicit,PIA_codinsumo,valesasist.val_fhsolicitud ,Pia_cantsolicitada,"+;
				" CAST(valesasist.VAL_medicosolicit as CHAR(30)) as nombreC,VAL_fechaconforme, VAL_horaconforme "+;
				" from valesasist inner join presinsuvas on valesasist = pia_valesasist " + ;
				" left join Zabinspsicoreceta on valesasist.VAL_codpun = IPR_valcodpun  "+;
				" where VAL_fechasolicitud >=?mifechaini and VAL_fechasolicitud <=?xmfechah and PIA_codinsumo =?minsumo  and  " + ;&&and val_codsector<>'EME'
				" val_estado = 3 and VAL_codservvale = 5410 ", "mwktodoins")
			Select *,Ctot(Dtoc(VAL_fechaconforme)+" "+Ttoc(VAL_horaconforme,2)) As FechaHoraConforme From mwktodoins Left Join mwkgrifol On PIA_codinsumo = mwkgrifol.ins_codpuntero ;
				WHERE Ctot(Dtoc(VAL_fechaconforme)+" "+Ttoc(VAL_horaconforme,2))>mfechaconf AND Pia_cantsolicitada>0   ;
				order By VAL_fechasolicitud ,VAL_codpun Into Cursor mwkvales  &&&mwkvalbol
			Select mwkvales && mwkvalbol
			Go Top
			mret = SQLExec(mcon1, "SELECT  Tabinsumosprogramacion.CantConformada, Tabinsumosprogramacion.CodInsumo"+;
				",Tabbolsasprogramacion.FechaHoraConforme,"+;
				" Tabbolsasprogramacion.FechaHoraDescarga, Tabbolsasprogramacion.ID,Tabquirofano.CodMed,"+;
				"  Tabquirofano.Cirujano, Tabquirofano.NroProtocolo, Tabquirofano.PacNombre,Tabquirofano.Nroregistrac   "+;
				" FROM  Tabinsumosprogramacion  "+;
				" INNER JOIN Tabbolsasprogramacion  ON  Tabinsumosprogramacion.IdTabBolsasProgramacion = Tabbolsasprogramacion.ID  "+;
				" INNER JOIN Tabquirofano ON  Tabbolsasprogramacion.IdTabQuirofano = Tabquirofano.ID  "+;
				" WHERE   codInsumo = ?minsumo  AND  FechaHoraConforme>= ?mifechaini and FechaHoraConforme<= ?xmfechah ","mwkbolsas01")
			Select Ttod(FechaHoraConforme) As VAL_fechasolicitud,"IQB" As val_codsector ;
				,Nvl(CODMED,0) As VAL_MedicoSolicit ,  CodInsumo As PIA_codinsumo,Id As VAL_codpun, Id As VAL_codvaleasist;
				,CantConformada As Pia_cantsolicitada,Padr(Transform(Nroregistrac),12) As VAL_codadmision;
				,FechaHoraConforme As val_fhsolicitud,FechaHoraConforme ;
				from mwkbolsas01 Where FechaHoraConforme>=mfechaconf  AND CantConformada >0 Order By FechaHoraConforme,Id Into Cursor mwkbolsas

			Select VAL_fechasolicitud ,VAL_MedicoSolicit ,PIA_codinsumo,VAL_codpun, VAL_codvaleasist;
				,Pia_cantsolicitada,VAL_codadmision,val_fhsolicitud,2 As tvb,val_codsector,FechaHoraConforme   From mwkbolsas;
				union All Select VAL_fechasolicitud ,VAL_MedicoSolicit ,PIA_codinsumo, VAL_codpun,VAL_codvaleasist;
				,Pia_cantsolicitada,Padr(VAL_codadmision,12) As VAL_codadmision,val_fhsolicitud,1 As tvb,val_codsector,FechaHoraConforme  ;
				from mwkvales  Into Cursor mwkegresos

			Select * From mwkegresos Order By PIA_codinsumo,FechaHoraConforme   Into Cursor mwkvalbol
			Go Top
			mret = SQLExec(mcon1, "select * from Zabinspsicoreceta where IPR_insumo=?minsumo and IPR_receta >= ?minro","mwkctrl")
			If Reccount("mwkctrl")>1
				midusua     = "CARMENA"
				Do sp_insert_tabctrlerr With mwkinslibro.INS_descriinsumo, "RECETAS DUPLICADAS"	, midusua, "GENERA_RECETA"
				Insert Into mwkrecetas(insumo,nroreceta ,vale ,bolsa ,motivo ) ;
					values (mwkinslibro.INS_descriinsumo,0,0,0,"RECETAS BLOQUEADAS")
				Loop
			Else
				If Reccount("mwkctrl")=0 And minro>1
					midusua     = "CARMENA"
					Do sp_insert_tabctrlerr With mwkinslibro.INS_descriinsumo, "RECETAS FALTANTES"	, midusua, "GENERA_RECETA"
					Insert Into mwkrecetas(insumo,nroreceta ,vale ,bolsa ,motivo ) ;
						values (mwkinslibro.INS_descriinsumo,0,0,0,"RECETAS BLOQUEADAS")
					Loop
				Endif
			Endif
			Select 	mwkvalbol
			Scan
				If !Isnull(mwkvalbol.PIA_codinsumo) &&& And  Evaluate(msechab ))
					mfecvale = TTOD( mwkvalbol.FechaHoraConforme )
					mcodpun = mwkvalbol.VAL_codpun
					If mwkvalbol.tvb = 1
						mtipo = Iif(mwkvalbol.VAL_MedicoSolicit>0,1,3)
						
					Else
						mtipo = Iif(mwkvalbol.VAL_MedicoSolicit>0,2,4)
					
					ENDIF
					mdet = mwkvalbol.VAL_codsector
					mret = SQLExec(mcon1, "select id from Zabinspsicoreceta where IPR_tipoEgreso=?mtipo  and  IPR_valcodpun =?mcodpun ","mwkctrlexiste" )
					If Reccount("mwkctrlexiste" )=0
						minro = minro +1
						mret = SQLExec(mcon1, "insert into Zabinspsicoreceta(IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,IPR_detalle)"+;
							" values ( ?minsumo,?minro,?mtipo ,?mcodpun,?mdet )")
						If Inlist(mtipo,3,4)
							Insert Into mwkrecetas(insumo,nroreceta ,vale ,bolsa ,motivo );
								values (mwkinslibro.INS_descriinsumo,minro,mwkvalbol.VAL_codvaleasist,0,;
								"PAC:"+Alltrim(mwkvalbol.VAL_codadmision))
						Endif
					Endif
					Select 	mwkvalbol
					If mfechor < FechaHoraConforme AND mwkvalbol.tvb = 1 
						mfechor = FechaHoraConforme
					Endif
				Endif
			Endscan
	 
		mret = SQLExec(mcon1, "update Zabinspsiconro set IPN_usubloq = 0,IPN_ultimaReceta =?minro  where IPN_insumo =?minsumo ")
		Select mwkinslibro

	Endscan
Next tipolib
mfechora = TRANSFORM(mfechor )
lcSql = 'update tabestados set descrip = ?mfechora where propietario = 44 and tipo = 1  '
If !Prg_EjecutoSql(lcSql,"mwkserquiro")
	Return .F.
Endif
