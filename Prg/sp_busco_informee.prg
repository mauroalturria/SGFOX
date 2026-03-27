****
**** Busco informes en un estado determinado  // && fechainforme = to_date('20/06/2006','dd/mm/yyyy') and
****
Parameters mifiltro,mopcion

If vartype(mopcion)#"N"
	mopcion = 1
Endif

mret = sqlexec(mcon1," select id as idprest,nombre from prestadores ", "mwkprestadores" )

mifechafiltro = ctod("05/05/2008")
*mifechafiltro = ctod("02/01/2007")
mifiltro = mifiltro + iif(at("estadoinforme = 3",mifiltro)>0,;
		" and fechaAprobacion >= ?mifechafiltro ","")
do case
case mopcion = 1
	mret = sqlexec(mcon1," select nroprotocolo,nrovale,fechainforme,pac_nombrepaciente,pre_descriprest, " + ;
		" val_prestador,informes.id,codservvale,VAL_tipopaciente,estadoinforme,val_fechasolicitud,Tabestados.Descrip    " + ;
		" FROM informes,prestacions,valesasist,pacientes,Tabestados " + ;
		" where pre_codprest = codprest and val_codpun = codpun  and "+;
		" propietario = 10 and estado = estadoinforme and "+;
		" pac_codadmision  = val_codadmision and "+ mifiltro ,"mwkInformes")

case mopcion = 9

	mret = sqlexec(mcon1," select nroprotocolo,nrovale,fechainforme,pac_nombrepaciente,pre_descriprest, " + ;
		" val_prestador,informes.id,codservvale,VAL_tipopaciente,estadoinforme,val_fechasolicitud,Tabestados.Descrip    " + ;
		",PAC_codhci,TabProtocolo.tpobserva,TabProtocolo.tpestado"+;
		" FROM informes,prestacions,valesasist,pacientes,Tabestados " + ;
		" left join TabProtocolo on TabProtocolo.tpestado=?mopcion "+;
		" and TabProtocolo.tpprotocolo = informes.nroprotocolo"+;
		" where pre_codprest = codprest and val_codpun = codpun  and "+;
		" propietario = 10 and estado = estadoinforme "+;
		" pac_codadmision  = val_codadmision and "+ mifiltro ,"mwkInformes")

endcase
If mret<1
	=aerr(eros)
	Messagebox(eros(2))
Endif

