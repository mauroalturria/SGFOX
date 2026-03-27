lparameters mot,mconforme 

mfecha = mwkfecserv.fechahora
mret = sqlexec(mcon1," update tabmantenimiento set conforme = ?mconforme ,FechaConforme =  ?mfecha  "+; 
" where id = ?mot ")

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

