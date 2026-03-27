****
** busco pacientes para nutricion
****

parameter mfecdia 

mfecdia = sp_busco_fecha_serv('DD')

mfechanull  = "1900-01-01 00:00:00"
*** Nutricion
mret = sqlexec(mcon3, "select PAC_codadmision "+;
	", TabNutPaciente.* " + ;
	", TabNutDetalle.* "+;
	" from TabNutPaciente left join pacientes on TNP_codadmision = PAC_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id" + ;
	" where TNP_Fecha< ?mfecdia and TNP_CodServ in (5,6) and TND_fecbaja = ?mfechanull " , "mwknutcam1")
if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
select PAC_codadmision , nvl(TNP_Fecha,mfecdia) as TNP_Fecha ,nvl(TNP_codadmision,0) as TNP_CodServ;
	, nvl(TNP_CodFact,'') as TNP_CodFact,nvl(TNP_Observaciones,'') as TNP_Observaciones;
	, nvl(TNP_Usuario, 0) as TNP_Usuario,nvl(TND_observa,space(50)) as TND_observa;
	, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,TND_cantidad,pre_descriprest;
	, TNP_factura,TNP_codfactu,TNP_dieta  ;
	from mwknutcam1 ;
	left join mwkpres on TND_codPrest = pre_codprest ;
	order by TNP_Fecha, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
	into cursor mwknutcd1

