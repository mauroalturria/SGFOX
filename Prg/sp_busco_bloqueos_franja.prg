*
* Bloqueos de una franja (todos los profesionales)
*
Lparameters mfecdes,mfechas,mbloqueo

If vartype(mfecdes) # "D"
	mfecdes = sp_busco_fecha_serv("DD")
Endif
If vartype(mfechas) # "D"
	mfechas = sp_busco_fecha_serv("DD")
Endif
IF VARTYPE(mbloqueo) # "N"
    mbloqueo = 0
ENDIF

If used('mwkexisteBloq')
	Use in mwkexisteBloq
Endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and FranjaHoraria.codambito = ?mxambito "
endif

mret=sqlexec(mcon1,"SELECT tabbloqueoamb.codmed,fvigend,fvigenh,diasem,"+;
	" tabbloqueoamb.horadesde,tabbloqueoamb.horahasta,"+;
	" FranjaHoraria.hhmmdes,FranjaHoraria.hhmmhas"+;
	" FROM tabbloqueoamb join franjahoraria"+;
	" ON tabbloqueoamb.idfranja = franjahoraria.id" +;
	" WHERE fvigend <= ?mfechas and fvigenh >= ?mfecdes "+;
	" and bloqAnulado = ?mbloqueo"+mccpoamb +;
	" and fecvigend <= ?mfechas and fecvigenh > ?mfecdes "+;
	" and fecvigenh <> fecvigend ","mwkexisteBloq")

select codmed,fvigend,fvigenh,diasem,horadesde,horahasta;
	,hour(horadesde)*100+minute(horadesde) as hhmmdes;
	,hour(horahasta)*100 + minute(horahasta)  as hhmmhas ;
	from mwkexisteBloq into cursor mwkbloqueo
	
If mret < 0
	Messagebox("ERROR EN CONSULTA DE TURNOS BLOQUEADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
