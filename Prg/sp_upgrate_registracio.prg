****
**  Actualizo registracio
****
Parameter mnombre, mdocu, mdomi, mtele, mcpostal, mtipdocu, mloca, mpcia

midregis = mwkbuspacie1.REG_nroregistrac

mret = sqlexec(mcon1, "update registracio set REG_nombrepac = ?mnombre, REG_numdocumento = ?mdocu, " + ;
				"REG_domicilio = ?mdomi, REG_telefonos = ?mtele, REG_cpostal = ?mcpostal, " + ;
				"REG_tipodocumento = ?mtipdocu, REG_localidad = ?mloca, " + ;
				"REG_provincia = ?mpcia where REG_nroregistrac = ?midregis")

if mret < 0
	messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	