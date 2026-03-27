*****
***** busco reclamos
*****
lparameters mpend, mbusco,mcodigovax
if type ('mbusco')#"C"
	mbusco = ""
endif
mbusco = mbusco + iif(mpend=1, ' and estado = 2  and tipoDeTarea in(1,0)', ' ')
if !empty(mbusco)
	mbusco = iif(at("Where",mbusco)=0," Where 1=1 ","") + mbusco
endif

mret = sqlexec(mcon1,'select TabMantenimiento.*,TabMantEst.descrip '+;
	' from TabMantenimiento' + ;
	' left join TabMantEst on TabMantenimiento.estado = TabMantEst.codest ' + ;
	' left join TabMantdetsector on ' +;
	' TabMantenimiento.codsector = TabMantdetsector.codsector '+;
	+ mbusco + ' and TabMantdetsector.codigovax = ?mcodigovax ', 'mwkrecla02')


if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif
