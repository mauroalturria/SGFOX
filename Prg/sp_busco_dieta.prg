****
** busco dieta
****
Parameter mfecha,nserv,mbusco,ldiant,lagrupa

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
If !used("mwkentidad")
	Do sp_entidades
Endif
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
	" where TNP_Fecha= ?mfecha  and TNP_CodServ = ?nserv "+ mbusco , "mwknutdieta1")

If mret<1
	=aerr(eros)
	Messagebox (eros(3))
Endif

If nserv>0
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
		" where TND_fecBaja= ?mfechanull  and TNP_Fecha= ?mfecha  and TNP_CodServ = 0 "+;
		mbusco + " group by TNP_codadmision &cgroupby", "mwknutdieta2")

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

	Select * from mwknutdieta2 where PAC_codadmision not in (select PAC_codadmision;
		from mwknutdieta) into cursor mwknutdietaSD

	If reccount('mwknutdietaSD')>0 and nserv <5
	
		Select PAC_habitacion, PAC_cama,PAC_nombrepaciente ,PAC_fechaadmision, PAC_descripdiagn ;
			, PAC_horaadmision , cob_codentidad ,PAC_codadmision,PAC_edad,PAC_fecnacimiento  ;
			, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, tnp_observaciones;
			, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga;
			,TND_Cantidad,sec_descripsec, fecpasiva, pac_fechaalta, pac_categoria ;
			,tnp_codfact as codfact, tnp_observaciones as indicacion,ENT_descrient ;
			,nvl(hora0,2400) as hora0, 2400 as horaserv ,sec_codsector,tnp_modi ;
			,nvl(tnd_observa ,space(50)) as comentario ;
			,PAC_codhci,Reg_numdocumento ;
			from mwknutdietaSD;
			left join mwkentidad on cob_codentidad=ENT_codent ;
			where  tnd_fecbaja = ctot("01/01/1900") or isnull(tnd_fecbaja ) ;
			into cursor mwknutdieta2

		Select PAC_habitacion, PAC_cama,PAC_nombrepaciente ,PAC_fechaadmision, PAC_descripdiagn ;
			, PAC_horaadmision , cob_codentidad ,PAC_codadmision,PAC_edad,PAC_fecnacimiento  ;
			, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, tnp_observaciones;
			, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga;
			,TND_Cantidad,sec_descripsec, fecpasiva, indicacion,codfact,pac_fechaalta,ENT_descrient ;
			,hora0, horaserv ,sec_codsector,tnp_modi, comentario, pac_categoria ;
			,PAC_codhci,Reg_numdocumento ;
			from mwknutdieta union ;
			select PAC_habitacion, PAC_cama,PAC_nombrepaciente ,PAC_fechaadmision, PAC_descripdiagn ;
			, PAC_horaadmision , cob_codentidad ,PAC_codadmision,PAC_edad,PAC_fecnacimiento  ;
			, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, tnp_observaciones;
			, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga;
			,TND_Cantidad,sec_descripsec, fecpasiva, indicacion,codfact,pac_fechaalta,ENT_descrient ;
			,hora0, horaserv ,sec_codsector,tnp_modi,comentario, pac_categoria, ;
			PAC_codhci,Reg_numdocumento ;
			from mwknutdieta2 into cursor mwknutdieta

	Endif

Else

	Select mwknutdieta1.*,tnp_observaciones as indicacion,tnp_codfact as codfact, ENT_descrient;
		,nvl(horas,2400) as hora0, 0000 as horaserv;
		,nvl(tnd_observa,space(50)) as comentario ;
		from mwknutdieta1 ;
		left join mwkentidad on cob_codentidad=ENT_codent ;
		where   ((mwknutdieta1.TNP_codserv = 0 and  mwknutdieta1.TND_codPrest>0) or mwknutdieta1.TNP_codserv>0) and ;
		tnd_fecbaja = ctot("01/01/1900") or isnull(tnd_fecbaja ) ;
		into cursor mwknutdieta
Endif

mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, pin_codentidad,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	",cob_codentidad,PAC_horaadmision ,pac_fechaalta, pac_categoria "+;
	" from pacinternad inner join pacientes on pacinternad .pin_codadmision = pacientes.PAC_codadmision " + ;
	" inner join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes "+;
	" left join habitacions on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	" group by pin_codadmision " , "mwkpacientes")
	
If mret<1
	=aerr(eros)
	Messagebox (eros(2))
Endif

