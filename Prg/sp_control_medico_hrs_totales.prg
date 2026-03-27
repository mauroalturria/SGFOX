
****************************
**** Autor:Claudia Antoniow
**** Fecha:25/09/2003
****************************
Parameter vr_fecha1, vr_fecha2, vr_med, vr_esp, mtole, mtols, mbuscot, mbuscom

If Vartype('mbuscot') <> 'C'

	mbusco2 = ''
	If !Isblank(vr_esp) And Used('mwkmedicos') And Isblank(vr_med)
		Sele mwkmedicos
		Go Top
		If !Eof()
			mbusco2 = " AND a.codmed in ("
			Scan
				mbusco2 = mbusco2  + Allt(Str(mwkmedicos.Id)) + ","
			Endscan
			mbusco2 = mbusco2  +  "0)"
		Endif
	Else
		mbusco2 =Iif(!Isblank(vr_med), " AND a.codmed=?vr_med ","")
	Endif

	mbusco2a = mbusco2

Else

	mbusco2  = mbuscot
	mbusco2a = ''

	If Vartype(mbuscom) = 'C'
		If !Empty(mbuscom)
			mbusco2a = mbuscom
		Endif
	Endif

Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif
mccpoambc = ''
If mxambito >1
	mccpoambc = "  and a.codambito = ?mxambito and franjahoraria.codambito = ?mxambito "
Endif

qbusco = Iif(Empty(mbusco2), '',Strtran(mbusco2 ,'a.','medpresta.'))
If Used('dias')
	Use In dias
Endif
mfechas = vr_fecha2
mfecdes = vr_fecha1
Create Cursor dias (fechatur D,diasem N )
For i = 0 To mfechas - mfecdes
	mdias = mfecdes + i
	mret=SQLExec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mdias",'MWKFeriados')
	If Reccount('MWKFeriados')=0
		Insert Into dias ( fechatur,diasem  ) Values ( mdias, Dow(mdias) )
	Endif
Next

