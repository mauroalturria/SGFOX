*
* Control para entidad sobre historias ingresadas en un franja
*
Lparameters menti, mdesd, mhast, mlid

If used('mwkarcdep')
	Use in mwkarcdep
Endif

mwhere = ""
If mlid > 0
	mwhere = " and TabHCIUbicacion.Id <> ?mlid"
Endif

mret = sqlexec(mcon1,"select * from TabHCIUbicacion"+;
	" where HCU_HCDesde <= ?mhast and HCU_HCHasta >= ?mdesd"+;
	" and HCU_codent = ?menti" + mwhere,"mwkarcdep")

If mret < 0
	Messagebox("EN CONSULTA DE H.C. DEPURADAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
