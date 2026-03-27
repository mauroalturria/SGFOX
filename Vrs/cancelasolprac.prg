Do sp_conexion
set step on
mtot = reccount('tabsolprac')
Select tabsolprac
locate for asp_nroregistrac= 2868724
Do while !eof('tabsolprac')
	mregistracio  = asp_nroregistrac
	wait windows transform(recno())+" / "+transform(mtot) nowait
	Select * from tabsolprac where asp_nroregistrac = mregistracio  into cursor solic
*!*		select * from vista5 where pac_codhci=mregistracio  ;
*!*		into cursor mwkconsumos2
	mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud, " + ;
		"VAL_codvaleasist, VAL_nroprotocolo,val_prestador,val_codservvale " + ;
		",pia_codprest,"+;
		"val_codpun,VAL_OperadorCarga,val_nrointfactura,VAL_estado "+;
		"from histambgua, presinsuvas, valesasist " + ;
		"where his_codadmision = VAL_codadmision and  val_codservvale <>5410 and  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST  and " + ;
		"his_nroregistrac = ?mregistracio  and VAL_fechasolicitud >to_date('01/01/2021','dd/mm/yyyy') " , "mwkconsumos2")
	If mret<1
		Set step on
	Endif
	If reccount('mwkconsumos2')>0
		Select solic.* from mwkconsumos2,solic where pia_codprest=asp_codprest and VAL_fechasolicitud>=asp_fechasol;
		group by solic.id into cursor realizados
		If reccount('realizados')>0
			If used('mwkbajar')
				Select * from mwkbajar union all select * from realizados into cursor mwkbajar
			Else
				Select * from realizados into cursor mwkbajar
			Endif
		Endif
	Endif
	Select tabsolprac
	Do while !eof() and mregistracio  = asp_nroregistrac
		Skip
	Enddo
Enddo
Do sp_desconexion
*pdate tabsolprac set asp_codestado = 2 where id in ( select id from mwkbajar)
