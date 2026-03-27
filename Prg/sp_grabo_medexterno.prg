
parameters mcodEsp,mmatriculas,mfechaIngreso,mnombre,mfechah,gerenciadora ,mpass,mfecvtomat,hhmmd,hhmmh

if vartype(gerenciadora ) # "N"
	gerenciadora = 0
ENDIF
if vartype(hhmmd) # "N"
	hhmmd= 0
ENDIF
if vartype(hhmmh) # "N"
	hhmmh= 2400
ENDIF
mfecnul   = ctod("01/01/1900")

if vartype(mpass) # "C"
	mpass = ''
endif

If vartype(mfecvtomat)#"D"
	mfecvtomat = mfecnul
Endif

if gerenciadora = 222 && no controlo fecha
	mret = sqlexec(mcon1, " Select fechaingreso  from Tabmedexterno "+;
		" where matricula = ?mmatriculas and gerenciadora = ?gerenciadora "+;
		" ","mwkValidmedext")
else
	mret = sqlexec(mcon1, " Select fechaingreso  from Tabmedexterno "+;
		" where matricula = ?mmatriculas and gerenciadora = ?gerenciadora "+;
		" and fechaingreso = ?mfechaingreso "+;
		" ","mwkValidmedext")
endif
if reccount('mwkValidmedext') = 0
	mret = sqlexec(mcon1, " Select fechaingreso  from Tabmedexterno "+;
		" where matricula = ?mmatriculas "+;
		" ","mwkMedExternoFranja")

	if mret < 0
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
		do Log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif

	select fechaingreso as fecvigenh, (fechaingreso + 86400) as fecvigend ;
		from mwkMedExternoFranja into cursor mwkfranja01

	select * from mwkfranja01 ;
		where fecvigend > mfechaIngreso and fecvigenh < mfechaIngreso ;
		into cursor mwkfranja02

	select * from mwkfranja01 ;
		where fecvigend > mfechah and fecvigenh < mfechah ;
		into cursor mwkfranja03

*!*		If  reccount('mwkfranja02')	> 0 OR reccount('mwkfranja03') > 0
*!*			Messagebox('LA FRANJA EXISTE O SE SUPERPONE CON UNA EXISTENTE.',48,'Validación')
*!*			Return
*!*		Endif

	mret = sqlexec(mcon1, "Insert into Tabmedexterno"+;
		"( codesp,matricula,gerenciadora,fechaingreso,tipomat,nombre, usuarpas ,FecVtoMatricula "+;
		",codambito, ambcentror,hhmmDesr, hhmmHasr"+;
		"  ) values (  ?mcodEsp,?mmatriculas,?gerenciadora ,?mfechaIngreso,'MN',?mnombre,?mpass,?mfecvtomat"+;
		", ?mxambito,?mxcentromedico,?hhmmd,?hhmmh )")

else
	mret = sqlexec(mcon1, " Update Tabmedexterno set  "+;
		" nombre = ?mnombre, FecVtoMatricula = ?mfecvtomat where matricula = ?mmatriculas  ")
endif

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	do Log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
mret = sqlexec(mcon1, "select id from Tabmedexterno "+;
	" where matricula = ?mmatriculas and gerenciadora = ?gerenciadora ","mwkbuscoid")

