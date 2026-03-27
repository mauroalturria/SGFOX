*** controla que no haya una cuenta de internacion activa  
*	mprima = 4 alimentacion no puede cargar vales a internados
lparameters nroregi,mtipo,mprima
if vartype(mprima)#"N"
	mprima = 0
endif
rtnp = .f.
if mtipo = "AMB"
	nhoras = 0
	ccart = "AMBULATORIO"
ELSE
	nhoras = 0
	ccart = "GUARDIA"
endif	

do sp_busco_cta_activa with nroregi
if reccount ("mwkctainter")>0
	select mwkctainter
	mfech	= ctot(dtoc(PAC_fechaadmision)+" "+ttoc(PAC_horaadmision,2))
	if mwkfecserv.fechahora-mfech >3600* nhoras &&& se interno hace mas de xx horas no puede cargarle nada
		messagebox("PACIENTE INTERNADO... NO PUEDE CARGARLE VALES DE "+ccart,64,"Control de Ingreso")
		rtnp = .f.
		if mtipo = "GUA" and mprima # 4
			select * from mwkctasamb where PAC_tipopaciente= "GUA" ;
				order by PAC_fechaadmision,PAC_horaadmision into cursor mwkctasamb
			go bott
			mfec = alltrim(mwkctasamb.HIS_fechaadmision)
			if !empty(mfec)
				mifec = date(2000+val(left(mfec,2)),val(substr(mfec,3,2)),val(right(mfec,2)))
				if mifec = ttod(mwkfecserv.fechahora)
					if mifec -mwkctainter.PAC_fechaadmision>2 
						rtnp = .t.
					else
						rtnp = .f.
					endif
				else
					rtnp = .t.
				endif
			endif
		endif
	endif
endif
return rtnp
