******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :11/11/2003
********************
parameter v_idbono, v_nrobono, vr_serie

if type('vr_serie')#"C"
	vr_serie=""
endif
*if !(vr_serie = "")
	mret = sqlexec(mcon1," SELECT bonoserie,nrodesde,nrohasta,procedencia,idbono,fecha "+;
		" FROM tabBonorec "+;
		" WHERE ?v_nrobono BETWEEN Nrodesde AND NroHasta "+;
		" AND  idbono=?v_idbono AND Bonoserie=?vr_serie ","MWKExisteBonoR")
*!*	else
*!*		mret = sqlexec(mcon1," SELECT bonoserie,nrodesde,nrohasta,procedencia,idbono,fecha "+;
*!*			" FROM tabBonorec "+;
*!*			" WHERE ?v_nrobono BETWEEN Nrodesde AND NroHasta "+;
*!*			" AND  idbono=?v_idbono AND (Bonoserie is null  or Bonoserie ='') ","MWKExisteBonoR")

*!*	endif
lhist = .f.
if mret < 0
	messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SISTEMAS',16,'VALIDACION')
	mret = 0
else
	if reccount("MWKExisteBonoR") = 0 and !(vr_serie = "")
		mret = sqlexec(mcon1," SELECT bonoserie,nrodesde,nrohasta,procedencia,idbono,fecha "+;
			" FROM tabBonorechist "+;
			" WHERE ?v_nrobono BETWEEN Nrodesde AND NroHasta  "+;
			" AND  idbono=?v_idbono AND Bonoserie = ?vr_serie ","MWKExisteBonoR")
		lhist = .t.
		if mret < 0
			messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SISTEMAS',16,'VALIDACION')
			mret = 0
		endif

	else
		if reccount("MWKExisteBonoR") = 0 
			mret = sqlexec(mcon1," SELECT bonoserie,nrodesde,nrohasta,procedencia,idbono,fecha "+;
				" FROM tabBonorechist "+;
				" WHERE ?v_nrobono BETWEEN Nrodesde AND NroHasta  "+;
				" AND  idbono=?v_idbono AND (Bonoserie is null  or Bonoserie ='') ","MWKExisteBonoR")
			lhist = .t.
			if mret < 0
				messagebox('ERROR AL VALIDAR LOS DATOS, AVISAR A SISTEMAS',16,'VALIDACION')
				mret = 0
			endif
		endif
	endif
endif
