*
* Busqueda de Admision en Maestro HCI Historias Anteriores
*
Parameters mcodadm, mjoin, mcamp

If vartype(mjoin) <> "C"
	mjoin = ""
	mcamp = ""
Endif

If used("mwkpacadm")
	Use in mwkpacadm
Endif

mret = sqlexec(mcon1,"select * " + iif(!empty(mjoin), mcamp, "") + " from TabHciAdm" +;
	iif(!empty(mjoin), mjoin, "") + " where adm_nroadm = ?mcodadm","mwkpacadm")

If mret < 0
	=aerror(merror)
	Messagebox("EN BUSQUEDA DE HISTORIAS ANTERIORES"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
Endif
