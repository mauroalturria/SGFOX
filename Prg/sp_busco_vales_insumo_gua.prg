****
** Busco todos los vales para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaser,noffice

do case
	case noffice = 1
		coff = " and guardia.protocolo in (select protocolo from guardia,prestacions "+;
			" where PRE_especialidad not in ('PEDI','GINE','OBST','TRAU')  and fechahoraing >= ?mfecdes "+;
			" and fechahoraing <= ?mfechas and codprest = pre_codprest ) "
	case noffice = 3
		coff = " and guardia.protocolo in (select protocolo from guardia,prestacions "+;
			" where PRE_especialidad = 'PEDI'  and fechahoraing >= ?mfecdes "+;
			" and fechahoraing <= ?mfechas and codprest = pre_codprest ) "
	otherwise
		coff = " and guardia.protocolo in (select protocolo from guardia,prestacions "+;
			" where PRE_especialidad in ('GINE','OBST','TRAU')  and fechahoraing >= ?mfecdes "+;
			" and fechahoraing <= ?mfechas and codprest = pre_codprest ) "
endcase
mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
	"VAL_codservvale, ser_descripserv,guardia.codmed as codmedg,guardiavale.codmed as codmedgv,  " + ;
	"nrovale,guardia.fechahoraate,guardiavale.diagnostico,codprest,descrip,codcie9   " + ;
	"from guardia,valesasist,guardiavale,servicios,tabtipoaltas    " + ;
	"where VAL_codvaleasist = nrovale " + mbuscaser +;
	" and guardia.protocolo = guardiavale.protocolo "+;
	" and VAL_codservvale = ser_codserv " + ;
	" and guardia.codestado 		= tabtipoaltas.id " + ;
	" and VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas " + coff +;
" group by VAL_codvaleasist,codprest,guardia.codmed ", "mwktodogua2")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
endif
if used("mwkMedicogua" )
	use in mwkMedicogua
endif
mret = SQLExec(mcon1,"SELECT id, nombre,codesp  FROM prestadores  " + ;
	" union  SELECT ID , nombre,'    ' as codesp  FROM TabMedExterno " + ;
	" where gerenciadora = 0 " , "mwkMedicogua0" )
if mret < 0
	=aerr(eros)
	messagebox(EROS(3), 48, "Validacion")
endif
if !used('mwkCiap2e')
	mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
		"DescrAbrev , Descripcion , Excluye , Incluye,fecanula from  TabCiap2E order by DescrAbrev ", "mwkCiap2e")
endif
select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, ;
	VAL_codservvale, ser_descripserv,codmedg as codmed,  ;
	nrovale,fechahoraate,diagnostico,codprest,descrip,codcie9    ;
	from mwktodogua2 where codmedg = codmedgv ;
	union select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, ;
	VAL_codservvale, ser_descripserv,iif(codmedg=1,codmedgv,codmedg) as codmed,  ;
	nrovale,fechahoraate,diagnostico,codprest,descrip,codcie9 ;
	from mwktodogua2 where codmedg # codmedgv into cursor mwktodogua1

select mwktodogua1.*,nombre,codesp,descripcion  from mwktodogua1 ;
	left join mwkMedicogua0 on codmed = mwkMedicogua0.id;
	left join mwkCiap2e on codcie9 = mwkCiap2e.id;
	into cursor mwktodogua
