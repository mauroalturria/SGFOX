****
** Busco todos los vales abiertos por prestacion para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaser
do sp_conexion
mfechactr = ctod("01/01/1900")
nosigue = .f.
mret = sqlexec(mcon1,'select * from TabPlanGua where '+;
	"VAL_fechasolicitud = ?mfechactr " ,'mwkctrl')

mfechactr = ttod( mwkctrl.fechahoraate )
if ( mfechas > mfechactr or mfecdes < ctod("01/09/2004") );
		and alltrim(mwkusuario.sector) # "SISTEMAS"
	nosigue = .t.
endif
cfecdes = prg_dtoc(mfecdes )
cfechas = prg_dtoc(mfechas + 1 )

mret = SQLExec(mcon1,"SELECT id, nombre  FROM prestadores  " + ;
	" union  SELECT ID , nombre FROM TabMedExterno " + ;
	" where gerenciadora = 0 " , "mwkMedicopg" )

mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest,PRE_codservicio  " + ;
	"from prestacions " + ;
	" ", "mwkpres")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_todos_los_vales_guardia1'
	cancel
endif
mret = sqlexec(mcon1, "select insumos as pre_codprest, INS_descriinsumo as pre_descriprest "+;
	" from insumos  " + ;
	"where INS_fechapasivo is null" , "mwkinsumos")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_todos_los_vales_guardia2'
	cancel
endif


if nosigue
	messagebox("ESE RANGO DE FECHAS SOLICITELO EN SISTEMAS"+ chr(13);
		+"HABILITADO DESDE 01/09/2004 HASTA "+dtoc(mfechactr), 16, "Validacion")
else
	if alltrim(mwkusuario.sector) = "SISTEMAS" or mfecdes > mfechactr
		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecdes)+" hasta:"+ transf(mfechas)+;
			" a las:"+ transf(datetime()),"", mwkusuario.idusuario, "Consulta"
		msecs = seconds()
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
			"COB_codentidad, pia_codprest, pia_cantsolicitada, PAC_nombrepaciente, PAC_codhce,VAL_codservvale  " + ;
			",ENT_descrient, ser_descripserv from presinsuvas, valesasist, pacientes, servicios, coberturas, entidades " + ;
			"where val_codpun = pia_valesasist and " + ;
			"VAL_codadmision = pacientes and VAL_codsector = 'GUA' and " +;
			"VAL_codservvale = ser_codserv and " + ;
			" VAL_codadmision = COB_pacientes and " + ;
			"COB_codentidad = ENT_codent and " + ;
			"VAL_fechasolicitud between ?mfecdes and ?mfechas " +  ;
			mbuscaser, "mwktodogua1")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_todos_los_vales_guardia3'
			cancel
		endif

		mret = sqlexec(mcon1, "select nrovale,guardia.fechahoraate,guardiavale.diagnostico, " + ;
			"guardia.codmed from guardia,guardiavale  " + ;
			"where guardia.protocolo = guardiavale.protocolo and " +;
			" fechahoraing >= ?cfecdes "+;
			" and fechahoraing <  ?cfechas ", "mwktodogua41")

		select nrovale,fechahoraate,diagnostico,nombre ;
			from mwktodogua41 left join mwkMedicopg on id = codmed ;
			into cursor mwktodogua4
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_todos_los_vales_guardia4'
			cancel
		endif

		select mwktodogua1.VAL_codvaleasist, PAC_nombrepaciente, PAC_codhce, 9, ;
			VAL_fechasolicitud,;
			padl(round(val(strtran(VAL_horasolicitud,'.', '')),0),4,"0") as VAL_horasolicituD, ;
			pia_codprest, pia_cantsolicitada, VAL_codservvale, ;
			COB_codentidad, ENT_descrient, ser_descripserv, nombre, fechahoraate,diagnostico ;
			from mwktodogua1,mwktodogua4 ;
			where mwktodogua1.VAL_codvaleasist = nrovale ;
			order by VAL_fechasolicitud, VAL_horasolicitud ;
			into cursor mwktodogua10

		select mwktodogua10.*, pre_descriprest+"     " as pre_descriprest  from mwktodogua10,mwkpres ;
			where 	pre_codprest = pia_codprest and VAL_codservvale <>5410 ;
			union 	select mwktodogua10.*, pre_descriprest from mwktodogua10,mwkinsumos ;
			where 	pre_codprest = pia_codprest and VAL_codservvale =5410 ;
			into cursor mwktodogua1

		select * from mwktodogua1 ;
			order by VAL_fechasolicitud, VAL_horasolicitud ;
			into cursor mwktodogua
*!*	msecs2 = seconds()
*!*	messagebox(transf(msecs2-msecs))
	else

		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecdes)+" hasta:"+ transf(mfechas)+;
			" a las:"+ transf(datetime()),"", mwkusuario.idusuario, "Consulta sin acceso"


		mret = sqlexec(mcon1,'select TabPlanGua.*'+;
			",ser_descripserv, nombre, ENT_descrient  " + ;
			' from tabplangua , servicios, entidades '+;
			" left outer join prestadores " + ;
			" on VAL_prestador = prestadores.id " + ;
			"where COB_codentidad = ENT_codent and " + ;
			"VAL_codservvale = ser_codserv and " + ;
			"VAL_fechasolicitud between ?mfecdes and ?mfechas  " + ;
			" and VAL_prestador <9999 " + mbuscaser, 'mwktodogua10')

		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_todos_los_vales_guardia5'
			cancel
		endif

		select mwktodogua10.*, pre_descriprest+"     " as pre_descriprest  from mwktodogua10,mwkpres ;
			where 	pre_codprest = pia_codprest and VAL_codservvale <>5410 ;
			union 	select mwktodogua10.*, pre_descriprest from mwktodogua10,mwkinsumos ;
			where 	pre_codprest = pia_codprest and VAL_codservvale =5410 ;
			into cursor mwktodogua1

		select * from mwktodogua1 ;
			order by VAL_fechasolicitud, VAL_horasolicitud ;
			into cursor mwktodogua

	endif
endif
if used ('mwkMedicopg')
	use in mwkMedicopg
endif