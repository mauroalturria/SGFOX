****
** Busco todos los vales abiertos por prestacion para estadistica de guardia
***
public mcon1
Ldisconnec = .F.
if !used("mwkserver1")
	DO sp_conexion
	Ldisconnec = .t.
ENDIF
mfecdes = Ctod("01/06/2006")
mfechas = Ctod("30/06/2006")
cfd = prg_dtoc(mfecdes)
cfh = prg_dtoc(mfechas+ 1 )

mfechastop = dtot(mfechas )
mtime1 = seconds()
mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud,"+;
	" VAL_horasolicitud, pia_codprest, pia_cantsolicitada, "+;
	"VAL_bono  " + ;
	"from presinsuvas, valesasist " + ;
	"where valesasist = pia_valesasist and " + ;
	"VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;
	"VAL_codsector = 'GUA' " +;
	"", "mwktodogua20")


mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest " + ;
	"from prestacions " + ;
	" ", "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
select * from mwktodogua20,mwkpres ;
	where 	pre_codprest = pia_codprest ;
	into cursor mwktodogua2

mtime1 = seconds()- mtime1
*			"VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;

if mret < 0
	=aerr(eros)
	if eros(1) = 1526 and eros(5) = 400
		messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
	else
		messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	endif
else

	mtime2 = seconds()
	mret = sqlexec(mcon1, "select VAL_codvaleasist, PAC_nombrepaciente, PAC_codhce " + ;
		"from valesasist, pacientes " + ;
		"where VAL_codadmision = pacientes and " + ;
		"VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;
		"VAL_codsector = 'GUA' " + ;
		"", "mwktodogua1")
	mtime2 = seconds()- mtime2

	if mret < 0
		=aerr(eros)
		if eros(1) = 1526 and eros(5) = 400
			messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
		else
			messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		endif
	else

		mtime3 = seconds()
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_codservvale, COB_codentidad, ENT_descrient, " + ;
			"ser_descripserv, VAL_prestador " + ;
			"from servicios, coberturas, entidades, " + ;
			"valesasist "+;
			"where VAL_codadmision = COB_pacientes and " + ;
			"COB_codentidad = ENT_codent and " + ;
			"VAL_codservvale = ser_codserv and " + ;
			"VAL_fechasolicitud between ?mfecdes and ?mfechas and " + ;
			"VAL_codsector = 'GUA' "  + ;
			"", "mwktodogua3")
		mtime3 = seconds() -mtime3

		if mret < 0
			=aerr(eros)
			if eros(1) = 1526 and eros(5) = 400
				messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
			else
				messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
			endif
		else

			mtime4 = seconds()
			mret = sqlexec(mcon1, "select nrovale,guardia.fechahoraate,guardiavale.diagnostico,guardia.protocolo,nombre,guardia.codmed   " + ;
				"from guardiavale left join guardia on guardia.protocolo = guardiavale.protocolo " +;
				"  "+;
				" left join prestadores on guardia.codmed = prestadores.id  " + ;
				"where  fechahoraing >= ?cfd "+;
				" and fechahoraing < ?cfh " + ;
				" group by nrovale,guardia.codmed,guardia.protocolo ", "mwktodogua4")
			mtime4 = seconds()-mtime4

			if mret < 0
				=aerr(eros)
				if eros(1) = 1526 and eros(5) = 400
					messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
				else
					messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				endif
			else

				select mwktodogua1.VAL_codvaleasist, PAC_nombrepaciente, PAC_codhce, 9, ;
					VAL_fechasolicitud, round(val(strtran(VAL_horasolicitud,'.', '')),0) as VAL_horasolicitud, ;
					pia_codprest, pia_cantsolicitada, pre_descriprest, VAL_codservvale, codmed as VAL_prestador, ;
					COB_codentidad, ENT_descrient, ser_descripserv, nombre, fechahoraate,diagnostico,nrovale,protocolo,VAL_bono  ;
					from mwktodogua1, mwktodogua2, mwktodogua3, mwktodogua4 ;
					where mwktodogua1.VAL_codvaleasist = mwktodogua2.VAL_codvaleasist and ;
					mwktodogua1.VAL_codvaleasist = mwktodogua3.VAL_codvaleasist and ;
					mwktodogua1.VAL_codvaleasist = nrovale ;
					order by VAL_fechasolicitud, VAL_horasolicitud ;
					into cursor mwktodogua

			endif
		endif
	endif
endif

*!*	messagebox("tiempo"+str(mtime1+mtime2+mtime3+mtime4)+chr(13)+"tiempo1"+;
*!*		str(mtime1)+chr(13)+"tiempo2"+str(mtime2)+chr(13)+"tiempo3"+str(mtime3);
*!*		+chr(13)+"tiempo4"+str(mtime4))


mret = sqlexec(mcon1,'select * from TabPlanGua where '+;
	"VAL_fechasolicitud between ?mfecdes and ?mfechas " ,'mwkctrl')
if reccount('mwkctrl')>0
	mret = sqlexec(mcon1,'DELETE from TabPlanGua '+;
		" where VAL_fechasolicitud between ?mfecdes and ?mfechas " )
endif

select mwktodogua

scan
	mVAL_fechasolicitud = mwktodogua.VAL_fechasolicitud
	mCOB_codentidad = mwktodogua.COB_codentidad
	mPAC_codhce = mwktodogua.PAC_codhce
	mPAC_nombrepaciente = mwktodogua.PAC_nombrepaciente
	mPIA_cantsolicitada = mwktodogua.PIA_cantsolicitada
	mPIA_codprest = mwktodogua.PIA_codprest
	mVAL_codservvale = mwktodogua.VAL_codservvale
	mVAL_codvaleasist = mwktodogua.VAL_codvaleasist
	mVAL_horasolicitud = mwktodogua.VAL_horasolicitud
	mVAL_prestador = mwktodogua.VAL_prestador
	mdiagnostico = nvl(mwktodogua.diagnostico,'')
	mfechahoraate = mwktodogua.fechahoraate
	mnrovale = nrovale
	mprotocolo = protocolo
	mVAL_bono = VAL_bono

	mret = sqlexec(mcon1,"insert into TabPlanGua ( VAL_fechasolicitud,COB_codentidad," + ;
		'PAC_codhce,PAC_nombrepaciente,PIA_cantsolicitada,PIA_codprest,' + ;
		'VAL_codservvale,VAL_codvaleasist,VAL_horasolicitud,VAL_prestador,' + ;
		'diagnostico,fechahoraate,nrovale,protocolo,VAL_bono ) values ' + ;
		'( ?mVAL_fechasolicitud, ?mCOB_codentidad,' + ;
		' ?mPAC_codhce, ?mPAC_nombrepaciente, ?mPIA_cantsolicitada, ?mPIA_codprest,' + ;
		' ?mVAL_codservvale, ?mVAL_codvaleasist, ?mVAL_horasolicitud, ?mVAL_prestador,' + ;
		' ?mdiagnostico, ?mfechahoraate, ?nrovale, ?protocolo, ?VAL_bono )' )
endscan

IF Ldisconnec
	DO sp_desconexion WITH "planilla guardia"
ENDIF
