****
** busco dieta
****
Parameter mfecha,nserv,madmision

madmi = madmision

If type('mbusco')#"C"
	mbusco=''
Endif
If type('ldiant')#"N"
	ldiant = 0
Endif
If type('lagrupa')#"N"
	lagrupa = 0
Endif
cgroupby = iif(lagrupa=0,'',' ,TND_codPrest ')

mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"

If  int(nserv/2)*2 <> nserv&& =3
	mdiaant = mfecha - 1
	mtipoant = nserv + 1
Else
	mdiaant = mfecha
	mtipoant = nserv - 1
Endif

mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, COB_codentidad " +;
	" ,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	", TabNutPaciente.*,sec_descripsec,PAC_fechaalta, pac_categoria " + ;
	", TabNutDetalle.ID,TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga " + ;
	", TND_observa,TND_fecBaja, TND_usuario,TND_Cantidad,TND_Hora as  horas " + ;
	", TNP_codfactu,TNP_factura,TNP_dieta, entidexclu.fecpasiva, sec_codsector "+;
	", PAC_codhci,Reg_numdocumento "+;
	" from TabNutPaciente inner join pacientes on TabNutPaciente.TNP_codadmision = pacientes .PAC_codadmision " + ;
	" inner join registracio on PAC_codhci  = registracio.reg_nroregistrac " + ;
	" inner join coberturas on pacientes.PAC_codadmision = coberturas .COB_pacientes "+;
	" left join TabNutDetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id" + ;
	" left join  entidexclu on coberturas .COB_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT'  " +;
	" inner join sectores on pacientes.PAC_sectorinternac = sectores .sec_codsector " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle .TND_codPrest" + ;
	" where TNP_Fecha= ?mfecha  and TNP_CodServ = ?nserv and TNP_codadmision = ?madmi" , "mwknutdieta1")

If mret<1
	=aerr(eros)
	Messagebox (eros(3))
Endif


	mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
		", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, COB_codentidad "+;
		", PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
		", TabNutPaciente.*,sec_descripsec,PAC_fechaalta, pac_categoria " + ;
		", TabNutDetalle.ID,TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga " + ;
		", TND_observa,TND_fecBaja, TND_usuario,TND_Cantidad,TND_Hora as  hora0 " + ;
		", TNP_codfactu,TNP_factura,TNP_dieta, entidexclu.fecpasiva, sec_codsector "+;
		", PAC_codhci,Reg_numdocumento  "+;
		" from TabNutPaciente inner join pacientes on TabNutPaciente .TNP_codadmision = pacientes .PAC_codadmision " + ;
		" inner join registracio on PAC_codhci  = registracio.reg_nroregistrac " + ;
		" left join coberturas on pacientes .PAC_codadmision = coberturas .COB_pacientes "+;
		" inner join TabNutDetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id" + ;
		" left join  entidexclu on coberturas .COB_codentidad = entidexclu.codent and entidexclu .tpopac = 'INT'  " +;
		" left outer join sectores on pacientes .PAC_sectorinternac = sectores .sec_codsector " + ;
		" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle .TND_codPrest" + ;
		" where TND_fecBaja= ?mfechanull  and TNP_Fecha= ?mfecha  and TNP_CodServ = 0 and TNP_codadmision = ?madmi "+;
		 " group by TNP_codadmision ,TND_codPrest ", "mwknutdieta2")

	If mret<1
		=aerr(eros)
		Messagebox (eros(3))
	Endif
	
	Select mwknutdieta1.*, mwknutdieta2.tnp_codfact as codfact, mwknutdieta2.tnp_observaciones as indicacion,ENT_descrient ;
		,nvl(hora0,2400) as hora0, nvl(horas,2400-2400) as horaserv;
		,nvl(mwknutdieta2.tnd_observa ,space(50)) as comentario;
		from mwknutdieta1 left join mwknutdieta2 on mwknutdieta1.TNP_codadmision = mwknutdieta2.TNP_codadmision ;
		left join mwkentidad on mwknutdieta1.cob_codentidad=ENT_codent ;
		where  ((mwknutdieta1.TNP_codserv = 0 and  mwknutdieta1.TND_codPrest>0) or mwknutdieta1.TNP_codserv>0) and ;
		mwknutdieta1.tnd_fecbaja = ctot("01/01/1900") or isnull(mwknutdieta1.tnd_fecbaja ) ;
		into cursor mwknutdieta

mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, cob_codentidad as pin_codentidad,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	",cob_codentidad,PAC_horaadmision ,pac_fechaalta, pac_categoria "+;
	" from pacientes " + ;
	" inner join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes "+;
	" where PAC_codadmision = ?madmi " , "mwkpacientes")
If mret<1
	=aerr(eros)
	Messagebox (eros(2))
Endif

Select PAC_habitacion +'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
	, proper(PAC_descripdiagn) as PAC_descripdiagn ;
	, PAC_fechaadmision, PAC_horaadmision , cob_codentidad as pin_codentidad;
	,PAC_codadmision , padr(prg_edad(PAC_fecnacimiento,mfecha,"AM"),20) as anios ;
	, mfecdia as TNP_Fecha ,0 as TNP_CodServ, space(50) as tnp_codfact, space(50) as TNP_codfactu;
	,space(50) as TNP_factura, space(200) as tnp_observaciones;
	,99999 as TNP_Usuario,space(200) as tnd_observa, 0 as TND_idPaciente,0 as TND_codPrest;
	,0 as TND_NroVale,dtot(mfecdia ) as TND_FHoraCarga,space(50) as pre_descriprest;
	,0 as TND_Cantidad ;
	,space(50) as sec_descripsec, "  " as pe, space(250) as indicacion,space(50) as codfact;
	,pac_fechaalta ,2400 as TND_Hora,space(250) as comentario, pac_categoria;
	, space(250) as adnutant, 0 as sec_codsector,0 as tnp_modi,PAC_fecnacimiento ;
	from mwkpacientes group by PAC_codadmision into cursor mwkpacinternad


	Select PAC_habitacion +'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
		, proper(PAC_descripdiagn) as PAC_descripdiagn ;
		, PAC_fechaadmision, PAC_horaadmision , cob_codentidad as pin_codentidad,PAC_codadmision ;
		,padr(prg_edad(PAC_fecnacimiento,mfecha,"AM"),20) as anios ;
		, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, tnp_observaciones;
		, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,pre_descriprest,TND_Cantidad ;
		,sec_descripsec, iif(isnull(mwknutdieta.fecpasiva),"  ","PE") as pe, indicacion,codfact,pac_fechaalta ;
		,iif(hora0>horaserv,hora0,horaserv) as TND_Hora,max(comentario) as comentario, pac_categoria;
		,"" as adnutant, sec_codsector ,tnp_modi,PAC_fecnacimiento ;
		,PAC_codhci,Reg_numdocumento ,dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pacfechaadmision ;
		from mwknutdieta ;
		left join mwkpres on TND_codPrest = pre_codprest ;
		order by sec_codsector,habitac, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
		group by habitac, PAC_codadmision ,TND_codPrest  ;
		into cursor mwkdieta

 