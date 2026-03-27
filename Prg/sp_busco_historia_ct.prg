*!*	Busco Historias c/Turnos
*!*	---------------------------------------------------------
Parameters mcFecDes, mcFecHas, mBusco

mfechanula = "1900-01-01 00:00:00"

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, reg_numdocumento, reg_nrohclinica, " + ;
	"TabHCArchivo.hca_Estado, TabHCEstado.hce_descrip, TabHCArchivo.hca_Usuario, " + ;
	"TabHCMovct.* ,nombre as hcm_descMed, ESP_descripcion as hcm_descEsp, registracio.REG_nroregistrac " +;
	" from TabHCMovct,TabHCArchivo, prestadores, registracio ,TabHCUbica ,especialid, TabHCEstado " +;
	"where hcm_registrac = hca_registrac and "+;
	"hca_registrac = REG_nroregistrac and codubi = hca_motfalta  and "+;
	"hcm_codmed = prestadores.id "+;
	"and TabHCEstado.Id = TabHCArchivo.hca_Estado "+ ;
	"and trim(hcm_codesp) = trim(ESP_codesp) " + ;
	"and hcm_fechatur >= ?mcFecDes " +;
	"and hcm_fechatur < ?mcFecHas " +;
	"and hcm_fechaIngr = ?mfechanula " + mBusco +;
	"  " , "mwkmovhist" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif