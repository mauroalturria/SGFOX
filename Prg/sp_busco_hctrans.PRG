Lparameters ldFecDes, ldFecHas, lcBusco

mret = Sqlexec(mcon1, "SELECT registracio.REG_nombrepac, registracio.REG_nrohclinica, " + ;
	"Prestadores.nombre, " + ;
	"sdep.Descripcion, " + ; 
	"TABhcmovst.* " + ; 
	"FROM TABhcmovst " + ; 
	"left join registracio on REG_nroregistrac = TABhcmovst.hcm_registrac " + ;
	"left join Prestadores on Prestadores.Id = Tabhcmovst.hcm_codmed " + ;
	"left join sdep on hcm_codesp = sdep.Id " + ;
	"WHERE Hcm_fechatur Between ?ldFecDes and ?ldFecHas " + lcBusco + " " + ;
	"Order by Hcm_fechatur asc " , "mwkHcTrans")
	
If mret <= 0
	Messagebox("ERROR DE LECTURA DE HC",48,"VALIDACION")
	Return .f.
Endif 	 
	
	