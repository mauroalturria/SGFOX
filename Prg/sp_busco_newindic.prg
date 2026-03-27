*
* Prescripción Medica - Log
*
parameters midevol,mvfecdes
nreg = 0
mfecdes = prg_dtoc(mvfecdes)
mdesde = prg_dtoc(ttod(mvfecdes)-1)
mret = sqlexec(mcon1,"select * from tabintpmpres where pps_idevol = ?midevol and pps_fechora>= ?mdesde order by id desc","mwkpresd")
if mret < 0
	mltabla = "PRESCRIPCION MEDICA - INICIALIZACIONES - " + upper(mleye)
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif
mret = sqlexec(mcon1,"select top 1 PS_fechormodif "+;
	" from TabIntPmSoluLg"+;
	" where PS_idevol = ?midevol "+;
	" order by id desc ","mwksollg")
if reccount("mwksollg") =0 or PS_fechormodif < mvfecdes
	mret = sqlexec(mcon1,"select  top 1 PS_fechormodif "+;
		" from TabIntPmSolu "+;
		" where PS_idevol = ?midevol "+;
		" order by id desc ","mwksol")
	if reccount("mwksol") =0 or PS_fechormodif < mvfecdes
		mret = sqlexec(mcon1,"select  top 1 PA_fechormodif "+;
			" from TabIntPmAgreLg"+;
			" where PA_idevol = ?midevol    "+;
			" order by id desc " ,"mwkagrelg")
		if reccount("mwkagrelg") =0 or PA_fechormodif < mvfecdes

			mret = sqlexec(mcon1,"select  top 1 PA_fechormodif "+;
				" from TabIntPmAgre"+;
				" where PA_idevol = ?midevol    "+;
				" order by id desc " ,"mwkagre")
			if reccount("mwkagre")>0
				nreg= iif(PA_fechormodif < mvfecdes,0,1)
			else
				nreg = 0
			endif
		else
			if reccount("mwkagrelg")>0
				nreg= iif(PA_fechormodif < mvfecdes,0,1)
			else
				nreg = 0
			endif
		endif
	else
		if reccount("mwksol")>0
			nreg= iif(PS_fechormodif < mvfecdes,0,1)
		else
			nreg = 0
		endif
	endif
else
	if reccount("mwksollg")>0
		nreg= iif(PS_fechormodif < mvfecdes,0,1)
	else
		nreg = 0
	endif
endif

return nreg>0
