*
* Busqueda Monitor de Vales guardia internados
*
Parameters mfecdes,mbus,mfecfull,mlistar,mservicio,mestado,mchkvale,mtxtvale,mchkcta,mbcuenta,;
	mfecfullhas,moptori,mpenval,mtodos,mtipobusca

If Vartype(mtipoFecha) <> 'C'
	mtipoFecha = 'FS'  && FS : Fecha Solicitud ó FC : Fecha Carga
Endif

If Vartype(mtipobusca) <> 'C'
	mtipobusca = 'N'
Endif

If Vartype(mfecfullhas)#"T"
	mfecfullhas=sp_busco_fecha_serv("DT")
Endif

If Vartype(moptori)#"N"
	moptori = 1
Endif

cjoin  = ''
cdato  = ''
cjoin2 = ''
cdato2 = ''
*Do sp_busco_pac_internados With  ""
morigen = " val_codsector = 'GUA' "

If Len(mbus)>1
	If 	mtodos = 1
		mwhere = " where VAL_fechasolicitud >= ?mfecdes and VAL_codservvale in " + mbus
		morigen = ' 1 = 1 '
	Else
		mwhere = " where VAL_fechasolicitud >= ?mfecdes and " + morigen +" and VAL_codservvale in " + mbus
	Endif
Else
	mwhere = " where VAL_fechasolicitud >= ?mfecdes and " + morigen +" and VAL_codservvale not in (8000,5410,5800,9400) "
Endif


*!* 06/03/2014 - 09/05/2014
*!*	If mtipobusca = 'N'
*!*		mwhere = mwhere + " and  VAL_estado < 3"
*!*	Endif

If Used("mwkvalesfar0")
	Use In mwkvalesfar0
Endif
If Vartype(zzdesti)<>"N"
	zzdesti=0
Endif
mdestino = zzdesti
lcWhere = Upper(mwhere)
lcWhere = Strtran(lcWhere,"WHERE","")
lcWhere = ' Where Exists( Select 1 from valesasist where ' + lcWhere + ' ) and ' + lcWhere + ' '

mret = SQLExec(mcon1, "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,"+;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,Descrip ,"+;
	"nvl(Tipo,0) as ttipo,nvl(TVO_SubEstado,0) as lestado,TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,"+;
	" TVO_Subestado, VAL_verficasolicit,nvl(TVO_obser,space(250)) as tvo_obser, TVO_Codigovax,"+;
	" TVO_evolucion, Prestadores.nombre as PRE_nombmed, "+;
	" TVC_Estado, TVC_usuario, TabFarmVPCabe.ID as TVC_idprepara, TVC_IniPre, TVC_FinPre, VAL_fechaconforme ,VAL_horaconforme, VAL_OperadorConforme, "+;
	" VAL_fechacargasoli, VAL_horacargasolic, VAL_Observaciones,VAL_medicosolicit, VAL_Lugar_Origen, "+;
	" sum(CASE WHEN(tss.ep_fechoranula<>null) then 1 else 0 end) as bajas, count(tss.id) as totalp, " + ;
	" TabIntPreAlta.IPA_fechah,presinsuvas.pia_codprest  " + ;
	" from valesasist " + ;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" left join TabIntPreAlta on IPA_admision = valesasist.VAL_codadmision and IPA_pasivado = '1900-01-01'" + ;
	" left JOIN tabestudiosSolic as tss on tss.ep_vale = valesasist.val_codvaleAsist " + ;
	" left outer join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun "+;
	" left outer join TabEstados on TabEstados.SubEstado = TabValObs.TVO_SubEstado and TabEstados.Propietario = 32 and TabEstados.Estado = ?mdestino "+;
	" left outer join prestadores on prestadores.id = TabValObs.TVO_codmed "+;
	" left outer join TabFarmVPDet  on TabFarmVPDet.TVD_Vale = valesasist.VAL_codvaleasist "+;
	" left outer join TabFarmVPCabe on TabFarmVPCabe.ID = TabFarmVPDet.TVD_IdPre"+;
	+ lcWhere + " group by VAL_codvaleasist,pia_codprest   order by VAL_codvaleasist,TVO_SubEstado ","mwkvalesfar0")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	Return
Endif

*!*		" left join tabestudiosSolic as tss on tss.ep_vale = val_codvaleAsist " + ;


mwhere  = ''

Select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_URGENCIASERV,;
	VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,VAL_verficasolicit,;
	VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,VAL_estado,;
	iif(VAL_estado=3,"CONFORMADO","SOLICITADO") As estvale,;
	nvl(Descrip,Space(50)) As tsolicita, 	;
	ttipo,lestado,Min(TVO_Fechamov) As TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,sp_busco_npac(VAL_codadmision,0) As PAC_nombrepacienteyedad,;
	sp_busco_entCob(VAL_codadmision) As COB_codentidad, ;
	ctot(Dtoc(VAL_fechasolicitud)+ " " +Strtran(Alltrim(VAL_horasolicitud),".",":")+":00") As fechahora,;
	sum(Iif(Isnull(TVO_SubEstado) Or Nvl(TVO_SubEstado,0)>=10,0,Iif(TVO_SubEstado=0,1,TVO_SubEstado) )) As TVO_SubEstado,;
	TVO_evolucion ,tvo_obser, TVO_Codigovax,Nvl(PRE_nombmed,Space(40)) As PRE_nombmed,;
	NVL(TVC_Estado,0) As TVC_Estado, Nvl(TVC_usuario,Space(20)) As TVC_usuario, ;
	Nvl(TVC_idprepara,0000000) As TVC_idprepara, Nvl(TVC_IniPre,Dtot({//})) As TVC_IniPre, ;
	TVC_FinPre, VAL_fechaconforme, VAL_horaconforme, VAL_OperadorConforme,;
	VAL_fechacargasoli, VAL_horacargasolic, ;
	Ctot(Dtoc(VAL_fechacargasoli)+ " " +Strtran(Alltrim(Left(Right(Ttoc(VAL_horacargasolic),8),5)),".",":")+":00") As fechahoraCarga,;
	VAL_Observaciones,VAL_medicosolicit,Alltrim(VAL_Lugar_Origen) As VAL_Lugar_Origen, ;
	sp_busco_npac(VAL_codadmision, 4) As PAC_ldocumento, bajas, totalp,sp_busco_entCob(VAL_codadmision,0,2,2) As DescriEnt, ;
	IPA_fechah,pia_codprest ;
	from mwkvalesfar0 ;
	&mwhere Group By VAL_codvaleasist,pia_codprest  ;
	Into Cursor mwkcons_prev

Select mwkcons_prev.*,;
	SUBSTR(PAC_nombrepacienteyedad, 1, At('*', PAC_nombrepacienteyedad)-1) As PAC_nombrepaciente,;
	SUBSTR(PAC_nombrepacienteyedad, At('*', PAC_nombrepacienteyedad)+1) + '.' As PAC_edad ;
	FROM mwkcons_prev;
	INTO Cursor mwkcons_prev

If Reccount('mwkcons_prev')>0

	Select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico, mwkentexc_int.fecpasiva;
		,PRE_codprest, PRE_descriprest, PRE_especialidad;
		from  mwkcons_prev;
		left Join mwkpmed On VAL_prestador = mwkpmed.Id ;
		left Join Mwkppres On pia_codprest  = PRE_codprest;
		left Join mwkserv On VAL_codservvale = mwkserv.ser_codserv ;
		left Join mwkentexc_int On mwkentexc_int.codent = COB_codentidad;
		where fechahora >= mfecfull And fechahora <= mfecfullhas ;
		into Cursor mwkconsumoss


Else
	Select mwkcons_prev.*,Space(30) As nombre, Space(30) As ser_descripserv, ;
		0 As ser_codserv,Space(3) As  scv_mnemonico, Ttod(fechahora)  As fecpasiva;
		,0 As PRE_codprest,Space(50) As  PRE_descriprest, '    ' As PRE_especialidad;
		from  mwkcons_prev;
		into Cursor mwkconsumoss

Endif

If Used('mwkconsu')
	Use In mwkconsu
Endif

mwhere2 = ''

If mservicio > 0
	mwhere2 = "where ser_codserv = mservicio "
Endif

Select 0 As esta,estvale,tsolicita,VAL_codadmision,val_codsector,fechahora As VAL_fechasolicitud,;
	VAL_codvaleasist,Nvl(VAL_nroprotocolo,100000000-100000000) As VAL_nroprotocolo,Nvl(VAL_habitacion,Space(5)) As VAL_habitacion,;
	nvl(VAL_cama,Space(3)) As VAL_cama,PAC_nombrepaciente,ser_descripserv,Iif(Empty(Nvl(nombre,Space(40) ) ),Nvl(PRE_nombmed,Space(40)),Nvl(nombre,Space(40) ) ) As nombre,;
	VAL_tipopaciente,ser_codserv,scv_mnemonico,ttipo,VAL_estado,VAL_codpun;
	,Iif(!Isnull(fecpasiva),'S','N') As svip,TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,Iif(Nvl(TVO_SubEstado,0)>10,1,TVO_SubEstado) As TVO_SubEstado;
	,Space(14)  As scamhab1,;
	(Alltrim(val_codsector)+','+Alltrim(VAL_habitacion)+','+Alltrim(VAL_cama)+;
	space(14-Len(Alltrim(val_codsector)+','+Alltrim(VAL_habitacion)+','+;
	alltrim(VAL_cama)))) As compara, VAL_verficasolicit,COB_codentidad, TVO_evolucion,tvo_obser, TVO_Codigovax,Nvl(PRE_nombmed,Space(40)) As PRE_nombmed,VAL_codservvale,VAL_URGENCIASERV, ;
	TVC_Estado, TVC_usuario, TVC_idprepara, TVC_IniPre,	TVC_FinPre, VAL_fechaconforme, VAL_horaconforme, PAC_edad, VAL_OperadorConforme,;
	fechahoraCarga As VAL_fechacargasoli,;
	VAL_Observaciones,VAL_medicosolicit,VAL_Lugar_Origen,  PAC_ldocumento, bajas, totalp,DescriEnt,  ;
	IPA_fechah,PRE_codprest, PRE_descriprest, PRE_especialidad  ;
	&mwhere2 From mwkconsumoss Into Cursor mwkconsu01


Select *,Left(scamhab1,14) As scamhab,;
	substr(scamhab1,18) As sfecha ;
	From mwkconsu01 ;
	Into Cursor mwkconsu

*
*   Reimpresiones y Fecha del Movimiento p/registros Vales dentro de Fecha Desde/Hasta
*

Select esta,Iif(totalp=0,' ',Iif(totalp=bajas,"T",Iif(bajas>0,"P"," "))) As BajaD, ;
	Iif(Isnull(TVO_Fechamov),VAL_fechasolicitud,TVO_Fechamov) As TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,;
	Nvl(IPA_fechah,Ctot('')) As IPA_fechah, ;
	nvl(TVO_SubEstado,0) As TVO_SubEstado,VAL_fechasolicitud, VAL_codvaleasist,;
	VAL_codadmision,PAC_nombrepaciente,DescriEnt,val_codsector,VAL_habitacion,VAL_cama,VAL_verficasolicit,;
	iif(compara = scamhab,Space(3), Padr(Left(scamhab,At(',',scamhab,1)-1),3)) As sectorn,;
	iif(compara = scamhab,Space(5),Padr(Substr(scamhab,At(',',scamhab,1)+1,;
	(At(',',scamhab,2)- At(',',scamhab,1))-1),5) ) As habitan,;
	iif(compara = scamhab,Space(3),Padr(Substr(scamhab,At(',',scamhab,2)+1,3),3) ) As caman,;
	ser_descripserv,VAL_nroprotocolo,Iif(Empty(Nvl(nombre,Space(40) ) ),Nvl(PRE_nombmed,Space(40)),Nvl(nombre,Space(40) ) ) As nombre,;
	estvale,tsolicita,	 COB_codentidad, ser_codserv,scv_mnemonico,;
	ttipo,scamhab1,compara,scamhab,sfecha,VAL_tipopaciente,;
	svip,VAL_codpun,VAL_estado,TVO_evolucion,tvo_obser, TVO_Codigovax,Nvl(PRE_nombmed,Space(40)) As PRE_nombmed,VAL_codservvale,VAL_URGENCIASERV, ;
	TVC_Estado, TVC_usuario, TVC_idprepara, TVC_IniPre,	TVC_FinPre, VAL_fechaconforme, VAL_horaconforme,PAC_edad, VAL_OperadorConforme,;
	VAL_fechacargasoli,VAL_Observaciones,VAL_medicosolicit,VAL_Lugar_Origen,  PAC_ldocumento, bajas, totalp ;
	,PRE_codprest, PRE_descriprest, PRE_especialidad;
	from mwkconsu Into Cursor mwkconsu3v

If Used('mwkvalesfar0')
	Use In mwkvalesfar0
Endif

mfec2  = mfecdes - (IIF(VARTYPE(mfecdes )="T",60*60*24,1)*10) && 10 días
mfec2a = mfecfullhas - (IIF(VARTYPE(mfecfullhas)="T",60*60*24,1)*10)  && 10 días

mwhere = " where VAL_fechasolicitud > ?mfec2 and VAL_fechasolicitud < ?mfecdes and TVO_codpun = VAL_codpun"+;
	" and TVO_Subestado>0 and TVO_Subestado<11"+;
	" and TVO_FechaMov > ?mfec2a and TVO_FechaMov<=?mfecfullhas "+;
	" and " + morigen + Iif(Len(mbus)>3," and VAL_codservvale in " + mbus,"")

*		 Ctrl

mret = SQLExec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud,"+;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_cama,VAL_habitacion,"+;
	"VAL_tipopaciente,VAL_nroprotocolo,VAL_prestador,VAL_codpun,"+;
	"VAL_estado,cast(0 as integer) as ttipo,"+;
	"nvl(TVO_SubEstado,0) as lestado, TVO_FechaMov,TVO_FechaEstudio,ep_comentario_lis ,TVO_SubEstado, VAL_verficasolicit,TVO_evolucion,tvo_obser, TVO_Codigovax,"+;
	"Prestadores.nombre as PRE_nombmed,"+;
	" TabFarmVPCabe.TVC_Estado, TabFarmVPCabe.TVC_usuario, TabFarmVPCabe.ID as TVC_idprepara, TabFarmVPCabe.TVC_IniPre,TabFarmVPCabe.TVC_FinPre,"+;
	" VAL_fechaconforme, VAL_horaconforme, VAL_OperadorConforme, "+;
	" VAL_fechacargasoli, VAL_horacargasolic, VAL_Observaciones,VAL_medicosolicit, VAL_Lugar_Origen, "+;
	" sum(CASE WHEN(tss.ep_fechoranula<>null) then 1 else 0 end) as bajas, count(tss.id) as totalp, IPA_fechah,presinsuvas.pia_codprest  " + ;
	" from valesasist " + ;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" left join TabIntPreAlta on IPA_admision = valesasist.VAL_codadmision and IPA_pasivado = '1900-01-01'" + ;
	" left JOIN tabestudiosSolic as tss on tss.ep_vale = valesasist.val_codvaleAsist " + ;
	" Inner join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun " + ;
	" left join Prestadores on prestadores.id = TabValObs.TVO_codmed "+;
	" left outer join TabFarmVPDet  on TabFarmVPDet.TVD_Vale = valesasist.VAL_codvaleasist "+;
	" left outer join TabFarmVPCabe on TabFarmVPCabe.ID = TabFarmVPDet.TVD_IdPre"+;
	mwhere + " Group By VAL_codvaleasist,pia_codprest   " ,"mwkvalesfar01")

* 		AND TVC_Estado <> 3

If mret > 0
	If Reccount("mwkvalesfar01")>0

		Select * From mwkvalesfar01	  Into Cursor mwkvalesfar01

		If mlistar = 1
			mwhere = "and ttipo = 0"
		Endif
*				,VAL_urgenciaserv


		Select mwkvalesfar01.*,Iif(VAL_estado=3,"CONFORMADO","SOLICITADO") As estvale,Space(50) As tsolicita,;
			sp_busco_npac(VAL_codadmision) As PAC_nombrepacienteyedad,sp_busco_entCob(VAL_codadmision) As COB_codentidad, ;
			ctot(Dtoc(VAL_fechasolicitud)+ " " +Strtran(Alltrim(VAL_horasolicitud),".",":")+":00") As fechahora,;
			iif(Empty(Nvl(nombre,Space(40) ) ),Nvl(PRE_nombmed,Space(40)),Nvl(nombre,Space(40) ) ) As nombre,ser_descripserv,ser_codserv,scv_mnemonico, ;
			NVL(mwkvalesfar01.TVC_Estado,0) As TVC_Estado2, Nvl(mwkvalesfar01.TVC_usuario,Space(20)) As TVC_usuario2,;
			Nvl(mwkvalesfar01.TVC_idprepara,0000000) As TVC_idprepara2,;
			Nvl(mwkvalesfar01.TVC_IniPre,Dtot({//})) As TVC_IniPre2, ;
			Nvl(mwkvalesfar01.TVC_FinPre,Dtot({//})) As TVC_FinPre2, ;
			mwkvalesfar01.VAL_fechaconforme As VAL_fechaconforme2,;
			mwkvalesfar01.VAL_horaconforme  As VAL_horaconforme2, ;
			mwkvalesfar01.VAL_OperadorConforme As VAL_OperadorConforme2, ;
			ctot(Dtoc(VAL_fechacargasoli)+ " " +Strtran(Alltrim(VAL_horasolicitud),".",":")+":00") As fechahoraCarga, ;
			sp_busco_npac(VAL_codadmision, 4) As PAC_ldocumento,sp_busco_entCob(VAL_codadmision,0,2,2) As DescriEnt ;
			,PRE_codprest, PRE_descriprest, PRE_especialidad;
			from mwkvalesfar01 ;
			left Join Mwkppres On pia_codprest  = PRE_codprest;
			left Join mwkpmed On VAL_prestador = mwkpmed.Id ;
			left Join mwkserv On VAL_codservvale = mwkserv.ser_codserv ;
			into Cursor mwkconsumoss

		mwhere3 = ' where fechahora<= ?mfecdes '
		If mservicio > 0
			mwhere3 = " where fechahora<= ?mfecdes  and ser_codserv = mservicio "
		Endif

*				,VAL_urgenciaserv

		Select 0 As esta,estvale,tsolicita,VAL_codadmision,val_codsector,;
			fechahora As VAL_fechasolicitud,;
			VAL_codvaleasist,Nvl(VAL_nroprotocolo,100000000-100000000) As VAL_nroprotocolo,;
			nvl(VAL_habitacion,Space(5)) As VAL_habitacion,;
			nvl(VAL_cama,Space(3)) As VAL_cama,VAL_verficasolicit,Substr(PAC_nombrepacienteyedad, 1, At('*', PAC_nombrepacienteyedad)-1) As PAC_nombrepaciente,;
			SUBSTR(PAC_nombrepacienteyedad, At('*', PAC_nombrepacienteyedad)+1) + '.' As PAC_edad,ser_descripserv,;
			iif(Empty(Nvl(nombre,Space(40) ) ),Nvl(PRE_nombmed,Space(40)),Nvl(nombre,Space(40) ) ) As nombre,VAL_tipopaciente,ser_codserv,;
			scv_mnemonico,ttipo,VAL_estado,VAL_codpun,;
			iif(!Isnull(fecpasiva),'S','N') As svip,TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,TVO_SubEstado,;
			nvl(sp_busca_monitor1_cambiohab(VAL_codadmision),Space(14)) As scamhab1,;
			(Alltrim(val_codsector)+','+Alltrim(VAL_habitacion)+','+Alltrim(VAL_cama)+Space(14-Len(Alltrim(val_codsector)+','+Alltrim(VAL_habitacion)+','+;
			alltrim(VAL_cama)))) As compara,COB_codentidad, ;
			mwkentexc_int.fecpasiva, TVO_evolucion,tvo_obser, TVO_Codigovax,Nvl(PRE_nombmed,Space(40)) As PRE_nombmed,VAL_codservvale,mwkconsumoss.VAL_URGENCIASERV,;
			mwkconsumoss.TVC_Estado2 As TVC_Estado,;
			mwkconsumoss.TVC_usuario2 As TVC_usuario,;
			mwkconsumoss.TVC_idprepara2 As TVC_idprepara,;
			mwkconsumoss.TVC_IniPre2 As TVC_IniPre,;
			mwkconsumoss.TVC_FinPre2 As TVC_FinPre,;
			mwkconsumoss.VAL_fechaconforme2 As VAL_fechaconforme,;
			mwkconsumoss.VAL_horaconforme2 As VAL_horaconforme, ;
			mwkconsumoss.VAL_OperadorConforme2 As VAL_OperadorConforme,	fechahoraCarga As VAL_fechacargasoli,;
			mwkconsumoss.VAL_Observaciones,VAL_medicosolicit, VAL_Lugar_Origen, PAC_ldocumento, bajas, totalp,DescriEnt, IPA_fechah  ;
			,PRE_codprest, PRE_descriprest, PRE_especialidad;
			from mwkconsumoss ;
			left Join mwkentexc_int On mwkentexc_int.codent = COB_codentidad;
			&mwhere3 Into Cursor mwkconsu01

		Select *,Left(scamhab1,14) As scamhab,;
			substr(scamhab1,18) As sfecha ;
			From mwkconsu01 ;
			Into Cursor mwkconsu

*				,VAL_urgenciaserv

		Select esta,Iif(totalp=0,' ',Iif(totalp=bajas,"T",Iif(bajas>0,"P"," ")))  As BajaD, ;
			Iif(Isnull(TVO_Fechamov),VAL_fechasolicitud, TVO_Fechamov) As TVO_Fechamov,TVO_FechaEstudio,ep_comentario_lis ,;
			Nvl(IPA_fechah,Ctot('')) As IPA_fechah, ;
			nvl(TVO_SubEstado,0) As TVO_SubEstado,VAL_fechasolicitud, VAL_codvaleasist,;
			VAL_codadmision,PAC_nombrepaciente,DescriEnt,val_codsector,VAL_habitacion,VAL_cama,VAL_verficasolicit,;
			iif(compara = scamhab,Space(3), Padr(Left(scamhab,At(',',scamhab,1)-1),3)) As sectorn,;
			iif(compara = scamhab,Space(5),Padr(Substr(scamhab,At(',',scamhab,1)+1,;
			(At(',',scamhab,2)- At(',',scamhab,1))-1),5) ) As habitan,;
			iif(compara = scamhab,Space(3),Padr(Substr(scamhab,At(',',scamhab,2)+1,3),3) ) As caman,;
			ser_descripserv,VAL_nroprotocolo,Iif(Empty(Nvl(nombre,Space(40) ) ),Nvl(PRE_nombmed,Space(40)),Nvl(nombre,Space(40) ) ) As nombre,;
			estvale,tsolicita, COB_codentidad, ser_codserv,scv_mnemonico,;
			ttipo,scamhab1,compara,scamhab,sfecha,VAL_tipopaciente,;
			svip,VAL_codpun,VAL_estado,TVO_evolucion,tvo_obser, TVO_Codigovax,Nvl(PRE_nombmed,Space(40)) As PRE_nombmed,VAL_codservvale,VAL_URGENCIASERV, ;
			mwkconsu.TVC_Estado, mwkconsu.TVC_usuario, mwkconsu.TVC_idprepara, mwkconsu.TVC_IniPre,;
			mwkconsu.TVC_FinPre, mwkconsu.VAL_fechaconforme, mwkconsu.VAL_horaconforme, PAC_edad, mwkconsu.VAL_OperadorConforme,;
			VAL_fechacargasoli,;
			VAL_Observaciones,VAL_medicosolicit, VAL_Lugar_Origen, PAC_ldocumento, bajas, totalp ;
			,PRE_codprest, PRE_descriprest, PRE_especialidad;
			from mwkconsu ;
			Into Cursor mwkconsu3r

		If Reccount('mwkconsu3r')>0

			If Reccount('mwkconsu3v')>0
				Select * From mwkconsu3v Union All Select * From mwkconsu3r;
					into Cursor mwkconsu3na
			Else
				Select * From mwkconsu3r;
					into Cursor mwkconsu3na
			Endif
		Else
			Select * From mwkconsu3v ;
				into Cursor mwkconsu3na

		Endif

	Else
		Select * From mwkconsu3v ;
			into Cursor mwkconsu3na

	Endif

ELSE
	
	Messagebox("EN CONSULTA DE REIMPRESIONES DE VALES"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif


Select mwkconsu3na.* &cdato ,sp_busco_npac(VAL_codadmision, 6) As PAC_codhci From mwkconsu3na &cjoin Order By TVO_Fechamov Desc;
	group By VAL_codvaleasist,pre_codprest   Into Cursor mwkconsu3a


If Used('mwkconsu3')
	Use In mwkconsu3
Endif

Use Dbf('mwkconsu3a') In 0 Again Alias mwkconsu3

Select mwkconsu3
Go Top


Return
