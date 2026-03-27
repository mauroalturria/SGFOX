
****************************
**** Autor:Claudia Antoniow
**** Fecha:25/09/2003
****************************
Parameter vr_fecha1, vr_fecha2, vr_med, vr_esp, mtole, mtols, mbuscot, mbuscom

If vartype('mbuscot') <> 'C'

	mbusco2 = ''
	If !isblank(vr_esp) and used('mwkmedicos') and isblank(vr_med)
		Sele mwkmedicos
		Go top
		If !eof()
			mbusco2 = " AND a.codmed in ("
			Scan
				mbusco2 = mbusco2  + allt(str(mwkmedicos.id)) + ","
			Endscan
			mbusco2 = mbusco2  +  "0)"
		Endif
	Else
		mbusco2 =iif(!isblank(vr_med), " AND a.codmed=?vr_med ","")
	Endif

	mbusco2a = mbusco2

Else

	mbusco2  = mbuscot
	mbusco2a = ''

	If vartype(mbuscom) = 'C'
		If !empty(mbuscom)
			mbusco2a = mbuscom
		Endif
	Endif

Endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
mccpoambc = ''
if mxambito >1
	mccpoambc = "  and a.codambito = ?mxambito and franjahoraria.codambito = ?mxambito "
endif
mret = sqlexec(mcon1, "select codmed,diasem,hhmmdes,hhmmhas,fecvigend,fecvigenh,tiposervicio,"+;
	" TabTipoturno.abreviatura as tturno"+;
	" from franjahoraria as a "+;
	" left join TabTipoTurno on TabTipoturno.tipoturno = a.tipoturno"+;
	" where diasem > 0 "+ ;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb +qbusco +;
	" group by codmed, diasem, fecvigenh, hhmmdes,a.tipoturno ","Mwkfran0")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif

qbusco = iif(empty(mbusco2), '',strtran(mbusco2 ,'a.','medpresta.'))

