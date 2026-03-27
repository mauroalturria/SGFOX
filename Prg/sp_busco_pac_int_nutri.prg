****
** busco pacientes para nutricion
****

parameter msector, mfecreald,mbusact

dimension cf(100)
store '' to cf
mfecreal = prg_dtoc(mfecreald)
msec = iif(!empty(msector)," PAC_sectorinternac = ?msector ",' 1=1 ')
mfechatope = sp_busco_fecha_serv('DD')- 10
mxfecant = prg_dtoc(mfechatope)
mfecha = sp_busco_fecha_serv('DD')
mbusact = IIF(VARTYPE(mbusact)#"N",0,1)
mfecbaja = ' where ((TNP_codserv = 0 and  TND_codPrest>0) or TNP_codserv>0) '
mfecnul = ctod("01/01/1900")
IF mbusact = 1
	mfecbaja = mfecbaja +" and nvl(TND_fecBaja, mfecnul ) =  mfecnul " 
endif
*------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select *, {fn hour(lug_horaingreso)}  as horaingreso "+;
	" from pacinternad,lugarintern " + ;
	"where pacinternad.pin_codadmision = lugarintern.lug_pacientes ", "mwkcamas")
if mret < 1
	=aerr(eros)
	messagebox(eros(2))
endif

msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
	" lug_categoria, lug_codsector, lug_habitacion, lug_cama,lug_pacientes "+;
	",lug_habitacion+' -'+ lug_cama as cama "+;
	" from mwkcamas where lug_pacientes in "+;
	"(select lug_pacientes from mwkcamas where lug_fechaingreso = ?mfecreald)"+;
	" and lug_fechaegreso = ?mfecreald "+;
	" order by lug_pacientes,lug_fechaingreso,lug_horaingreso "+;
	" into cursor mwkcamas1"

&msql_hab
 

msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
	" lug_categoria, lug_codsector, lug_habitacion, lug_cama,lug_pacientes "+;
	",lug_habitacion+' -'+ lug_cama as cama "+;
	" from mwkcamas where ISNULL(lug_fechaegreso) and lug_fechaingreso = ?mfecreald "+;
	" order by lug_pacientes,lug_fechaingreso,lug_horaingreso "+;
	" into cursor mwkcamasact"

&msql_hab
select * from mwkcamas1 group by lug_pacientes;
	into cursor mwkcamas
*!*	msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
*!*		" lug_categoria, lug_codsector, lug_habitacion, lug_cama,lug_pacientes "+;
*!*		" from mwkcamas order by lug_pacientes,lug_fechaingreso,lug_horaingreso "+;
*!*		" into cursor mwkcamas1"
*!*		
	
*------------------------------------------------------------------------------------
mret =	sqlexec(mcon1, "select pre_codprest, PRE_descriprest " +  ; 
	"from prestacions " +  ; 
	"where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

*------------------------------------------------------------------------------------
do sp_busco_ingred

*-*-*------------------------------------------------------------
*!*	BUSCA PACIENTES (INT)

*** Nutricion del dia
*!*	mret = sqlexec(mcon1, "select VAL_codadmision "+;
*!*		" from pacinternad " + ;
*!*		" inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ; 
*!*		" inner join valesasist on pacientes.PAC_codadmision = VAL_codadmision " + ;
*!*		" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
*!*	 	" where  pacientes.PAC_sectorinternac = ?msector and VAL_fechasolicitud > ?mfechatope  "+;
*!*		" and VAL_codservvale = 9400 and VAL_estado = 1 and PIA_codprest =  42030357" +;
*!*		" group by VAL_codadmision ", "mwknutic")

mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama, PAC_nombrepaciente, " +  ; 
	"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision,  afi_codentidad, PAC_edad, " + ; 
	"PAC_codadmision, PAC_fecnacimiento, PAC_codhci, entidexclu.fecpasiva, " + ;
	"pac_fechaalta, PAC_sectorinternac " + ; 
	"from pacinternad " + ;
	"inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ; 
	"left join afiliacion on " + ; 
	"	pacientes.PAC_codhci = afiliacion.registracio and " +  ; 
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " +  ; 
	"left join entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT' " + ; 
	"where &msec  " + ; 
	"group by PAC_codadmision", "mwknutpac01")

if mret < 1
	=aerr(eros)
	messagebox(eros(2))
endif
*------------------------------------------------------------------------------------
*!*		BUSCO PACIENTES 
*!*		Y QUE LA FECHA DE ALTA SEA POSTERIOR A LA SOLICUTADA 

mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama, PAC_nombrepaciente, " + ; 
	"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, afi_codentidad, PAC_edad, " + ; 
	"PAC_codadmision, PAC_fecnacimiento, PAC_codhci, entidexclu.fecpasiva, " + ;
	"pac_fechaalta, PAC_sectorinternac " + ; 
	"from pacientes " +  ; 
	"left join afiliacion on " + ; 
	"	pacientes.PAC_codhci = afiliacion.registracio " +  ; 
	"left join  entidexclu on afiliacion.AFI_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT' " + ; 
	"where &msec and pac_fechaalta >= ?mfecreal AND pac_tipopac<2 "  + ; 
	"group by PAC_codadmision", "mwknutpac02")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
*------------------------------------------------------------------------------------

select mwknutpac01.*; 
	from mwknutpac01  ; 
	where mwknutpac01.pac_fechaadmision <= ?mfecreald  ; 
union  ; 
select mwknutpac02.* ; 
	from mwknutpac02 ; 
into cursor mwknutpac1

*------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select TabNutPaciente.* , TNP_codfactu, TNP_factura, TNP_dieta " +  ; 
	",  TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga,  TND_observa, TND_hora,  TND_FHoraCarga,TND_fecBaja " + ; 
	" from TabNutPaciente " +  ; 
	" inner join pacientes on pacientes.PAC_codadmision = TNP_codadmision " +  ; 
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" +  ; 
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest" +  ; 
	" where &msec and  TNP_Fecha =?mfecreal and  pac_tipopac<2     " , "mwknutdet10")
	

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

select * from mwknutdet10 &mfecbaja into cursor mwknutdet1
*------------------------------------------------------------------------------------
select *  ; 
	from mwknutpac1  ; 
	left join mwknutdet1 on pac_codadmision = tnp_codadmision  ; 
	into cursor mwknutact1

*------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------
*** Nutricion anterior
*------------------------------------------------------------------------------------
*!*	BUSCO EN PACIENTES INTERNADOS + NUTRICION
*------------------------------------------------------------------------------------

if !empty(msector)
mret = sqlexec(mcon1, "select PAC_habitacion,  PAC_cama, PAC_nombrepaciente, " +  ; 
		"PAC_descripdiagn,  PAC_fechaadmision,  PAC_horaadmision,  afi_codentidad, " + ; 
		"PAC_edad,  PAC_codadmision, PAC_fecnacimiento, " + ; 
		"TabNutPaciente.*, TND_codPrest, " +  ; 
		"PAC_sectorinternac " + ; 
		"from pacinternad " + ;
		"inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ; 
		"inner join TabNutPaciente on  pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " +  ; 
		"left join TabNutdetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id "  +  ; 
		"left join afiliacion on " + ; 
		"	pacientes.PAC_codhci = afiliacion.registracio and " +  ; 
		"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " +  ; 
		"where &msec and  TNP_Fecha >= '"+alltrim(mxfecant)+"' "  + ; 
		"GROUP By TNP_Fecha, PAC_codadmision, TNP_CodServ " +  ; 
		"", "mwknutant1")
else
	mret = sqlexec(mcon1, "select PAC_habitacion,  PAC_cama, PAC_nombrepaciente, " +  ; 
		"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, cast(0 as integer) as afi_codentidad, " + ; 
		"PAC_edad,  PAC_codadmision, " + ; 
		"PAC_fecnacimiento, " + ; 
		"TabNutPaciente.*, TND_codPrest, " +  ; 
		"PAC_sectorinternac " + ; 
		"from pacinternad " + ;
		"inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ; 
		"inner join TabNutPaciente on  pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " +  ; 
		"left join TabNutdetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id "  +  ; 
		"where TNP_Fecha >= '"+alltrim(mxfecant)+"' "  + ; 
		"GROUP By TNP_Fecha, PAC_codadmision, TNP_CodServ " +  ; 
		"", "mwknutant1")
endif

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

*------------------------------------------------------------------------------------
*!*	ANAMNESIS DE LOS PACIENTES INTERNADOS
*------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select pin_codadmision, TNH_fecha, TNH_anamnesis, " + ;
	"pac_fechaadmision, TNH_registracio, " + ;
	"cast(CASE WHEN TNH_fecha >= PAC_fechaadmision and " + ;
		"TNH_anamnesis = 'COME TODOS LOS ALIMENTOS' THEN 1 ELSE 0 END as Integer) as cometodo " + ; 
	"from pacinternad " + ;
	"inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ; 
	"left join TabNutHpac on pacientes.PAC_codhci = TabNutHpac.TNH_registracio " + ; 
	"where &msec " +  ; 
	"", "mwknuthana01")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

*------------------------------------------------------------------------------------
*!*	ANAMNESIS DE LOS PACIENTES 
*------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select pac_codadmision as pin_codadmision, TNH_fecha, " + ;
	"TNH_anamnesis, TNH_registracio, cast(0 as Integer) as cometodo " + ; 
	"from pacientes " +  ; 
	"left join TabNutHpac on pacientes.PAC_codhci = TabNutHpac.TNH_registracio " + ; 
	"where &msec and  pac_fechaalta >= ?mfecreal  " +  ; 
	"", "mwknuthana02")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

