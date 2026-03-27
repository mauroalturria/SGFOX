*********************
*** Claudia Antoniow
*** Fecha 20/09/2004
*** Series Cargadas
*********************
parameters vr_tipoBono

if vr_tipoBono > 0
	mret  =sqlexec(mcon1," SELECT bonoserie FROM TabbonoRec WHERE idBono=?vr_tipoBono "+;
					     " GROUP BY Bonoserie ORDER BY Bonoserie ","MwkBonoSerie")
					 
	if mret < 1
		messagebox('ERROR; NO SE CREO CURSOR DE SERIE',16,'VALIDACION')
		mret=0
		do prg_cancelo
	endif
endif						   	