mret = sqlexec(mcon1, " select diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,generaagen,codmed" +;
	" from especialid,medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb +;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif


mfechent  = ctot("01/01/2100")
mfechsal  = ctot("01/01/1900")

mbusco2ie = iif(empty(mbuscom), '',strtran(mbuscom ,'codmed','TAI_codmed'))
mbusco2ier = iif(empty(mbusco2a), '',strtran(mbusco2 ,'a.','franjahoraria.'))

*!* Do sp_busco_medrempzt_amb with vr_fecha1

*!* Query Nuevo
mbusco2ie = Upper(Strtran(Lower(mbusco2ie), 'a.codesp', 'Prestadores.CodEsp'))
mbusco2ier = Upper(Strtran(Lower(mbusco2ier), 'franjahoraria.codesp', 'Prestadores.CodEsp'))

Use in select("mwkambiemed0")
mret = sqlexec(mcon1, "SELECT tai_codmed, TAI_consultorio , TAI_fecha , "+;
	" TAI_hhmmEgr , TAI_hhmmIng, TAI_idfranja "+;
	" FROM TabAmbIEMed as a "+;
	" where TAI_fecha between ?vr_fecha1 and ?vr_fecha2  and TAI_codmed <9999 " + ;
	mccpoamb , "mwkambiemed0")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif
mccpoambme = ''
if mxambito >1
	mccpoambme = "  and tabmedexterno.codambito = ?mxambito "
endif

Use in select("mwkambiemed01b")
mret = sqlexec(mcon1, "SELECT TAI_codmed , TAI_consultorio , TAI_fecha , "+;
	" TAI_hhmmEgr , TAI_hhmmIng, TAI_idfranja ,tabmedexterno.gerenciadora as codmed,tabmedexterno.nombre  "+;
	" FROM TabAmbIEMed , tabmedexterno "+;
	" where tabmedexterno.id = a.tai_codmed "+;
	" and TAI_fecha between ?vr_fecha1 and ?vr_fecha2 " +;
	mccpoamb, "mwkambiemed01b")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif

Use in select("mwkambiemed02b")
Select * from mwkambiemed0;
	union;
	select * from mwkambiemed01b into cursor mwkambiemed02b;

Select TAI_codmed , TAI_consultorio , TAI_fecha ,;
	max(TAI_hhmmEgr) as TAI_hhmmEgr , min(TAI_hhmmIng) as TAI_hhmmIng,;
	nombre, hhmmdes, hhmmhas, TAI_idfranja, medico;
	from mwkambiemed02b group by TAI_idfranja, TAI_fecha into cursor mwkambiemed1 && mwkambiemed0  && Reemplazante

Use in select("mwkambiemed01b")
Use in select("mwkambiemed02b")

*!*	Select mwkambiemed0.*,mwkMedrpzt.nombre as medico ;
*!*		from mwkambiemed0 left join mwkMedrpzt on mwkMedrpzt.id = TAI_codmed;
*!*		into cursor mwkambiemed1

Select padr(nombre,50) as nombre,TAI_fecha as fecha, ;
	ctot(dtoc(TAI_fecha)+" "+transf(hhmmdes,"99:99")) as horadesde,;
	ctot(dtoc(TAI_fecha)+" "+transf(hhmmhas ,"99:99")) as horahasta,;
	ctot(dtoc(TAI_fecha)+" "+transf(TAI_hhmmIng,"99:99")) as entradac,;
	iif(TAI_hhmmEgr<9999,ctot(dtoc(TAI_fecha)+" "+transf(TAI_hhmmEgr ,"99:99")),mfechsal ) as salidac,;
	TAI_codmed as codmed,hhmmdes,hhmmhas,;
	padr(medico,50) as reemplazo,TAI_idfranja as ide,dow(TAI_fecha) as diasem,;
	iif(TAI_hhmmIng=9999,0,1) as hec,iif(TAI_hhmmEgr=9999 ,0,1) as hsc ;
	from mwkambiemed1 order by fecha,horadesde,horahasta,codmed ;
	into cursor mwkambiemed

mret=sqlexec(mcon1, " SELECT a.nombre,fecha, horadesde ,horahasta, "+;
	" cast(CASE WHEN entsal=1 THEN fechahora "+;
	" ELSE ?mfechent END as TIMESTAMP) as entrada, "+;
	" cast(CASE WHEN entsal=2 THEN fechahora "+;
	" ELSE ?mfechsal END as  TIMESTAMP) as salida,codmed,"+;
	" b.nombre as reemplazo,ide,{fn DAYOFWEEK(fecha )} as diasem "+;
	" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
	" WHERE a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2a  +;  &&+mccpoamb
	" ORDER by fecha,horadesde,horahasta,a.codmed, entsal ","MwkControlMb")

If mret < 0
	mret = 0
	Messagebox('ERROR DE GENERACION DE CURSOR 1, AVISAR A SISTEMAS',16,'VALIDACION')
	Cancel
Else
	Select nombre,fecha, horadesde ,horahasta, iif(entrada=mfechent,salida ,entrada ) as entrada;
		,iif(salida=mfechsal ,entrada ,salida ) as salida,codmed;
		,hour(horadesde)*100+minute(horadesde) as hhmmdes;
		,hour(horahasta)*100 + minute(horahasta)  as hhmmhas ;
		,reemplazo,ide,diasem ;
		,iif(entrada=mfechent,0,1) as he,iif(salida=mfechsal ,0,1) as hs ;
		from MwkControlMb into cursor MwkControlMa

	Select mwkambiemed.nombre,mwkambiemed.fecha, mwkambiemed.horadesde ,mwkambiemed.horahasta, ;
		entrada,salida,entradac,salidac,;
		mwkambiemed.codmed,mwkambiemed.hhmmdes,mwkambiemed.hhmmhas,mwkambiemed.reemplazo,;
		mwkambiemed.ide,mwkambiemed.diasem ,he,hs,hec,hsc;
		from mwkambiemed left join MwkControlMa ;
		on (mwkambiemed.codmed = MwkControlMa.codmed  ;
		and mwkambiemed.horadesde = MwkControlMa.horadesde);
		into cursor MwkControliec

	Select MwkControlMa.nombre,MwkControlMa.fecha, MwkControlMa.horadesde ,MwkControlMa.horahasta, ;
		entrada,salida,entradac,salidac,;
		MwkControlMa.codmed,MwkControlMa.hhmmdes,MwkControlMa.hhmmhas,MwkControlMa.reemplazo,;
		MwkControlMa.ide,MwkControlMa.diasem ,he,hs,hec,hsc;
		from MwkControlMa left join mwkambiemed;
		on(mwkambiemed.codmed = MwkControlMa.codmed  ;
		and mwkambiemed.horadesde = MwkControlMa.horadesde);
		into cursor MwkControlief

	Select * from MwkControlief where isnull(salidac) union all;
		select * from MwkControliec where !isnull(salida) and !isnull(salidac) union all;
		select * from MwkControliec where isnull(salida) ;
		into cursor MwkControlM0


	Do sp_busco_bloqueos_franja with vr_fecha1, vr_fecha2
	mccpoamb = ''
	if mxambito >1
		mccpoamb = "  and codambito = ?mxambito "
	endif

	Select MwkControlM0.codmed,nombre,fecha, MwkControlM0.horadesde,MwkControlM0.horahasta, ;
		min(entrada) as entrada, max(salida) as salida,	min(entradac) as entradac, max(salidac) as salidac,	reemplazo,tiposervicio,Mwkmedpre0.codesp ;
		,Mwkmedpre0.ESP_descripcion,max(he) as he,max(hs) as hs,max(hec) as hec,max(hsc) as hsc  ;
		,MwkControlM0.hhmmdes,MwkControlM0.hhmmhas ;
		,CodCargo ,descrip,mwkbloqueo.horadesde as hdb ,mwkbloqueo.horahasta as hhb,;
		Mwkfran0.tturno ,mwkbloqueo.codmed  as codmedb;
		from MwkControlM0 ;
		left join Mwkfran0 on ;
		MwkControlM0.codmed	= Mwkfran0.codmed and  ;
		MwkControlM0.diasem = Mwkfran0.diasem and  ;
		Mwkfran0.hhmmdes  	= MwkControlM0.hhmmdes and ;
		Mwkfran0.hhmmhas 	= MwkControlM0.hhmmhas and ;
		Mwkfran0.fecvigend 	<= MwkControlM0.fecha  and ;
		Mwkfran0.fecvigenh 	>= MwkControlM0.fecha ;
		left join Mwkmedpre0 on ;
		Mwkmedpre0.codmed  = MwkControlM0.codmed   and ;
		Mwkmedpre0.diasem  = MwkControlM0.diasem   and ;
		Mwkmedpre0.hhmmdes = MwkControlM0.hhmmdes and ;
		Mwkmedpre0.hhmmhas = MwkControlM0.hhmmhas and ;
		Mwkmedpre0.fecvigend <= MwkControlM0.fecha and ;
		Mwkmedpre0.fecvigenh >= MwkControlM0.fecha ;
		left join mwkMedicoscar on ;
		mwkMedicoscar.id = MwkControlM0.codmed ;
		left join mwkbloqueo on ;
		mwkbloqueo.codmed  = MwkControlM0.codmed     and ;
		mwkbloqueo.diasem  = dow(MwkControlM0.fecha) and ;
		mwkbloqueo.hhmmdes<MwkControlM0.hhmmhas  and ;
		mwkbloqueo.hhmmhas > MwkControlM0.hhmmdes  and ;
		mwkbloqueo.fvigend <= MwkControlM0.fecha 	 and ;
		mwkbloqueo.fvigenh >= MwkControlM0.fecha ;		
		group by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
		order by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
		into cursor MwkControlM1
	
	If !empty(vr_esp)
		Select * from MwkControlM1 where codmed in (select codmed from Mwkmedpre0) into cursor MwkControlM1
	Endif

Endif
