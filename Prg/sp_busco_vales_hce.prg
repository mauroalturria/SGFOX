*
* Busqueda Monitor de Vales
*
parameters madmision,lmonito
if vartype(lmonito)	#"N"
	lmonito = 0 &&& solo vales tradicional
endif
do case
	case lmonito = 0
		mret = sqlexec(mcon1, "select ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale ,val_estado "+;
			", VAL_codvaleasist ,val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,VAL_codsector ,nombre"+;
			" from valesasist inner join servicios on VAL_codservvale = ser_codserv " + ;
			" left join prestadores on valesasist.val_medicosolicit= prestadores.id "+;
			" left join tabusuario on valesasist.val_operadorcarga= tabusuario.codigovax "+;
			" where VAL_codadmision = ?madmision   " + ;
			"  ", "mwkvales")

		if mret < 0
			=aerr(eros)
			messagebox(eros(3))
			do sp_desconexion with "Err sp_busco_protocolo_historia"
			cancel
		endif

		select VAL_codvaleasist as nrovale, ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale as codserv,;
			val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,VAL_codsector ,nombre,iif(val_estado=3,"C"," ") as conforme;
			from mwkvales order by conforme,val_fechasolicitud desc into cursor mwkvale

		mret = sqlexec(mcon1, "select VAL_codvaleasist ,pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,"+;
			"pre_descriprest,VAL_codadmision,VAL_codsector  "+;
			",VAL_codservvale "+;
			" from valesasist, presinsuvas,prestacions  " + ;
			" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
			" pre_codprest = pia_codprest and VAL_codservvale<> 5410 and " + ;
			" VAL_codadmision = ?madmision ", "mwkvaldetp")

		if mret < 0
			=aerr(eros)
			messagebox(eros(3))
			do sp_desconexion with "Err sp_busco_protocolo_historia"
			cancel
		endif
		mret = sqlexec(mcon1, "select VAL_codvaleasist,pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,"+;
			"INS_descriinsumo as pre_descriprest,VAL_codadmision,VAL_codsector ,ins_codinsumo "+;
			",VAL_codservvale "+;
			" from valesasist, presinsuvas, insumos " + ;
			" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
			" pia_codinsumo = insumos and VAL_codservvale = 5410 and "  + ;
			" VAL_codadmision = ?madmision ", "mwkvaldeti")

		select VAL_codvaleasist as nrovale, padr(transform(pia_codprest),11) as pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,;
			left(pre_descriprest,45) as pre_descriprest,VAL_codservvale  as codserv,VAL_codadmision,VAL_codsector ;
			, VAL_codvaleasist as idgv  from mwkvaldetp ;
			union select VAL_codvaleasist as nrovale,ins_codinsumo  as  pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,;
			left(pre_descriprest,45) as pre_descriprest,VAL_codservvale  as codserv,VAL_codadmision,VAL_codsector ;
			, VAL_codvaleasist as idgv ;
			from mwkvaldeti ;
			into cursor mwkvaledet
	case lmonito = 1
