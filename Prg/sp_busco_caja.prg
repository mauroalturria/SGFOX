*
* Busco caja
*
parameters mdigito,mcaja

mdigito = iif(vartype(mdigito)#"N","",mdigito)
mcaja 	= iif(vartype(mcaja)#"N","",mcaja)
mdigito = transf(mdigito )
if pcount()= 0
	sqlCmd 	= ''
else
	sqlCmd 	= " where "+ iif(!empty(mdigito)," digito = ?mdigito ",'')+;
		iif(!empty(mcaja)," digito = ?mdigito and caja = ?mcaja",'' )
endif
mret = sqlexec(mcon1, "SELECT *,id as lid from TabHciCajas" + sqlCmd ,"mwkCaja")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif

