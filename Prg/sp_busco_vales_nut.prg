****
** busco pacientes para nutricion
****

parameter mcodadm,nserv,ltodos,mfecdia,lvarios
if type ('ltodos') # "N"
	ltodos = 0
endif
cbaja = ''
lvarios = iif(vartype(lvarios)#"N",0,lvarios)
if ltodos = 0
	cbaja = "and tnd_fecbaja = ?mfechanull " 
endif
cfecha = ' = ?mfecdia '
if lvarios = 1
	cfecha = ' >= ?mfecdia '
endif
if type ('mfecdia') # "D"
	mfecdia = sp_busco_fecha_serv('DD')
endif
mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
	" from prestacions " + ;
	" where pre_codservicio=9400 and PRE_fechapasiva is null " , "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
mfechanull  = "1900-01-01 00:00:00"
*** Nutricion
mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, pin_codentidad,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	", TabNutPaciente.* " + ;
	", TabNutDetalle.* ,tnp_fecimp,TNP_codfactu,TNP_factura,TNP_dieta "+;
	" from pacinternad inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	" left join habitacions on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	" inner join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision" + ;
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest" + ;
	" inner join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	" where PAC_codadmision = ?mcodadm and TNP_Fecha "+cfecha  + cbaja , "mwknutcam1")
if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
select PAC_codadmision , nvl(TNP_Fecha,mfecdia) as TNP_Fecha ,nvl(TNP_CodServ,0) as TNP_CodServ;
	, nvl(TNP_CodFact,'') as TNP_CodFact,nvl(TNP_Observaciones,'') as TNP_Observaciones;
	, nvl(TNP_Usuario, 0) as TNP_Usuario,nvl(TND_observa,space(50)) as TND_observa;
	, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,TND_cantidad,pre_descriprest;
	, TNP_factura,TNP_codfactu,TNP_dieta,tnd_fecbaja ,nvl(TND_Usuario, 00000) as TND_Usuario,tnp_fecimp  ;
	from mwknutcam1 ;
	left join mwkpres on TND_codPrest = pre_codprest ;
	WHERE ((TNP_codserv = 0 and  TND_codPrest>0) or TNP_codserv>0) ;
	order by TNP_Fecha, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
	into cursor mwknutcd1
