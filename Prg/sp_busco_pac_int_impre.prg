*!*	------------------------------------------------------------------------
*!*	Imprime informe de hospitalizacion de pacientes
*!*	------------------------------------------------------------------------
parameter mcodadm,eqorden

IF VARTYPE(eqorden)#"C"
	eqorden= ''
ENDIF
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = 	" and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) " 
Endif

mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_codhce, PAC_codadmision, " + ;
	"paj_nropajarera, COB_codentidad, ENT_descrient,ENT_nroprestadorexterno, COB_codcontrato,COB_CondicImpositiva, " + ;
	"CON_descricont, AFI_nroafiliado, REG_tipodocumento, REG_numdocumento,PAC_denuncia, " + ;
	"PAC_fecnacimiento, PAC_edad, PAC_sexo, PAC_estadocivil, PAC_ocupacion, " + ;
	"reg_domicilio,REG_localidad,REG_provincia, REG_telefonos, tabcie10.descrip as diagnostico, " + ;
	"PAC_nombrerespons, PAC_domicresponsab, PAC_telefresponsab, PAC_fechaadmision, " + ;
	"PAC_horaadmision, tabsectorint.descrip as areaint, PAC_habitacion, PAC_cama,PAC_motivoalta,PAC_motivoadmision ,PAC_codcie10diagegr, " + ;
	"PAC_operadm, PAC_operalta, PAC_fechaalta, PAC_horaalta, TPV_Estado, PAC_codhci,PAC_codcie10diagn ,tabcie10.codcie10, " +;
	"tabdocumentos.abrevio, PAC_descripdiagn, entidexclu.fecpasiva,pac_tipopac,PAC_sectorinternac ,sec_descripsec " + ;
	"from pacientes " + ;
	"Inner Join coberturas on COB_pacientes = PAC_codadmision " + ;
	"Inner Join entidades on ENT_codent = COB_codentidad " + ;
	"Inner Join contratos on CON_codcont = COB_codcontrato " + ;
	"Inner Join registracio on PAC_codhci = REG_nroregistrac " + ;
	"Inner Join tabcie10 on tabcie10.Id = PAC_codcie10diagn " + ;
	"Inner Join afiliacion on afiliacion.registracio = REG_nroregistrac and AFI_codentidad = COB_codentidad " + ;
	"Inner Join tabdocumentos on codigovax = cast(REG_tipodocumento as integer) " + ;
	"Inner Join sectores on pacientes.PAC_sectorinternac = sec_codsector " + ;
	"left join  tabsectorint on pacientes.PAC_areainternac = tabsectorint.id " +;
	"left join  entidexclu on coberturas.COB_codentidad = entidexclu.codent  and entidexclu.tpopac='INT'  " +;
	"left join  pajareras on pacientes.PAC_codadmision = pajareras.paj_codadmision " +;
	"left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	"where  PAC_codadmision 	= ?mcodadm " +mwcm+ ;
	" order by COB_fechacomcob "+eqorden, "mwklista0")
if mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
 	MessageBox("ERROR DE LECTURA ", 48, "VALIDACION")
	aerror(eros)
	Return .f.
Endif 

select * ;
	from mwklista0 ;
	group by PAC_codadmision ;
	into cursor mwklista
	
use in mwklista0
