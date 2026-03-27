*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mcodmed, mfecha

mfechanula = ctot("01/01/1900"
mfecd = dtoc(mfecha) + " 00:00:00"
mfech = dtoc(mfecha+1) + " 00:00:00"
mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac,"+ ;
	" TabHCArchivo.*, TabHCMovct.* " + ;
	" from TabHCMovct " +;
	"left outer join TabHCArchivo on TabHCMovct.hcm_registrac = TabHCArchivo.hca_registrac "+;
	"left outer join registracio on TabHCArchivo.hca_registrac = registracio .REG_nroregistrac "+;
	" where hca_estado = 1 and hcm_codmed = ?mcodmed " + ;
	" and hcm_fechatur >= ?mfecd " +;
	" and hcm_fechatur < ?mfech " +;
	" and hcm_fechaIngr = ?mfechanula " +;
	" order by hca_registrac " , "mwkmovhistan" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif
