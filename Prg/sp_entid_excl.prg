***
***  busqueda de las entidades exclusivas
***

mfecpas = ctod('01/01/1900')
mret = sqlexec(mcon1, "select codent, tipoturno from entidexclu " + ;
						"where id <100000 and fecpasiva = ?mfecpas " + ;
						"and tpopac = 'AMB' and tipoturno = 7 " , "mwkentexc")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	do prg_cancelo
endif	