*
* Eliminación - Pasiva, registro de Auditoría CIAM, codigo de motivo 9
*
Lparameters mlid

musuario = mwkusuario.idusuario
mfecmov  = sp_busco_fecha_serv('DT') 

*messagebox(str(mlid))

mret = sqlexec(mcon1,"update TabCiamAudInt set TCI_idmotivo = 9,TCI_usuario = ?musuario,"+;
	"TCI_fecmov = ?mfecmov where id = ?mlid")

If mret < 0
	Messagebox("EN ELIMINACION DE AUDITORIA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
