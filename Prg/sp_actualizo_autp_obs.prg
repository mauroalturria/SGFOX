******
* Actualizo las observaciones agregadas
******
parameters mfechaobs,midautprevias,mobserva,musuario,mestado,mabm,miorigen,mcampo,mvalor

if vartype(miorigen)#"N"
	miorigen= 1
endif

if vartype(mabm)#"N"
	mabm = 1
endif
do case
case mabm = 1
	mret = sqlexec(mcon1,"insert into tabautobs(fechaobs,idautprevias,observa,"+;
		"usuario,estado,origen)"+;
		" values (?mfechaobs,?midautprevias,?mobserva,?musuario,?mestado,?miorigen)")
case mabm = 2
	mret = sqlexec(mcon1,"select id,observa from tabautobs"+;
		" where fechaobs = ?mfechaobs and idautprevias= ?midautprevias and estado = ?mestado "+;
		" and  usuario = ?musuario","mwkobsid")
	if reccount("mwkobsid")>0
		mid = mwkobsid.id
		miobserva = alltrim(mobserva) + " - "+ mwkobsid.observa
		mret = sqlexec(mcon1,"update tabautobs set observa = ?miobserva "+;
			" where id = ?mid")
	else
		mret = sqlexec(mcon1,"insert into tabautobs(fechaobs,idautprevias,observa,"+;
			"usuario,estado,origen)"+;
			" values (?mfechaobs,?midautprevias,?mobserva,?musuario,?mestado,?miorigen)")
	endif	
case mabm = 3
	mret = sqlexec(mcon1,"insert into Zautprevprm (APVP_idAutprevia	,"+mcampo+")"+;
		" values (?midautprevias,?mvalor)")
		
***		APVP_cadera24,APVP_justifPorta	,APVP_planATB	,APVP_tipoaisla

endcase



if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

