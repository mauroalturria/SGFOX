****
** Busco pacientes de alta por nombre y fecha_alta desde
****

parameter mnroadm, msql_pac

ctipopac =" pac_tipopac<2 "
if !used('mwkusuariosall')
	do sp_busco_usuarios_all
endif
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_codadmision, PAC_fechaadmision, " + ;
	"PAC_fechaalta, ENT_descrient, mte_descripcion, PAC_sexo, " + ;
	"PAC_edad, PAC_diagegreso, PAC_nombrerespons, PAC_domicresponsab, " + ;
	"PAC_telefresponsab, PAC_medicoadmision, PAC_descripdiagn, " + ;
	"PAC_denuncia, PAC_medicoalta, PAC_diagegreso, PAC_observalta, " + ;
	"PAC_codhce, PAC_horaadmision, PAC_horaalta , PAC_operadm ,PAC_operalta," + ;
	"reg_domicilio,REG_localidad,REG_provincia, REG_telefonos,PAC_codhci,COB_codentidad, COB_codcontrato,REG_distrito, " + ;
	"pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos,pac_ordeninternac " +;
	"from coberturas, entidades, registracio,pacientes " + ;
	"left join motivoegreso on pacientes.PAC_motivoalta = motivoegreso.mte_codmotivo " + ;
	"where PAC_codadmision 	= COB_pacientes and " + ;
	"COB_codentidad 		= ENT_codent and " + ;
	"PAC_codhci				= REG_nroregistrac and " + ;
	"PAC_codadmision 		= ?mnroadm and " + ;
	ctipopac  + ;
	"order by PAC_nombrepaciente, PAC_fechaadmision ", "mwkpacalta1")

*						"PAC_tipopaciente not in ('GUA', 'AMB') "

if mret < 0
	messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
	do prg_cancelo
else

	select mwkpacalta1.* ,tabusuario2.idusuario as operalta,tabusuario1.idusuario as operadmi ;
		from mwkpacalta1 ;
		left join  mwkusuariosall as tabusuario1 on PAC_operadm 	= tabusuario1.codigovax;
		left join  mwkusuariosall as tabusuario2 on PAC_operalta 	= tabusuario2.codigovax;
		into cursor mwkpacalta
endif
