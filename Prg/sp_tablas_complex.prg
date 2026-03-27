PARAMETERS pBanderaTOdos

mId = IIF(!pBanderaTOdos," and id  not in  (2,3,4,5) " ,'')
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 27  " + mId + " order by descrip", "mwkTabEstados")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
