***
*** Busco centros medicos
***

mret = SQLExec(mcon1, "select descripcion, ID,centromedico, abreviatura, activo, ambito,"+;
  " centromedicoMK, centros,orden, web "+;
	" from Tabctromedico where activo = 1 " , "mwkambitoCM")
If mret < 0
	Do log_errores With Error(), Message(),'Tabctromedico ', Program(), Lineno()

Endif
