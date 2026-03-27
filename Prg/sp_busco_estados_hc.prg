****
** Busco TabEstados
****

Parameters mbusco,mcursor

If vartype(mbusco) # "C"
	mbusco= ""
Endif
If vartype(mcursor) # "C"
	mcursor = "mwkHCEstado"
Endif
if used(mcursor)
	use in &mcursor
endif
mret = sqlexec(mcon1,"select * from tabhcestado &mbusco order by hce_descrip " , mcursor)
	
If mret < 1
	=aerr(eros)
	Messagebox(eros(3))
Endif
