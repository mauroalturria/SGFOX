****
** Busco medicos de gerenciadoras
****
lparameters mgerencia
mfechabaja = ctod("01/01/2100")
if used ("mwkMedgeren")
	use in mwkMedgeren
endif

mret = SQLExec(mcon1," SELECT * FROM TabMedExterno " + ;
	" where gerenciadora = ?mgerencia and fechaBaja = ?mfechabaja "+;
	" group by matricula  order by nombre ", "mwkMedgeren" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
