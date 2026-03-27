****
** Actualizo datos - Entidad Agrupación
****
parameter mabm, mCodPad, mCodHijo

If mabm = 2 && Actualizacion
	mret = Sqlexec(mcon1, "Update entidades Set Ent_CodAgrup = ?mCodPad "+;
		"Where Ent_CodEnt = ?mCodHijo ")
Endif 

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
