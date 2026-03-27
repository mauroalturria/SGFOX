lparameters mot,motadd,mfechahora

mret = sqlexec(mcon1," insert into tabmantadd(idot,otadd,fechahora)"+; 
" values(?mot,?motadd,?mfechahora) ")

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

