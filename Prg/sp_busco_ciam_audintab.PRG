*
* Tablas CIAM para AUDITORIA DE INTERNACIONES
*

mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select TabCiamubica.ID,TCU_nombre,TCU_telef"+;
	" from TabCiamubica,TabCiamRedM"+;
	" where TabCiamubica.ID = TRM_idcentro"+;
	" and TCU_fecpasiva = ?mfecnull","mwkcentros")
If mret < 0
	Messagebox("EN CONSULTA DE CENTROS ASISTENCIALES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
*
mret = sqlexec(mcon1,"select * from ENTIDADES"+;
	" where ENT_fecpas is null","mwkentidades")
If mret < 0
	Messagebox("EN BUSQUEDA DE LA ENTIDAD"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
*
mret = sqlexec(mcon1,"select * from MotivoEgreso","mwkmotivos")
If mret < 0
	Messagebox("EN BUSQUEDA DE MOTIVOS DE EGRESO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
*
mret = sqlexec(mcon1,"select SEC_codsector,SEC_descripsec from SECTORES"+;
	" where SEC_internacion = 1","mwksectores")
If mret < 0
	Messagebox("EN BUSQUEDA DE SECTORES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
*
mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos order by id", "mwkdocu")
If mret < 1
	Messagebox("EN CONSULTA DE DOCUMENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif