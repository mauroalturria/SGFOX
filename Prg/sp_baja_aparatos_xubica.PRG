*
* Baja de Aparatos x ubicación
*
Lparameters mlid

muser = mwkusuario.idusuario
mfebj = sp_busco_fecha_serv('DT')
mfnul = sp_busco_fecha_serv('DD')

mret = sqlexec(mcon1,"update TabApaUbica set "+;
	"TAU_idusuario=?muser,TAU_fechamov=?mfebj,TAU_FPasiva=?mfnul"+;
	" where id=?mlid")

If mret < 0
	Messagebox("EN BAJA DE APARATOS POR UBICACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

