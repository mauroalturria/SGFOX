****
** busco pacientes para nutricion
****

dimension cf(100)
store '' to cf
if vartype(msoloint)#"N"
	msoloint = 0
endif
if vartype(mbusco)#"C"
	mbusco = ''
endif
mfechatope = sp_busco_fecha_serv('DD')- 7
mfecha = sp_busco_fecha_serv('DD')
mfecreal = mfecha 
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
	"(select lug_pacientes from mwkcamas where lug_fechaingreso = mfecreal)"+;
	" and lug_fechaegreso = mfecreal "+;
	" order by lug_pacientes,lug_fechaingreso,lug_horaingreso "+;
	" into cursor mwkcamas1"

&msql_hab

select * from mwkcamas1 group by lug_pacientes;
	into cursor mwkcamas
if !used("mwkpres")

*------------------------------------------------------------------------------------
	mret =	sqlexec(mcon1, "select pre_codprest, PRE_descriprest " +  ;
		"from prestacions " +  ;
		"where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")

	if mret<1
		=aerr(eros)
		messagebox(eros(2))
	endif

*------------------------------------------------------------------------------------
endif
do sp_busco_ingred

*-*-*------------------------------------------------------------
*!*	BUSCA PACIENTES (INT)

*** Nutricion del dia

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
	"group by PAC_codadmision", "mwknutpac1")

if mret < 1
	=aerr(eros)
	messagebox(eros(2))
endif
*------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select TabNutPaciente.* , TNP_codfactu, TNP_factura, TNP_dieta " +  ;
	",  TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga,  TND_observa, TND_hora,  TND_FHoraCarga " + ;
	" from TabNutPaciente " +  ;
	" inner join pacinternad on pin_codadmision = TNP_codadmision " +  ;
	" inner join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" +  ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest" +  ;
	" where TNP_Fecha =?mfecreal and tnp_codserv = 0 ", "mwknutdet1")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
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

mret = sqlexec(mcon1, "select PAC_habitacion,  PAC_cama, PAC_nombrepaciente, " +  ;
	"PAC_descripdiagn,  PAC_fechaadmision,  PAC_horaadmision,  afi_codentidad, " + ;
	"PAC_edad,  PAC_codadmision, PAC_fecnacimiento, " + ;
	"TabNutPaciente.*, " +  ;
	"PAC_sectorinternac " + ;
	"from pacinternad " + ;
	"inner join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +  ;
	"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " +  ;
	"left join afiliacion on " + ;
	"	pacientes.PAC_codhci = afiliacion.registracio and " +  ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " +  ;
	"where TNP_fecha > ?mfechatope " + ;
	"GROUP By TNP_Fecha, PAC_codadmision , TNP_CodServ " ,"mwknutant1")


if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif

*------------------------------------------------------------------------------------
*!*	DESDE ACA NO HAY MAS CONSULTAS AL SERVIDOR
*------------------------------------------------------------------------------------

&& nutricion de dia
select pac_habitacion+'-'+pac_cama as habitac, pac_nombrepaciente   ;
	,  proper(pac_descripdiagn) as pac_descripdiagn,  pac_edad ;
	,  dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pac_fechaadmision ;
	,  afi_codentidad, ent_descrient ,  pac_codadmision  ;
	,  prg_edad(PAC_fecnacimiento,mfecha,"AM")  as anios  ;
	,  nvl(tnp_fecha, mfecreal) as tnp_fecha , nvl(tnp_codserv, 0) as tnp_codserv ;
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
	,  iif(isnull(fecpasiva), "  ", "PE") as pe, pac_fechaalta , hour(TND_FHoraCarga) as hhc, PAC_sectorinternac    ;
	from mwknutact1  ;
	left outer join mwkentidad on afi_codentidad = ent_codent  ;
	left join mwkpres on tnd_codprest = pre_codprest and tnp_codserv <= 2  ;
	left join mwktningr on tnd_codprest = mwktningr.id  and tnp_codserv in( 3, 4, 5, 6)  ;
	where isnull(tnp_fecha) or tnp_fecha >=mfechatope  ;
	order by tnp_fecha, habitac,  pac_codadmision ,  tnp_codserv, tnd_nrovale   ;
	group by tnp_fecha, pac_codadmision, tnp_codserv   ;
	into cursor mwknutcdact1