Select PAC_habitacion +'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
	, proper(PAC_descripdiagn) as PAC_descripdiagn ;
	, PAC_fechaadmision, PAC_horaadmision , cob_codentidad as pin_codentidad;
	,PAC_codadmision , prg_edad(PAC_fecnacimiento,mfecha,"AM") as anios ;
	, mfecdia as TNP_Fecha ,0 as TNP_CodServ, space(50) as tnp_codfact, space(50) as TNP_codfactu;
	,space(50) as TNP_factura, space(200) as tnp_observaciones;
	,99999 as TNP_Usuario,space(200) as tnd_observa, 0 as TND_idPaciente,0 as TND_codPrest;
	,0 as TND_NroVale,dtot(mfecdia ) as TND_FHoraCarga,space(50) as pre_descriprest;
	,0 as TND_Cantidad ;
	,space(50) as sec_descripsec, "  " as pe, space(250) as indicacion,space(50) as codfact;
	,pac_fechaalta ,2400 as TND_Hora,space(250) as comentario, pac_categoria;
	, space(250) as adnutant, 0 as sec_codsector,0 as tnp_modi,PAC_fecnacimiento,ENT_descrient ;
	from mwkpacientes 	left join mwkentidad on cob_codentidad=ENT_codent ;
	group by PAC_codadmision into cursor mwkpacinternad

If !used('mwkpres')
	mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
		" from prestacions " + ;
		" where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")
Endif

If ldiant = 1
*** Nutricion anterior
	mret = sqlexec(mcon1, "select TNP_codadmision,TNP_Observaciones,tnp_modi  from TabNutPaciente " + ;
		" where TNP_Fecha = ?mdiaant and  TNP_CodServ = ?mtipoant" , "mwknutante1")
	Select TNP_codadmision,tnp_observaciones from mwknutante1 ;
		where upper(tnp_observaciones)=tnp_observaciones or tnp_modi = 1 into cursor mwknutant1
	If mret<1
		=aerr(eros)
		Messagebox (eros(2))
	Endif

	Select PAC_habitacion +'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
		, proper(PAC_descripdiagn) as PAC_descripdiagn ;
		, PAC_fechaadmision, PAC_horaadmision , cob_codentidad as pin_codentidad,PAC_codadmision ;
		, prg_edad(PAC_fecnacimiento,mfecha,"AM") as anios ;
		, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, mwknutdieta.tnp_observaciones;
		, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,pre_descriprest,TND_Cantidad ;
		,sec_descripsec, iif(isnull(mwknutdieta.fecpasiva),"  ","PE") as pe, indicacion,codfact,pac_fechaalta ;
		,iif(hora0>horaserv,hora0,horaserv) as TND_Hora,max(comentario) as comentario, pac_categoria;
		, mwknutant1.tnp_observaciones as adnutant, sec_codsector,tnp_modi,PAC_fecnacimiento,ENT_descrient ;
		,PAC_codhci,Reg_numdocumento ,dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pacfechaadmision ;
		from mwknutdieta ;
		left join mwkpres on TND_codPrest = pre_codprest ;
		left join mwknutant1 on mwknutdieta.PAC_codadmision = mwknutant1.TNP_codadmision;
		order by sec_codsector,habitac, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
		group by habitac, PAC_codadmision &cgroupby  ;
		into cursor mwkdieta

Else

	Select PAC_habitacion +'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
		, proper(PAC_descripdiagn) as PAC_descripdiagn ;
		, PAC_fechaadmision, PAC_horaadmision , cob_codentidad as pin_codentidad,PAC_codadmision ;
		,prg_edad(PAC_fecnacimiento,mfecha,"AM") as anios ;
		, TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu,TNP_factura, tnp_observaciones;
		, TNP_Usuario,tnd_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,pre_descriprest,TND_Cantidad ;
		,sec_descripsec, iif(isnull(mwknutdieta.fecpasiva),"  ","PE") as pe, indicacion,codfact,pac_fechaalta ;
		,iif(hora0>horaserv,hora0,horaserv) as TND_Hora,max(comentario) as comentario, pac_categoria;
		,"" as adnutant, sec_codsector ,tnp_modi,PAC_fecnacimiento,ENT_descrient ;
		,PAC_codhci,Reg_numdocumento ,dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pacfechaadmision ;
		from mwknutdieta ;
		left join mwkpres on TND_codPrest = pre_codprest ;
		order by sec_codsector,habitac, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
		group by habitac, PAC_codadmision &cgroupby  ;
		into cursor mwkdieta

Endif
