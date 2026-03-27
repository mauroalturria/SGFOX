*!*	select presu
*!*	go top
*!*	scan
*!*		afi = presu.nroafiliado
*!*		menti = presu.entidad
*!*		requery('vista2')
*!*		if reccount('vista2')= 1
*!*			mireg = vista2.REG_nroregistrac
*!*			select presu
*!*			replace nroregistrac with mireg
*!*		else
*!*			if reccount('vista2')> 1
*!*				set step on
*!*				mireg = vista2.REG_nroregistrac
*!*				select presu
*!*				replace nroregistrac with mireg
*!*			endif
*!*		endif
*!*		select presu
*!*	endscan


select presu
go top
scan
	midoc 	= val(presu.nroafiliado)
	cpac 	= presu.paciente
	if midoc>10000
		requery('regishc')
		if reccount('regishc')= 1
			if cpac = regishc.REG_nombrepac
				mireg = regishc.REG_nroregistrac
				select presu
				replace nroregistrac with mireg
			else
				if messagebox("Presu--- "+cpac+chr(13)+"Regis--- "+ regishc.REG_nombrepac;
						, 4+48+256, "Validacion") = 6
					mireg = regishc.REG_nroregistrac
					select presu
					replace nroregistrac with mireg
				endif
			endif
		else
			if reccount('regishc')> 1
				if messagebox(transf(reccount('regishc'))+chr(13)+"Presu--- "+;
				cpac+chr(13)+"Regis--- "+ regishc.REG_nombrepac;
						, 4+48+256, "Validacion") = 6
					mireg = regishc.REG_nroregistrac
					select presu
					replace nroregistrac with mireg
				endif
			endif
		endif
	endif
	select presu
endscan

