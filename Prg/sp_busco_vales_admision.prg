*
* Busqueda Monitor de Vales
*
parameters mbcuenta,mservicio,mbusca,mcursorori
if vartype(mcursorori)#"C"
	mcursorori = 'mwkconsu'
	mcursor = 'mwkconsu3'
else
	mcursor = alltrim(mcursorori) + '3'
endif

if vartype(zzdesti) # "C"
	zzdesti= ''
ENDIF
if vartype(mbusca) # "C"
	mbusca    = ''
endif
if vartype(mservicio) ="N"
	mwhere = " where val_codadmision= ?mbcuenta and VAL_codservvale =?mservicio" +mbusca
else
	mwhere = " where val_codadmision= ?mbcuenta " +mbusca
endif
*mret = sqlexec(mcon1,"select valesasist.* from valesasist where val_codadmision=?migual" ,"mwkbus1")

use in select('mwkconsumoss')
use in select('mwkvalesfar0')
use in select('mwkcons_prev')
use in select(mcursorori)
use in select(mcursor)
if !used('mwkserv')
	mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico "+;
		"from servicios, servcargval " + ;
		"where ser_codserv = servcargval.scv_codservicio " + ;
		"and scv_mnemonico is not null and ser_fechapasiva is null ", "mwkserv")
endif
if !used("mwkentexc_int")
	mret = sqlexec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0","mwkentexc_int")
endif
if !used('mwkpMed')
	if used('mwkmedicoint')
		select * from mwkmedicoint into cursor mwkpMed
	else
		mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " + ;
			"", "mwkpMed" )
	endif
ENDIF
mordenIC = IIF(mwkexe.nomexe='PISOS'," VAL_estado,","")
mdestino = iif(val(transform(zzdesti))>0," and TabEstados.Estado = ?zzdesti ","")
mret = sqlexec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,"+;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,Descrip ,"+;
	"nvl(Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov, TVO_Fechaestudio, pre_descriprest,PRE_especialidad,"+;
	" TVO_Subestado, VAL_verficasolicit,nvl(TVO_obser,space(200)) as TVO_observa,"+;
	" TVO_evolucion,TVO_codmed,SCV_MNEMONICO "+;
	" ,Prestadores.nombre as PRE_nombmed,pre_codprest "+;
	" from valesasist " + ;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" inner join PRESTACIONS 	on prestacions.pre_codprest		= presinsuvas.pia_codprest" + ;
	" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
	" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado"+;
	" and TabEstados.Propietario = 32 "+mdestino +;
	" left outer join prestadores on prestadores.id = TabValObs.TVO_codmed "+;
	" left join servcargval on valesasist.VAL_codservvale = scv_codservicio "+;
	+ mwhere + " order by  VAL_codvaleasist,TabValObs.id ","mwkvalesfar0")

if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	return
endif



select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_URGENCIASERV,;
	VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,VAL_verficasolicit,;
	VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,;
	iif(VAL_estado=3,"CONFORMADO","SOLICITADO") as estvale,;
	nvl(descrip,space(50)) as tsolicita,pre_descriprest, 	;
	ttipo,lestado,max(TVO_Fechamov) as TVO_Fechamov,TVO_Fechaestudio, ;
	ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora,;
	sum(iif(isnull(TVO_SubEstado) or nvl(TVO_SubEstado,0)>=10,0,iif(TVO_SubEstado=0,1,TVO_SubEstado) )) as TVO_SubEstado,;
	TVO_evolucion ,TVO_observa,PRE_nombmed,PRE_especialidad,TVO_codmed,scv_mnemonico,pre_codprest  ;
	from mwkvalesfar0 ;
	group by VAL_codvaleasist   into cursor mwkcons_prev


if reccount('mwkcons_prev')>0

	select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv ;
		,mwkentexc_int.fecpasiva;
		from  mwkcons_prev;
		left join mwkpmed on VAL_prestador = mwkpmed.id ;
		left join mwkserv on VAL_codservvale = mwkserv.ser_codserv ;
		into cursor mwkconsumoss

	select VAL_fechasolicitud ,pre_descriprest,estvale,VAL_codvaleasist,tsolicita,VAL_codpun,;
		VAL_nroprotocolo,nombre,TVO_Fechamov,ser_codserv,scv_mnemonico,ttipo,VAL_tipopaciente,ser_descripserv,VAL_verficasolicit,;
		TVO_observa,PRE_nombmed,VAL_codservvale,nvl(TVO_SubEstado,0) as TVO_SubEstado,VAL_fechasolicitud,TVO_evolucion;
		,TVO_Fechaestudio,lestado,PRE_especialidad,TVO_codmed,pre_codprest ;
		from mwkconsumoss order by &mordenIC VAL_codvaleasist desc into cursor &mcursorori

else
	select mwkcons_prev.*,space(30) as nombre, space(30) as ser_descripserv, ;
		0 as ser_codserv,space(3) as  scv_mnemonico, ttod(fechahora)  as fecpasiva;
		from  mwkcons_prev;
		into cursor mwkconsumoss

	select * from mwkconsumoss order by &mordenIC VAL_codvaleasist desc into cursor &mcursorori
endif


if used(mcursorori)
	use dbf(mcursorori) in 0 again alias &mcursor
	select &mcursor
	go top
endif