&& recorte una fecha

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad,  ;
	pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ;
	,  anios,  tnp_fecha , tnp_codserv,  tnp_codfact,  tnp_codfact0, tnp_codfact1,  tnp_codfact2 ;
	,  tnp_observaciones1, tnp_observaciones2 ;
	,  tnp_usuario, indicacion,  observaciones, TND_hora  ;
	,  pe, pac_fechaalta, hhc, PAC_sectorinternac, cama as Cama_A, hora ;
	from mwknutcdact1 left join mwkcamas on pac_codadmision = lug_pacientes ;
	into cursor mwkcateringx
	
select *,iif(nvl(cama_a, space(10)) = habitac,space(10),nvl(cama_a, space(10))) as cama_ant;
	,iif(nvl(cama_a, space(10)) = habitac,space(5),nvl(hora,space(5))) as hora_cbio;
	from mwkcateringx ;
	into cursor mwkcatering

**** anteriores
if used('mwkauxi')
	use in mwkauxi
endif
select pac_habitacion+'-'+pac_cama as habitac, pac_nombrepaciente   ;
	,  proper(pac_descripdiagn) as pac_descripdiagn,  pac_edad ;
	,  dtoc(pac_fechaadmision)+" " +ttoc(pac_horaadmision, 2) as pac_fechaadmision ;
	,  afi_codentidad, ent_descrient ,  pac_codadmision  ;
	,  iif(pac_edad>0, transf(pac_edad, '999'), transf(round((mfecreal-pac_fecnacimiento)/30, 0), '99')+"M") as anios  ;
	,  nvl(tnp_fecha, mfecreal) as tnp_fecha , nvl(tnp_codserv, 0) as tnp_codserv ;
	,  iif(tnp_codserv>0, tnp_codfact, space(50)) as tnp_codfact ;
	,  iif(tnp_codserv=0, tnp_codfact, space(50)) as tnp_codfact0 ;
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact1 ;
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 , nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact2 ;
	,  iif(mod(nvl(tnp_codserv, 0), 2)=1 and nvl(tnp_codserv, 0)>0 , nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones1 ;
	,  iif(mod(nvl(tnp_codserv, 0), 2)=0 and nvl(tnp_codserv, 0)>0 ,  ;
	nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones2 ;
	,  nvl(tnp_usuario,  00000) as tnp_usuario ;
	, iif(tnp_codserv=0, tnp_observaciones, space(250))  as indicacion, iif(tnp_codserv=0, tnp_observaciones, space(250)) as observaciones ;
	,  PAC_sectorinternac ;
	from mwknutant1  ;
	left outer join mwkentidad on afi_codentidad = ent_codent  ;
	order by tnp_fecha, habitac,  pac_codadmision ,  tnp_codserv  ;
	group by tnp_fecha, pac_codadmision, tnp_codserv   ;
	into cursor mwknutcdant1
*,  iif(isnull(fecpasiva), "  ", "PE") as pe

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad, pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ;
	,  anios, tnp_fecha , tnp_codserv,  tnp_codfact2,  tnp_observaciones2 ;
	, max(indicacion) as indicacion ;
	, iif(tnp_codserv=1, tnp_observaciones1, space(250)) as an1 ;
	, iif(tnp_codserv=2, tnp_observaciones2, space(250)) as an2 ;
	, iif(tnp_codserv=3, tnp_observaciones1, space(250)) as an3 ;
	, iif(tnp_codserv=4, tnp_observaciones2, space(250)) as an4 ;
	, iif(tnp_codserv=5, tnp_observaciones1, space(250)) as an5 ;
	, iif(tnp_codserv=6, tnp_observaciones2, space(250)) as an6, PAC_sectorinternac ;
	from mwknutcdant1  ;
	where tnp_fecha< mfecreal  ;
	order by tnp_fecha desc, habitac asc,  pac_codadmision  ;
	group by tnp_fecha, habitac,  pac_codadmision, tnp_codserv  ;
	into cursor mwkcatant0

select habitac, pac_nombrepaciente,  pac_descripdiagn,  pac_edad, pac_fechaadmision,  afi_codentidad, ent_descrient ,  pac_codadmision  ;
	,  anios, tnp_fecha , tnp_codserv,  tnp_codfact2,  tnp_observaciones2;
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

