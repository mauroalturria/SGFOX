***
*** Generacion de planilla de Cancelaciones / Reprogramaciones
***
parameter mfecdes, mfechas, mbusco, mbuscom

mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas)

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret = sqlexec(mcon1,"select nombre,ESP_descripcion,"+;
	" cast(fecharep as date) as lfecha "+;
	" FROM turnosreprog,prestadores,especialid"+;
	" where &mccpoamb prestadores.id = turnosreprog.codmed"+;
	" and esp_codesp = prestadores.codesp"+;
	" and turnosreprog.fecharep >= ?mfecd"+;
	" and turnosreprog.fecharep <= ?mfech"+;
	" and turnosreprog.codmedrepro = 0 " + mbusco + mbuscom,"mwklista")

if mret > 0
	if used('mwklista')
		if reccount('mwklista')>0
			select *, count(*) as lcancela ;
				from mwklista group by nombre,lfecha ;
				order by nombre,lfecha into cursor mwklista
		endif
	endif
else
	messagebox("EN CONSULTA DE CANCELACION/REPROGRAMACION DE TURNOS",16,"ERROR")
endif
