*
* Monitor busqueda de destinos
*
If used('mwkldestinos')
	Use in mwkldestinos
Endif

mret = sqlexec(mcon1,"select * from CPDESTIN","mwkldestinos")

If mret < 0
	=aerror(eros)
	Messagebox("EN CONSULTA DE DESTINOS"+chr(10)+;
		alltrim(eros(3))+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif


