****
** grabo valores de habitaciones
****
lparameters mvhdoble,mvhind,mvhlux
mret = sqlexec(mcon1, "update Tabestados set subestado=?mvhdoble where propietario = 14 and estado = 1")
mret = sqlexec(mcon1, "update Tabestados set subestado=?mvhind where propietario = 14 and estado = 2")
mret = sqlexec(mcon1, "update Tabestados set subestado=?mvhlux where propietario = 14 and estado = 3")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif