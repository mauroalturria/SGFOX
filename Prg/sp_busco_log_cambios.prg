*******
*** Busco el log de los datos modificados de una tabla
*******
parameters mtabla,mdato,mid
mwhere = ''
if vartype(mdato)="C"
	mwhere = mwhere + " and TLC_Dato = ?mdato "
endif
if vartype(mid)="N"
	mwhere = mwhere + " and and TLC_Id = ?mid "
endif
mret = sqlexec(mcon1," select TLC_Dato, TLC_FecMod, TLC_Id, TLC_Tabla,"+;
	" TLC_Tipo, TLC_Usuario, TLC_ValorAct, TLC_ValorAnt from TabLogCambios "+;
	"where TLC_Tabla = ?mtabla " + mwhere , "mwkLogcambios")
if mret<1
	=aerr(eros)
	messagebox(eros(3)  )
endif
