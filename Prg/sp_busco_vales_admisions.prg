*
* Busqueda Monitor de Vales
*
parameters mbcuenta,mservicio,mbusca

mwhere = " where val_codadmision= ?mbcuenta and VAL_codservvale =?mservicio" +mbusca
*mret = sqlexec(mcon1,"select valesasist.* from valesasist where val_codadmision=?migual" ,"mwkbus1")

if used("mwkvalesfar0")
	use in mwkvalesfar0
endif

mdestino = zzdesti
mret = sqlexec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,"+;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,Descrip ,"+;
	"nvl(Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov, pre_descriprest,"+;
	" TVO_Subestado, VAL_verficasolicit,nvl(TVO_obser,space(200)) as TVO_observa,"+;
	" TVO_evolucion"+;
	" ,Prestadores.nombre as PRE_nombmed"+;
	" from valesasist " + ;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" inner join PRESTACIONS 	on prestacions.pre_codprest		= presinsuvas.pia_codprest" + ;
	" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
	" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado"+;
	" and TabEstados.Propietario = 32 and TabEstados.Estado = ?mdestino "+;
	" left outer join prestadores on prestadores.id = TabValObs.TVO_codmed "+;
	+ mwhere + " order by VAL_codvaleasist,TVO_SubEstado ","mwkvalesfar0")

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
	ttipo,lestado,min(TVO_Fechamov) as TVO_Fechamov,;
	ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora,;
	sum(iif(isnull(TVO_SubEstado) or nvl(TVO_SubEstado,0)>=10,0,iif(TVO_SubEstado=0,1,TVO_SubEstado) )) as TVO_SubEstado,;
	TVO_evolucion ,TVO_observa,PRE_nombmed;
	from mwkvalesfar0 ;
	group by VAL_codvaleasist into cursor mwkcons_prev


if reccount('mwkcons_prev')>0
	select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico ;
		,mwkentexc_int.fecpasiva;
		from  mwkcons_prev;
		left join mwkpmed on VAL_prestador = mwkpmed.id ;
		left join mwkserv on VAL_codservvale = mwkserv.ser_codserv ;
		into cursor mwkconsumoss
		
select VAL_fechasolicitud as TVO_Fechamov,VAL_codvaleasist,ser_descripserv,;
		estvale,tsolicita,pre_descriprest,VAL_nroprotocolo,nombre,;
		ser_codserv,scv_mnemonico,;
		ttipo,VAL_tipopaciente,val_verificasolicit, tvo_evolucion,tvo_observa,;

select VAL_fechasolicitud as TVO_Fechamov,VAL_codvaleasist,ser_descripserv,;
		estvale,tsolicita,pre_descriprest,VAL_nroprotocolo,nombre,;
		ser_codserv,scv_mnemonico,;
		ttipo,VAL_tipopaciente,;
		VAL_verficasolicit ,TVO_evolucion,TVO_observa,PRE_nombmed,VAL_codservvale, ;
		nvl(TVO_SubEstado,0) as TVO_SubEstado,VAL_fechasolicitud ;
		from mwkconsumoss order by VAL_codvaleasist desc into cursor mwkconsu

else
	select mwkcons_prev.*,space(30) as nombre, space(30) as ser_descripserv, ;
		0 as ser_codserv,space(3) as  scv_mnemonico, ttod(fechahora)  as fecpasiva;
		from  mwkcons_prev;
		into cursor mwkconsumoss

	select * from mwkconsumoss order by VAL_codvaleasist desc into cursor mwkconsu
endif


if used('mwkconsu3')
	use in mwkconsu3
endif

use dbf('mwkconsu') in 0 again alias mwkconsu3

select mwkconsu3
go top

endif
