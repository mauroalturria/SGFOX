****
** Armo variables para activar puntos de menu
****

parameter miduser, midsec

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1, "select nomfrm, codgrupo, codusuario " + ;
	"from tabpermisosfrm, tabfrm " + ;
	"where codfrm = tabfrm.id and " + ;
	"codusuario = ?miduser and codsector = ?midsec and " + ;
	"tabpermisosfrm.fecpasiva = ?mfecpas ", "mwkmenu")
if _tally > 0
	selec mwkmenu
	do while !eof('mwkmenu')
		wwwa = "m" + allt(mwkmenu.nomfrm)
		public &wwwa
		&wwwa =	.t.
		skip 1 in mwkmenu
	enddo
endif

mret = sqlexec(mcon1, "select cmdnombre,nomfrm " + ;
	"from tabpermisosfrmcmd, tabcmdfrm ,tabfrm" + ;
	" where codcmd = tabcmdfrm.id " + ;
	" and codfrm = tabfrm.id " + ;
	" and tabfrm.fecpasiva = ?mfecpas " + ;
	" and codusuario = ?miduser and codsector = ?midsec and " + ;
	" tabpermisosfrmcmd.fecpasiva = ?mfecpas ", "mwkcmd")

if _tally > 0
	select mwkcmd
	scan
		wwwa = "m" +allt(mwkcmd.nomfrm)+allt(mwkcmd.cmdnombre)
		public &wwwa
		&wwwa =	.t.
	endscan

	select * from mwkmenu where alltrim(nomfrm) = "GENERAL" into cursor mwkcmdgral
	if reccount('mwkcmdgral')>0
		mret = sqlexec(mcon1, "select nomfrm, id from tabfrm " +;
			" where fecpasiva = ?mfecpas ", "mwkfrm1")
		select mwkfrm1
		scan
			mcomand = allt(mwkfrm1.nomfrm)
*!*				Select mwkfrm1
*!*				scan
			wwwa = "m" +allt(mwkfrm1.nomfrm)
			public &wwwa
			&wwwa =	.t.
*!*				Endscan

		endscan
	endif
endif
mret = sqlexec(mcon1, "select cmdnombre from tabcmdfrm where cmdinv = 1 " , "mwkcmd")
