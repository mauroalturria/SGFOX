****
** busco camas y  pacientes en habitacions
****

parameter mbusca, mwhere, morden, mvgrupo , mvcampo, mCursor

mCursor = IIF(VARTYPE(mCursor) <> "C","mwkpaccama",mCursor)
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = "  and hab_sectores in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico)  "
Endif

mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_habilitada, "+;
	"hab_sectores, sec_descripsec, PAC_nombrepaciente, PAC_descripdiagn, PAC_fechaadmision, "+;
	"PAC_horaadmision, pin_codentidad, cast(trim(REG_distrito) as integer) as REG_distrito , " + ;
	"AFI_nroafiliado, AFI_idplan, PAC_categoria ,PAC_sexo, PAC_edad, PAC_codadmision ,sec_internacion,"+;
	"entidexclu.fecpasiva ,PAC_fecnacimiento, idusuario, pacientes.PAC_fechaalta, "+;
	" PAC_codhci, registracio.reg_numdocumento,registracio.REG_email " + ;
	"from habitacions "+;
	"left outer join pacientes on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	"left outer join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	"left outer join sectores on sectores.sec_codsector = habitacions.hab_sectores " + ;
	"left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	"left join  entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT'  " +;
	"left outer join registracio on registracio.reg_nroregistrac = pacientes.pac_codhci " + ;
	"left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax " +;
	"where sec_internacion = 1 " + mbusca + mwcm + ;
	" group by hab_sectores, hab_codhabitacion, hab_codcama, hab_codpaciente "+;
	" order by hab_sectores, hab_codhabitacion, hab_codcama ", "mwkpaccama1")
if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
mfecdia = sp_busco_fecha_serv('DD')
select mwkpaccama1.*,iif(hab_codpaciente="BLOQUEO","B",PAC_categoria) as categoria,iif(isnull(fecpasiva),'  ','PE') as tipoPe, ;
	ENT_descrient , &mvgrupo as vargrupo ,&mvcampo as varcampo ;
	,iif(PAC_edad>0,transf(PAC_edad,'999'),transf(round((mfecdia-PAC_fecnacimiento)/30,0),'99')+"M") as anios ;
	from mwkpaccama1 ;
	left outer join mwkentidad on pin_codentidad = ENT_codent ;
	&mwhere ;
	&morden ;
	into cursor &mCursor
