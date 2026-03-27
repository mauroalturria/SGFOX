if type('mcon1') = "N"
	if mcon1>0
		on error =aerr(eros)
		DO sp_desconexion WITH "prg_cancelo"

		mcon1 = 0
	endif
endif
on error
CANCEL