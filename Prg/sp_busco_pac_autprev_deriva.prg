****
** busco internados
****
parameters mbusco1ac, msql_pac, mnomcur

if vartype(mnomcur)# "C"
	mnomcur = "mwkpacint"
endif
mbusco1	=  iif(empty(mbusco1ac),''," and  ")   + mbusco1ac
mbusco1f	=  "where " + mbusco1ac +iif(empty(mbusco1ac),''," AND ")

mbusco1ac = iif(vartype(mbusco1ac)#"C",'',mbusco1ac)

*!*	--------------------------------------------------------------
*!*	Car 11/12/2014
*!*	--------------------------------------------------------------

if !used('mwkentidad')
	do sp_entidades with ,,2
endif
if !used('mwksectorint')
	do sp_sectorint
endif
if !used('mwkentexc_int')
	mret = sqlexec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT' ","mwkentexc_int")
	if mret<1
		do log_errores with error(), message(), message(1), program(), lineno()
		messagebox("ERROR EN LA GENERACION DEL CURSOR mwkentexc_int",48,"VALIDACION")
		return .f.
	endif
endif
mifecha = sp_busco_fecha_serv("DT")
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 27  ", "mwkTabEstados")

if mret<1
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR MWKTABESTADOS",48,"VALIDACION")
	return .f.
endif

mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad " + ;
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
	", apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac,Cast(1 as Integer) as autp "+;
	" from autprevias " + ;
	" inner join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
	" left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
	"	cob_codentidad = afiliacion.afi_codentidad " + ;
	" where  APV_Estado = 3 and apv_presinsu = 'C' "  + mbusco1 +;
	" group by pac_codadmision  ", "mwkpacint00")

if mret<1
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT00",48,"VALIDACION")
	return .f.
endif


mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad " + ;
	", pac_habitacion, pac_cama " + ;
	", pac_sexo, pac_codadmision " + ;
	", pac_fechaadmision, pac_fechaalta, pac_horaadmision "+;
	", pac_horaalta , pac_codhci, pac_codhce " + ;
	", pac_descripdiagn, pac_categoria " + ;
	", coberturas.cob_codentidad ,pacientes.pac_sectorinternac  "+;
	", afi_nroafiliado ,  pac_tipopac,Cast(0 as Integer) as autp "+;
	" from Pacientes " + ;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
	" left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
	"	cob_codentidad = afiliacion.afi_codentidad " + ;
	mbusco1f + " 1=1  group by pac_codadmision ", "mwkpacint01")

if mret<1
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT01",48,"VALIDACION")
	return .f.
endif
mret = sqlexec(mcon1, "select autprevias.* "+;
	" FROM autprevias where apv_idautprevias = 55","mwkaut")


mret = sqlexec(mcon1, "select  TabIntFundamenta.*,nombre "+;
	" FROM pacientes "+;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" inner join TabIntFundamenta on pac_codadmision = IF_admision "+;
	" inner join prestadores on prestadores.id = IF_codmed " + ;
	mbusco1f+ " IF_pasivado = '1900-01-01 ' order by  TabIntFundamenta.id " , "mwkfunda")
SELECT * FROM mwkfunda group by IF_admision into cursor mwkfundagr
select IF_admision ,NVL(IF_chk11,0) *1000+NVL(IF_chk13,0) as fundestado,nombre ,FecHorDbAdd from mwkfundagr ;
	where (NVL(IF_chk11,0)+NVL(IF_chk13,0))>0 into cursor mwkfunda3rn

select * from mwkpacint00 union all select PAC_nombrepaciente, PAC_edad , pac_habitacion, pac_cama ;
	, pac_sexo, pac_codadmision , pac_fechaadmision, pac_fechaalta, pac_horaadmision ;
	, pac_horaalta , pac_codhci, pac_codhce, pac_descripdiagn, pac_categoria;
	, apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision ;
	, apv_codinsuautori , apv_codinsusolic , apv_codmedicosolic , apv_codprestautori;
	, apv_codprestsolic , apv_codsector , apv_dosisxdiaautor , apv_dosisxdiasolic;
	, apv_duracionautor , apv_duracionsolic , apv_estado , apv_fechaauditoria;
	, apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
	, apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud;
	, apv_presinsu , apv_unixdosisautor , apv_unixdosissolic , apv_urgencia, APV_FechaCirugia  ;
	, apv_idagrupador, APV_NroVale, apv_subestadopend ,1 as autid,cob_codentidad ,pac_sectorinternac  ;
	, apv_diagnostico , apv_resprev, afi_nroafiliado , ;
	apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac, autp ;
	from mwkpacint01 ,mwkaut where pac_codadmision not in (select pac_codadmision from mwkpacint00 ) into cursor mwkpacint0

select * from mwkpacint0 left join mwkfunda3rn on pac_codadmision = IF_admision   ;
	into cursor mwkpacint0f

select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, pac_cama, pac_categoria;
	,ent_descrient, ;
	padr(iif(apv_presinsu ="C","CUIDADOS DOMICILIARIOS ","")+;
	iif(nvl(fundestado,0) >1000,"En espera de 3° Nivel " +iif(mod(nvl(fundestado,0),1000) >0,"Requiere Centro de Rehabilitación",'');
	,iif(nvl(fundestado,0) >0,"Centro de Rehabilitación",'')),250) as solicitado;
	, ''  as resultados, iif(autp=1,apv_fechaauditoria,ttod(FecHorDbAdd)) as apv_fechaauditoria;
	,iif(autp=1, apv_nommedicosolic,nombre) as apv_nommedicosolic,'  ' as PAC_excl, ;
	"Admision" as operadmi,  pac_sexo, PAC_edad, pac_codadmision , ;
	pac_fechaadmision,substr(ttoc(PAC_horaadmision),12,5) as   PAC_horaadmision ;
	, pac_codhce, afi_nroafiliado , space(250) as  pac_descripdiagno,PAC_descripdiagn, "N" as orden ;
	,"          " as vtoori ," " as DocInCompl;
	, ent_codent , pac_codadmision as apv_codadmision  , 0 as apv_codmedicosolic ,  '   ' as apv_codsector  ;
	, pac_codhci, 1 as apv_estado ;
	, date() as apv_fechasolicitud , datetime() as apv_horaauditoria , datetime() as apv_horasolicitud , 0 as apv_idautprevias;
	,space(50) as apv_observaciones , 0 as apv_operauditoria , 0 as apv_opersolicitud;
	, space(12) as apv_presinsu , space(7) as apv_urgencia,ctod("  /  /  ") as APV_FechaCirugia , 0 as apv_idagrupador ,  1 as ;
	apv_subestadopend ;
	, 0 as   autid, ;
	space(80) as  apv_diagnostico , space(250) as apv_resprev , space(250) as apv_descripsolic, ;
	space(250) as apv_descripautori, space(50) as apv_posologiasol,  pac_tipopac ,0 as TPV_Estado,nombre ,FecHorDbAdd,ENT_nroprestadorexterno;
	from mwkpacint0f;
	left join mwkentidad on cob_codentidad = mwkentidad.ent_codent  ;
	left join mwksectorint on pac_sectorinternac = mwksectorint.sec_codsector  ;
	group by pac_codadmision order by pac_nombrepaciente ;
	into cursor mwkpacint0a

***apv_descripsolic as solicitado, apv_fechaauditoria, apv_nommedicosolic
create cursor mwkobserva (idprev n(8),observa c(250))
select apv_idautprevias from mwkpacint0a where apv_idautprevias >0 into cursor mwkbusco
select mwkbusco
scan
	mid = apv_idautprevias
	do sp_busco_autp_obs with mid
	locate for estado = 1
	miobs = left(observa,250)
	insert into mwkobserva (idprev ,observa ) values (mid,miobs)
endscan

select pac_nombrepaciente, sec_codsector, sec_descripsec, pac_habitacion, pac_cama, pac_categoria;
	,ent_descrient,   solicitado, apv_fechaauditoria, apv_nommedicosolic ,resultados,PAC_excl, ;
	operadmi,  pac_sexo, PAC_edad, pac_codadmision , ;
	pac_fechaadmision,PAC_horaadmision ;
	, pac_codhce, afi_nroafiliado , pac_descripdiagno,PAC_descripdiagn, orden ;
	,vtoori ,DocInCompl;
	, ent_codent , apv_codadmision  , apv_codmedicosolic ,  apv_codsector  ;
	, pac_codhci, apv_estado ;
	, apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
	,apv_observaciones , apv_operauditoria , apv_opersolicitud;
	, apv_presinsu , apv_urgencia, APV_FechaCirugia , apv_idagrupador ,  apv_subestadopend ;
	,   autid;
	, apv_diagnostico , apv_resprev  , apv_descripsolic, apv_descripautori, apv_posologiasol, ;
	pac_tipopac ,TPV_Estado,ENT_nroprestadorexterno ;
	from mwkpacint0a left join mwkobserva on nvl(apv_idautprevias,0) = idprev  ;
	where !empty(solicitado);
	into cursor &mnomcur
msql_pac = "select * from " + mnomcur + " 	order by pac_nombrepaciente group by pac_codadmision into cursor mwkpacint1"

return .t.
