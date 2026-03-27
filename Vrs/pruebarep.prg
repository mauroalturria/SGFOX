use in 0 informe1.frx
select informe1
scan
	if objtype=8
		mvar = mline(expr,1)
		public &mvar
		&mvar = Recno()
	endif
endscan
select informe1
*!*	scan
*!*		if objtype=5
*!*			if atline("Sanatorio",expr)>0
*!*				mvar = strtran(expr,"Sanatorio","Clinica")
*!*				replace expr with mvar
*!*			endif
*!*		endif
*!*	endscan

use in informe1
select mwkusuario
report form c:\desaguemes\rep\informe1 preview