&&& vales del monitor
		use in select('mwkvaleshce')
		mfecha = ttod(mwkfecserv.fechahora)
		mret = sqlexec(mcon1, "select descrip,codpres "+;
			" from Turnosprepara where fecbaja = '1900-01-01' ","mwkprepara")
		for ixi = 0 to 2
			mfecha = mfecha - ixi
			mret = sqlexec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,PIA_codprest,pre_descriprest"+;
				",VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
				"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,Descrip ,TVO_codmed ,"+;
				"nvl(Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov,tvo_fechaestudio,"+;
				" TVO_Subestado, VAL_verficasolicit,TVO_obser, TabEstados.Estado,val_medicosolicit,VAL_fechaconforme,ser_codserv,ser_descripserv  "+;
				" from presinsuvas,valesasist,prestacions " + ;
				" inner join  Servcargval on Servcargval.SCV_codservicio = valesasist.val_codservvale " +;
				" inner join servicios on VAL_codservvale = ser_codserv " + ;
				" inner join  Cpdestr on Cpdestr.CPDR_mnemonico = Servcargval.SCV_mnemonico " +;
				" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
				" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado"+;
				" and TabEstados.Propietario = 32 and TabEstados.Estado = CPDR_destino "+;
				" where val_codservvale <>5410 and  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST "+;
				" and pre_codprest = pia_codprest and Valesasist.VAL_codadmision = ?madmision"+;
				" and VAL_fechasolicitud = ?mfecha ","mwkvalpres0")


			if mret < 0
				=aerr(eros)
				messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				return
			endif
			mret = sqlexec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,PIA_codprest,INS_descriinsumo as pre_descriprest"+;
				",VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
				"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,Descrip ,TVO_codmed ,"+;
				"nvl(Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov,tvo_fechaestudio,"+;
				" TVO_Subestado, VAL_verficasolicit,TVO_obser, TabEstados.Estado,val_medicosolicit,VAL_fechaconforme,ser_codserv,ser_descripserv  "+;
				" from presinsuvas,valesasist,insumos " + ;
				" inner join  Servcargval on Servcargval.SCV_codservicio = valesasist.val_codservvale " +;
				" inner join servicios on VAL_codservvale = ser_codserv " + ;
				" inner join  Cpdestr on Cpdestr.CPDR_mnemonico = Servcargval.SCV_mnemonico " +;
				" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
				" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado"+;
				" and TabEstados.Propietario = 32 and TabEstados.Estado = CPDR_destino "+;
				" where val_codservvale =5410 and  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST "+;
				" and pia_codinsumo = insumos and Valesasist.VAL_codadmision = ?madmision"+;
				" and VAL_fechasolicitud = ?mfecha ","mwkvalfar0")


			if mret < 0
				=aerr(eros)
				messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				return
			endif

			select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_URGENCIASERV,pre_descriprest,ser_codserv,ser_descripserv ,;
				VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,VAL_verficasolicit,;
				VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,;
				"SOLICITADO" as estvale,iif(isnull(descrip) or lestado<20,padr("SOLICITADO",50),descrip) as tsolicita,PIA_codprest, 	;
				ttipo,lestado,TVO_Fechamov,val_medicosolicit,VAL_fechaconforme, TVO_codmed ,;
				ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora,;
				iif(isnull(TVO_SubEstado) or nvl(TVO_SubEstado,0)>=20,0,iif(TVO_SubEstado=0,1,TVO_SubEstado) ) as TVO_SubEstado,;
				TVO_Obser ,tvo_fechaestudio ;
				from mwkvalpres0 ;
				union all;
				select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_URGENCIASERV,pre_descriprest,ser_codserv,ser_descripserv ,;
				VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,VAL_verficasolicit,;
				VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,;
				"SOLICITADO" as estvale,iif(isnull(descrip) or lestado<20,padr("SOLICITADO",50),descrip) as tsolicita,PIA_codprest, 	;
				ttipo,lestado,TVO_Fechamov,val_medicosolicit,VAL_fechaconforme,	TVO_codmed ,;
				ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora,;
				iif(isnull(TVO_SubEstado) or nvl(TVO_SubEstado,0)>=20,0,iif(TVO_SubEstado=0,1,TVO_SubEstado) ) as TVO_SubEstado,;
				TVO_Obser ,tvo_fechaestudio ;
				from mwkvalfar0 ;
				into cursor mwkvales0

			if used('mwkvaleshce')
				select * from mwkvaleshce union all;
					select * from mwkvales0 into cursor mwkvaleshce
			else
				select * from mwkvales0 into cursor mwkvaleshce
			endif
		next ixi

		select VAL_codvaleasist,ser_descripserv ,VAL_fechasolicitud,nvl(nombre,padr("MEDICO DE PISO",40)) as nombre;
			,PIA_codprest,pre_descriprest;
			,tsolicita,iif(nvl(tvo_fechaestudio,ctot("01/01/1900")) = ctot("01/01/1900"),space(20),ttoc(tvo_fechaestudio)) as tvo_fechaestudio;
			,iif(isnull(TVO_obser) or lestado<20,space(250),TVO_obser) as TVO_observa,mwkprepara.descrip as prepara ;
			,VAL_tipopaciente,ser_codserv,ttipo,VAL_estado,VAL_codpun;
			,val_codsector,VAL_codservvale ,lestado,TVO_codmed ,TVO_obser ;
			,nvl(VAL_nroprotocolo,100000000-100000000) as VAL_nroprotocolo,VAL_verficasolicit,VAL_codadmision;
			from mwkvaleshce;
			left join mwkmedicointall on  mwkmedicointall.id =  VAL_medicosolicit ;
			left join mwkprepara on  mwkprepara.codpres =  PIA_codprest ;
			order by VAL_codvaleasist desc,pre_descriprest group by VAL_codvaleasist ,pre_descriprest into cursor mwkconsu
	case lmonito = 2
&&& vales del monitor por sector
		use in select('mwkvaleshce')
		mfecha = ttod(mwkfecserv.fechahora)
		mifec = mfecha
		if at("'",madmision )=0 AND at('"',madmision )=0
			mbussec = " and Valesasist.val_codsector = ?madmision "
		else
			mbussec = " and Valesasist.val_codsector in ("+madmision +") "
		endif
		for ixi = 0 to 4
			mfecha = mfecha - ixi
			mret = sqlexec(mcon1, "select VAL_codadmision,tvo_fechaestudio "+;
				" from valesasist " + ;
				" INNER join pacinternad on pacinternad.pin_codadmision = valesasist.VAL_codadmision "+;
				" INNER join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
				" where val_codservvale <>5410 AND VAL_estado <3 "+;
				mbussec + " and VAL_fechasolicitud = ?mfecha ","mwkvales0")
			if mret < 0
				=aerr(eros)
				messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				return
			endif

			if used('mwkvaleshce')
				select * from mwkvaleshce union all;
					select * from mwkvales0 into cursor mwkvaleshce
			else
				select * from mwkvales0 into cursor mwkvaleshce
			endif
		next ixi

		select * from mwkvaleshce where nvl(tvo_fechaestudio,ctot("01/01/1900"))>=mifec ;
			order by tvo_fechaestudio into cursor mwkconsu
	case lmonito = 3
&&& vales del monitor para todos
		use in select('mwkvaleshce')
		mfecha = ttod(mwkfecserv.fechahora)
		mifec = mfecha
		mbussec =''
		for ixi = 0 to 4
			mfecha = mfecha - ixi
			mret = sqlexec(mcon1, "select VAL_codadmision,tvo_fechaestudio "+;
				" from valesasist " + ;
				" INNER join pacinternad on pacinternad.pin_codadmision = valesasist.VAL_codadmision "+;
				" INNER join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
				" where val_codservvale <>5410 AND VAL_estado <3 "+;
				mbussec + " and VAL_fechasolicitud = ?mfecha ","mwkvales0")
			if mret < 0
				=aerr(eros)
				messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				return
			endif

			if used('mwkvaleshce')
				select * from mwkvaleshce union all;
					select * from mwkvales0 into cursor mwkvaleshce
			else
				select * from mwkvales0 into cursor mwkvaleshce
			endif
		next ixi

		select * from mwkvaleshce where nvl(tvo_fechaestudio,ctot("01/01/1900"))>=mifec ;
			order by tvo_fechaestudio into cursor mwkconsu
endcase
