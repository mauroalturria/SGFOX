*
* Farmacia / Citostáticos : Estados
*


If used('mwkTabEstados')
	Use in mwkTabEstados
Endif

mret = sqlexec(mcon1,"select * from tabestados where propietario=31 and estado=1"+;
	" order by descrip","mwkTabEstados")

If mret < 0
	Messagebox("FARMACIA, TABLA ESTADOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
