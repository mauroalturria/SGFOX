****
** busco internados
****
Parameters mbusco1ac, msql_pac, mnomcur

If Vartype(mnomcur)# "C"
	mnomcur = "mwkpacint"
Endif

mbusco1ac = Iif(Vartype(mbusco1ac)#"C",'',mbusco1ac)

*!*	--------------------------------------------------------------
*!*	Car 11/12/2014
*!*	--------------------------------------------------------------

If !Used('mwkentidad')
	Do sp_entidades With ,,2
Endif
If !Used('mwksectorint')
	Do sp_sectorint
Endif
If !Used('mwkentexc_int')
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT' and tipoturno = 0 ","mwkentexc_int")
	If mret<1
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR EN LA GENERACION DEL CURSOR mwkentexc_int",48,"VALIDACION")
		Return .F.
	Endif
Endif

mret = SQLExec(mcon1,"select * from TabEstados where propietario = 27  ", "mwkTabEstados")

If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKTABESTADOS",48,"VALIDACION")
	Return .F.
Endif

mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad " + ;
	", pac_habitacion, pac_cama " + ;
	", pac_sexo, pac_codadmision " + ;
	", pac_fechaadmision, pac_fechaalta, pac_horaadmision "+;
	", pac_horaalta , pac_codhci, pac_codhce " + ;
	", pac_descripdiagn, pac_categoria " + ;
	", apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision"+;
	", apv_codinsuautori , apv_codinsusolic , apv_codmedicosolic , apv_codprestautori"+;
	", apv_codprestsolic , apv_codsector , apv_dosisxdiaautor , apv_dosisxdiasolic"+;
	", apv_duracionautor , apv_duracionsolic , apv_estado , apv_fechaauditoria"+;
	", apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias"+;
	", apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud"+;
	", apv_presinsu , apv_unixdosisautor , apv_unixdosissolic , apv_urgencia, APV_FechaCirugia  "+;
	", apv_idagrupador, APV_NroVale"+;
	", apv_subestadopend "+;
	", autprevias.id as autid,coberturas.cob_codentidad ,pacientes.pac_sectorinternac  "+;
	", autprevias.apv_diagnostico , autprevias.apv_resprev, afi_nroafiliado "+;
	", apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac"+;
	", APVP_cadera24,APVP_justifPorta, APVP_planATB,APVP_tipoaisla "+;
	" from autprevias " + ;
	" inner join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
	" left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
	"	cob_codentidad = afiliacion.afi_codentidad " + ;
	" left JOIN Zautprevprm  ON  Autprevias.ID = Zautprevprm.APVP_idAutprevia "+;
   	" where  pac_categoria<>'C' and  APV_Estado = 3 and apv_presinsu = 'S' "  + mbusco1ac +;
	" group by autprevias.id ", "mwkpacint00")
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT00",48,"VALIDACION")
	Return .F.
Endif

mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad " + ;
	", pac_habitacion, pac_cama " + ;
	", pac_sexo, pac_codadmision " + ;
	", pac_fechaadmision, pac_fechaalta, pac_horaadmision "+;
	", pac_horaalta , pac_codhci, pac_codhce " + ;
	", pac_descripdiagn, pac_categoria " + ;
	", apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision"+;
	", apv_codinsuautori , apv_codinsusolic , apv_codmedicosolic , apv_codprestautori"+;
	", apv_codprestsolic , apv_codsector , apv_dosisxdiaautor , apv_dosisxdiasolic"+;
	", apv_duracionautor , apv_duracionsolic , apv_estado , apv_fechaauditoria"+;
	", apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias"+;
	", apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud"+;
	", apv_presinsu , apv_unixdosisautor , apv_unixdosissolic , apv_urgencia, APV_FechaCirugia  "+;
	", apv_idagrupador, APV_NroVale"+;
	", apv_subestadopend "+;
	", autprevias.id as autid,coberturas.cob_codentidad ,pacientes.pac_sectorinternac  "+;
	", autprevias.apv_diagnostico , autprevias.apv_resprev, afi_nroafiliado "+;
	", apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac "+;
	", APVP_cadera24,APVP_justifPorta, APVP_planATB,APVP_tipoaisla "+;
	" from autprevias " + ;
	" inner join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
	" left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
	"	cob_codentidad = afiliacion.afi_codentidad " + ;
	" left JOIN Zautprevprm  ON  Autprevias.ID = Zautprevprm.APVP_idAutprevia "+;
	" where  pac_categoria='A' "  + mbusco1ac +;
	" group by pac_codadmision ", "mwkpacint01")

