****
** busco camas y  pacientes en habitacions
****

parameter mfecha

mret = sqlexec(mcon1, "select hab_habilitada, hab_sectores, hab_codpaciente" + ;
	", hab_codbloqueo, pin_codentidad, PAC_categoria ,sec_internacion" + ;
	",sectoragrup, secagrup.descripcion, sec_descripsec "+;
	"from habitacions left outer join pacientes on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	"left outer join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	"left outer join sectores on sectores.sec_codsector = habitacions.hab_sectores " + ;
	"left join secagrup on hab_sectores = secagrup.sector " + ;
	"left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	"where sec_internacion = 1 and hab_codpaciente <>'BLOQUEO' " +;
	" group by hab_sectores, hab_codhabitacion, hab_codcama, hab_codpaciente "+;
	" ", "mwkpaccama1")

if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif

select nvl(pin_codentidad,0) as codenti ,sectoragrup, descripcion ,count(hab_codpaciente) as totcam;
	from mwkpaccama1 ;
	group by  sectoragrup,codenti where trim(hab_codpaciente) <>'IND.' ;
	into cursor mwkpaccam

sqlsuma = "sum(iif(sectoragrup='INT',totcam,0)) as piso,"+;
	"sum(iif(sectoragrup='TIN',totcam,0)) as utiint,"+;
	" sum(iif(sectoragrup='UCO',totcam,0)) as uco,"+;
	" sum(iif(sectoragrup='PED',totcam,0)) as ped, " +;
	" sum(iif(sectoragrup='TEP',totcam,0)) as utiped,"+;
	" sum(iif(sectoragrup='NEO',totcam,0)) as neo, " +;
	" sum(iif(sectoragrup#'CEG' and sectoragrup#'NUR' ,totcam,0)) as total1," +;
	" sum(iif(sectoragrup='RCV',totcam,0)) as RCV,"+;
	" sum(iif(sectoragrup='CEG' ,totcam,0)) as htldia," +;
	" sum(iif(sectoragrup='NUR' ,totcam,0)) as nur, " +;
	" sum(iif(!inlist(sectoragrup,'TIN','INT','UCO','PED','TEP','NEO','RCV','CEG','NUR'),totcam,0)) as nodef, " +;
	" sum(totcam) as otros "

select mwkpaccam.*, ENT_descrient,ENT_nroprestadorexterno, &sqlsuma;
	from mwkpaccam ;
	left outer join mwkentidad on codenti = ENT_codent ;
	group by codenti ;
	order by ENT_descrient;
	into cursor mwkpacoc2

select nvl(pin_codentidad,0) as codenti ,sectoragrup, descripcion ,count(hab_codpaciente) as totcam;
	from mwkpaccama1 ;
	group by  sectoragrup,codenti where trim(hab_codpaciente) <>'IND.' ;
	into cursor mwkpaccam

select iif(sectoragrup='CEG' or sectoragrup='NUR',2,1) as tipo , descripcion , sum(iif(hab_codpaciente='0',1,0)) as libres ;
	, sum(iif(hab_codpaciente#'0' and trim(hab_codpaciente) <>'IND.',1,0)) as ocupadas ;
	from mwkpaccama1 ;
	group by sectoragrup;
	order by sectoragrup;
	into cursor mwkepdef1

select 0 as tipo , sec_descripsec+space(5) as descripcion , sum(iif(hab_codpaciente='0',1,0)) as libres ;
	, sum(iif(hab_codpaciente#'0' and trim(hab_codpaciente) <>'IND.',1,0)) as ocupadas ;
	from mwkpaccama1 ;
	group by hab_sectores;
	order by hab_sectores;
	into cursor mwkepdef0

select * from mwkepdef0;
	union select * from mwkepdef1;
	into cursor mwkepdef

if used('mwkpaccama1')
	use in mwkpaccama1
endif
if used('mwkepdef0')
	use in mwkepdef0
endif

if used('mwkepdef1')
	use in mwkepdef1
endif

