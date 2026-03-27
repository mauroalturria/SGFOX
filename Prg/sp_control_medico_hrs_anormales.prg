****************************
**** Autor:Claudia Antoniow
**** Fecha:25/09/2003 mwkmed01.id
****************************
Parameter vr_fecha1, vr_fecha2, vr_med, vr_esp, mtole, mtols, mbuscot, mbuscom

mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
If vartype('mbuscot') <> 'C'
	mbusco2= ''
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
		mbusco2 = iif(!isblank(vr_med), " AND a.codmed=?vr_med ","")
	Endif

Else

	mbusco2  = mbuscot
	mbusco2a = ''

	If vartype(mbuscom) = 'C'
		If !Empty(mbuscom)
			mbusco2a = mbuscom
		Endif
	Endif

Endif

mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tiposervicio "+;
	" from franjahoraria as a "+;
	" where diasem > 0 "+ ;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb+;
	" group by codmed, diasem, fecvigenh, hhmmdes,tipoturno ","Mwkfran0")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif

qbusco = iif(empty(mbusco2), '',strtran(mbusco2 ,'a.','medpresta.'))

mret = sqlexec(mcon1, " select diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,nombre as nn,generaagen,sala,codmed as cm " +;
	" from  especialid,medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+mccpoamb+;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif

&&Tardes
mret=sqlexec(mcon1, " SELECT a.nombre,fecha, horadesde ,horahasta, "+;
	" trim(CASE WHEN entsal=1 THEN fechahora ELSE '01/01/1900 00:00:00' END) as entrada, "+;
	" '01/01/1900 00:00:00' as salida,  "+;
	" b.nombre as reemplazo,ide,a.codmed "+;
	" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
	" WHERE entsal=1 "+;
	" AND a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2a +mccpoamb+;
	" ORDER by fecha,horadesde,horahasta,a.codmed ","MWKLLTardes")

If mret < 0
	mret = 0
	Messagebox('ERROR DE GENERACION DE CURSOR 1, AVISAR A SISTEMAS',16,'VALIDACION')
	Cancel
ELSE
    &&Salidas
	mret=sqlexec(mcon1, " SELECT a.nombre,fecha, horadesde,horahasta, "+;
		" '01/01/1900 00:00:00' as entrada, "+;
		" trim(CASE WHEN entsal=2 THEN fechahora ELSE '01/01/1900 00:00:00' END) as salida,  "+;
		" b.nombre as reemplazo,ide,a.codmed "+;
		" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
		" WHERE entsal=2 "+;
		" AND a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2a +mccpoamb+;
		" ORDER by fecha,horadesde,horahasta,a.codmed ","MWKSalidas")
	If mret < 0
		mret = 0
		Messagebox('ERROR DE GENERACION DE CURSOR 2, AVISAR A SISTEMAS',16,'VALIDACION')
		Cancel
	ELSE
	    &&Ausentes
		mret=sqlexec(mcon1, " SELECT a.nombre,a.fecha, a.horadesde, a.horahasta, "+;
			" '01/01/1900 00:00:00' as entrada, '01/01/1900 00:00:00' as salida, "+;
			" 'SIN REGISTRO' as reemplazo,id as ide, codmed "+;
			" FROM horarioConsulE as a "+;
			" WHERE a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2a +mccpoamb +;
			" AND a.id not in (select ide from horarioConsuld "+;
			" WHERE {fn convert (fechahora , sql_date)} between ?vr_fecha1 and ?vr_fecha2 "  +;
			" GROUP BY ide)"+;
			" ORDER BY fecha, horadesde, horahasta, codmed ","MWKAusentes")
		If mret < 0
			mret = 0
			Messagebox('ERROR DE GENERACION DE CURSOR 3, AVISAR A SISTEMAS',16,'VALIDACION')
			Cancel
		Else
			Select a.nombre,a.fecha, a.horadesde,a.horahasta, allt(a.entrada) as entrada,;
				iif(isnull(b.salida),'01/01/1900 00:00:00',b.salida) as salida,;
				allt(a.reemplazo)as reemplazo,a.codmed ;
				from MWKLLTardes as a left outer join MWKSalidas as b on a.ide = b.ide ;
				union all;
				select b.nombre, b.fecha, b.horadesde, b.horahasta, ;
				iif(isnull(a.entrada),'01/01/1900 00:00:00',allt(a.entrada)) as entrada, ;
				b.salida, allt(b.reemplazo) as reemplazo,b.codmed ;
				from MWKSalidas as b left outer join MWKLLTardes as a on b.ide = a.ide ;
				into cursor MwkControl

			Select nombre, fecha, horadesde, horahasta, entrada, allt(salida) as salida, ;
				reemplazo,codmed;
				from MwkControl;
				where substr(ttoc(horadesde+mtole*60,2),1,5) < substr(entrada,12,5);
				or entrada = '01/01/1900 00:00:00';
				union all;
				select nombre, fecha, horadesde, horahasta, entrada, allt(salida) as salida, ;
				reemplazo,codmed;
				from MwkControl;
				where substr(ttoc(horahasta - mtols *60,2),1,5) > substr(salida,12,5);
				or salida = '01/01/1900 00:00:00';
				union ;
				select nombre, fecha, horadesde, horahasta, allt(entrada),allt(salida),;
				allt(reemplazo) as reemplazo,codmed;
				from MWKAusentes;
				into cursor MwkControlM

			Select nombre, fecha, horadesde, horahasta, entrada, allt(salida) as salida, ;
				reemplazo,dow(fecha) as diasemana,;
				hour(horadesde)*100+minute(horadesde) as hhmmd,hour(horahasta)*100+minute(horahasta) as hhmmh,codmed;
				from MwkControlM;
				group by nombre, fecha, entrada, salida;
				into cursor MwkControl01
			Do sp_busco_bloqueos_franja with vr_fecha1, vr_fecha2
			mccpoamb = ''
			if mxambito >1
				mccpoamb = "  and codambito = ?mxambito "
			endif

			Select nombre, fecha, MwkControl01.horadesde, MwkControl01.horahasta, entrada, allt(salida) as salida, ;
				reemplazo,tiposervicio,codesp ,ESP_descripcion;
				,CodCargo ,descrip,mwkbloqueo.horadesde as hdb ,mwkbloqueo.horahasta as hhb;
				from MwkControl01 ;
				left join Mwkfran0 on (;
				MwkControl01.codmed	= Mwkfran0.codmed and  ;
				diasemana = Mwkfran0.diasem and ;
				Mwkfran0.hhmmDes 	= MwkControl01.hhmmd and ;
				Mwkfran0.hhmmHas 	= MwkControl01.hhmmh and ;
				Mwkfran0.fecvigend 	<= MwkControl01.fecha and ;
				Mwkfran0.fecvigenh 	>= MwkControl01.fecha);
				left join Mwkmedpre0 on ( ;
				MwkControl01.codmed	= cm and  ;
				Mwkmedpre0.diasem 	= diasemana and ;
				hhmmd 	>= Mwkmedpre0.hhmmDes and ;
				hhmmh 	<= Mwkmedpre0.hhmmHas and ;
				fecha >= Mwkmedpre0.fecvigend and ;
				fecha <= Mwkmedpre0.fecvigenh );
				left join mwkMedicoscar on MwkControl01.codmed = mwkMedicoscar.id;
				left join mwkbloqueo on (;
				MwkControl01.codmed	= mwkbloqueo.codmed and  ;
				diasemana  = mwkbloqueo.diasem and ;
				hhmmh  >=	mwkbloqueo.hhmmDes and ;
				hhmmd  <= mwkbloqueo.hhmmHas and ;
				MwkControl01.fecha 	>= mwkbloqueo.fvigend and ;
				MwkControl01.fecha	<= mwkbloqueo.fvigenh);
				WHERE mwkbloqueo.codmed is null ;
				group by nombre, fecha, entrada, salida;
				order by nombre, fecha, MwkControl01.horadesde, MwkControl01.horahasta;
				into cursor MwkControlM1

			If !Empty(vr_esp)
				Select * from MwkControlM1 where codmed in (select codmed from Mwkmedpre0) into cursor MwkControlM1
			Endif

		Endif
	Endif
Endif
