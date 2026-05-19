****
** busco internados
****
Parameters mbusco1ac, msql_pac, mnomcur

If Vartype(mnomcur)# "C"
	mnomcur = "mwkpacint"
Endif

mbusco1ac = Iif(Vartype(mbusco1ac)#"C",'',mbusco1ac)

Use In Select("mwkplanpre")
mret = SQLExec(mcon1, "select * from planes where fecpasivaplan  = '1900-01-01' ", "mwkplanpre")

*!*	--------------------------------------------------------------
*!*	Car 11/12/2014
*!*	--------------------------------------------------------------

If !Used('mwkentidad')
	Do sp_entidades With ,,2
Else
	If Empty(Fields('ENT_nroprestadorexterno','mwkentidad'))
		Do sp_entidades With ,,2
	Endif
Endif
If !Used('mwksectorint')
	Do sp_sectorint
Endif
If !Used('mwkentexc_int')
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT' and tipoturno = 0","mwkentexc_int")
Endif
If !Used('mwkinsuac')

	Do sp_busco_texto_insumo  With '', " in ('A','W','U','M','D') ",.F.,"mwkinsuac"
Endif
mret = SQLExec(mcon1,"select * from TabEstados where propietario = 27  ", "mwkTabEstados")
If Not Used('mwkprestaAC')
	mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona , " + ;
		"pre_especialidad from prestacions " + ;
		"inner join servcargval on prestacions.pre_codservicio = servcargval.scv_codservicio "  + ;
		"group by pre_codprest ", "mwkprestaAC")
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
	", apv_subestadopend  , Tabautest.SubEstado,tabestados.descrip "+;
	", autprevias.id as autid,coberturas.cob_codentidad ,pacientes.pac_sectorinternac  "+;
	", autprevias.apv_diagnostico , autprevias.apv_resprev, afi_nroafiliado, afi_idplan "+;
	", apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac, COB_fechacomcob,idcodmed "+;
	" from autprevias " + ;
	" left join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" left JOIN Tabusuario ON  Autprevias.APV_OperSolicitud = Tabusuario.codigovax " +;
	" left join tabautest on Tabautest.IdAutPrevias = autprevias.id " + ;
	" left join tabestados on Tabautest.SubEstado = tabestados.id " + ;
	" left join coberturas on coberturas.cob_pacientes = pacientes.pac_codadmision " + ;
	" left join afiliacion on pac_codhci = afiliacion.registracio and " + ;
	"	cob_codentidad = afiliacion.afi_codentidad " + ;
	" where pac_tipopac < 2 "  + mbusco1ac +;
	" order by  autprevias.id desc,COB_fechacomcob,tabautest.id  ", "mwkpacint00")
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	Return .F.
Endif



Select pac_nombrepaciente, pac_edad , sec_codsector, sec_descripsec, pac_habitacion, pac_cama ;
	, ENT_descrient, pac_sexo, pac_codadmision , pac_fechaadmision, pac_fechaalta, pac_horaadmision ;
	, pac_horaalta , pac_codhci, pac_codhce , pac_descripdiagn, pac_categoria, ent_codent ;
	, apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision;
	, apv_codinsuautori , apv_codinsusolic , apv_codmedicosolic , apv_codprestautori;
	, apv_codprestsolic , apv_codsector , apv_dosisxdiaautor , apv_dosisxdiasolic;
	, apv_duracionautor , apv_duracionsolic , apv_estado , apv_fechaauditoria;
	, apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias;
	, apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud;
	, apv_presinsu , apv_unixdosisautor , apv_unixdosissolic , apv_urgencia, APV_FechaCirugia  ;
	, ainsau.ins_descriinsumo ,apv_idagrupador, APV_NroVale,Padr(Nvl(mwkplanpre.descripcion,''),50) As plan ;
	, ainsso.ins_descriinsumo As ins_descriinsumo1, ainsso.ins_medsensi, ainsso.ins_ddd, ainsso.ins_uniddd,ainsso.ins_contenido, esta.Descrip As descest ;
	, prestau.pre_descriprest, apv_subestadopend ;
	, prestso.pre_descriprest As pre_descriprest1, mwkpacint00.Descrip As desccpafar, estse.Descrip As descsubes  , estse.subestado ;
	, autid, mwkentexc_int.fecpasiva, prestso.pre_codservicio ;
	, apv_diagnostico , apv_resprev, afi_nroafiliado, afi_idplan,  Nvl(mwkpacint00.subestado,100000-100000) As SubEstadocpa, mwkpacint00.Descrip As descripcpa;
	, apv_descripsolic, apv_descripautori, apv_posologiasol, pac_tipopac,Nvl(prestso.pre_tipomuestra,1) As pre_tipomuestra ;
	,Nvl(prestso.PRE_Lateralidad,1) As PRE_Lateralidad ,Nvl(prestso.PRE_tipozona,1) As PRE_tipozona ,prg_busco_dato_estsolic(pac_codadmision,apv_idautprevias,apv_codprestsolic ,1) As apv_codlado ;
	,Iif(Left(sec_codsector ,2)='CO',0,1) As prio,idcodmed,ENT_nroprestadorexterno ;
	from mwkpacint00;
	left Join mwkinsuac As ainsau On ainsau.insumos = apv_codinsuautori ;
	left Join mwkinsuac As ainsso On ainsso.insumos = apv_codinsusolic ;
	left Join mwkprestaac As prestau On prestau.pre_codprest = apv_codprestautori ;
	left Join mwkprestaac As prestso On prestso.pre_codprest = apv_codprestsolic ;
	left Join mwktabestados As estse On estse.Id = apv_subestadopend ;
	left Join mwktabestados As esta On esta.Id = apv_estado ;
	left Join mwkentidad On cob_codentidad = mwkentidad.ent_codent  ;
	left Join mwksectorint On pac_sectorinternac = mwksectorint.sec_codsector  ;
	left Join mwkentexc_int On mwkentexc_int.codent =  cob_codentidad ;
	Left Join mwkplanpre On  mwkplanpre.Id = afi_idplan;
	GROUP By apv_idautprevias;
	into Cursor mwkpacint0

