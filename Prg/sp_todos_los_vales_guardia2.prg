****
** Busco todos los vales para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaser

mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
	"VAL_codservvale, ser_descripserv,guardia.codmed as codmedg,guardiavale.codmed as codmedgv,  " + ;
	"nrovale,guardia.fechahoraate,guardiavale.diagnostico,codprest,descrip,codcie9,nroregistrac  " + ;
	"from guardia,valesasist,guardiavale,servicios,tabtipoaltas    " + ;
	"where VAL_codvaleasist = nrovale " + mbuscaser +;
	" and guardia.protocolo = guardiavale.protocolo "+;
	" and VAL_codservvale = ser_codserv " + ;
	" and guardia.codestado 		= tabtipoaltas.id " + ;
	" and VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas " + ;
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
 DO sp_tablas_cie
endif
select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, ;
	VAL_codservvale, ser_descripserv,codmedg as codmed,  ;
	nrovale,fechahoraate,diagnostico,codprest,descrip,codcie9,nroregistrac     ;
	from mwktodogua2 where codmedg = codmedgv ;
	union select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, ;
	VAL_codservvale, ser_descripserv,iif(codmedg=1,codmedgv,codmedg) as codmed,  ;
	nrovale,fechahoraate,diagnostico,codprest,descrip,codcie9,nroregistrac ;
	from mwktodogua2 where codmedg # codmedgv into cursor mwktodogua1

select mwktodogua1.*,nombre,codesp,descripcion  from mwktodogua1 ;
	left join mwkMedicogua0 on codmed = mwkMedicogua0.id;
	left join mwkCiap2e on codcie9 = mwkCiap2e.id;
	into cursor mwktodogua