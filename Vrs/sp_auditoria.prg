do sp_conexion
mret = sqlexec(mcon1, "select * from TabPacVip where TPV_Audit = 1  ","mwkctrl")
select * from mwkctrl where TPV_Observa = "*" into cursor mwkctrl0
select mwkctrl0
set step on
scan 
	 if TPV_Observa = "*"
 		mid = id
		mret = sqlexec(mcon1, "update TabPacVip set TPV_Audit = 0, TPV_Observa = '' "+;
			" where id = ?mid ")
	endif
endscan
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
do sp_desconexion 