If Hour(mwkfecserv.fechahora)<=8
	mordensql = "  prinsu,prio "
Else
	mordensql = "  prio "
Endif
Select  pac_nombrepaciente;
	,Padr(Alltrim(Nvl(apv_descripsolic,''))+Alltrim(Nvl(ins_descriinsumo1,''))+Alltrim(Nvl(pre_descriprest1,''))+Alltrim(apv_codlado),250) As solicitado;
	,ENT_descrient,Nvl(apv_diagnostico,Space(80)) As apv_diagnostico,sec_descripsec ;
	,pac_edad, pac_fechaadmision;
	,pac_codadmision ,apv_fechasolicitud;
	,pac_codhce ,Iif(apv_urgencia = 'U','SI','  ') As apv_urgencia;
	,Iif(Isnull(fecpasiva),'  ','PE') As pac_excl ;
	,Alltrim(pac_habitacion) + "-" + Alltrim(pac_cama)  As cama;
	,Iif(!Isnull(desccpafar),desccpafar,Iif(!Isnull(descsubes),descsubes,descest)) As Descrip ;
	,apv_cantsolicitada	,Iif(Isnull(apv_cantautorizada),00000,apv_cantautorizada)As apv_cantautorizada ;
	,apv_cantefectuadas ;
	,Iif(Nvl(apv_dosisxdiaautor,0)= 0,apv_dosisxdiasolic,apv_dosisxdiaautor) As apv_dosisxdiaautor;
	,apv_duracionautor,APV_FechaCirugia,apv_dosisxdiasolic,apv_duracionsolic,apv_operauditoria ;
	,apv_fechaauditoria,apv_horaauditoria,subestado,descest  ;
	,Alltrim(Nvl(ins_descriinsumo,''))+Alltrim(Nvl(pre_descriprest,'')) As autorizad ;
	,pac_codhci,  ent_codent,apv_estado,autid, apv_nommedicosolic;
	,pac_sexo,  sec_codsector , pac_categoria,pac_habitacion,pac_cama,apv_presinsu;
	,apv_opersolicitud,apv_codinsusolic ,apv_unixdosissolic;
	,apv_unixdosisautor ,apv_codinsuautori ,apv_codprestautori,apv_idautprevias,apv_codprestsolic;
	,Nvl(apv_subestadopend,apv_estado) As apv_subestadopend;
	,apv_horasolicitud, Nvl(pre_codservicio,5410) As pre_codservicio, pac_descripdiagn ,apv_resprev, afi_nroafiliado, afi_idplan ;
	,Nvl(apv_descripsolic,Space(30)) As apv_descripsolic, Nvl(apv_descripautori,Space(30)) As  apv_descripautori;
	, Nvl(apv_posologiasol,Space(30)) As apv_posologiasol, pac_tipopac;
	, Iif( !Inlist(apv_presinsu , 'P','Q','M','C'),apv_idautprevias ;
	,apv_idagrupador ) As apv_idagrupador, APV_NroVale , SubEstadocpa, descsubes,descripcpa,ENT_nroprestadorexterno  ;
	,pac_fechaalta, ins_medsensi, ins_ddd, ins_uniddd,ins_contenido, pac_horaalta ,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,prio,idcodmed ;
	, Iif(apv_presinsu ='I',1,2) As prinsu,apv_codlado,plan;
		,sp_busco_datos_regis_cond(pac_codadmision ," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ",;
	"mwkpacvip",1) As lespacvip ;
	,sp_busco_datos_regis_cond(pac_codadmision ," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
	"mwkpacvip",1) As lespactras ;
	from mwkpacint0 ;
	order By &mordensql,apv_fechasolicitud Desc,pac_nombrepaciente,apv_idagrupador,apv_idautprevias Desc ;
	into Cursor &mnomcur

msql_pac = "select *,count(APV_Estado) as cant_AC from " + mnomcur + " into cursor mwkpaci"
Return .T.
