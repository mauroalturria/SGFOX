****
** busco vales de demanda espontanea
****

Parameter mfecdes, mfechas, mbusco, msql_tot,mgroup
If Used('mwktv')
	Use In mwktv
Endif
If Used('mwktotval')
	Use In mwktotval
Endif
mbuscoval  =  " "
mcjoinvales = ""
If mxambito >1
	mbuscoval  =  " and pac_codambito=?mxambito "
Endif

Use In Select("mwkespecag")
mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")


*if month(mfecdes) < month(mfechas)
mfd = mfecdes
Do While mfd <= mfechas
	mfp = mfd+31
	mfh = Date(Year(mfp),Month(mfp),1)-1
	mfh = Iif(mfh>mfechas,mfechas,mfh )
	Wait Windows ("Procesando hasta "+Dtoc(mfh)) Nowait
	mret = SQLExec(mcon1, "select  VAL_codvaleasist,VAL_horasolicitud " + ;
		" ,pia_codprest, VAL_circuitoorigen,VAL_fechasolicitud,val_operadorcarga,HIS_codentidad  " + ;
		" ,VAL_codadmision,val_codsector,VAL_codservvale,VAL_tipopaciente,VAL_nroprotocolo,ent_descrient "+;
		" from pacientes, servicios, histambgua,valesasist,entidades " + ;
		" left join  presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " +;
		"where his_codadmision = PAC_codadmision and his_codentidad = ent_codent and " + ;
		"PAC_codadmision = VAL_codadmision and " + ;
		"VAL_codservvale = ser_codserv and " + ;
		"his_nroregistrac = pac_codhci " + ;
		" and VAL_codservvale<>5410 and  VAL_codsector in('AMB', 'GUA') and  " + ;
		" VAL_fechasolicitud >= ?mfd and " + ;
		" VAL_fechasolicitud <= ?mfh and pia_cantsolicitada<1  " + ;
		"" , "mwktotval")
		
	If mret<0
		=Aerr(eros)
		Messagebox(eros(3))
		Messagebox("SI ES ERROR 400 DEBE SELECCIONAR UN RANGO MENOR")
	Endif

	mfd = mfh +1
	If Used('mwktv')
		Select * From  mwktv Union Select * From mwktotval  Into Cursor mwktv
	Else
		Select * From  mwktotval Into Cursor mwktv
	Endif
Enddo
Wait Clear
Select * ;
	from mwktv,mwkprestac;
	where  pre_codprest = pia_codprest;
	order By ser_descripserv, VAL_tipopaciente ;
	into Cursor mwkvaleanu

