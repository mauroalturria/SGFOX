*
* Tablas Varias Farmacia
*

If used('mwkentidad')
	Use in mwkentidad
Endif
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient, ENT_turnoshabilit from entidades " + ;
	"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")

If mret < 0
	Messagebox("EN TABLA DE ENTIDADES"+chr(10)+;
		"NOTIFIQUE A SISTEMAS",16,"ERROR")
	Return
Endif

If used('mwkdocu')
	Use in mwkdocu
Endif
mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id from tabdocumentos " + ;
	" where id <100000 order by id", "mwkdocu")

If mret < 0
	Messagebox("EN TABLA DE DOCUMENTOS"+chr(10)+;
		"NOTIFIQUE A SISTEMAS",16,"ERROR")
	Return
Endif


If used('mwkpcia')
	Use in mwkpcia
Endif

mret = sqlexec(mcon1,"select descrip, id from tabpcia " + ;
	" where id <100000 order by descrip", "mwkpcia")

If mret < 0
	Messagebox("EN TABLA DE PROVINCIAS"+chr(10)+;
		"NOTIFIQUE A SISTEMAS",16,"ERROR")
	Return
Endif

If used('mwkloca')
	Use in mwkloca
Endif

mret = sqlexec(mcon1,"select descrip, id from tabloca " + ;
	"where id <100000 order by descrip", "mwkloca")

If mret < 0
	Messagebox("EN TABLA DE LOCALIDADES"+chr(10)+;
		"NOTIFIQUE A SISTEMAS",16,"ERROR")
	Return
Endif