If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT01",48,"VALIDACION")
	Return .F.
Endif

*!*	mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, hab_habilitada  " + ;
*!*		" from habitacions " + ;
*!*		" inner join sectores on sec_codsector = hab_sectores " + ;
*!*		" where sec_internacion = 1 order by hab_codhabitacion, hab_codcama", "mwkcama0")

*!*	select hab_codhabitacion from mwkcama0 where hab_codpaciente#"BLOQUEO" group by hab_codhabitacion having count(hab_codhabitacion ) = 2 into cursor mwkhab
Select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, pac_cama, pac_categoria;
	,ENT_descrient, apv_descripsolic As solicitado, apv_fechaauditoria, apv_nommedicosolic ,Left(apv_resprev ,250) As resultados,'  ' As PAC_excl, ;
	"Admision" As operadmi,  pac_sexo, PAC_edad, pac_codadmision , ;
	pac_fechaadmision,Substr(Ttoc(PAC_horaadmision),12,5) As   PAC_horaadmision ;
	, pac_codhce, afi_nroafiliado , Left(apv_diagnostico,250)  As pac_descripdiagno,PAC_descripdiagn, "N" As orden ;
	,"          " As vtoori ," " As DocInCompl;
	, ent_codent , apv_codadmision  , apv_codmedicosolic ,  apv_codsector  ;
	, pac_codhci, apv_estado ;
	, apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
	,apv_observaciones , apv_operauditoria , apv_opersolicitud;
	, apv_presinsu , apv_urgencia, APV_FechaCirugia , apv_idagrupador ,  apv_subestadopend ;
	,   autid,RC_estado,COV_HisopaVigilan,ENT_nroprestadorexterno ;
	, apv_diagnostico , Left(apv_resprev,250) As apv_resprev  , apv_descripsolic, apv_descripautori, apv_posologiasol, ;
	pac_tipopac ,0 As TPV_Estado, APVP_cadera24,APVP_justifPorta, APVP_planATB,APVP_tipoaisla  ;
	from mwkpacint00;
	left Join mwkentidad On cob_codentidad = mwkentidad.ent_codent  ;
	left Join mwksectorint On pac_sectorinternac = mwksectorint.sec_codsector  ;
  	left join mwkepicov  on  admisionficha=PAC_codadmision ;
	where At("AISLAMIENTO",apv_descripsolic)>0 Group By pac_codadmision Order By pac_nombrepaciente,apv_fechaauditoria,apv_horaauditoria ;
	into Cursor mwkpacint0
Select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, pac_cama, pac_categoria;
	,ENT_descrient, Padr("Sin solicitud de AISLAMIENTO",250) As solicitado, Ctod("  /  /  ") As apv_fechaauditoria, Space(40) As apv_nommedicosolic ,Space(250) As resultados,'  ' As PAC_excl, ;
	"Admision" As operadmi,  pac_sexo, PAC_edad, pac_codadmision , ;
	pac_fechaadmision,Substr(Ttoc(PAC_horaadmision),12,5) As   PAC_horaadmision ;
	, pac_codhce, afi_nroafiliado , Space(250) As  pac_descripdiagno,PAC_descripdiagn, "N" As orden ;
	,"          " As vtoori ," " As DocInCompl;
	, ent_codent , pac_codadmision As apv_codadmision  , 0 As apv_codmedicosolic ,  '   ' As apv_codsector  ;
	, pac_codhci, 1 As apv_estado ;
	, Date() As apv_fechasolicitud , Datetime() As apv_horaauditoria , Datetime() As apv_horasolicitud , 0 As apv_idautprevias;
	,Space(50) As apv_observaciones , 0 As apv_operauditoria , 0 As apv_opersolicitud;
	, Space(12) As apv_presinsu , Space(7) As apv_urgencia,Ctod("  /  /  ") As APV_FechaCirugia , 0 As apv_idagrupador ,  1 As ;
	apv_subestadopend ;
	, 0 As   autid,RC_estado,COV_HisopaVigilan,ENT_nroprestadorexterno;
	, ;
	space(80) As  apv_diagnostico , Space(250) As apv_resprev , Space(250) As apv_descripsolic, ;
	space(250) As apv_descripautori, Space(50) As apv_posologiasol,  pac_tipopac ,0 As TPV_Estado , APVP_cadera24,APVP_justifPorta, APVP_planATB,APVP_tipoaisla ;
	from mwkpacint01;
	left Join mwkentidad On cob_codentidad = mwkentidad.ent_codent  ;
	left Join mwksectorint On pac_sectorinternac = mwksectorint.sec_codsector  ;
  	left join mwkepicov  on  admisionficha=PAC_codadmision ;
	where  pac_codadmision Not In (Select  pac_codadmision  From mwkpacint0 )     ;
	into Cursor mwkpacint1

Select pac_codadmision,apv_fechaauditoria,pac_habitacion From mwkpacint0 Where  pac_categoria="I" Group By pac_codadmision Into Cursor mwksacar
Wait Windows "Buscando retiro de aislamiento" Nowait
Use In Select("mwkquesaco")
Create Cursor mwkquesaco (admision c(8))
Select mwksacar
Scan
	mifec = apv_fechaauditoria
	mipac = Alltrim(pac_codadmision)
*!*		mihab = pac_habitacion
*!*		select mwkhab
*!*		locate for hab_codhabitacion = mihab
*!*		if !found()

	lcSql = " SELECT HoraAtencion, Horafinalizacion,"+;
		" paciente " + ;
		" FROM	SOCIO " + ;
		" WHERE	 Atendido = 1 and IdMotivo= 68 and  paciente = ?mipac AND HoraAtencion > ?mifec "
	If !Prg_EjecutoSql(lcSql,"mwkAtendidoA",.F.)
		Return .F.
	Endif
	If Reccount("mwkAtendidoA")= 0
		lcSql = " SELECT HoraAtencion, Horafinalizacion,"+;
			" paciente " + ;
			" FROM	SOCIOHIS  " + ;
			" WHERE	 Atendido = 1 and IdMotivo= 68 and paciente = ?mipac AND HoraAtencion > ?mifec "
		If !Prg_EjecutoSql(lcSql,"mwkAtendidoA",.F.)
			Return .F.
		Endif
	Endif
	If Reccount("mwkAtendidoA")>0
		Insert Into mwkquesaco (admision) Values (mipac)
	Endif
*!*		else
*!*			insert into mwkquesaco (admision) values (mipac)
*!*		endif

	Select mwksacar

Endscan

Select  * From mwkpacint0 ;
	where pac_codadmision Not In (Select admision From mwkquesaco  );
	union All Select * From mwkpacint1 Into Cursor mwkpacint0a


Create Cursor mwkobserva (idprev N(8),observa c(250))
Select apv_idautprevias From mwkpacint0a Where apv_idautprevias >0 Into Cursor mwkbusco
Select mwkbusco
Scan
	mid = apv_idautprevias
	Do sp_busco_autp_obs With mid
	Locate For estado = 1
	miobs = Left(observa,250)
	Insert Into mwkobserva (idprev ,observa ) Values (mid,miobs)
Endscan

Select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, pac_cama, pac_categoria;
	,ENT_descrient, Padr(Alltrim(strtran(solicitado,"AISLAMIENTO ",''))+" "+Nvl(observa,''),250) As solicitado, apv_fechaauditoria, apv_nommedicosolic ,resultados,PAC_excl, ;
	operadmi,  pac_sexo, PAC_edad, pac_codadmision , ;
	pac_fechaadmision,PAC_horaadmision ;
	, pac_codhce, afi_nroafiliado , pac_descripdiagno,PAC_descripdiagn, orden ;
	,vtoori ,DocInCompl,'' as newsec,'' as oldsec;
	, ent_codent , apv_codadmision  , apv_codmedicosolic ,  apv_codsector  ;
	, pac_codhci, apv_estado ;
	, apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
	,apv_observaciones , apv_operauditoria , apv_opersolicitud;
	, apv_presinsu , apv_urgencia, APV_FechaCirugia , apv_idagrupador ,  apv_subestadopend ;
	,   autid,RC_estado,COV_HisopaVigilan,ENT_nroprestadorexterno,"N" as  ENT_capita;
	, apv_diagnostico , apv_resprev  , apv_descripsolic, apv_descripautori, apv_posologiasol, ;
	pac_tipopac ,TPV_Estado, APVP_cadera24,APVP_justifPorta, APVP_planATB,APVP_tipoaisla  ;
	from mwkpacint0a Left Join mwkobserva On Nvl(apv_idautprevias,0) = idprev  ;
	into Cursor &mnomcur
msql_pac = "select * from " + mnomcur + " 	order by pac_nombrepaciente group by pac_codadmision into cursor mwkpacint1"

Return .T.
 
 
