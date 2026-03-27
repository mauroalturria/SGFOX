private vec
aerr(vec)
mival = iif(vartype(valeerror)#"C","??",valeerror)
if vartype(	nxreintenta)#"N"
	nxreintenta = 0
endif
if vec[1,1] = 1105

	if messagebox("ERROR AL INTENTAR IMPRIMIR POR LPT1" + chr(13) +;
			"verifique que la impresora esté encendida y en línea",16+5,"Atención") = 4
		retry
	endif
ELSE
	mipc =  SYS(0)
					mipc = left(left(mipc,at("#",mipc)-1)+STRTRAN(myip,'172.16.',''),50)
	mierror = transf(vec(1))+" "+ vec(2)+ttoc(datetime())
	do sp_insert_tabCtrlErr with mierror,mival,mipc,"CONTROL DE ERRORES"
	nxreintenta = nxreintenta + 1
	if nxreintenta >30
		messagebox("ERROR" + mierror+ +"vale:"+mival+chr(13) +;
			"AVISE a Sistemas antes de tocar nada. Gracias",16+5,"Atención")
		cancel
	else
		retry
	endif
endif
