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
mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
Use In Select("mwkespecag")
mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest ,pre_especialidad,ESP_descripcion " + ;
	" FROM prestacions left join especialid on pre_especialidad = ESP_codesp "+;
	" where pre_fechapasiva is null " + ;
	" group by pre_codprest " , "mwkpresta")
*if month(mfecdes) < month(mfechas)
mfd = mfecdes
Do While mfd <= mfechas
	mfp = mfd+31
	mfh = Date(Year(mfp),Month(mfp),1)-1
	mfh = Iif(mfh>mfechas,mfechas,mfh )
	Wait Windows ("Procesando hasta "+Dtoc(mfh)) Nowait
	mret = SQLExec(mcon1, "select valesasist ,VAL_tipopaciente,sum(pia_cantsolicitada) as canti, " + ;
		"pia_codprest, VAL_circuitoorigen,VAL_fechasolicitud,VAL_codservvale,val_operadorcarga,PAC_CentroMedico  " + ;
		"from valesasist " + ;
		"left join  presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
		"where  VAL_codservvale<>5410 and  " + ;
		"VAL_fechasolicitud >= ?mfd and " + ;
		"VAL_fechasolicitud <= ?mfh  " + ;
		mbusco  + mbuscoval +;
		"group by VAL_codservvale, VAL_tipopaciente " + mgroup +  ;
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
Select ser_descripserv, VAL_tipopaciente,  Month(VAL_fechasolicitud) As mes;
	, pia_codprest,canti As cantidad,val_operadorcarga, VAL_codservvale, ;
	nvl(VAL_circuitoorigen,'2') As VAL_circuitoorigen,pre_descriprest,pre_especialidad,ESP_descripcion,NVL(PAC_CentroMedico,1) as PAC_CentroMedico  ;
	from mwktv,mwkpresta ;
	left Join  mwkserv On VAL_codservvale = ser_codserv ;
	where  pre_codprest = pia_codprest;
	order By ser_descripserv, VAL_tipopaciente ;
	into Cursor mwktotvale1

If At('VAL_fechasolicitud',mgroup)>0
	mgr = Strtran(mgroup,'VAL_fechasolicitud','mes')
	Select ser_descripserv, VAL_tipopaciente, mes,pia_codprest, ;
		sum(cantidad) As cantid,VAL_circuitoorigen, pre_descriprest,val_operadorcarga,pre_especialidad,ESP_descripcion,PAC_CentroMedico  ;
		from mwktotvale1;
		group By VAL_codservvale, VAL_tipopaciente &mgr Into Cursor mwktotvale
Else
	Select ser_descripserv, VAL_tipopaciente, mes,pia_codprest, ;
		sum(cantidad) As cantid,VAL_circuitoorigen , pre_descriprest,val_operadorcarga,pre_especialidad,ESP_descripcion,PAC_CentroMedico  ;
		from mwktotvale1 ;
		group By VAL_codservvale, VAL_tipopaciente &mgroup Into Cursor mwktotvale
Endif
**						"group by VAL_codservvale, pia_codprest,VAL_circuitoorigen " + ;
**       							" and pia_codprest=105  " +;

If Used ('mwktv')
	Use In mwktv
Endif
If Used ('mwktotval')
	Use In mwktotval
Endif
