****
** busco AC Prestaciones
****
parameters mbusco1, mNomCur
if vartype(mnomcur)#"C"
	mnomcur = "mwkautpre"
endif
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad " + ;
	", sec_codsector, sec_descripsec, PAC_habitacion, PAC_cama " + ;
	", PAC_sexo, PAC_codadmision " + ;
	", PAC_fechaadmision, PAC_fechaalta, PAC_horaadmision "+;
	", PAC_horaalta , PAC_codhci, PAC_codhce " + ;
	", PAC_descripdiagn, PAC_categoria " + ;
	", APV_CantAutorizada , APV_CantEfectuadas , APV_CantSolicitada , APV_CodAdmision"+;
	", APV_CodInsuAutori , APV_CodInsuSolic , APV_CodMedicoSolic , APV_CodPrestAutori"+;
	", APV_CodPrestSolic , APV_CodSector , APV_DosisXDiaAutor , APV_DosisXDiaSolic"+;
	", APV_DuracionAutor , APV_DuracionSolic , APV_Estado , APV_FechaAuditoria"+;
	", APV_FechaSolicitud , APV_HoraAuditoria , APV_HoraSolicitud , APV_IdAutPrevias"+;
	", APV_NomMedicoSolic ,APV_Observaciones , APV_OperAuditoria , APV_OperSolicitud"+;
	", APV_PresInsu , APV_UniXDosisAutor , APV_UniXDosisSolic , apv_urgencia, APV_FechaCirugia  "+;
	", EstA.descrip as descest, APV_subestadopend,APV_IdAgrupador  "+;
	", PrestSo.PRE_descriprest, EstSE.descrip , EstSE.subestado "+;
	", AutPrevias.id as autID, PrestSo.PRE_codservicio "+;
	", AutPrevias.APV_Diagnostico , AutPrevias.APV_ResPrev "+;
	", APV_DescripSolic, APV_DescripAutori, APV_PosologiaSol, pac_tipopac,PRE_Lateralidad "+;
	" from AutPrevias " + ;
	" Left join Prestacions as PrestSo on PrestSo.Pre_CodPrest = APV_CodPrestSolic "+;
	" Left Join TabEstados as EstSE on EstSE.Id = APV_subestadopend "+;
	" Left Join TabEstados as EstA on EstA.Id = APV_estado "+;
	" Left join Pacientes on Pacientes.Pac_CodAdmision = AutPrevias.APV_CodAdmision " + ;
	" Left join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector " + ;
	" where pac_tipopac < 2 "  + mbusco1 +;
	" group by AutPrevias.id ", "mwkpacint0")


if mret<1
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	return .f.
endif


select  PAC_nombrepaciente;
	,PADR(ALLTRIM(PRE_descriprest)+prg_busco_dato_estsolic(pac_codadmision,apv_idautprevias,APV_CodPrestSolic ,1),100) as solicitado;
	,nvl(APV_Diagnostico,space(80)) as APV_Diagnostico,sec_descripsec ;
	,PAC_edad, PAC_fechaadmision;
	,PAC_codadmision ,APV_FechaSolicitud;
	,PAC_codhce ,iif(apv_urgencia = 'U','SI','  ') as apv_urgencia, APV_FechaCirugia;
	,'  ' as PAC_excl ;
	,alltrim(PAC_habitacion) + "-" + alltrim(PAC_cama)  as Cama;
	,iif(empty(nvl(descrip,'')),descest,nvl(descrip,space(20))) as descrip ;
	,APV_CantSolicitada	,iif(isnull(apv_cantAutorizada),00000,apv_cantAutorizada)as apv_cantautorizada ;
	,APV_CantEfectuadas ;
	,iif(nvl(apv_dosisxdiaautor,0)= 0,apv_dosisxdiasolic,apv_dosisxdiaautor) as apv_dosisxdiaautor;
	,apv_duracionAutor,apv_dosisxdiasolic,apv_duracionsolic,apv_operauditoria ;
	,apv_fechaauditoria,apv_horaauditoria,subestado,descest  ;
	,nvl(PRE_descriprest,'') as autorizad ;
	,PAC_codhci,  APV_Estado,autID, apv_nomMedicosolic;
	,PAC_sexo,  sec_codsector , PAC_categoria,PAC_habitacion,PAC_cama,apv_presinsu;
	,apv_opersolicitud,APV_CodInsuSolic ,apv_unixdosisSolic;
	,apv_unixdosisAutor ,apv_codinsuautori ,apv_codprestautori,APV_IdAutPrevias,apv_codprestsolic;
	,nvl(APV_subestadopend,APV_Estado) as APV_subestadopend;
	,APV_HoraSolicitud, PRE_codservicio, PAC_descripdiagn ,APV_ResPrev ;
	, nvl(APV_PosologiaSol,space(30)) as APV_PosologiaSol, pac_tipopac;
	, iif( alltrim(APV_PresInsu) # "P",APV_IdAutPrevias ;
	,APV_IdAgrupador) as APV_IdAgrupador ;
	,PAC_fechaalta, PAC_horaalta,NVL(PRE_Lateralidad,0) as PRE_Lateralidad ,prg_busco_dato_estsolic(pac_codadmision,apv_idautprevias,APV_CodPrestSolic ,1) as apv_codlado  ;
	from mwkpacint0 ;
	order by APV_FechaSolicitud desc,PAC_nombrepaciente,APV_IdAgrupador ;
	into cursor &mNomCur

select * from &mNomCur into cursor mwkpaci
