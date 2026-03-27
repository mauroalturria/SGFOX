*
* Busqueda Monitor de Vales
*
parameters msec,mfec,mbusco

IF VARTYPE(mbusco)#"C"
	mbusco=''
endif
mret = sqlexec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,PIA_codprest,PAC_habitacion, PAC_cama,"+;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,TabEstados.Descrip ,TVO_codmed ,"+;
	"nvl(TabEstados.Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov,tvo_fechaestudio,"+;
	" TVO_Subestado, VAL_verficasolicit,TVO_obser, TabEstados.Estado,val_medicosolicit,VAL_fechaconforme, PAC_codhci," + ;
	" PRE_especialidad, ESP_descripcion, VAL_observaciones, tabcie10.descrip as diagnosticoCie, pacientes.PAC_descripdiagn,PAC_motivoalta "+;
	" from presinsuvas,valesasist,pacientes     " + ;
	" inner join  Servcargval on Servcargval.SCV_codservicio = valesasist.val_codservvale " +;
	" inner join  Cpdestr on Cpdestr.CPDR_mnemonico = Servcargval.SCV_mnemonico " +;
	" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
	" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado"+;
	" and TabEstados.Propietario = 32 and TabEstados.Estado = CPDR_destino "+;
	" inner join Prestacions on Prestacions.Pre_CodPrest = presinsuvas.PIA_codprest "+;
	" left join ESPECIALID on ESPECIALID.ESP_codesp = Prestacions.PRE_especialidad "+;
	" left Join tabcie10 on tabcie10.Id = PAC_codcie10diagn " + ;
	" where val_codservvale <> 5410 and  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST and pacientes.pac_codadmision = Valesasist.VAL_codadmision "+;&&and val_estado = 2  
	IIF(!EMPTY(msec)," and PAC_sectorinternac = ?msec","")+" and VAL_fechasolicitud>= ?mfec "+mbusco,"mwkvalesfar0")

if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	return
endif

DO sp_medicos_all

select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_URGENCIASERV,;
	VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,VAL_verficasolicit,;
	VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,;
	"SOLICITADO" as estvale,iif(isnull(descrip) or lestado<20,padr("SOLICITADO",50),descrip) as tsolicita,PIA_codprest, 	;
	ttipo,lestado,TVO_Fechamov,sp_busco_npac(VAL_codadmision) as PAC_nombrepaciente,val_medicosolicit,VAL_fechaconforme,;
	sp_busco_entCob(VAL_codadmision) as COB_codentidad, TVO_codmed ,;
	ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora,;
	iif(isnull(TVO_SubEstado) or nvl(TVO_SubEstado,0)>=20,0,iif(TVO_SubEstado=0,1,TVO_SubEstado) ) as TVO_SubEstado,PAC_codhci,;
	TVO_Obser ,tvo_fechaestudio, PRE_especialidad, ESP_descripcion, VAL_observaciones, diagnosticoCie;
	, PAC_habitacion, PAC_cama,PAC_descripdiagn,NVL(PAC_motivoalta,9) as PAC_motivoalta;
	from mwkvalesfar0 ;
	order  by VAL_codvaleasist,PIA_codprest,lestado into cursor mwkcons_prev

select mwkcons_prev.*,ser_descripserv, ser_codserv,scv_mnemonico ;
	,mwkentexc_int.fecpasiva,mwkprestac.pre_descriprest,mwkprestac.pre_codprest,mwkmedicosall.nombre ;
	from  mwkcons_prev;
	left join mwkprestac on PIA_codprest = mwkprestac.pre_codprest;
	left join mwkentexc_int on mwkentexc_int.codent = COB_codentidad;
	left join mwkmedicosall on mwkcons_prev.val_medicosolicit = mwkmedicosall.id;
	WHERE PAC_motivoalta=9;
	group by  VAL_codvaleasist,PIA_codprest into cursor mwkconsumoss

if used('mwkconsu')
	use in mwkconsu
endif

select PAC_nombrepaciente,nvl(PAC_habitacion,space(5)) as PAC_habitacion, nvl(PAC_cama,SPACE(3)) as PAC_cama,;
	pre_descriprest,ttod(fechahora) as VAL_fechasolicitud,VAL_codvaleasist,;
	tsolicita,iif(nvl(tvo_fechaestudio,ctot("01/01/1900")) = ctot("01/01/1900"),space(20),ttoc(tvo_fechaestudio)) as tvo_fechaestudio,;
	COB_codentidad, iif(isnull(TVO_obser) or lestado<20,space(250),TVO_obser) as TVO_observa,NVL(nombre,PADR("MEDICO DE PISO",40)) as nombre;
	,ser_descripserv ,nvl(VAL_habitacion,space(5)) as VAL_habitacion,;
	nvl(VAL_cama,space(3)) as VAL_cama,VAL_tipopaciente,ser_codserv,scv_mnemonico,ttipo,VAL_estado,VAL_codpun,;
	iif(!isnull(fecpasiva),'S','N') as svip,TVO_Fechamov,iif(nvl(TVO_SubEstado,0)>19,1,TVO_SubEstado) as TVO_SubEstado,;
	nvl(sp_busca_monitor1_cambiohab( VAL_codadmision ),space(14)) as scamhab1,;
	(alltrim(val_codsector)+','+alltrim(VAL_habitacion)+','+alltrim(VAL_cama)+;
	space(14-len(alltrim(val_codsector)+','+alltrim(VAL_habitacion)+','+;
	alltrim(VAL_cama)))) as compara, val_codsector,VAL_codservvale ,lestado,TVO_codmed ,TVO_obser ,;
	nvl(VAL_nroprotocolo,100000000-100000000) as VAL_nroprotocolo,VAL_verficasolicit,fechahora,PAC_codhci,;
	VAL_codadmision,pre_codprest, PRE_especialidad, ESP_descripcion, VAL_observaciones, diagnosticoCie, PAC_descripdiagn ;
	from mwkconsumoss ;
	order by PAC_nombrepaciente,VAL_fechasolicitud desc into cursor mwkconsu01


if used('mwkconsumo')
	use in mwkconsumo
endif
select *,left(scamhab1,14) as scamhab,;
	substr(scamhab1,18) as sfecha from mwkconsu01 into cursor mwkconsumo


