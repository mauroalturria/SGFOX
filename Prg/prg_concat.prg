***
** Concateno un string para grabar sin error
***
*!*	jj = int(len(alltrim(meditx))/250)
*!*	for i = 0 to jj
*!*		clin = "linea"+padl(i,3,"0")
*!*		public &clin 		agregar estas lineas antes de llamar a la funcion
*!*	next

parameter medit,desde
cconcat = "''"
if vartype(medit)="C"
	desde = iif(vartype(desde)#"N","000",padl(desde,3,"0"))
	medita = alltrim(medit)
	mlong 	= lenc(medita)
	if mlong<=250
		cconcat = "'"+alltrim(substr(medita,1,250))+"'"
	else
		clin = "linea"+desde
		&clin = substr(medita,1,250)
		mresto = substr(medita,251)
		cconcat = "{fn CONCAT( ?"+clin
		mcola = " ) } "
		i = int(val(desde))+1
		do while lenc(mresto)>0
			clin = "linea"+padl(i,3,"0")
			&clin = substr(mresto,1,250)
			mrestito = mresto
			mresto = substr(mrestito,251)
			if lenc(mresto)>0
				cconcat = cconcat+ ",{fn CONCAT( ?"+clin
				mcola = mcola + " ) } "
			else
				cconcat = cconcat+ ", ?"+clin
			endif
			i = i+1
		enddo
		cconcat = cconcat+ mcola
	endif
endif
return cconcat
