****
** busco dieta
****
parameter mfecha,mhfecha,nserv,mbusco,ldiant,lagrupa

if type('mbusco')#"C"
	mbusco=''
endif
if type('ldiant')#"N"
	ldiant = 0
endif
if type('lagrupa')#"N"
	lagrupa = 0
endif
cgroupby = iif(lagrupa=0,'',' ,TND_codPrest ')
if !used("mwkentidad")
	do sp_entidades
endif
mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"
if  int(nserv/2)*2 <> nserv&& =3
	mdiaant = mfecha - 1
	mtipoant = nserv + 1
else
	mdiaant = mfecha
	mtipoant = nserv - 1
endif

mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
	", pac_descripdiagn, pac_fechaadmision, pac_horaadmision, cob_codentidad " +;
	" ,pac_edad, pac_codadmision,pac_fecnacimiento "+;
	", tabnutpaciente.*,sec_descripsec,pac_fechaalta, pac_categoria " + ;
	", tabnutdetalle.id,tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga " + ;
	", tnd_observa,tnd_fecbaja, tnd_usuario,tnd_cantidad,tnd_hora as  horas " + ;
	", tnp_codfactu,tnp_factura,tnp_dieta, entidexclu.fecpasiva, sec_codsector "+;
	", pac_codhci "+;
	" from tabnutpaciente inner join pacientes on tabnutpaciente.tnp_codadmision = pacientes .pac_codadmision " + ;
	" inner join coberturas on pacientes.pac_codadmision = coberturas .cob_pacientes "+;
	" left join tabnutdetalle on tabnutdetalle .tnd_idpaciente = tabnutpaciente.id" + ;
	" left join  entidexclu on coberturas .cob_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT'  " +;
	" inner join sectores on pacientes.pac_sectorinternac = sectores .sec_codsector " + ;
	" left join tabnutprest on tabnutprest.tnp_codprest= tabnutdetalle .tnd_codprest" + ;
	" where tnp_fecha>= ?mfecha  and tnp_fecha<= ?mhfecha  and tnp_codserv = ?nserv "+ mbusco , "mwknutdieta1")

if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif

if nserv>0
	mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_nombrepaciente " + ;
		", pac_descripdiagn, pac_fechaadmision, pac_horaadmision, cob_codentidad "+;
		", pac_edad, pac_codadmision,pac_fecnacimiento "+;
		", tabnutpaciente.*,sec_descripsec,pac_fechaalta, pac_categoria " + ;
		", tabnutdetalle.id,tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga " + ;
		", tnd_observa,tnd_fecbaja, tnd_usuario,tnd_cantidad,tnd_hora as  hora0 " + ;
		", tnp_codfactu,tnp_factura,tnp_dieta, entidexclu.fecpasiva, sec_codsector "+;
		", pac_codhci "+;
		" from tabnutpaciente inner join pacientes on tabnutpaciente .tnp_codadmision = pacientes .pac_codadmision " + ;
		" inner join coberturas on pacientes .pac_codadmision = coberturas .cob_pacientes "+;
		" inner join tabnutdetalle on tabnutdetalle .tnd_idpaciente = tabnutpaciente.id" + ;
		" left join  entidexclu on coberturas .cob_codentidad = entidexclu.codent and entidexclu .tpopac = 'INT'  " +;
		" inner join sectores on pacientes .pac_sectorinternac = sectores .sec_codsector " + ;
		" left join tabnutprest on tabnutprest.tnp_codprest= tabnutdetalle .tnd_codprest" + ;
		" where tnd_fecbaja= ?mfechanull  and tnp_fecha>= ?mfecha  and tnp_fecha <= ?mhfecha "+;
		" and tnp_codserv = 0 "+;
		mbusco + " group by TNP_codadmision ,TNP_Fecha &cgroupby", "mwknutdieta2")

	if mret<1
		=aerr(eros)
		messagebox (eros(3))
	endif

	select mwknutdieta1.*, mwknutdieta2.tnp_codfact as codfact, mwknutdieta2.tnp_observaciones as indicacion,ent_descrient ;
		,nvl(hora0,2400) as hora0, nvl(horas,2400-2400) as horaserv;
		,nvl(mwknutdieta2.tnd_observa ,space(50)) as comentario;
		from mwknutdieta1 left join mwknutdieta2 on (mwknutdieta1.tnp_codadmision = mwknutdieta2.tnp_codadmision ;
		and mwknutdieta1.tnp_fecha = mwknutdieta2.tnp_fecha );
		left join mwkentidad on mwknutdieta1.cob_codentidad=ent_codent ;
		where ((mwknutdieta1.TNP_codserv = 0 and  mwknutdieta1.TND_codPrest>0) or mwknutdieta1.TNP_codserv>0) and;
		mwknutdieta1.tnd_fecbaja = ctot("01/01/1900") or isnull(mwknutdieta1.tnd_fecbaja ) ;
		into cursor mwknutdieta

	select * from mwknutdieta2 where pac_codadmision not in (select pac_codadmision;
		from mwknutdieta) into cursor mwknutdietasd

	if reccount('mwknutdietaSD')>0 and nserv <5

		select pac_habitacion, pac_cama,pac_nombrepaciente ,pac_fechaadmision, pac_descripdiagn ;
			, pac_horaadmision , cob_codentidad ,pac_codadmision,pac_edad,pac_fecnacimiento  ;
			, tnp_fecha ,tnp_codserv, tnp_codfact, tnp_codfactu,tnp_factura, tnp_observaciones;
			, tnp_usuario,tnd_observa, tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga;
			,tnd_cantidad,sec_descripsec, fecpasiva, pac_fechaalta, pac_categoria ;
			,tnp_codfact as codfact, tnp_observaciones as indicacion,ent_descrient ;
			,nvl(hora0,2400) as hora0, 2400 as horaserv ,sec_codsector,tnp_modi ;
			,nvl(tnd_observa ,space(50)) as comentario ;
			,pac_codhci ;
			from mwknutdietasd;
			left join mwkentidad on cob_codentidad=ent_codent ;
			where  tnd_fecbaja = ctot("01/01/1900") or isnull(tnd_fecbaja ) ;
			into cursor mwknutdieta2b

		select pac_habitacion, pac_cama,pac_nombrepaciente ,pac_fechaadmision, pac_descripdiagn ;
			, pac_horaadmision , cob_codentidad ,pac_codadmision,pac_edad,pac_fecnacimiento  ;
			, tnp_fecha ,tnp_codserv, tnp_codfact, tnp_codfactu,tnp_factura, tnp_observaciones;
			, tnp_usuario,tnd_observa, tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga;
			,tnd_cantidad,sec_descripsec, fecpasiva, indicacion,codfact,pac_fechaalta,ent_descrient ;
			,hora0, horaserv ,sec_codsector,tnp_modi, comentario, pac_categoria ;
			,pac_codhci ;
			from mwknutdieta union ;
			select pac_habitacion, pac_cama,pac_nombrepaciente ,pac_fechaadmision, pac_descripdiagn ;
			, pac_horaadmision , cob_codentidad ,pac_codadmision,pac_edad,pac_fecnacimiento  ;
			, tnp_fecha ,tnp_codserv, tnp_codfact, tnp_codfactu,tnp_factura, tnp_observaciones;
			, tnp_usuario,tnd_observa, tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga;
			,tnd_cantidad,sec_descripsec, fecpasiva, indicacion,codfact,pac_fechaalta,ent_descrient ;
			,hora0, horaserv ,sec_codsector,tnp_modi,comentario, pac_categoria, ;
			pac_codhci ;
			from mwknutdieta2b into cursor mwknutdietaa
	else

		select mwknutdieta1.*,tnp_observaciones as indicacion,tnp_codfact as codfact, ent_descrient;
			,nvl(horas,2400) as hora0, 0000 as horaserv;
			,nvl(tnd_observa,space(50)) as comentario ;
			from mwknutdieta1 ;
			left join mwkentidad on cob_codentidad=ent_codent ;
			where   ((mwknutdieta1.TNP_codserv = 0 and  mwknutdieta1.TND_codPrest>0) or mwknutdieta1.TNP_codserv>0) and ;
			tnd_fecbaja = ctot("01/01/1900") or isnull(tnd_fecbaja ) ;
			into cursor mwknutdietaa
	endif

endif


mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", pac_descripdiagn, pac_fechaadmision, pin_codentidad,pac_edad, pac_codadmision,pac_fecnacimiento "+;
	",cob_codentidad,pac_horaadmision ,pac_fechaalta, pac_categoria "+;
	" from pacinternad inner join pacientes on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
	" inner join coberturas on pacientes.pac_codadmision = coberturas.cob_pacientes "+;
	" left join habitacions on habitacions.hab_codpaciente = pacientes.pac_codadmision where pac_codhce<>'3123743-5'" + ;
	" group by pin_codadmision " , "mwkpacientes")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

