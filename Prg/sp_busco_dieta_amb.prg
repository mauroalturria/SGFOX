****
** busco dieta amb
****

Parameter mfecha, nserv, mbusco, ldiant, lagrupa

*!*	mfecha = Date()-2
*!*	nserv  = 1
*!*	ldiant = 1
*!*	mbusca = " and protocolo = '1029142-11' "
*!*	Set Step On

If Type('mbusco')#"C"
	mbusco = ''
Endif
If Type('ldiant')#"N"
	ldiant = 0
Endif
If Type('lagrupa')#"N"
	lagrupa = 0
Endif
cgroupby = Iif(lagrupa=0,'',' ,TND_codPrest ')
If !Used("mwkentidad")
	Do sp_entidades
Endif
mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"

If  Int(nserv/2)*2 <> nserv&& =3
	mdiaant = mfecha - 1
	mtipoant = nserv + 1
Else
	mdiaant = mfecha
	mtipoant = nserv - 1
Endif


mret = SQLExec(mcon1, "select " + ;
	"REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, " + ;
	"TabNutPacAmb.*, Guardia.fechahoraing, " + ;
	"TabNutDetAmb.ID, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, " + ;
	"TND_observa, TND_fecBaja, TND_usuario, TND_Cantidad, TND_Hora as  horas, " + ;
	"TNP_codfactu, TNP_factura, TNP_dieta, Guardia.CodEnt, Guardia.CodPrest, " + ;
	"Reg_nroregistrac "+;
	"from TabNutPacAmb " + ;
	"left join Guardia on TabNutPacAmb.TNP_protocolo = Protocolo " + ;
	"left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	"left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
	"left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " + ;
	"where TNP_Fecha = ?mfecha and " + ;
	"TNP_CodServ = ?nserv " + ;
	" " + mbusco , "mwknutdieta1")

*!*	"PAC_codhce <> '3123743-5'

If mret <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif


*!*	*----------------------------------------------------------------------------------------
*!*	*----------------------------------------------------------------------------------------
If nserv > 0

