****
** convierte fecha para busqueda
****
Parameter mfec
	mfecn = ctod("01/01/1900")
	Set mark to '-'
	Set date to YMD
	cfechahora = dtoc(mfecn)

	If vartype(mfec)="T"
		cfechahora = ttoc(mfec)
	Else
		If vartype(mfec)="D"
			cfechahora = ttoc(dtot(mfec))
		else
			if vartype(mfec)="C"
				cfechahora = ttoc(ctot(mfec))
			endif
		Endif
	Endif

	Set date to french
	Set mark to
Return cfechahora


