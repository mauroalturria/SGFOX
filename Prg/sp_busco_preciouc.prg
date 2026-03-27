****
** Busco Listado
****

Parameter mnroArt,mnroDep
mret = sqlexec(mcon1, "select first 1 rpd.Rpvd_Preciouni as Precio " + ;
		" from Remitoprvdet rpd "+;
		" join Confrecepdet cnd on (cnd.Rpv_Id = rpd.Rpv_Id and " + ;
		" cnd.Art_Id = rpd.Art_Id) "+;
		" join Confrecep cnr on (cnr.Cnr_Id = cnd.Cnr_Id ) "+;
		"  where rpd.Art_Id = ?mnroArt and cnr.Cnr_Deposito = ?mnroDep "+;
		" order by cnr.Cnr_Fecha Descending ", "mwkpuc")

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 18, "Validacion")
endif