*!*	PAC_habitacion, PAC_cama, PAC_nombrepaciente, " + ;
*!*			"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, COB_codentidad
*!*			"PAC_edad, PAC_codadmision, PAC_fecnacimiento, " + ;
*!*			, entidexclu.fecpasiva, sec_codsector
*!*			"left join entidexclu on coberturas.COB_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT' " + ;

	mret = SQLExec(mcon1, "select Guardia.CodEnt, Guardia.fechahoraing, " + ;
		"REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, " + ;
		"TabNutPacAmb.*, " + ;
		"TabNutDetAmb.ID, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, " + ;
		"TND_observa, TND_fecBaja, TND_usuario, TND_Cantidad, TND_Hora as  hora0, " + ;
		"TNP_codfactu, TNP_factura, TNP_dieta, Guardia.CodPrest, " + ;
		"Reg_nroregistrac,VAL_codadmision "+;
		"from TabNutPacAmb " + ;
		"left join Guardia on TabNutPacAmb.TNP_protocolo = Guardia.Protocolo " + ;
		"left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
		"left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
		"left join Valesasist on TabNutDetAmb.TND_NroVale = Valesasist.VAL_codvaleasist " + ;
		"left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " + ;
		"where TND_fecBaja = ?mfechanull and TNP_Fecha = ?mfecha and TNP_CodServ = 0 " + ;
		mbusco + " group by TNP_protocolo &cgroupby", "mwknutdieta2")

	If mret <= 0
		Messagebox("ERROR DE LECTURA ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select mwknutdieta1.*, ;
		mwknutdieta2.tnp_codfact As codfact, ;
		mwknutdieta2.tnp_observaciones As indicacion, ENT_descrient, ;
		Nvl(hora0,2400) As hora0, Nvl(horas,2400-2400) As horaserv, ;
		Nvl(mwknutdieta2.tnd_observa ,Space(50)) As comentario,VAL_codadmision ;
		from mwknutdieta1 ;
		Left Join mwknutdieta2 On mwknutdieta1.TNP_protocolo = mwknutdieta2.TNP_protocolo ;
		Left Join mwkentidad On mwknutdieta1.CodEnt = ENT_codent ;
		where  mwknutdieta1.tnd_fecbaja = Ctot("01/01/1900") Or Isnull(mwknutdieta1.tnd_fecbaja ) ;
		into Cursor mwknutdieta

	Select * ;
		From mwknutdieta2 ;
		Where TNP_protocolo Not In (Select TNP_protocolo From mwknutdieta);
		Into Cursor mwknutdietaSD

	If Reccount('mwknutdietaSD') > 0 And nserv < 5

*!*	Codent, Fechahoraing, Id, Tnp_codfact, Tnp_codserv,
*!*	Tnp_fecimp, Tnp_fecha, Tnp_modi, Tnp_observaciones, Tnp_usuario,
*!*	Tnp_protocolo, Id1, Tnd_idpaciente, Tnd_codprest, Tnd_nrovale,
*!*	Tnd_fhoracarga, Tnd_observa, Tnd_fecbaja, Tnd_usuario, Tnd_cantidad,
*!*	Hora0, Tnp_codfactu, Tnp_factura, Tnp_dieta

		Select REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, ;
			mwknutdietaSD.Id, TNP_Fecha, TNP_CodServ, tnp_codfact, TNP_codfactu, TNP_factura, tnp_observaciones, ;
			TNP_Usuario, tnd_observa, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, ;
			TND_Cantidad, TNP_protocolo, ;
			tnp_codfact As codfact, tnp_observaciones As indicacion, ENT_descrient, ;
			Nvl(hora0,2400) As hora0, 2400 As horaserv, tnp_modi, ;
			Nvl(tnd_observa, Space(50)) As comentario, CodPrest, ;
			Reg_nroregistrac,VAL_codadmision,codent;
			from mwknutdietaSD ;
			left Join mwkentidad On CodEnt = ENT_codent ;
			where tnd_fecbaja = Ctot("01/01/1900") Or Isnull(tnd_fecbaja) ;
			into Cursor mwknutdieta2

		Select Id, TNP_Fecha, TNP_CodServ, tnp_codfact, TNP_codfactu, TNP_factura, tnp_observaciones, ;
			TNP_Usuario, tnd_observa, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, ;
			TND_Cantidad, indicacion, codfact, ENT_descrient, TNP_protocolo, ;
			hora0, horaserv, tnp_modi, comentario, ;
			REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, CodPrest, ;
			Reg_nroregistrac,VAL_codadmision,codent   ;
			from mwknutdieta ;
			Union ;
			select Id, TNP_Fecha, TNP_CodServ, tnp_codfact, TNP_codfactu, TNP_factura, tnp_observaciones, ;
			TNP_Usuario, tnd_observa, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, ;
			TND_Cantidad, indicacion, codfact, ENT_descrient, TNP_protocolo, ;
			hora0, horaserv, tnp_modi, comentario, ;
			REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, CodPrest, ;
			Reg_nroregistrac,VAL_codadmision,codent  ;
			from mwknutdieta2 ;
			Into Cursor mwknutdieta

	Endif

Else
	Select mwknutdieta1.*, ;
		tnp_observaciones As indicacion, ;
		tnp_codfact As codfact, ;
		ENT_descrient, ;
		Nvl(horas,2400) As hora0, ;
		0000 As horaserv, ;
		Nvl(tnd_observa, Space(50)) As comentario ;&&&&,codprest
		from mwknutdieta1 ;
		left Join mwkentidad On CodEnt = ENT_codent ;
		where tnd_fecbaja = Ctot("01/01/1900") Or Isnull(tnd_fecbaja) ;
		into Cursor mwknutdieta
Endif
*!*	*----------------------------------------------------------------------------------------
*!*	*----------------------------------------------------------------------------------------


If !Used('mwkpres')

	mret =	SQLExec(mcon1, "select pre_codprest, PRE_descriprest " + ;
		"from prestacions " + ;
		"where (pre_codservicio = 9400 OR PRE_codservicio = 8000) and PRE_fechapasiva is null " , "mwkpres")

	If mret <= 0
		Messagebox("ERROR DE LECTURA ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endif

If ldiant = 1
*** Nutricion anterior
	mret = SQLExec(mcon1, "select TNP_Protocolo, TNP_Observaciones, tnp_modi " + ;
		"from TabNutPacAmb " + ;
		"where TNP_Fecha = ?mdiaant and  TNP_CodServ = ?mtipoant" , "mwknutante1")

	If mret <= 0
		Messagebox("ERROR DE LECTURA ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select TNP_protocolo, tnp_observaciones ;
		From mwknutante1 ;
		where Upper(tnp_observaciones) = tnp_observaciones Or tnp_modi = 1 ;
		Into Cursor mwknutant1


*!*	PAC_habitacion + '-' + PAC_cama As habitac, PAC_nombrepaciente, ;
*!*			Proper(PAC_descripdiagn) As PAC_descripdiagn, ;
*!*			PAC_fechaadmision, PAC_horaadmision, cob_codentidad As pin_codentidad, PAC_codadmision, ;
*!*			Iif( PAC_edad > 0, Transf(PAC_edad,'999'), Transf(Round((mfecdia - PAC_fecnacimiento)/30,0),'99')+"M") As anios, ;
*!*			, sec_codsector, PAC_fecnacimientopac_fechaalta, pac_categoria, sec_descripsec,
*!*		Iif(Isnull(mwknutdieta.fecpasiva),"  ","PE") As pe,


	Select REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, ;
		TNP_Fecha ,TNP_CodServ, tnp_codfact, TNP_codfactu, TNP_factura, ;
		mwknutdieta.tnp_observaciones, ;
		TNP_Usuario, tnd_observa, TND_idPaciente, TND_codPrest, mwknutdieta.TNP_protocolo, ;
		TND_NroVale, TND_FHoraCarga, mwkpres.pre_descriprest, TND_Cantidad, ;
		indicacion, codfact, ;
		Iif(hora0 > horaserv, hora0, horaserv) As TND_Hora, Max(comentario) As comentario,  ;
		mwknutant1.tnp_observaciones As adnutant, tnp_modi, bPrest.pre_descriprest as PrestaGuar, 'GUA' as sec_descripsec, ;
		Reg_nroregistrac,VAL_codadmision,codprest,codent  ;
		from mwknutdieta ;
		left Join mwkpres On TND_codPrest = pre_codprest ;
		left Join mwkpres as bPrest On CodPrest = bPrest.pre_codprest ;
		left Join mwknutant1 On mwknutdieta.TNP_protocolo = mwknutant1.TNP_protocolo;
		order By mwknutdieta.TNP_protocolo, TNP_CodServ, TND_NroVale  ;
		group By mwknutdieta.TNP_protocolo &cgroupby  ;
		into Cursor mwkdieta
Else

*!*	PAC_habitacion + '-' + PAC_cama As habitac, PAC_nombrepaciente, ;
*!*			Proper(PAC_descripdiagn) As PAC_descripdiagn, ;
*!*			PAC_fechaadmision, PAC_horaadmision , cob_codentidad As pin_codentidad, PAC_codadmision, ;
*!*			Iif(PAC_edad > 0, Transf(PAC_edad,'999'),Transf(Round((mfecdia - PAC_fecnacimiento)/30,0),'99') + "M") As anios, ;
*!*		pac_categoria,, PAC_fecnacimiento sec_codsector, pac_fechaalta, sec_descripsec,
*!*	Iif(Isnull(mwknutdieta.fecpasiva),"  ","PE") As pe,

	Select REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento, ;
		TNP_Fecha, TNP_CodServ, tnp_codfact, TNP_codfactu, TNP_factura, tnp_observaciones, ;
		TNP_Usuario, tnd_observa, TND_idPaciente, TND_codPrest, ;
		TND_NroVale, TND_FHoraCarga, mwkpres.pre_descriprest, TND_Cantidad, ;
		indicacion, codfact,  ;
		Iif(hora0>horaserv, hora0, horaserv) As TND_Hora, Max(comentario) As comentario,  ;
		"" As adnutant,  tnp_modi, bPrest.pre_descriprest as PrestaGuar, 'GUA' as sec_descripsec, ;
		Reg_nroregistrac,VAL_codadmision,codprest,codent  ;
		from mwknutdieta ;
		left Join mwkpres On TND_codPrest = pre_codprest ;
		left Join mwkpres as bPrest On CodPrest = bPrest.pre_codprest ;
		order By TNP_protocolo, TNP_CodServ, TND_NroVale  ;
		group By TNP_protocolo &cgroupby  ;
		into Cursor mwkdieta

Endif
