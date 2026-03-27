****
** busco internados
****
parameters mbusco1ac, msql_pac, mnomcur

if vartype(mnomcur)# "C"
    mnomcur = "mwkpacint"
endif

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
    mret = sqlexec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0 ","mwkentexc_int")
endif
if !used('mwkinsuac')
 
    do sp_busco_texto_insumo  with '', " in ('A','W','U','M','D') ",.f.,"mwkinsuac"
endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 27  ", "mwkTabEstados")
if not used('mwkprestaAC')
    mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio,PRE_Lateralidad ,PRE_tipozona ,   " + ;
        "pre_especialidad from prestacions " + ;
        "inner join servcargval on prestacions.pre_codservicio = servcargval.scv_codservicio "  + ;
        "group by pre_codprest ", "mwkprestaAC")
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
    ", apv_idagrupador"+;
    ", apv_subestadopend,TabAutObs.observa,TabAutObs.FechaObs, TabAutObs.estado, TabAutObs.usuario, TabAutObs.Id as IdObs "+;
    ", autprevias.id as autid,coberturas.cob_codentidad ,pacientes.pac_sectorinternac  "+;
    ", autprevias.apv_diagnostico , autprevias.apv_resprev, afi_nroafiliado "+;
    ", apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac "+;
    " from autprevias " + ;
	" INNER JOIN TabAutObs ON (AutPrevias.Id = TabAutObs.IdAutPrevias and TabAutObs.estado>1) " + ; 
    " left join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
    " left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
    " left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
    "	cob_codentidad = afiliacion.afi_codentidad " + ;
    " where pac_tipopac < 2 "  + mbusco1ac +;
    "  ", "mwkpacint00")
    &&group by autprevias.id
if mret<1
    do log_errores with error(), message(), message(1), program(), lineno()
    messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
    return .f.
endif



select pac_nombrepaciente, pac_edad , sec_codsector, sec_descripsec, pac_habitacion, pac_cama ;
    , ent_descrient, pac_sexo, pac_codadmision , pac_fechaadmision, pac_fechaalta, pac_horaadmision ;
    , pac_horaalta , pac_codhci, pac_codhce , pac_descripdiagn, pac_categoria, ent_codent ;
    , apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision;
    , apv_codinsuautori , apv_codinsusolic , apv_codmedicosolic , apv_codprestautori;
    , apv_codprestsolic , apv_codsector , apv_dosisxdiaautor , apv_dosisxdiasolic;
    , apv_duracionautor , apv_duracionsolic , apv_estado , apv_fechaauditoria;
    , apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
    , apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud;
    , apv_presinsu , apv_unixdosisautor , apv_unixdosissolic , apv_urgencia, APV_FechaCirugia  ;
    , ainsso.ins_descriinsumo ,apv_idagrupador;
    , ainsso.ins_descriinsumo as ins_descriinsumo1, ainsso.ins_medsensi, ainsso.ins_ddd, ainsso.ins_uniddd,ainsso.ins_contenido, esta.descrip as descest ;
    , prestso.pre_descriprest, apv_subestadopend ;
    , prestso.pre_descriprest as pre_descriprest1, estse.descrip , estse.subestado ;
    , autid, mwkentexc_int.fecpasiva, prestso.pre_codservicio ;
    , apv_diagnostico , apv_resprev, afi_nroafiliado ;
    , apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac ;
    ,observa,FechaObs, mwkpacint00.estado, usuario, IdObs,estaob.descrip as EstadoObs,ENT_nroprestadorexterno;
    ,Nvl(mwkprestaac.PRE_Lateralidad,1) As PRE_Lateralidad ,Nvl(mwkprestaac.PRE_tipozona,1) As PRE_tipozona ,prg_busco_dato_estsolic(pac_codadmision,apv_idautprevias,APV_CodPrestSolic ,1) as apv_codlado  ;
    from mwkpacint00;
    left join mwkinsuac as ainsso on ainsso.insumos = apv_codinsusolic ;
    left join mwkprestaac as prestso on prestso.pre_codprest = apv_codprestsolic ;
    left join mwktabestados as estse on estse.id = apv_subestadopend ;
    left join mwktabestados as esta on esta.id = apv_estado ;
    left join mwktabestados as estaob on estaob.id = mwkpacint00.estado  ;
    left join mwkentidad on cob_codentidad = mwkentidad.ent_codent  ;
    left join mwksectorint on pac_sectorinternac = mwksectorint.sec_codsector  ;
    left join mwkentexc_int on mwkentexc_int.codent =  cob_codentidad ;
    into cursor mwkpacint0
 
select  PAC_nombrepaciente;
	,padr(alltrim(nvl(INS_descriinsumo1,''))+;
	alltrim(nvl(APV_DescripSolic,''))+ alltrim(nvl(PRE_descriprest1,'')),50) as solicitado;
	,ENT_descrient,nvl(APV_Diagnostico,space(80)) as APV_Diagnostico,sec_descripsec, ;
	alltrim(PAC_habitacion) + "-" + alltrim(PAC_cama)  as Cama, PAC_edad, PAC_fechaadmision;
	,PAC_codadmision ,APV_FechaSolicitud ,;
	PAC_codhce ,iif(empty(nvl(descrip,'')),descest,nvl(descrip,space(20))) as descrip ; 
	,iif(apv_urgencia = 'U','SI','  ') as apv_urgencia, APV_FechaCirugia;
	,iif(isnull(fecpasiva),'  ','PE') as PAC_excl, ;
	Nvl(FechaObs,'') as FechaObs, Nvl(EstadoObs,'') as EstadoObs, Nvl(usuario,'') as usuario, estado ;	
	,iif(isnull(apv_cantAutorizada),00000,apv_cantAutorizada)as apv_cantautorizada ;
	,apv_dosisxdiasolic,apv_duracionsolic,apv_operauditoria ;
	,apv_fechaauditoria,apv_horaauditoria,subestado  ;
	,alltrim(nvl(INS_descriinsumo,''))+alltrim(nvl(PRE_descriprest,'')) as autorizad ;
	,PAC_codhci,  ENT_codent,APV_Estado,autID, apv_nomMedicosolic ;
	,PAC_sexo,  sec_codsector , PAC_categoria,PAC_habitacion,PAC_cama,APV_CantSolicitada,apv_presinsu;
	,apv_opersolicitud,APV_CodInsuSolic ,apv_dosisxdiaautor,apv_duracionAutor, apv_unixdosisSolic;
	,apv_unixdosisAutor ,apv_codinsuautori ,apv_codprestautori,APV_IdAutPrevias,apv_codprestsolic;
	,nvl(APV_subestadopend,APV_Estado) as APV_subestadopend,APV_CantEfectuadas ;
	,APV_HoraSolicitud, PRE_codservicio, PAC_descripdiagn ,APV_ResPrev, AFI_nroafiliado,ENT_nroprestadorexterno ;
	,nvl(APV_DescripSolic,space(30)) as APV_DescripSolic, nvl(APV_DescripAutori,space(30)) as  APV_DescripAutori;
	, nvl(APV_PosologiaSol,space(30)) as APV_PosologiaSol, pac_tipopac,observa,PRE_Lateralidad ,PRE_tipozona ,apv_codlado  ;
	from mwkpacint0 ;
	order by APV_FechaSolicitud desc,PAC_nombrepaciente into cursor &mNomCur

msql_pac = "select * from " + mNomCur + " mwkpacint into cursor mwkpaci"
