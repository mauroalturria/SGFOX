msec1 = seconds()
	mret = sqlexec(mcon1,"SELECT *,APV_CODPRESTSOLIC->PRE_DESCRIPREST FROM AutPrevias","c1")
	if mret<0
		=aerr(eros)
		messagebox(eros(3))
	endif
msec2 = seconds()
messagebox(transf(msec2-msec1))
msec1 = seconds()
	mret = sqlexec(mcon1,"SELECT *,PRE_DESCRIPREST FROM AutPrevias,prestacions"+;
						" where pre_codprest = APV_CODPRESTSOLIC" ,"c1")
	if mret<0
		=aerr(eros)
		messagebox(eros(3))
	endif
msec2 = seconds()
messagebox(transf(msec2-msec1))

