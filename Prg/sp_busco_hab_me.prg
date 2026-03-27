****
** busco camas en habitacions
****
parameter mcodsec, mhabitsala, msql_cama

mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
	"hab_habilitada, pac_nombrepaciente, pac_sexo, pac_edad, " + ;
	"pac_descripdiagn, pac_categoria, pin_codentidad " + ;
	"from habitacions left outer join pacientes on " + ;
	"habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
	"left outer join pacinternad on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
	"where hab_sectores = ?mcodsec " + ;
	"order by hab_codhabitacion, hab_codcama", "mwkcama0")

if !used("mwkCorcama")
	mret = sqlexec(mcon1, "select * from  TabHabcolor ", "mwkCorcama")
endif
select  mwkcama0.*,THC_Cor  from mwkcama0;
	left join mwkCorcama on hab_codhabitacion = THC_Hab and hab_codcama = THC_Cama ;
	into cursor mwkcama1
use in 	mwkcama0
if mhabitsala = 'H'
	selec hab_codhabitacion;
		,iif(hab_codcama = '01',hab_codcama,'  ')  as cam1 ;
		,iif(hab_codcama = '01',pac_categoria ,' ') as pac1 ;
		,iif(hab_codcama = '01',pin_codentidad ,pin_codentidad-pin_codentidad) as ent1 ;
		,iif(hab_codcama = '01',pac_nombrepaciente ,space(50) ) as nom1 ;
		,iif(hab_codcama = '01',pac_sexo ,' ') as sex1 ;
		,iif(hab_codcama = '01',pac_edad ,pac_edad-pac_edad) as eda1 ;
		,iif(hab_codcama = '01',pac_descripdiagn ,space(50)) as dia1 ;
		,iif(hab_codcama = '01',hab_codpaciente ,'        ') as codp1 ;
		,iif(hab_codcama = '01',nvl(THC_Cor,0) ,0) as cama_esp_1 ;
		,iif(hab_codcama = '02',hab_codcama ,'  ') as cam2;
		,iif(hab_codcama = '02',pac_categoria ,' ') as pac2 ;
		,iif(hab_codcama = '02',pin_codentidad ,pin_codentidad-pin_codentidad) as ent2;
		,iif(hab_codcama = '02',pac_nombrepaciente ,space(50)) as nom2;
		,iif(hab_codcama = '02',pac_sexo ,' ') as sex2 ;
		,iif(hab_codcama = '02',pac_edad ,pac_edad-pac_edad) as eda2;
		,iif(hab_codcama = '02',pac_descripdiagn ,space(50)) as dia2;
		,iif(hab_codcama = '02',hab_codpaciente,'        ') as codp2 ;
		,iif(hab_codcama = '02',nvl(THC_Cor,0) ,0) as cama_esp_2 ;
		from mwkcama1 into cursor mwkc2
&&		, iif(inlist(hab_codhabitacion,'1336'),1,0) as cama_esp

	selec hab_codhabitacion as hab1, max(cam1) as cam1, max(pac1) as pac1, ;
		max(ent1) as ent1, max(nom1) as nom1, max(sex1) as sex1,  ;
		max(eda1) as eda1, max(dia1) as dia1,max(codp1) as codp1, ;
		hab_codhabitacion as hab2, max(cam2) as cam2, max(pac2) as pac2, ;
		max(ent2) as ent2, max(nom2) as nom2, max(sex2) as sex2, ;
		max(eda2) as eda2, max(dia2) as dia2,max(codp2 ) as codp2 ;
		, cama_esp_1, cama_esp_2;
		from mwkc2 group by hab_codhabitacion;
		into cursor mwkcamas


*!*		select * from mwkcama1 where hab_codcama = '01' into cursor mwkc2
*!*		select * from mwkcama1 where hab_codcama = '02' into cursor mwkc3
else
	select * from mwkcama1 order by hab_codcama   into cursor mwkc2
	select * from mwkcama1 where hab_codcama = '' into cursor mwkc3
	selec a.hab_codhabitacion as hab1, a.hab_codcama as cam1, a.pac_categoria as pac1, ;
		a.pin_codentidad as ent1, a.pac_nombrepaciente as nom1, a.pac_sexo as sex1,  ;
		a.pac_edad as eda1, a.pac_descripdiagn as dia1,a.hab_codpaciente as codp1, ;
		b.hab_codhabitacion as hab2, b.hab_codcama as cam2, b.pac_categoria as pac2, ;
		b.pin_codentidad as ent2, b.pac_nombrepaciente as nom2, b.pac_sexo as sex2, ;
		b.pac_edad as eda2, b.pac_descripdiagn as dia2,b.hab_codpaciente as codp2;
		, nvl(a.THC_Cor,0) as cama_esp_1,nvl(b.THC_Cor,0)  as cama_esp_2 ;
		from mwkc2 as a left outer join	mwkc3 as b on ;
		a.hab_codhabitacion = b.hab_codhabitacion ;
		into cursor mwkcamas

endif
msql_cama = "select hab1, cam1, " + ;
	"iif(pac1 = 'A', 'AISL', iif(pac1 = 'I', 'IND ', iif(codp1 = 'BLOQUEO'," + ;
	" 'BLQ ', iif(codp1 = 'RESERV', 'RES ', '    ')))) as est1, "+ ;
	"iif(isnull(ent1), '     ', transf( ent1, '@z 99999' ) ) as ent1, " + ;
	"iif(isnull(nom1), space(40), nom1) as nom1, " + ;
	"iif(isnull(sex1), ' ', sex1) as sex1, iif(val(codp1)=0 or isnull(eda1), '   ', str(eda1, 3)) as eda1, " + ;
	"iif(isnull(cam2), '  ', cam2) as cam2, iif( codp2 = 'BLOQUEO', 'BLQ ', " +;
	" iif(codp2 = 'RESERV', 'RES ', '    ')) as est2, " + ;
	"iif(isnull(ent2), '     ', transf( ent2, '@z 99999' ) ) as ent2, " + ;
	"iif(isnull(nom2), space(40), nom2) as nom2,"+;
	" iif(isnull(sex2), ' ', sex2) as sex2, " + ;
	"iif(val(codp2)=0 or isnull(eda2), '   ', str(eda2, 3)) as eda2, dia1, dia2,cama_esp_1 ,cama_esp_2   "+;
	"from mwkcamas into cursor mwkcama"


