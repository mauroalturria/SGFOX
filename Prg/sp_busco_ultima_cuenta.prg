****
** Busco ultimo Contratos para guardia
****

parameter mnroreg, mcodentid,mtipop

mtipop = iif(vartype(mtipop)#"C","GUA",mtipop)

mret = sqlexec(mcon1, "select histambgua.*,Entidcontr2.TIPO "+;
		"from histambgua,Entidcontr2"+;
		" where his_nroregistrac = ?mnroreg and CONTRATO = HIS_codcontrato " + ;
		" and his_codentidad = ?mcodentid and TIPO = ?mtipop ", "mwkcuentas")
select HIS_codcontrato ,ffech(HIS_fechaadmision) as fecha ;
	from mwkcuentas order by fecha desc into cursor mwkultCta
select mwkultCta
go top
function ffech(cfec)
	local mm,yy,dd,yyyy
	dd = val(substr(cfec,5,2))
	mm = val(substr(cfec,3,2))
	yy = val(left(HIS_fechaadmision,2))
	yyyy = iif(yy<50,2000,1900)+yy
	if empty(cfec)
		return ctod("01/01/1900")
	else
		return date(yyyy,mm,dd)
	endif
endfunc

