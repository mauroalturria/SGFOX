*****
** Busco Vales - Consumos
****

parameter mprotocolo,maprob,mtipopac
if type ('maprob')#"C"
	maprob = ""
endif
if type ('mtipopac')#"C"
	mtipopac= "GUA"
endif
if mtipopac= "GUA"
	mret = sqlexec(mcon1, "select descripcion"+;
		" from guardia,tabtipoaltas,TabCiap2E "+;
		" where codestado = tabtipoaltas.id and tipoest = 0 "+;
		" and TabCiap2E.id = codcie9 and protocolo = ?mprotocolo "  , "mwkestalta")

	mret = sqlexec(mcon1, "select nrovale, ser_descripserv,idusuario "+;
		"from guardiavale, servicios,valesasist,tabusuario " + ;
		"where codserv  = ser_codserv and " + ;
		"guardiavale.nrovale = valesasist.VAL_codvaleasist  and " + ;
		"VAL_OperadorCarga = codigovax  and " + ;
		"protocolo 		= ?mprotocolo order by nrosec", "mwkvales")

	mret = sqlexec(mcon1, "select sum(pia_cantsolicitada) as pia_cantsolicitada, " + ;
		"INS_descriinsumo,INS_codpuntero, nrovale, INS_codinsumo,aprobado,fechahora,eg_indicnurse, EG_evolucion  " + ;
		"from valesasist, presinsuvas, insumos, guardiavale " + ;
		"  left join Tabguaevol on guardiavale.protocolo =Tabguaevol.eg_protocolo "+;
		"where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
		"presinsuvas.pia_codinsumo = insumos.insumos and " + ;
		"guardiavale.nrovale = valesasist.VAL_codvaleasist  and " + ;
		"codserv  = 5410  and " + ;
		"protocolo = ?mprotocolo " + maprob + ;
		"group by nrovale, INS_codinsumo", "mwkvalinsu")
else
	madmision =transform(val(left(mprotocolo,at("-",mprotocolo)-1)),"999999-9")
	mret = sqlexec(mcon1, "select descrip "+;
		" from tabinthce,Tabcie10 "+;
		" where IH_motIngreso = Tabcie10.ID "+;
		" and IH_admision = ?madmision and ih_secagrup = 'INT' "  , "mwkestalta0")
	select descrip as descripcion from mwkestalta0 into cursor mwkestalta
	select nrovale, "FARMACIA" as ser_descripserv,nombreefe,fechahoraate as fechahora from mwktodoinsumo where protocolo = mprotocolo ;
		into cursor  mwkvales

	mret = sqlexec(mcon1, "select sum(pia_cantsolicitada) as pia_cantsolicitada, " + ;
		"INS_descriinsumo,INS_codpuntero, VAL_codvaleasist, VAL_fechasolicitud,VAL_horasolicitud,INS_codinsumo,VAL_horacargasolic, VAL_fechacargasoli  " + ;
		"from valesasist, presinsuvas, insumos " + ;
		"where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
		"presinsuvas.pia_codinsumo = insumos.insumos and " + ;
		" val_codservvale  = 5410  and " + ;
		"val_codadmision = ?madmision and VAL_codsector  in ('EME','CEG','IDE','IEP') and VAL_estado <> 3  "+   ;
		"group by VAL_codvaleasist  , INS_codinsumo", "mwkvalinsu0")
		
	select pia_cantsolicitada, INS_descriinsumo,INS_codpuntero, VAL_codvaleasist as nrovale, INS_codinsumo,  ;
		"indicaciones para enfermeria" as eg_indicnurse,0 as aprobado,;
		ctot(dtoc(VAL_fechacargasoli )+" "+ttoc(VAL_horacargasolic,2)) as fechahora ;
		from mwkvalinsu0 where pia_cantsolicitada>0 ;
		and val_codvaleasist in (select nrovale from mwktodoinsumo);
		into cursor mwkvalinsu 
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	do sp_desconexion with "Error sp_busco_prot_VALE_INSUMOS"
	cancel
endif
