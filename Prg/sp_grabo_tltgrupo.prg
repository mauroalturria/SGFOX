Parameters mabm ,mxid,mxnreg,mxgrupo,mxprio,mxidusuario,mxusuarioid,mxobser,mxfecfin,mxtgrupo,mxestado

mfechora = sp_busco_fecha_serv("DT")
mfecha = Ttod(mfechora )
mfecpas = Ctod("01/01/1900")
If Vartype(mxfecfin)<>"D"
	mxfecfin = Ctod("01/01/2100")
Endif
If Vartype(mxobser)="C"
	mxobserva =',  TLR_Observacion= ?mobs '
Else
	mxobserva = ''
	mxobser = ''
Endif
If Vartype(mxidusuario)<>"C"
	mxidusuario=''
Endif
If Vartype(mxprio)<>"N"
	mxprio = 0
Endif
If Vartype(mxestado)<>"N"
	mxestado = 0
ENDIF
mobs = Left(mxobser,250)
Do Case
	Case mabm=1
		If mxid=0
			lcSql = "Insert into Zabtltreg (TLR_CodGrupo,TLR_FPasiva,TLR_FechaFin,"+;
			" TLR_Nroregistrac, TLR_Observacion, TLR_Prioridad,TLR_IdGrupo,TLR_Estado  )"+;
				" values (?mxtgrupo,?mfecpas , ?mxfecfin  , ?mxnreg,?mobs ,?mxprio,?mxgrupo,?mxestado) "
		Else
			lcSql = "update Zabtltreg set  TLR_CodGrupo= ?mxtgrupo,TLR_FechaFin= ?mxfecfin ,TLR_IdGrupo = ?mxgrupo  "+	mxobserva +;
				" ,TLR_Prioridad  = ?mxprio,UserDbUpd = ?mxidusuario,FecHorDbUpd = ?mfechora, TLR_Estado =?mxestado  where id = ?mxid"
		Endif

	Case mabm = 2
Endcase
tcCursor = ''

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif

If mxid=0
	lcSql = "select id from Zabtltreg where TLR_Nroregistrac= ?mxnreg and TLR_FechaFin= ?mxfecfin   "
	tcCursor = 'mwkregctrl'
	If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
		Return .F.
	Endif
	mid= mwkregctrl.Id
	tcCursor = ''
	lcSql = "update Zabtltreg set UserDbUpd = ?mxidusuario,FecHorDbUpd = ?mfechora  where id = ?mid"
	If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
		Return .F.
	Endif
Endif
If mxid>0

	lcSql = "Insert into Zabtltobs( TLO_FechaH, TLO_Observacion, TLO_TabUsuario, TLO_idTLTReg )"+;
		" values (?mfechora  ,?mxobser , ?mxusuarioid  ,?mxid)"
	tcCursor = ''
	If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
		Return .F.
	Endif
Endif
