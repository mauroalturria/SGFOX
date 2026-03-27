Parameters lnId

mFecha = sp_busco_fecha_serv('DT')

mRet = SqlExec(mcon1, "Update TabPasePrecinObj Set Pro_FecPasiva = ?mFecha where Id = ?lnId")

If mRet <= 0
	aerror(eros)
	MessageBox("ERROR AL ELIMINAR EL PRECINTO",48,"VALIDACION")
	Return .f.
Endif 