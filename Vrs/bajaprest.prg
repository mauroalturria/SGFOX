select prestadores
fecnul = ctod("01/01/1900")
mfecha = ctod("01/09/2011")
scan
	mrep = "fecpasivap with  mfecha,usuarpas with 'SISTEMAS'  "
	select bajas 
	locate for codmed = prestadores.id
	if found()
		select prestadores
		if dambula = 1 or fecpasiva > mfecha
			mrep = mrep + " , fecpasiva with mfecha "
		endif 	
		if dguardia = 1 or fecpasivag > mfecha
			mrep = mrep + " , fecpasivag with mfecha "
		endif 	
		if dinterna = 1 or fecpasivai > mfecha
			mrep = mrep + " , fecpasivai with mfecha "
		endif 	
		replace &mrep
	endif
	select prestadores
endscan