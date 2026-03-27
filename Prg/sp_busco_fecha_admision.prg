Lparameters mNroReg

Local ldResu

mret = Sqlexec(mcon1, "Select Top 1 Pac_FechaAdmision  " + ;
	    "from pacientes " + ;
	    "where PAC_codhci = ?mNroReg " + ;
	    "Order By Pac_FechaAdmision Desc","mwkPacUlt")

If mRet <= 0
	Messagebox("ERROR AL OBTENER FECHA DE ULTIMA ADMISION",48,"VALIDACION")
	Return Ctod("")
Endif  	    

ldResu = mwkPacUlt.Pac_FechaAdmision
Use In mwkPacUlt

Return ldResu	    