select pac_habitacion +'-'+pac_cama as habitac,pac_nombrepaciente  ;
	, proper(pac_descripdiagn) as pac_descripdiagn ;
	, pac_fechaadmision, pac_horaadmision , cob_codentidad as pin_codentidad;
	,pac_codadmision , padr(prg_edad(pac_fecnacimiento,mfecha,"AM"),10) as anios ;
	, mfecdia as tnp_fecha ,0 as tnp_codserv, space(50) as tnp_codfact, space(50) as tnp_codfactu;
	,space(50) as tnp_factura, space(200) as tnp_observaciones;
	,99999 as tnp_usuario,space(200) as tnd_observa, 0 as tnd_idpaciente,0 as tnd_codprest;
	,0 as tnd_nrovale,dtot(mfecdia ) as tnd_fhoracarga,space(50) as pre_descriprest;
	,0 as tnd_cantidad ;
	,space(50) as sec_descripsec, "  " as pe, space(250) as indicacion,space(50) as codfact;
	,pac_fechaalta ,2400 as tnd_hora,space(250) as comentario, pac_categoria;
	, space(250) as adnutant, 0 as sec_codsector,0 as tnp_modi,pac_fecnacimiento ;
	from mwkpacientes group by pac_codadmision,tnp_fecha into cursor mwkpacinternad

if !used('mwkpres')
	mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
		" from prestacions " + ;
		" where pre_codservicio = 9400 and pre_fechapasiva is null " , "mwkpres")
endif

select pac_habitacion +'-'+pac_cama as habitac,pac_nombrepaciente  ;
	, proper(pac_descripdiagn) as pac_descripdiagn ;
	, pac_fechaadmision, pac_horaadmision , cob_codentidad as pin_codentidad,pac_codadmision ;
	,padr(prg_edad(pac_fecnacimiento,mfecha,"AM"),10) as anios ;
	, tnp_fecha ,tnp_codserv, tnp_codfact, tnp_codfactu,tnp_factura, tnp_observaciones;
	, tnp_usuario,tnd_observa, tnd_idpaciente,tnd_codprest,tnd_nrovale,tnd_fhoracarga,pre_descriprest,tnd_cantidad ;
	,sec_descripsec, iif(isnull(mwknutdietaa.fecpasiva),"  ","PE") as pe, indicacion,codfact,pac_fechaalta ;
	,iif(hora0>horaserv,hora0,horaserv) as tnd_hora,max(comentario) as comentario, pac_categoria;
	,"" as adnutant, sec_codsector ,tnp_modi,pac_fecnacimiento ;
	,pac_codhci,codfact_res(tnp_observaciones) as codfacres ;
	from mwknutdietaa ;
	left join mwkpres on tnd_codprest = pre_codprest ;
	order by pac_codadmision , tnp_codserv,tnd_nrovale  ;
	group by pac_codadmision,tnp_fecha &cgroupby  ;
	into cursor mwkdieta

function codfact_res(observ)
	local ncf,mpos,mcodf,mobs
	ncf = ''
	dimension vdieta(100)
	vdieta(1) = "2A     "
	vdieta(2) = "2B     "
	vdieta(3) = "ACO     "
	vdieta(4) = "AE     "
	vdieta(5) = "AYUNO  "
	vdieta(6) = "CELÍACO"
	vdieta(7) = "NXB     "
	vdieta(8) = "R1     "
	vdieta(9) = "R2     "
	vdieta(10) = "R3     "
	vdieta(11) = "R4     "
	vdieta(12) = "R5     "
	vdieta(13) = "R6     "
	vdieta(14) = "R7     "
	vdieta(15) = "R8     "
	vdieta(16) = "F      "
	vdieta(17) = "L      "
	vdieta(18) = "BM*    "
	vdieta(19) = "*-*    "

	mobs = alltrim(observ)
	mpos = ascan(vdieta,mobs)
	if mpos = 0
		for ifc = 1 to 18
			mpos = at(alltrim(vdieta(ifc)),mobs)
			if mpos>0
				mpos = ifc
				exit
			endif
		endfor
	endif
	mpos = iif( mpos = 0,19,nvl(mpos,19))
	
	return vdieta(mpos)
endfunc
