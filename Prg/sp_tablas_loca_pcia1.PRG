****
**	Busco solo las Pcias y Localidades
****

*!* Despues hay que cambiarla por TabPcia cuando Nico migre los datos
If used('mwkpcia')
	use in mwkpcia
Endif
mret = sqlexec(mcon1,"select ID as pciaID,* from TabPcia1"+;
	" order by descrip","mwkPcia")
If mret < 0
	Messagebox("ERROR EN CURSOR DE PROVINCIAS",0+48,"Validación")
	Return
Endif
*!* Despues hay que cambiarla por TabLoca cuando Nico migre los datos
If used('mwkloca')
	use in mwkloca
Endif
mret = sqlexec(mcon1,"select * from TabLoca1"+;
	" order by descrip","mwkLoca")
If mret < 0
	Messagebox("ERROR EN CURSOR DE LOCALIDADES",0+48,"Validación")
	Return
Endif
