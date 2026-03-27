lparameters mdestino
mretorno = .f.
if used('mwkcodserv')
	use in mwkcodserv
endif
mret=sqlexec(mcon1, "select SCV_codservicio,SCV_mnemonico as mnemonico "+;
	"from SERVCARGVAL join CPDESTR on SERVCARGVAL.SCV_mnemonico = CPDESTR.CPDR_mnemonico and "+;
	"CPDESTR.CPDR_destino = ?mdestino","mwkcodserv")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+" EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
else
	if reccount('mwkcodserv')>0
		mretorno = .t.
	else
*!*			messagebox("EL PRESENTE DESTINO NO SE ENCUENTRA DEFINIDO"+chr(10)+;
*!*				"AVISE A SISTEMAS",0,"Validacion")
	endif
endif
return mretorno
