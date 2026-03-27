*
* Registro de LOG HCI Archivo de Internados
*

Lparameters madm,mfec,mestado,mobs,muse

mret = sqlexec(mcon1,"insert into TabHCILog (TLO_admision,TLO_fecestado,"+;
	"TLO_estado,TLO_obser,TLO_idusuario)"+;
	" values (?madm,?mfec,?mestado,?mobs,?muse)")

If mret < 0
	Messagebox("EN REGISTRO DE UNA ADMISION EN TABLA H.C.I./LOG"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
