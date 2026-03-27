****
** Busco todos los vales abiertos por prestacion para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaent, mbuscaserv, mtipopac,selserv
mcserv = " VAL_codsector = ?mtipopac "
mfiltro = ''
if mtipopac = "INT"
	mcserv = " VAL_codsector not in ('AMB','GUA') "
	mfiltro = " where pre_codprest <> 42020102 "

endif
mfecbaja= ctod("01/01/1900") 
*!*	mret = sqlexec(mcon1, "select codent,modalidad from EntidModalidad where fecbaja = ?mfecbaja", "mwkmensaje") 
*!*	select codent,left(modalidad,30) as tipoent from mwkmensaje into cursor mwktipoent 	

mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_codservvale, COB_codentidad "+ ;
	",VAL_fechasolicitud , pia_codprest, pia_cantsolicitada,pia_codinsumo " + ;
	", ENT_descrient,ENT_nroprestadorexterno, ser_descripserv, pia_secuen_carga,ent_tipo " + ;
	"from  presinsuvas,coberturas, entidades,valesasist,pacientes   " + ;
	"left outer join servicios on valesasist.VAL_codservvale = servicios.ser_codserv " + ;
	" where  VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;
	" valesasist = pia_valesasist and "+;
	" VAL_codadmision = COB_pacientes and "+;
	" COB_codentidad = ENT_codent and " + ;
	" VAL_codadmision = pac_codadmision and "+;
	iif(selserv=1," VAL_codservvale <> 5410 and ","")+ mcserv  + ;
	mbuscaserv+ mbuscaent  , "mwktodogua0")
if mret < 0
	=aerr(eros)
	if eros(1) = 1526 and eros(5) = 400
		messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
	else
		messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	endif
else
	mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest,PRE_especialidad   " + ;
			"from prestacions " + mfiltro , "mwkpres")
	if mret<1
		=aerr(eros)
		messagebox(eros(2))
	endif
	mret =	sqlexec(mcon1, "select INS_codpuntero as pre_codprest,INS_descriinsumo as pre_descriprest,cast('FARM' as char(4)) as  PRE_especialidad   " + ;
			" from Insumos "  , "mwkins")
	if mret<1
		=aerr(eros)
		messagebox(eros(2))
	endif
	select * from mwktodogua0,mwkpres ;
			where 	pre_codprest = pia_codprest and val_codservvale # 5410;
			into cursor mwktodoguap

	select mwktodogua0.*,pre_codprest,left(pre_descriprest,45) as pre_descriprest,PRE_especialidad;
	    from mwktodogua0,mwkins ;
		where 	pre_codprest = pia_codinsumo and val_codservvale = 5410 ;
			into cursor mwktodogua2
	if reccount('mwktodogua2')>0
		select * from mwktodogua2 union all select * from mwktodoguap into cursor mwktodogua
	else
		select * from mwktodoguap into cursor mwktodogua
	endif		
	if mtipopac="INT"
		select distinct * from mwktodogua ;
		where VAL_codservvale not in ( 130, 1200, 5180);
		into cursor mwktodoguaint

		use in mwktodogua 		

		use dbf('mwktodoguaint') again in 0 alias mwktodogua 
		update mwktodogua set VAL_codservvale = 8900 ;
			,ser_descripserv = 'INTERCONSULTAS DE INTERNACION';
			where left(alltrim(STR(pia_codprest,16,0)),6) = "420303"
		
	endif

	select sum(pia_cantsolicitada) as cantidad, * from mwktodogua   ;
		group by pia_codprest, COB_codentidad,VAL_codservvale,PRE_especialidad ;
		order by COB_codentidad,pia_codprest ;
		into cursor mwkconsulta
endif