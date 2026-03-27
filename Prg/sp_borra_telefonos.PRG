*
* Eliminación de teléfonos
*
Parameters mlid
musu = mwkusuario.idusuario
midusu_id = mwkusuario.Id
If Left(mwkusuario.nomape,1)='*'
	musu = mwkusuarios.idusuario
	midusu_id = mwkusuarios.Id
Endif
mfnu = sp_busco_fecha_serv('DD')
mret = sqlexec(mcon1,"update TabRegTel set TRT_pasiva=?mfnu,UserDbUpd=?musu where id=?mlid")
If mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
Return .T.
