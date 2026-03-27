*
* Tipos de Ubicación según centros de derivación
*
mdestino = 9

If used('mwkubica')
	Use in mwkubica
Endif

mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino"+;
	" order by descrip", "mwkubica")
	
If mret<1
	Messagebox("EN TABLA ESTADOS - TIPOS DE UBICACION"+;
	chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