*------------------------------------------------------------------------------------
*!*	DESDE ACA NO HAY MAS CONSULTAS AL SERVIDOR
*------------------------------------------------------------------------------------

*!*	UNO ANAMNESIS
select pin_codadmision, tnh_fecha, tnh_anamnesis, TNH_registracio, cometodo  ; 
	from mwknuthana01  ; 
	where pac_fechaadmision <= mfecreald  ; 
	union  ; 
select *  ; 
	from mwknuthana02  ; 
	into cursor mwknuthana

*!*	ANAMNESIS X ADMISION
select *  ; 
	from mwknuthana  ; 
	order by tnh_fecha  ; 
	group by pin_codadmision  ; 
	into cursor mwknuthana1

if used('mwkauxi')
	use in mwkauxi
endif

&& nutricion de dia 
select pac_habitacion+'-'+pac_cama as habitac, pac_nombrepaciente   ; 
	,  proper(pac_descripdiagn) as pac_descripdiagn,  pac_edad ; 
	,  dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pac_fechaadmision ; 
	,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  prg_edad(PAC_fecnacimiento,mfecha,"AM")  as anios  ; 
	,  nvl(tnp_fecha, mfecreald) as tnp_fecha , nvl(tnp_codserv, 0) as tnp_codserv ; 
	,  iif(tnp_codserv=0, tnp_codfact, space(50)) as tnp_codfact0 ; 
	,  iif(tnp_codserv>0, tnp_codfact, space(50)) as tnp_codfact ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact1 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact2 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones1 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 ,  ; 
	nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones2 ; 
	,  nvl(tnp_usuario,  00000) as tnp_usuario, nvl(tnd_observa, space(50)) as tnd_observa, TND_hora ; 
	,  tnd_idpaciente, tnd_codprest, tnd_nrovale, tnd_fhoracarga, tn_ingrediente, pre_descriprest  ; 
	, iif(tnp_codserv=0, tnp_observaciones, space(250))  as indicacion, iif(tnp_codserv=0, max(TND_observa), space(250)) as observaciones ; 
	,  tnh_anamnesis,  cometodo, iif(isnull(fecpasiva), "  ", "PE") as pe, pac_fechaalta , hour(TND_FHoraCarga) as hhc, PAC_sectorinternac    ; 
	from mwknutact1  ; 
	left outer join mwkentidad on afi_codentidad = ent_codent  ; 
	left outer join mwknuthana1 on pac_codadmision = pin_codadmision ; 
	left join mwkpres on tnd_codprest = pre_codprest and tnp_codserv <= 2  ; 
	left join mwktningr on tnd_codprest = mwktningr.id  and tnp_codserv in( 3, 4, 5, 6)  ; 
	where isnull(tnp_fecha) or tnp_fecha >=mfechatope  ; 
	order by tnp_fecha, habitac,  pac_codadmision ,  tnp_codserv, tnd_nrovale   ; 
	group by tnp_fecha, pac_codadmision, tnp_codserv   ; 
	into cursor mwknutcdact1

&& recorte una fecha
select *  ; 
	from mwknutcdact1  ; 
	where tnp_fecha = mfecreald  ; 
	into cursor mwkcataux0

select pin_codadmision  ; 
	from mwknuthana1  ; 
	where pin_codadmision not in (select pac_codadmision  ; 
	from mwkcataux0) into cursor mwkcataux1

select *  ; 
	from mwknutcdact1  ; 
	where pac_codadmision in (select pin_codadmision  ; 
	from mwkcataux1) ; 
	group by pac_codadmision  ; 
	into cursor mwkcataux2

&& cierro mwkcataux1 ?

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad,  ; 
	pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  anios,  tnp_fecha , tnp_codserv,  tnp_codfact,  tnp_codfact0, tnp_codfact1,  tnp_codfact2 ; 
	,  tnp_observaciones1, tnp_observaciones2 ; 
	,  tnp_usuario, indicacion,  observaciones, TND_hora,  ; 
	iif(isnull(tnh_anamnesis), ' ', iif(cometodo=1, '=', '*')) as hanam ; 
	,  pe, pac_fechaalta, hhc, PAC_sectorinternac, d.cama as Cama_A, h.hora ; 
	from mwkcataux0 left join mwkcamas D on pac_codadmision = d.lug_pacientes;
	 left join mwkcamasact H on pac_codadmision = h.lug_pacientes  ; 
	union  ; 
	select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad,  ; 
	pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  anios,  tnp_fecha , 0 as tnp_codserv,  tnp_codfact, tnp_codfact0,  tnp_codfact1,  tnp_codfact2 ; 
	,  tnp_observaciones1, tnp_observaciones2 ; 
	,  tnp_usuario, indicacion,  observaciones, TND_hora,  ; 
	iif(isnull(tnh_anamnesis), ' ', iif(cometodo=1, '=', '*')) as hanam ; 
	, pe, pac_fechaalta, hhc, PAC_sectorinternac, '','' ; 
	from mwkcataux2  ; 
	into cursor mwkcateringx

 
