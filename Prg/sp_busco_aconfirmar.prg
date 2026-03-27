*****************************
*** sp_busco_aconfirmar
*** Claudia Antoniow Torrico
*** Fecha :18/11/2004
*****************************
mfecnul = CTOD("01/01/1900")

mret=sqlexec(mcon1," SELECT TRA.id,confirmado, TRA.nombre,TRA.codmed, Pres.nombre as nombreMed, "+;
	" idfranja, TRA.fvigend, TRA.fvigenh, "+;
	" TRA.horadesde, TRA.horahasta, TRA.hhmmdes, TRA.hhmmhas, "+;
	" FrHr.horadesde, FrHr.horahasta, FrHr.hhmmdes, FrHr.hhmmhas, "+;
	" FrHr.diasem, FrHr.fecvigend, FrHr.fecvigenh "+;
	" FROM TabReemplazoAmb as Tra, prestadores as Pres, franjahoraria as FrHr "+;
	" WHERE fecpasivap = ?mfecnul and TRA.codmed=Pres.id and idfranja=FrHr.id "+;
	" and confirmado ='SIN CONFIRMAR'","MWKSINCONFIRMAR")
if mret < 0
	messagebox('ERROR DE CONEXION, AVISAR A SISTEMAS',16,'VALIDACION')
	mret=0
	do prg_cancelo
else

	mret=sqlexec(mcon1," SELECT TBA.id,confirmado,"+;
		" Pres.nombre,TBA.codmed, TRA.nombre as nombreMed, "+;
		" TBA.idfranja, TBA.fvigend, TBA.fvigenh, "+;
		" TBA.horadesde, TBA.horahasta, TBA.hhmmdes, TBA.hhmmhas, "+;
		" FrHr.horadesde, FrHr.horahasta, FrHr.hhmmdes, FrHr.hhmmhas, "+;
		" FrHr .diasem, FrHr .fecvigend, FrHr .fecvigenh "+;
		" FROM prestadores as Pres,TabbloqueoAmb as TBA "+;
		" left join franjahoraria as FrHr on FrHr.id= TBA.idfranja "+;
		" left join TabreemplazoAmb as TRA on TBA.idfranja = TRA.idfranja"+;
		" WHERE fecpasivap = ?mfecnul and Pres.id=TBA.codmed and reemplazo =2 and TRA.confirmado ='SIN CONFIRMAR' "+;
		" group by TBA.codmed","MWKSINCONFIRMAR1")
	if mret < 0
		messagebox('ERROR DE CONEXION, AVISAR A SISTEMAS',16,'VALIDACION')
		mret=0
		do prg_cancelo
	else
		select * from MWKSINCONFIRMAR1;
			where codmed not in (select codmed from MWKSINCONFIRMAR;
			group by codmed) into cursor MWKSINCONFIRMAR2
	endif

	select codmed, nombremed,iif(diasem=2,'Lun',;
		iif(diasem=3,'Mar',iif(diasem=4,'Mie',;
		iif(diasem=5,'Jue',iif(diasem=6,'Vie',iif(diasem=7,'Sab','Dom')))))) as diasem,;
		ttoc(horadesde,2) as horadesde,ttoc(horahasta,2) as horahasta,;
		fecvigend, fecvigenh, id from MWKSINCONFIRMAR;
		union;
		select codmed, nombremed,iif(diasem=2,'Lun',;
		iif(diasem=3,'Mar',iif(diasem=4,'Mie',;
		iif(diasem=5,'Jue',iif(diasem=6,'Vie',iif(diasem=7,'Sab','Dom')))))) as diasem,;
		ttoc(horadesde,2) as horadesde,ttoc(horahasta,2) as horahasta,;
		fecvigend, fecvigenh, id from MWKSINCONFIRMAR2 into cursor mwkSinConf

endif
