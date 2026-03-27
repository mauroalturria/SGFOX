*
* Busqueda en Tabambulatorio HCE
*
Parameters mregis, mfechaing, mcodmed

mretorno = space(3)
Use in select("mwkbushce")
mret = 0
if mfechaing # {  /  /  }
	mret = sqlexec(mcon1,"select * from Tabambulatorio" +;
	" where nroregistrac = ?mregis and fechaate = ?mfechaing" +;
	" and demanda < 8 and codestado > 1"+;
	" and codmed = ?mcodmed","mwkbushce")
endif
If mret < 0
	mretorno = "ERR"
Else
	If used("mwkbushce")
		If reccount("mwkbushce")>0
			mretorno = "HCE"
		Endif
	Endif
Endif
Use in select("mwkbushce")

Return mretorno