select *,iif(nvl(cama_a, space(10)) = habitac,space(10),nvl(cama_a, space(10))) as cama_ant;
	,iif(nvl(cama_a, space(10)) = habitac,space(5),nvl(hora,space(5))) as hora_cbio,0 as VAL_codadmision;  	
	from mwkcateringx ;&&left join mwknutic on pac_codadmision= VAL_codadmision
	into cursor mwkcatering

**** anteriores
if used('mwkauxi')
	use in mwkauxi
endif
select pac_habitacion+'-'+pac_cama as habitac, pac_nombrepaciente   ; 
	,  proper(pac_descripdiagn) as pac_descripdiagn,  pac_edad ; 
	,  dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pac_fechaadmision ; 
	,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  iif(pac_edad>0, transf(pac_edad, '999'), transf(round((mfecreald-pac_fecnacimiento)/30, 0), '99')+"M") as anios  ; 
	,  nvl(tnp_fecha, mfecreald) as tnp_fecha , nvl(tnp_codserv, 0) as tnp_codserv ; 
	,  iif(tnp_codserv>0, tnp_codfact, space(50)) as tnp_codfact ; 
	,  iif(tnp_codserv=0, tnp_codfact, space(50)) as tnp_codfact0 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact1 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact2 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones1 ; 
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 ,  ; 
	nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones2 ; 
	,  nvl(tnp_usuario,  00000) as tnp_usuario ; 
	, iif(tnp_codserv=0, tnp_observaciones, space(250))  as indicacion, iif(tnp_codserv=0, tnp_observaciones, space(250)) as observaciones ; 
	,  tnh_anamnesis, cometodo, PAC_sectorinternac ; 
	from mwknutant1  ; 
	left outer join mwkentidad on afi_codentidad = ent_codent  ; 
	left outer join mwknuthana1 on pac_codadmision = pin_codadmision ; 
	WHERE ((mwknutant1.TNP_codserv = 0 and  mwknutant1.TND_codPrest>0) or mwknutant1.TNP_codserv>0) ;
	order by tnp_fecha, habitac,  pac_codadmision ,  tnp_codserv  ; 
	group by tnp_fecha, pac_codadmision, tnp_codserv   ; 
	into cursor mwknutcdant1
	
*,  iif(isnull(fecpasiva), "  ", "PE") as pe

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad, pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  anios, tnp_fecha , tnp_codserv,  tnp_codfact2,  tnp_observaciones2,  max(iif(isnull(tnh_anamnesis), ' ', iif(cometodo=1, '=', '*'))) as hanam  ; 
	, max(indicacion) as indicacion ; 
	, iif(tnp_codserv=1, tnp_observaciones1, space(250)) as an1 ; 
	, iif(tnp_codserv=2, tnp_observaciones2, space(250)) as an2 ; 
	, iif(tnp_codserv=3, tnp_observaciones1, space(250)) as an3 ; 
	, iif(tnp_codserv=4, tnp_observaciones2, space(250)) as an4 ; 
	, iif(tnp_codserv=5, tnp_observaciones1, space(250)) as an5 ; 
	, iif(tnp_codserv=6, tnp_observaciones2, space(250)) as an6, PAC_sectorinternac ; 
	from mwknutcdant1  ; 
	where tnp_fecha< mfecreald  ; 
	order by tnp_fecha desc, habitac asc,  pac_codadmision  ; 
	group by tnp_fecha, habitac,  pac_codadmision, tnp_codserv  ; 
	into cursor mwkcatant0

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad, pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ; 
	,  anios, tnp_fecha , tnp_codserv,  tnp_codfact2,  tnp_observaciones2,  hanam  ; 
	, max(indicacion) as indicacion ; 
	, max(an1) as an1 ; 
	, max(an2) as an2 ; 
	, max(an3) as an3 ; 
	, max(an4) as an4 ; 
	, max(an5) as an5 ; 
	, max(an6) as an6, PAC_sectorinternac, '' as Cama_Ant, '' as hora ; 
	from mwkcatant0  left join mwkcamas on pac_codadmision = lug_pacientes ; 
	order by tnp_fecha desc, habitac asc,  pac_codadmision  ; 
	group by tnp_fecha, habitac,  pac_codadmision  ; 
	into cursor mwkcatant