mret = SQLExec(mcon1, " select diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,generaagen,sala,codmed" +;
	" from especialid,medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb +;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif
mbuscomfh = Upper(Strtran(Lower(mbuscom), ' a.', ' franjahoraria.'))
mret = SQLExec(mcon1, "select franjahoraria.id,codmed,diasem,hhmmdes,hhmmhas,fecvigend,fecvigenh,tiposervicio,"+;
	" TabTipoturno.abreviatura as tturno,nombre,estructura,enreldep,cuil,nrolegajo "+;
	" from franjahoraria inner join prestadores on prestadores.id = franjahoraria.codmed "+;
	" left join TabTipoTurno on TabTipoturno.tipoturno = franjahoraria.tipoturno"+;
	" where diasem > 0 "+ ;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb + mbuscomfh +;
	" group by codmed, diasem, fecvigenh, hhmmdes,franjahoraria.tipoturno ","Mwkfran0")
If mret < 0
	= Aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif

mfechent  = Ctot("01/01/2100")
mfechsal  = Ctot("01/01/1900")

mbusco2ie = Iif(Empty(mbuscom), '',Strtran(mbuscom ,'codmed','TAI_codmed'))
mbusco2ier = Iif(Empty(mbusco2a), '',Strtran(mbusco2 ,'a.','franjahoraria.'))

*!* Do sp_busco_medrempzt_amb with vr_fecha1

*!* Query Nuevo
mbusco2ie = Upper(Strtran(Lower(mbusco2ie), 'a.codesp', 'Prestadores.CodEsp'))
mbusco2ier = Upper(Strtran(Lower(mbusco2ier), 'franjahoraria.codesp', 'Prestadores.CodEsp'))

Use In Select("mwkambiemed0")
mret = SQLExec(mcon1, "SELECT franjahoraria.codmed as tai_codmed, TAI_consultorio , TAI_fecha , "+;
	" TAI_hhmmEgr , TAI_hhmmIng, prestadores.nombre, hhmmdes, hhmmhas, TAI_idfranja, prestadores.nombre as medico"+;
	" FROM TabAmbIEMed as a, franjahoraria, prestadores "+;
	" where TAI_idfranja = franjahoraria.id and franjahoraria.codmed = prestadores.id "+;
	" and TAI_fecha between ?vr_fecha1 and ?vr_fecha2  and a.TAI_codmed <9999 " + mbusco2ie +;
	mccpoambc , "mwkambiemed0a")
If mret < 0
	= Aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif
Use In Select("mwkambiemed01")
mret = SQLExec(mcon1, "SELECT franjahoraria.codmed,tai_codmed, TAI_consultorio , TAI_fecha , "+;
	" TAI_hhmmEgr , TAI_hhmmIng, prestadores.nombre, hhmmdes, hhmmhas, franjahoraria.id as TAI_idfranja, prestadores.nombre as medico"+;
	" FROM TabAmbIEMed as a, franjahoraria, prestadores "+;
	" where TAI_idfranja <> franjahoraria.id and franjahoraria.codmed = prestadores.id "+;
	" and TAI_fecha between Franjahoraria.Fecvigend and Franjahoraria.Fecvigenh  "+;
	" and TAI_fecha between ?vr_fecha1 and ?vr_fecha2  and a.TAI_codmed = franjahoraria.codmed " + mbusco2ie +;
	mccpoambc +" group by franjahoraria.id,a.id" , "mwkambiemed01")
If mret < 0
	= Aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif
Select tai_codmed, TAI_consultorio , TAI_fecha , TAI_hhmmEgr , TAI_hhmmIng, nombre, hhmmdes, hhmmhas, TAI_idfranja, nombre As medico;
	FROM mwkambiemed01 Where Dtos(TAI_fecha )+Transform(TAI_idfranja,"@L 999999999") Not In (Select Dtos(TAI_fecha )+Transform(TAI_idfranja,"@L 999999999") From mwkambiemed0a  );
	union All;
	SELECT tai_codmed, TAI_consultorio , TAI_fecha , TAI_hhmmEgr , TAI_hhmmIng, nombre, hhmmdes, hhmmhas, TAI_idfranja, nombre As medico;
	FROM mwkambiemed0a  ;
	into Cursor mwkambiemed0
mccpoambme = ''
If mxambito >1
	mccpoambme = "  and tabmedexterno.codambito = ?mxambito "
Endif

Use In Select("mwkambiemed01b")
mret = SQLExec(mcon1, "SELECT franjahoraria.codmed as TAI_codmed , TAI_consultorio , TAI_fecha , "+;
	" TAI_hhmmEgr , TAI_hhmmIng, prestadores.nombre, hhmmdes, hhmmhas, TAI_idfranja, tabmedexterno.nombre as medico"+;
	" FROM TabAmbIEMed as a, franjahoraria, tabmedexterno, prestadores"+;
	" where TAI_idfranja = franjahoraria.id and franjahoraria.codmed = tabmedexterno.gerenciadora"+;
	" and tabmedexterno.fechaingreso between TAI_fecha and dateadd('dd',1,TAI_fecha) "+;
	" and tabmedexterno.id = a.tai_codmed "+;
	" and franjahoraria.codmed = prestadores.id "+;
	" and TAI_fecha between ?vr_fecha1 and ?vr_fecha2 " + mbusco2ier +;
	mccpoambc +mccpoambme, "mwkambiemed01b")

If mret < 0
	= Aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif

Use In Select("mwkambiemed02b")
Select * From mwkambiemed0;
	union;
	select * From mwkambiemed01b Into Cursor mwkambiemed02b;

Select tai_codmed , TAI_consultorio , TAI_fecha ,;
	max(TAI_hhmmEgr) As TAI_hhmmEgr , Min(TAI_hhmmIng) As TAI_hhmmIng,;
	nombre, hhmmdes, hhmmhas, TAI_idfranja, medico;
	from mwkambiemed02b Group By TAI_idfranja, TAI_fecha Into Cursor mwkambiemed1 && mwkambiemed0  && Reemplazante

Use In Select("mwkambiemed01b")
Use In Select("mwkambiemed02b")

*!*	Select mwkambiemed0.*,mwkMedrpzt.nombre as medico ;
*!*		from mwkambiemed0 left join mwkMedrpzt on mwkMedrpzt.id = TAI_codmed;
*!*		into cursor mwkambiemed1

Select Padr(nombre,50) As nombre,TAI_fecha As fecha, ;
	ctot(Dtoc(TAI_fecha)+" "+Transf(hhmmdes,"99:99")) As horadesde,;
	ctot(Dtoc(TAI_fecha)+" "+Transf(hhmmhas ,"99:99")) As horahasta,;
	ctot(Dtoc(TAI_fecha)+" "+Transf(TAI_hhmmIng,"99:99")) As entradac,;
	iif(TAI_hhmmEgr<9999,Ctot(Dtoc(TAI_fecha)+" "+Transf(TAI_hhmmEgr ,"99:99")),mfechsal ) As salidac,;
	tai_codmed As codmed,hhmmdes,hhmmhas,;
	padr(medico,50) As reemplazo,TAI_idfranja As ide,Dow(TAI_fecha) As diasem,;
	iif(TAI_hhmmIng=9999,0,1) As hec,Iif(TAI_hhmmEgr=9999 ,0,1) As hsc ;
	from mwkambiemed1 Order By fecha,horadesde,horahasta,codmed ;
	into Cursor mwkambiemed

mret=SQLExec(mcon1, " SELECT a.nombre,fecha, horadesde ,horahasta, "+;
	" cast(CASE WHEN entsal=1 THEN fechahora "+;
	" ELSE ?mfechent END as TIMESTAMP) as entrada, "+;
	" cast(CASE WHEN entsal=2 THEN fechahora "+;
	" ELSE ?mfechsal END as  TIMESTAMP) as salida,codmed,"+;
	" b.nombre as reemplazo,ide,{fn DAYOFWEEK(fecha )} as diasem "+;
	" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
	" WHERE a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2a  +mccpoamb +;
	" ORDER by fecha,horadesde,horahasta,a.codmed, entsal ","MwkControlMb")

If mret < 0
	mret = 0
	Messagebox('ERROR DE GENERACION DE CURSOR 1, AVISAR A SISTEMAS',16,'VALIDACION')
	Cancel
Else
	Select nombre,fecha, horadesde ,horahasta, Iif(entrada=mfechent,salida ,entrada ) As entrada;
		,Iif(salida=mfechsal ,entrada ,salida ) As salida,codmed;
		,Hour(horadesde)*100+Minute(horadesde) As hhmmdes;
		,Hour(horahasta)*100 + Minute(horahasta)  As hhmmhas ;
		,reemplazo,ide,diasem ;
		,Iif(entrada=mfechent,0,1) As he,Iif(salida=mfechsal ,0,1) As hs ;
		from MwkControlMb Into Cursor MwkControlMa

	Select mwkambiemed.nombre,mwkambiemed.fecha, mwkambiemed.horadesde ,mwkambiemed.horahasta, ;
		entrada,salida,entradac,salidac,;
		mwkambiemed.codmed,mwkambiemed.hhmmdes,mwkambiemed.hhmmhas,mwkambiemed.reemplazo,;
		mwkambiemed.ide,mwkambiemed.diasem ,he,hs,hec,hsc;
		from mwkambiemed Left Join MwkControlMa ;
		on (mwkambiemed.codmed = MwkControlMa.codmed  ;
		and mwkambiemed.horadesde = MwkControlMa.horadesde);
		into Cursor MwkControliec

	Select MwkControlMa.nombre,MwkControlMa.fecha, MwkControlMa.horadesde ,MwkControlMa.horahasta, ;
		entrada,salida,entradac,salidac,;
		MwkControlMa.codmed,MwkControlMa.hhmmdes,MwkControlMa.hhmmhas,MwkControlMa.reemplazo,;
		MwkControlMa.ide,MwkControlMa.diasem ,he,hs,hec,hsc;
		from MwkControlMa Left Join mwkambiemed;
		on(mwkambiemed.codmed = MwkControlMa.codmed  ;
		and mwkambiemed.horadesde = MwkControlMa.horadesde ;
		and MwkControlMa.fecha = mwkambiemed.fecha ) ;
		into Cursor MwkControlief

	Select * From MwkControlief Where Isnull(salidac) Union All;
		select * From MwkControliec Where !Isnull(salida) And !Isnull(salidac) Union All;
		select * From MwkControliec Where Isnull(salida) ;
		into Cursor MwkControlM0


	Do sp_busco_bloqueos_franja With vr_fecha1, vr_fecha2

	Select Mwkfran0.*,dias.fechatur As fecha;
		,Ctot(Dtoc(dias.fechatur)+" "+Transf(Mwkfran0.hhmmdes,"@L 99:99")) As horadesde;
		,Ctot(Dtoc(dias.fechatur)+" "+Transf(Mwkfran0.hhmmhas,"@L 99:99")) As horahasta ;
		from dias;
		left Join Mwkfran0 On ;
		dias.diasem = Mwkfran0.diasem And  ;
		Mwkfran0.fecvigend 	<= dias.fechatur And ;
		Mwkfran0.fecvigenh 	>= dias.fechatur ;
		group By nombre, fecha, hhmmdes, hhmmhas ;
		into Cursor Mwkfran01

	Select * From Mwkfran01 Where !Isnull(nombre)  Into Cursor Mwkfran0

	Select Mwkfran0.Id,Mwkfran0.codmed,Mwkfran0.nombre+Space(10) As nombre,Mwkfran0.fecha;
		,Mwkfran0.horadesde,Mwkfran0.horahasta ;
		,Dtot(dias.fechatur) As entrada, Dtot(dias.fechatur) As salida ;
		,Dtot(dias.fechatur) As entradac, Dtot(dias.fechatur) As salidac ;
		,Space(50) As reemplazo,tiposervicio,Mwkmedpre0.codesp ;
		,Mwkmedpre0.ESP_descripcion,0000 As he,0000 As hs,0000 As hec,0000 As hsc  ;
		,Mwkfran0.hhmmdes,Mwkfran0.hhmmhas,estructura,enreldep,demanda,generaagen,sala,cuil,nrolegajo ;
		,CodCargo ,Descrip,Mwkfran0.tturno,Mwkfran0.fecvigend,Mwkfran0.fecvigenh,Mwkfran0.diasem;
		from dias;
		left Join Mwkfran0 On ;
		dias.diasem = Mwkfran0.diasem And  ;
		Mwkfran0.fecvigend 	<= dias.fechatur And ;
		Mwkfran0.fecvigenh 	>= dias.fechatur ;
		left Join Mwkmedpre0 On ;
		Mwkmedpre0.codmed  = Mwkfran0.codmed   And ;
		Mwkmedpre0.diasem  = Mwkfran0.diasem   And ;
		Mwkmedpre0.hhmmdes = Mwkfran0.hhmmdes And ;
		Mwkmedpre0.hhmmhas = Mwkfran0.hhmmhas And ;
		Mwkmedpre0.fecvigend <= Mwkfran0.fecvigenh And ;
		Mwkmedpre0.fecvigenh >= Mwkfran0.fecvigend 	;
		left Join mwkMedicoscar On ;
		mwkMedicoscar.Id = Mwkfran0.codmed ;
		group By nombre, fecha, Mwkfran0.hhmmdes, Mwkfran0.hhmmhas  ;
		into Cursor MwkControlMS0
	Select * From MwkControlMS0 Where !Isnull(nombre)  Into Cursor MwkControlMSS


	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and codambito = ?mxambito "
	Endif
	Select Mwkfran0.Id,Mwkfran0.codmed,Mwkfran0.nombre+Space(10) As nombre,Mwkfran0.fecha, Mwkfran0.horadesde;
		,Mwkfran0.horahasta, Min(entrada) As entrada, Max(salida) As salida;
		, Min(entradac) As entradac, Max(salidac) As salidac, reemplazo,tiposervicio,Mwkmedpre0.codesp ;
		,Mwkmedpre0.ESP_descripcion,Max(he) As he,Max(hs) As hs,Max(hec) As hec,Max(hsc) As hsc  ;
		,Mwkfran0.hhmmdes,Mwkfran0.hhmmhas,estructura,enreldep,demanda,generaagen,sala,cuil,nrolegajo ;
		,CodCargo ,Descrip,Mwkfran0.tturno,Mwkfran0.fecvigend,Mwkfran0.fecvigenh,Mwkfran0.diasem ;
		from Mwkfran0 ;
		left Join MwkControlM0 On ;
		MwkControlM0.codmed	= Mwkfran0.codmed And  ;
		MwkControlM0.fecha = Mwkfran0.fecha  And  ;
		MwkControlM0.diasem = Mwkfran0.diasem And  ;
		Mwkfran0.hhmmdes  	= MwkControlM0.hhmmdes And ;
		Mwkfran0.hhmmhas 	= MwkControlM0.hhmmhas And ;
		Mwkfran0.fecvigend 	<= MwkControlM0.fecha  And ;
		Mwkfran0.fecvigenh 	>= MwkControlM0.fecha ;
		left Join Mwkmedpre0 On ;
		Mwkmedpre0.codmed  = Mwkfran0.codmed   And ;
		Mwkmedpre0.diasem  = Mwkfran0.diasem   And ;
		Mwkmedpre0.hhmmdes = Mwkfran0.hhmmdes And ;
		Mwkmedpre0.hhmmhas = Mwkfran0.hhmmhas And ;
		Mwkmedpre0.fecvigend <= Mwkfran0.fecha And ;
		Mwkmedpre0.fecvigenh >= Mwkfran0.fecha ;
		left Join mwkMedicoscar On ;
		mwkMedicoscar.Id = Mwkfran0.codmed ;
		group By Mwkfran0.nombre, Mwkfran0.fecha, Mwkfran0.hhmmdes, Mwkfran0.hhmmhas ;
		into Cursor MwkControlMci
	
	Select * From MwkControlMci;
		union All;
		select * From MwkControlMSS ;
		where Id Not In (Select Id From MwkControlMci);
		into Cursor MwkControlM0

	Select * From mwkbloqueo Where codmed In (Select codmed From Mwkfran0) Into Cursor mwkbloqueomed

	If !Empty(vr_esp)
		Select * From MwkControlM0 Where codmed In (Select codmed From Mwkmedpre0) ;
			order By nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
			group By nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
			into Cursor MwkControlM1
	Else
		Select * From MwkControlM0  ;
			order By nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
			group By nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta ;
			into Cursor MwkControlM1

	Endif

Endif
