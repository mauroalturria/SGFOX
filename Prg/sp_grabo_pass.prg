****
* Actualiza fecha y pass
****
PARAMETERS mpassword,mcodigovax,mfecha  
mFecha = sp_busco_fecha_serv('DD') + 30
mret = SQLEXEC(mcon1," update tabpusuario set  fechavence =?mFecha  ,password = ?mpassword "+;
" where codigovax = ?mcodigovax")

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF