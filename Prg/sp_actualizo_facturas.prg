****
** grabo los movimientos por facturas y n. credito
****
Parameter mcodent, mnroreg, mtpopac, mcodvax, maplipvta, ;
	mapliletra, maplinrof, maplitcte,mcodserv,mnroadm,mcodpun,nrointerno,mformapg
If Type('mcodserv') # 'N'
	mcodserv = 0
Endif
If Type('mnroadm')# 'C'
	mnroadm = ""
Endif
If Type('mcodpun')#"N"
	mcodpun= 0
Endif
If Type('nrointerno') # 'N'
	nrointerno = 0
Endif
If Type('mformapg') # 'N'
	mformapg= 0
Endif
If mformapg = 0
	mcfp = ''
	mvfp = ''
Else
	mcfp = ",formapago"
	mvfp =",?mformapg"
Endif
mnroval	= Round(Val(dat_fac(1)), 0)
mptovta = Round(Val(dat_fac(4)), 0)
mletra	= dat_fac(3)
mtpocte = Iif(dat_fac(2) = 'FC', 1, Iif(dat_fac(2) = 'ND', 2, Iif(dat_fac(2) = 'CC', 4,Iif(dat_fac(2) = 'DC', 7, 5))))
mnrocte = Round(Val(dat_fac(5)), 0)
mfecha  = dat_fac(6)
mimpor	= Val(dat_fac(9))
mfechor = sp_busco_fecha_serv('DT')

If mtpocte < 5
	maplipvta 	= mptovta
	mapliletra 	= mletra
	maplinrof	= mnrocte
	maplitcte	= mtpocte
Endif

If mcodserv>0
	mret = SQLExec(mcon1, "insert into tabfacturas(ptovta, tpocte, letracte, nrocte, fechacte, " + ;
		"importe, codent, codserv, nroregistracio, nrovale, tpopac, apliptovta, " + ;
		"aplitpocte, apliletracte, aplinrocte, cuenta, usuario, fechahora,codpun,nuin &mcfp) " + ;
		"values(?mptovta, ?mtpocte, ?mletra, ?mnrocte, ?mfecha, ?mimpor, " + ;
		"?mcodent, ?mcodserv, ?mnroreg, ?mnroval, ?mtpopac, ?maplipvta, ?maplitcte, " + ;
		"?mapliletra, ?maplinrof, ?mnroadm, ?mcodvax, ?mfechor,?mcodpun,?nrointerno &mvfp)")
Else
	mret = SQLExec(mcon1, "insert into tabfacturas(ptovta, tpocte, letracte, nrocte, fechacte, " + ;
		"importe, codent, nroregistracio, nrovale, tpopac, apliptovta, " + ;
		"aplitpocte, apliletracte, aplinrocte, cuenta, usuario, fechahora,codpun,nuin &mcfp) " + ;
		"values(?mptovta, ?mtpocte, ?mletra, ?mnrocte, ?mfecha, ?mimpor, " + ;
		"?mcodent, ?mnroreg, ?mnroval, ?mtpopac, ?maplipvta, ?maplitcte, " + ;
		"?mapliletra, ?maplinrof, ?mnroadm, ?mcodvax, ?mfechor, ?mcodpun, ?nrointerno &mvfp)")
Endif
If mret < 0
	Messagebox('NO SE ACTUALIZO TABFACTURAS, AVISAR A SISTEMAS', 16, 'Validacion')
	Do prg_cancelo
Endif
mret = SQLExec(mcon1, "select id from tabfacturas where ptovta = ?mptovta and tpocte = ?mtpocte "+;
	" and letracte = ?mletra and nrocte = ?mnrocte ","mwktabf")
