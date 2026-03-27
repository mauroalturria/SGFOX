parameters sqlgraba

If mcon1=0
	Messagebox("Error de conexion, no graba datos",16,"Error")
	Return .F.
Else
	mret = SQLExec(mcon1,sqlgraba)
Endif

Return (mret > 0)

