****
** busco camas y  pacientes en habitacions
****

parameter mfecha
mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_codadmision , " + ;
	"PAC_sectorinternac, COB_codcontrato, AFI_nroafiliado,PAC_codhce,  " + ;
	"PAC_fechaalta, PAC_nombrepaciente, PAC_fechaadmision, COB_codentidad, " + ;
	"PAC_categoria ,PAC_codadmision , CON_descricont,entidexclu.fecpasiva "+;
	",PAC_medicoadmision, PAC_descripdiagn,PAC_urgenprogramad,PAC_sexo,PAC_edad,PAC_motivoalta,PAC_nombrerespons,PAC_telefresponsab "+;
	"from habitacions left join pacientes on habitacions.hab_codpaciente = pacientes.pacientes " + ;
	"left join pacinternad on pacinternad.pin_codadmision = pacientes.pacientes " + ;
	"left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	"left join coberturas on pacientes.pacientes = coberturas.COB_pacientes " + ;
	"left join contratos on coberturas.COB_codcontrato = contratos.contratos " + ;
	"left join  entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT'  " +;
	"where pacientes<>'BLOQUEO' and COB_codentidad = AFI_codentidad " + ;
	" group by hab_sectores, hab_codhabitacion, hab_codcama, hab_codpaciente "+;
	" ", "mwkpaccama1")
if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif

select min(PAC_fechaadmision) as fechabaja from mwkpaccama1 into cursor mwkfecha1

mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_habilitada, hab_sectores, sec_descripsec,  " + ;
	"PAC_nombrepaciente, PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad , " + ;
	"PAC_categoria ,PAC_sexo, PAC_edad, PAC_codadmision ,sec_internacion,entidexclu.fecpasiva,PAC_nombrerespons,PAC_telefresponsab "+;
	"from habitacions left outer join pacientes on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	"left outer join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	"left outer join sectores on sectores.sec_codsector = habitacions.hab_sectores " + ;
	"left join  entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT'  " +;
	"where sec_internacion = 1 and hab_codpaciente<>'BLOQUEO' " +;
	" group by hab_sectores, hab_codhabitacion, hab_codcama, hab_codpaciente "+;
	"", "mwkpaccams")
if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif
select min(PAC_fechaadmision) as fechabaja from mwkpaccams into cursor mwkfecha2

mret = sqlexec(mcon1, "select PAC_habitacion , PAC_cama, PAC_codadmision , " + ;
	"PAC_sectorinternac, COB_codcontrato,AFI_nroafiliado, PAC_codhce, " + ;
	"PAC_fechaalta, PAC_nombrepaciente, PAC_fechaadmision, COB_codentidad, " + ;
	"PAC_categoria ,PAC_codadmision , CON_descricont,entidexclu.fecpasiva "+;
	",PAC_medicoadmision, PAC_descripdiagn,PAC_urgenprogramad,PAC_sexo, PAC_edad, PAC_motivoalta,PAC_nombrerespons,PAC_telefresponsab  "+;
	"from pacientes, afiliacion,contratos,coberturas " + ;
	"left join  entidexclu on coberturas.COB_codentidad = entidexclu.codent and entidexclu.tpopac='INT'   " +;
	" where PAC_codhci = registracio and " + ;
	" COB_codentidad = AFI_codentidad and " + ;
	" COB_codcontrato = contratos and " + ;
	" PAC_codadmision 	= COB_pacientes and "+;
	" PAC_tipopac<2 " + ;
	" and PAC_fechaalta >= ?mfecha "+;
	" group by PAC_codadmision  ","mwkpacalta")
if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif
select min(PAC_fechaadmision) as fechabaja from mwkpacalta into cursor mwkfecha3

mfechapasiva = min(mwkfecha1.fechabaja ,mwkfecha2.fechabaja ,mwkfecha3.fechabaja )
do sp_entidades  with mfechapasiva

update mwkpacalta set PAC_habitacion ='' , PAC_cama='';
	,PAC_sectorinternac='', PAC_categoria =''

if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif

select PAC_habitacion , PAC_cama, PAC_codadmision , PAC_sectorinternac, COB_codcontrato,;
	PAC_fechaalta, PAC_nombrepaciente, PAC_fechaadmision, COB_codentidad, ;
	PAC_medicoadmision, PAC_descripdiagn,AFI_nroafiliado,PAC_codhce,PAC_urgenprogramad,;
	PAC_categoria ,PAC_codadmision ,CON_descricont,fecpasiva ,PAC_sexo, PAC_edad, PAC_motivoalta,PAC_nombrerespons,PAC_telefresponsab;
    from mwkpaccama1  ;
	union select PAC_habitacion , PAC_cama, PAC_codadmision , PAC_sectorinternac,COB_codcontrato,  ;
	PAC_fechaalta, PAC_nombrepaciente, PAC_fechaadmision, COB_codentidad, ;
	PAC_medicoadmision, PAC_descripdiagn,AFI_nroafiliado,PAC_codhce,PAC_urgenprogramad,;
	PAC_categoria ,PAC_codadmision , CON_descricont,fecpasiva,PAC_sexo, PAC_edad, PAC_motivoalta,PAC_nombrerespons,PAC_telefresponsab;
	from mwkpacalta ;
	into cursor mwkpaccam

=tablerevert(.t.,'mwkpacalta')



select mwkpaccam.*,iif(isnull(fecpasiva),'  ','PE') as tipoPe,ENT_descrient,ENT_nroprestadorexterno,ENT_codent  ;
	from mwkentidad ;
	left outer join mwkpaccam on COB_codentidad = ENT_codent ;
	order by PAC_nombrepaciente;
	into cursor mwkpaccama

select hab_codhabitacion, hab_codcama, hab_sectores, count(hab_codcama) as libres ;
	from mwkpaccams where hab_codpaciente='0';
	group by hab_sectores ;
	into cursor mwkpaccamlib

select mwkpaccams.*,pin_codentidad  as COB_codentidad ,ENT_descrient,ENT_nroprestadorexterno,libres  ;
	from mwkpaccams ;
	left outer join mwkentidad  on pin_codentidad = ENT_codent ;
	left outer join mwkpaccamlib ;
	on 	mwkpaccams.hab_sectores= mwkpaccamlib.hab_sectores;
	order by mwkpaccams.hab_sectores, mwkpaccams.hab_codhabitacion, mwkpaccams.hab_codcama ;
	into cursor mwkpaccamas

if used ('mwkpacalta')
	use in mwkpacalta
endif
select mwkpaccama1.*,ENT_descrient,ENT_nroprestadorexterno  ;
	from mwkpaccama1 ;
	left outer join mwkentidad on COB_codentidad = ENT_codent ;
	order by COB_codentidad,COB_codcontrato,PAC_codadmision   ;
	into cursor mwkpacent
